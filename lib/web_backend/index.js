const fs = require('fs');
const path = require('path');
const express = require('express');
const admin = require('firebase-admin');
const cron = require('node-cron');

const app = express();
app.use(express.json());

const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');
if (fs.existsSync(serviceAccountPath)) {
  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
} else {
  admin.initializeApp({ credential: admin.credential.applicationDefault() });
}

const db = admin.firestore();
const messaging = admin.messaging();
const PORT = process.env.PORT || 3000;

function asMillis(value) {
  if (!value) return null;
  if (typeof value === 'number') return value;
  if (value.toMillis) return value.toMillis();
  if (value.seconds) return value.seconds * 1000;
  const parsed = Date.parse(value);
  return Number.isNaN(parsed) ? null : parsed;
}

async function getNotificationSettings(userId) {
  const doc = await db
    .collection('users')
    .doc(userId)
    .collection('settings')
    .doc('notifications')
    .get();

  const data = doc.data() || {};
  return {
    enableNotifications: data.enable_notifications !== false,
    bookingNotifications: data.booking_notifications !== false,
  };
}

async function canReceiveBookingNotifications(userId) {
  if (!userId) return false;
  const settings = await getNotificationSettings(userId);
  return settings.enableNotifications && settings.bookingNotifications;
}

async function getUserTokens(userId) {
  const tokens = new Set();

  const userDoc = await db.collection('users').doc(userId).get();
  const userData = userDoc.data() || {};
  const userTokens = Array.isArray(userData.fcmTokens) ? userData.fcmTokens : [];
  userTokens.forEach((token) => token && tokens.add(token));

  const devices = await db
    .collection('user_devices')
    .where('uid', '==', userId)
    .where('isActive', '==', true)
    .get();

  devices.docs.forEach((doc) => {
    const token = doc.data().token;
    if (token) tokens.add(token);
  });

  return [...tokens];
}

async function sendToTokens(tokens, payload) {
  if (!tokens.length) return { successCount: 0, failureCount: 0 };

  const message = {
    tokens,
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data: {
      type: 'booking',
      bookingId: String(payload.bookingId),
    },
  };

  const response = await messaging.sendEachForMulticast(message);
  return { successCount: response.successCount, failureCount: response.failureCount };
}

function eventTemplate(eventType, bookingId) {
  switch (eventType) {
    case 'created':
      return {
        title: 'Booking Created',
        body: 'Your booking request was created successfully.',
        bookingId,
      };
    case 'approved':
      return {
        title: 'Booking Approved',
        body: 'Your booking has been approved.',
        bookingId,
      };
    case 'rejected':
      return {
        title: 'Booking Rejected',
        body: 'Your booking request was rejected.',
        bookingId,
      };
    case 'reminder':
    default:
      return {
        title: 'Booking Reminder',
        body: 'Your booking starts soon.',
        bookingId,
      };
  }
}

async function sendBookingNotificationToUser(userId, payload) {
  const allowed = await canReceiveBookingNotifications(userId);
  if (!allowed) return { userId, skipped: true, reason: 'notifications-disabled' };

  const tokens = await getUserTokens(userId);
  if (!tokens.length) return { userId, skipped: true, reason: 'no-tokens' };

  const result = await sendToTokens(tokens, payload);
  return { userId, skipped: false, ...result };
}

async function sendBookingNotificationToMany(userIds, payload) {
  const unique = [...new Set((userIds || []).filter(Boolean))];
  const results = [];

  for (const userId of unique) {
    const result = await sendBookingNotificationToUser(userId, payload);
    results.push(result);
  }

  return results;
}

async function getBookingParticipants(bookingId) {
  const doc = await db.collection('bookings').doc(bookingId).get();
  if (!doc.exists) return { userIds: [] };

  const data = doc.data() || {};
  const userIds = [data.userId, data.ownerId, data.adminId].filter(Boolean);
  return { userIds, booking: { id: doc.id, ...data } };
}

