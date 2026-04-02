/**
 * Firebase Cleanup Script
 * يحذف كل اليوزرز والمساحات والحجوزات
 * ما عدا اليوزر: mo2@gmail.com
 *
 * كيف تشغّله:
 * 1. حمّل Service Account Key من Firebase Console:
 *    Project Settings → Service Accounts → Generate new private key
 * 2. احفظ الملف باسم: serviceAccountKey.json في نفس المجلد
 * 3. شغّل: node cleanup_firebase.js
 */

const admin = require('firebase-admin');
const path = require('path');

// ─── إعدادات ──────────────────────────────────────────────
const KEEP_EMAIL = 'mo2@gmail.com';
const SERVICE_ACCOUNT_PATH = path.join(__dirname, 'serviceAccountKey.json');
// ──────────────────────────────────────────────────────────

// تحقق من وجود ملف الـ Service Account
const fs = require('fs');
if (!fs.existsSync(SERVICE_ACCOUNT_PATH)) {
  console.error('❌ ملف serviceAccountKey.json غير موجود!');
  console.error('   حمّله من Firebase Console → Project Settings → Service Accounts');
  process.exit(1);
}

const serviceAccount = require(SERVICE_ACCOUNT_PATH);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'masahatak-73bf9',
});

const db = admin.firestore();
const auth = admin.auth();

// ─── حذف كل documents في collection ──────────────────────
async function deleteCollection(collectionName, excludeIds = []) {
  const snap = await db.collection(collectionName).get();
  const toDelete = snap.docs.filter(d => !excludeIds.includes(d.id));

  if (toDelete.length === 0) {
    console.log(`✅ ${collectionName}: لا يوجد شيء للحذف`);
    return;
  }

  // batch delete (500 max per batch)
  let batch = db.batch();
  let count = 0;
  let total = 0;

  for (const doc of toDelete) {
    batch.delete(doc.ref);
    count++;
    total++;

    if (count === 499) {
      await batch.commit();
      batch = db.batch();
      count = 0;
    }
  }

  if (count > 0) await batch.commit();
  console.log(`🗑️  ${collectionName}: تم حذف ${total} document`);
}

// ─── حذف يوزرز من Firebase Auth ──────────────────────────
async function deleteAuthUsers(keepUid) {
  let nextPageToken;
  let deletedCount = 0;
  const uidsToDelete = [];

  do {
    const result = await auth.listUsers(1000, nextPageToken);
    for (const user of result.users) {
      if (user.uid !== keepUid) {
        uidsToDelete.push(user.uid);
      }
    }
    nextPageToken = result.pageToken;
  } while (nextPageToken);

  // حذف بـ batches من 1000
  for (let i = 0; i < uidsToDelete.length; i += 1000) {
    const batch = uidsToDelete.slice(i, i + 1000);
    await auth.deleteUsers(batch);
    deletedCount += batch.length;
  }

  console.log(`🗑️  Firebase Auth: تم حذف ${deletedCount} مستخدم`);
}

// ─── الدالة الرئيسية ──────────────────────────────────────
async function main() {
  console.log('🚀 بدء تنظيف Firebase...');
  console.log(`✅ سيتم الإبقاء على: ${KEEP_EMAIL}\n`);

  try {
    // 1. ابحث عن UID الخاص بـ mo2@gmail.com
    let keepUid = null;
    try {
      const userRecord = await auth.getUserByEmail(KEEP_EMAIL);
      keepUid = userRecord.uid;
      console.log(`🔑 UID لـ ${KEEP_EMAIL}: ${keepUid}`);
    } catch (e) {
      console.warn(`⚠️  اليوزر ${KEEP_EMAIL} غير موجود في Firebase Auth`);
    }

    // 2. ابحث عن doc ID الخاص بـ mo2 في Firestore
    let keepDocId = keepUid;
    if (!keepDocId) {
      // جرّب البحث بالـ email في collection users
      const snap = await db.collection('users').where('email', '==', KEEP_EMAIL).get();
      if (!snap.empty) keepDocId = snap.docs[0].id;
    }

    // 3. حذف Firebase Auth users (ما عدا mo2)
    if (keepUid) {
      await deleteAuthUsers(keepUid);
    } else {
      await deleteAuthUsers('___NO_UID___');
    }

    // 4. حذف Firestore users (ما عدا doc الخاص بـ mo2)
    const excludeUserIds = keepDocId ? [keepDocId] : [];
    await deleteCollection('users', excludeUserIds);

    // 5. حذف كل المساحات
    await deleteCollection('spaces');

    // 6. حذف كل الحجوزات
    await deleteCollection('bookings');

    // 7. حذف كل العروض (offers)
    await deleteCollection('offers');

    console.log('\n✅ تم التنظيف بنجاح!');
    console.log(`   اليوزر ${KEEP_EMAIL} محفوظ.`);

  } catch (error) {
    console.error('❌ خطأ:', error.message);
    process.exit(1);
  }

  process.exit(0);
}

main();
