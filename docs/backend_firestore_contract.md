# Backend Firestore Contract (Node.js + Express)

This document is a ready-to-use implementation contract for building the backend consumed by the mobile/admin app.
It reflects the current Firestore structure and the existing legacy variants that the backend **must** normalize.

## 1) Goal

Build a Node.js + Express backend using Firebase Admin SDK that:

- Uses Firestore as source of truth.
- Supports both canonical and legacy field/status variants.
- Separates user/admin/AI flows clearly.
- Prevents data-shape drift between app modules.

---

## 2) Firestore Collections in Scope

- `users`
- `users/{uid}/settings/notifications`
- `user_devices`
- `spaces`
- `bookings`
- `notifications`
- `admin_payment_reviews`
- `app_meta`

---

## 3) Core Schemas

## 3.1 `users/{uid}`

Primary fields used by app/backend:

- `role`
- `assignedSpaceIds` (sub/super admin mapping)
- `fcmTokens` (array)
- `fcmTokenUpdatedAt`
- `lastPlatform`
- optional profile fields (`fullName`, `email`, `onboarding.completed`)

### Notification settings subdocument
Path: `users/{uid}/settings/notifications`

- `enable_notifications`
- `booking_notifications`
- `bookingApproved`
- `bookingRejected`
- `bookingReminder`
- `offerSuggestion`
- `reminderTiming`
- `updatedAt`

> Default behavior if settings doc is missing: treat notification toggles as enabled.

## 3.2 `user_devices`

Used to resolve active FCM tokens:

- `uid`
- `token`
- `platform` (`android|ios|web`)
- `app` (`mobile`)
- `isActive`
- `createdAt`, `updatedAt`

## 3.3 `spaces`

Common fields:

- `name`, `subtitle`, `description`
- `currency`
- `basePriceValue` / `pricePerDay`
- `adminId`
- `totalSeats`, `availableSeats`
- `offers` (array)
- `paymentMethods` (array)
- `images`, `features`, `amenities`
- `workingHours`, `policySections`

## 3.4 `bookings` (core)

Minimum contract fields:

- identity/joins:
  - `bookingId` (usually equals doc id)
  - `userId`, `userName`
  - `spaceId`, `spaceName`
  - `adminId`
  - `space: { id, name, basePricePerDay, currency, adminId }`
- times:
  - `startDate`, `endDate`
  - `createdAt`, `updatedAt`
  - `paymentDeadline`
- pricing:
  - `totalAmount`, `currency`
  - legacy optional: `totalPrice`
- lifecycle:
  - `status`
  - `statusHint`
- payment:
  - `paymentId`
  - `paymentMethod`, `paymentMethodName`
  - `paymentReceiptUrl`
  - `paidAt`
  - `cardLast4`, `cardHolder`, `cardExpiry`
  - `payerAccountHolder`, `payerTransferTime`, `payerReferenceNumber`
- cancellation:
  - `cancelReason`
  - `cancellationStage`
  - `cancelledBy`
  - `cancelledAt`
  - optional `cancellationCompensation`
- reminders/cron flags:
  - `reminderSent`
  - `reminderSentAt`

### Booking statuses observed

- `pending`
- `under_review`
- `approved_waiting_payment`
- `approved` (legacy alias)
- `payment_under_review`
- `payment_rejected`
- `confirmed`
- `paid` (legacy alias)
- `active`
- `completed`
- `rejected`
- `cancelled` / `canceled`
- `expired`

## 3.5 `notifications`

Used for in-app notification feed:

- `userId` (legacy variant: `user_id`)
- `title`
- `subtitle` (legacy may use `body` / `message`)
- `type`
- `isRead` (legacy: `is_read`)
- `bookingId` (or legacy `requestId` / `request_id`)
- `spaceId` (optional)
- `createdAt` (legacy: `created_at`)

## 3.6 `admin_payment_reviews`

Payment review queue for admins:

- `bookingId`, `userId`, `spaceId`, `spaceName`
- `amount`, `currency`
- `paymentMethod`, `receiptUrl`
- `paidAt`
- `status` (usually starts `pending`)
- `createdAt`

---

## 4) Required Backend Endpoints

## 4.1 Notifications

### `POST /send-booking-notification`

Request body:

- `bookingId` (required)
- one of:
  - `userId` (single recipient)
  - `userIds` (array recipients)
- optional:
  - `eventType`
  - `title`
  - `body`
  - `includeBookingParticipants`

Behavior:

1. Resolve recipients from payload and/or booking participants.
2. Apply notification settings gating.
3. Resolve tokens from both `users.fcmTokens` and `user_devices` active records.
4. Deduplicate tokens.
5. Send push + write in-app `notifications` docs.

### `POST /booking-reminder`

Request body:

- `bookingId` (required)

Behavior:

- Send reminder only when booking status/time window qualifies.
- Mark reminder flags to avoid duplicate sends.

## 4.2 Booking lifecycle/cron

### `POST /cron/booking-sync`

Can be manual trigger plus scheduled invocation.

Behavior:

- Reminders:
  - target confirmed bookings where `reminderSent != true` and booking start is in reminder window.
- Lifecycle transitions:
  - `confirmed -> active` when `now >= startAt`
  - `active -> completed` when `now >= endAt`
- Time resolver:
  - `startAt = startDate ?? startTime`
  - `endAt = endDate ?? endTime`
- Processing safety:
  - per-booking `try/catch` and continue loop on item failure.

## 4.3 AI

### `POST /api/ai/chat`

Request body:

- `message`
- `userId`
- `history` (Gemini-style role/parts)
- `lastSpaces` (IDs list)