app.post('/send-booking-notification', async (req, res) => {
  try {
    const {
      bookingId,
      userId,
      userIds,
      eventType = 'created',
      title,
      body,
      includeBookingParticipants = false,
    } = req.body || {};

    if (!bookingId) {
      return res.status(400).json({ ok: false, error: 'bookingId is required' });
    }

    let targetUserIds = [];
    if (userId) targetUserIds.push(userId);
    if (Array.isArray(userIds)) targetUserIds.push(...userIds);

    if (includeBookingParticipants) {
      const participants = await getBookingParticipants(bookingId);
      targetUserIds.push(...participants.userIds);
    }

    targetUserIds = [...new Set(targetUserIds.filter(Boolean))];
    if (!targetUserIds.length) {
      return res.status(400).json({ ok: false, error: 'No target users provided' });
    }

    const payload = {
      ...eventTemplate(eventType, bookingId),
      title: title || eventTemplate(eventType, bookingId).title,
      body: body || eventTemplate(eventType, bookingId).body,
      bookingId,
    };

    const results = await sendBookingNotificationToMany(targetUserIds, payload);
    return res.json({ ok: true, results });
  } catch (error) {
    return res.status(500).json({ ok: false, error: error.message });
  }
});

app.post('/booking-reminder', async (req, res) => {
  try {
    const { bookingId } = req.body || {};
    if (!bookingId) {
      return res.status(400).json({ ok: false, error: 'bookingId is required' });
    }

    const { userIds, booking } = await getBookingParticipants(bookingId);
    if (!booking) {
      return res.status(404).json({ ok: false, error: 'Booking not found' });
    }

    const payload = {
      title: 'Booking Reminder',
      body: `Your booking at ${booking.spaceName || 'your space'} starts soon.`,
      bookingId,
    };

    const results = await sendBookingNotificationToMany(userIds, payload);
    return res.json({ ok: true, results });
  } catch (error) {
    return res.status(500).json({ ok: false, error: error.message });
  }
});

async function processBookingReminders() {
  const now = Date.now();
  const reminderWindowEnd = now + 30 * 60 * 1000;

  const snap = await db
    .collection('bookings')
    .where('status', '==', 'confirmed')
    .where('reminderSent', '!=', true)
    .get();

  for (const doc of snap.docs) {
    const booking = { id: doc.id, ...doc.data() };
    const startAt = asMillis(booking.startTime);
    if (!startAt) continue;
    if (startAt < now || startAt > reminderWindowEnd) continue;

    const userIds = [booking.userId, booking.ownerId, booking.adminId].filter(Boolean);
    const payload = {
      title: 'Booking Reminder',
      body: `Your booking at ${booking.spaceName || 'your space'} starts soon.`,
      bookingId: doc.id,
    };

    await sendBookingNotificationToMany(userIds, payload);
    await doc.ref.set(
      {
        reminderSent: true,
        reminderSentAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
  }
}

async function processBookingLifecycle() {
  const now = Date.now();

  const confirmed = await db.collection('bookings').where('status', '==', 'confirmed').get();
  for (const doc of confirmed.docs) {
    const booking = doc.data();
    const startAt = asMillis(booking.startTime);
    if (startAt && startAt <= now) {
      await doc.ref.set(
        { status: 'active', updatedAt: admin.firestore.FieldValue.serverTimestamp() },
        { merge: true }
      );
    }
  }

  const active = await db.collection('bookings').where('status', '==', 'active').get();
  for (const doc of active.docs) {
    const booking = doc.data();
    const endAt = asMillis(booking.endTime);
    if (endAt && endAt <= now) {
      await doc.ref.set(
        { status: 'completed', updatedAt: admin.firestore.FieldValue.serverTimestamp() },
        { merge: true }
      );
    }
  }
}

cron.schedule('*/5 * * * *', async () => {
  try {
    await processBookingReminders();
    await processBookingLifecycle();
    console.log('[scheduler] booking reminder + lifecycle processed');
  } catch (error) {
    console.error('[scheduler] error', error);
  }
});

app.get('/health', (_, res) => {
  res.json({ ok: true, service: 'masahtak-backend' });
});

app.listen(PORT, () => {
  console.log(`Masahatak backend running on port ${PORT}`);
});
