# Masahatak Node.js Backend (FCM + Booking Scheduler)

## 1) Where to create backend folder

Create a separate backend folder outside Flutter app (recommended), then copy these files:

- `index.js`
- `package.json`
- `README.md`

You can also run directly from `lib/web_backend` for quick testing.

## 2) Firebase service account

Place your Firebase Admin key file as:

- `serviceAccountKey.json` (same folder as `index.js`)

If the file is missing, backend will fallback to `applicationDefault()` credentials.

## 3) Install and run

```bash
npm install
node index.js
```

Server starts on `PORT` env var or `3000`.

## 4) Endpoints

### POST `/send-booking-notification`
Send booking notification with Flutter-compatible payload.

Request body example:

```json
{
  "bookingId": "123",
  "eventType": "approved",
  "userIds": ["uid1", "uid2"],
  "includeBookingParticipants": true
}
```

Supported `eventType`:
- `created`
- `approved`
- `rejected`
- `reminder`

Payload sent to FCM is always:

```json
{
  "notification": {
    "title": "...",
    "body": "..."
  },
  "data": {
    "type": "booking",
    "bookingId": "123"
  }
}
```

### POST `/booking-reminder`
Send reminder for one booking.

Request body:

```json
{
  "bookingId": "123"
}
```

## 5) Settings check before send

Before sending, backend checks:

`users/{userId}/settings/notifications`

- `enable_notifications`
- `booking_notifications`

If either is `false`, booking notification is skipped.

## 6) Scheduler jobs

Runs every 5 minutes:

1. Booking reminders (for upcoming confirmed bookings)
2. Lifecycle updates:
   - `confirmed -> active`
   - `active -> completed`

## 7) Token sources

Backend sends to tokens from:

- `users.fcmTokens`
- `user_devices` collection (`uid`, `token`, `isActive == true`)