Response:

- `text`
- `currentSpaces` (space objects)

### `POST /api/ai/finalize`

Request body:

- `userId`
- `history`

Response:

- success marker/message.

## 4.4 Health

### `GET /health`

Response:

- service health payload (status + optional version/build metadata).

---

## 5) Normalization Rules (Mandatory)

Backend must normalize legacy/canonical variants consistently.

## 5.1 Field aliases

- `userId` ↔ `user_id`
- `isRead` ↔ `is_read`
- `createdAt` ↔ `created_at`
- booking start/end:
  - `startDate` / `endDate`
  - fallback `startTime` / `endTime`

## 5.2 Status aliases

Recommended canonical map:

- `approved` => `approved_waiting_payment`
- `paid` => `confirmed`
- `canceled` => `cancelled`

Persist canonical status in writes; accept aliases in reads/filters.

## 5.3 Admin/owner recipient fallback

When a flow needs space owner/admin recipient:

`ownerId ?? adminId ?? space.adminId`

---

## 6) Role Split (Behavior Contract)

## 6.1 User flows

- Create booking request (`pending`).
- View bookings/status timeline.
- Cancel booking (store cancellation metadata).
- Submit payment (`payment_under_review`) and create admin payment review item.

## 6.2 Admin flows

- List bookings by tabs:
  - `all`, `pending`, `awaiting_payment`, `awaiting_confirmation`, `booked`, `canceled`
- Accept/reject booking requests.
- Review payment and confirm/reject.

## 6.3 AI flows

- Chat with contextual payload (`userId`, `history`, `lastSpaces`).
- Finalize session with persisted summary/analytics hook.

---

## 7) Validation & Security Requirements

- Validate all endpoint payloads (schema validation library recommended: zod/joi).
- Verify Firebase ID token on protected routes.
- Enforce role checks for admin endpoints.
- Use idempotency keys for operations at risk of retries (notifications, payment review actions).
- Log audit trail for status transitions (`from`, `to`, `actorId`, `timestamp`, `reason`).

---

## 8) Testing Requirements (Mandatory)

- Unit tests:
  - field normalization
  - status normalization
  - start/end time resolver
- Integration tests:
  - notification gating by user settings
  - token resolution + deduplication
  - cron lifecycle transitions
  - reminder idempotency
- Contract tests:
  - `/api/ai/chat` payload validation and response shape
  - `/api/ai/finalize` payload validation and response shape

---

## 9) Known Inconsistencies to Resolve in Backend Layer

1. `canceled` vs `cancelled` status spelling.
2. `startDate/endDate` vs `startTime/endTime` scheduler fields.
3. recipient source mismatch (`ownerId` vs `adminId`).
4. legacy field names (`user_id`, `is_read`, `created_at`).
5. notification UX policy ambiguity (mark-read on list-open vs on-tap).

---

## 10) Ready-to-paste Build Prompt for Codex

```text
Build a Node.js + Express backend for a Flutter app using Firebase Admin SDK.
Use Firestore as source of truth and support existing legacy fields.

### Collections used
- users
- users/{uid}/settings/notifications
- user_devices
- spaces
- bookings
- notifications
- admin_payment_reviews
- app_meta

### Booking schema contract
bookings doc fields:
- bookingId, userId, userName
- spaceId, spaceName, adminId
- space { id, name, basePricePerDay, currency, adminId }
- startDate, endDate, createdAt, updatedAt, paymentDeadline
- status, statusHint
- totalAmount, currency
- paymentId, paymentMethod, paymentMethodName, paymentReceiptUrl, paidAt
- cardLast4, cardHolder, cardExpiry
- payerAccountHolder, payerTransferTime, payerReferenceNumber
- cancelReason, cancellationStage, cancelledBy, cancelledAt
- reminderSent, reminderSentAt

Normalize legacy variants:
- canceled/cancelled
- userId/user_id
- createdAt/created_at
- isRead/is_read
- startDate/endDate AND startTime/endTime

### Required endpoints
1) POST /send-booking-notification
2) POST /booking-reminder
3) POST /api/ai/chat
4) POST /api/ai/finalize
5) POST /cron/booking-sync
6) GET /health

### Notification preferences gating
Before sending booking push:
read users/{uid}/settings/notifications:
- enable_notifications must be true
- booking_notifications must be true
If document missing => default true.
If explicitly false => skip send.

### FCM token sources
- users/{uid}.fcmTokens array
- user_devices where uid == userId and isActive == true
Deduplicate tokens before multicast.

### booking-sync behavior
- Reminders: confirmed bookings with no reminderSent and start in reminder window.
- Lifecycle:
  confirmed -> active when now >= startAt
  active -> completed when now >= endAt
- Use startAt = startDate ?? startTime
- Use endAt = endDate ?? endTime
- per-booking try/catch; continue processing.

### Admin/User role split
User flows:
- create booking request
- view bookings and status
- cancel booking
- submit payment (sets payment_under_review)

Admin flows:
- list bookings by tab (all, pending, awaiting_payment, awaiting_confirmation, booked, canceled)
- accept/reject requests
- review payments and confirm/reject

AI flows:
- /api/ai/chat receives message,userId,history,lastSpaces and returns text,currentSpaces
- /api/ai/finalize receives userId,history and updates user AI profile summary

### Tests (mandatory)
- Unit tests for field normalization, status normalization, start/end resolver.
- Integration tests for notification send gating and token resolution.
- Integration tests for cron lifecycle transitions and reminder idempotency.
- Contract tests for AI chat/finalize payload validation.
```
