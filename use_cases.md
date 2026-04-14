# Use Cases (Actual Implemented Behavior)

This document reflects current code behavior in the project (Bloc → UseCase → Repo → Source).  
Only implemented flows are listed.

---

## User Use Cases

### 1) App Start Decision
- **Title:** Initialize app startup and decide first route
- **Actor:** User
- **Preconditions:** App launched; `AppStartBloc` receives `AppStartStarted`
- **Main Flow:**
  1. `AppStartBloc` calls `InitializeStartupUseCase`.
  2. Then calls `DecideAppStartUseCase`.
  3. Bloc emits startup decision state based on returned decision.
- **Postconditions:** App state contains start decision used by UI routing.

### 2) Email/Password Login
- **Title:** Login with credentials
- **Actor:** User
- **Preconditions:** `AuthLoginRequested` dispatched with email/password
- **Main Flow:**
  1. `AuthBloc` sets loading state.
  2. Calls `LoginUseCase(email, password)`.
  3. On success emits authenticated user state.
  4. On failure emits error state.
- **Postconditions:** User is logged in or receives error message.

### 3) Sign Up
- **Title:** Register new account
- **Actor:** User
- **Preconditions:** `AuthSignUpRequested` dispatched with signup fields
- **Main Flow:**
  1. `AuthBloc` enters loading.
  2. Calls `SignUpUseCase(...)`.
  3. Emits success with created user, or error on failure.
- **Postconditions:** Account is created and auth state updated, or error shown.

### 4) Reset Password
- **Title:** Send password reset email
- **Actor:** User
- **Preconditions:** `AuthForgotPasswordRequested` with email
- **Main Flow:**
  1. `AuthBloc` calls `ResetPasswordUseCase(email)`.
  2. Emits success/failure state.
- **Postconditions:** Reset action requested through auth backend.

### 5) Google Login
- **Title:** Login with Google
- **Actor:** User
- **Preconditions:** `AuthGoogleLoginRequested`
- **Main Flow:**
  1. `AuthBloc` calls `LoginWithGoogleUseCase()`.
  2. Emits authenticated user on success.
  3. Emits error on failure.
- **Postconditions:** Session is established or failure returned.

### 6) Logout
- **Title:** Logout current user
- **Actor:** User
- **Preconditions:** `AuthLogoutRequested`
- **Main Flow:**
  1. `AuthBloc` calls `LogoutUseCase()`.
  2. Emits logged-out state.
- **Postconditions:** User session is cleared.

### 7) Load Home Data
- **Title:** Load home page content
- **Actor:** User
- **Preconditions:** `HomeStarted`
- **Main Flow:**
  1. `HomeBloc` calls `GetHomeDataUseCase`.
  2. Also triggers `GetRecommendedSpacesUseCase`, `GetNearbySpacesUseCase`, `GetFeaturedSpacesUseCase`.
  3. Loads notifications via `GetNotificationsUseCase`.
  4. Emits populated home state.
- **Postconditions:** Home screen data is loaded into bloc state.

### 8) Search Spaces
- **Title:** Search and filter spaces
- **Actor:** User
- **Preconditions:** Search events (`SearchResultsStarted`, query/filter events)
- **Main Flow:**
  1. `SearchResultsBloc` calls `SearchSpacesUseCase(...)` using query/filters.
  2. For preferred chips, calls `GetPreferredFilterChipsUseCase(originKey)`.
  3. Emits updated results/chips.
- **Postconditions:** Search results and active filter chips are updated.

### 9) Load Map and Nearby Spaces
- **Title:** View nearby spaces on map
- **Actor:** User
- **Preconditions:** `MapStarted` or map radius events
- **Main Flow:**
  1. `MapBloc` calls `GetCurrentLocationUseCase()`.
  2. Calls `GetNearbySpacesUseCase(center, radiusKm)`.
  3. Re-fetches when radius/show-all changes.
- **Postconditions:** Map center and nearby spaces are available in state.

### 10) View Space Details + Favorites Toggle
- **Title:** Open space details and toggle favorite
- **Actor:** User
- **Preconditions:** `SpaceDetailsStarted` with spaceId
- **Main Flow:**
  1. `SpaceDetailsBloc` loads details via repo (`fetchSpaceDetails`).
  2. Loads current favorites via `GetFavoritesUseCase`.
  3. On favorite toggle:
     - If favorite: `RemoveFromFavoritesUseCase(spaceId)`.
     - Else: `AddToFavoritesUseCase(spaceId, details)`.
  4. Emits updated favorite state + notice.
- **Postconditions:** Space details loaded and favorite status persisted.

### 11) Create Booking Request
- **Title:** Create a booking request with quote recalculation
- **Actor:** User
- **Preconditions:** `BookingRequestStarted` and form interactions; `SubmitBookingRequestPressed`
- **Main Flow:**
  1. `BookingRequestBloc` updates local form fields through events.
  2. Re-quotes using repo `quote(...)` when inputs change.
  3. On submit, calls `CreateBookingRequestUseCase(...)`.
  4. Emits created request and status.
- **Postconditions:** Booking request is created (or error emitted).

### 12) Check Booking Request Status
- **Title:** Open and refresh booking status
- **Actor:** User
- **Preconditions:** `BookingRequestStatusOpened` / `StatusRefreshRequested`
- **Main Flow:**
  1. On open: `GetBookingRequestStatusUseCase(requestId)`.
  2. On refresh: `RefreshBookingRequestStatusUseCase(requestId)`.
  3. State updated with latest request status.
- **Postconditions:** Latest booking request status is shown.

### 13) Cancel Booking Request
- **Title:** Cancel pending/eligible booking request
- **Actor:** User
- **Preconditions:** `CancelRequestPressed`
- **Main Flow:**
  1. `BookingRequestBloc` calls `CancelBookingRequestUseCase(requestId, reason)`.
  2. Emits updated canceled request state.
- **Postconditions:** Request status becomes canceled when backend accepts cancellation.

### 14) Submit Payment for Booking Request
- **Title:** Submit payment with optional uploaded receipt
- **Actor:** User
- **Preconditions:** `PaymentStarted` then `PayNowPressed`; valid payment form/method
- **Main Flow:**
  1. `PaymentBloc` loads details via `GetPaymentDetailsUseCase(bookingId)`.
  2. If transfer + receipt selected, uploads via `UploadPaymentReceiptUseCase`.
  3. Calls `SubmitPaymentUseCase(...)`.
  4. Calls `VerifyPaymentUseCase(bookingId)`.
  5. Emits success/failure state and receipt data.
- **Postconditions:** Payment submission is stored and booking verification re-triggered.

### 15) Load User Bookings
- **Title:** View current user bookings list
- **Actor:** User
- **Preconditions:** `BookingsStarted`
- **Main Flow:**
  1. `BookingsBloc` calls `GetBookingsUseCase()`.
  2. Subscribes to live updates via `ListenBookingsUpdatesUseCase()`.
  3. Applies segment filters in bloc state.
- **Postconditions:** Booking list is visible and reacts to updates.

### 16) Cancel Booking from Bookings List
- **Title:** Cancel an existing booking
- **Actor:** User
- **Preconditions:** `BookingsCancelRequested(bookingId)`
- **Main Flow:**
  1. `BookingsBloc` calls `CancelBookingUseCase(bookingId)`.
  2. Re-fetches list with `GetBookingsUseCase`.
- **Postconditions:** Booking list reflects cancellation.

### 17) Open Booking Details
- **Title:** View booking details
- **Actor:** User
- **Preconditions:** `BookingDetailsStarted(bookingId)`
- **Main Flow:**
  1. User booking-details bloc calls `GetBookingDetailsUseCase(bookingId)`.
  2. Emits details or error.
- **Postconditions:** Booking detail state populated.

### 18) Manage Notification Settings + Read Status
- **Title:** Load notifications and persist notification settings
- **Actor:** User
- **Preconditions:** `NotificationsStarted` / settings events
- **Main Flow:**
  1. On start, get token via `GetFcmTokenUseCase`; save using `SaveFcmTokenUseCase`.
  2. Load settings via `GetNotificationSettingsUseCase`.
  3. Load notifications via `GetNotificationsUseCase`.
  4. Mark all read via `MarkAllNotificationsReadUseCase`.
  5. Save changed settings via `SaveNotificationSettingsUseCase`.
- **Postconditions:** Notification list/settings stay synchronized with backend source.

### 19) Manage Profile
- **Title:** View and edit profile, password, email verification, avatar
- **Actor:** User
- **Preconditions:** Profile events in `ProfileBloc`
- **Main Flow:**
  1. Load profile via `GetProfileUseCase`.
  2. Update profile via `UpdateProfileUseCase`.
  3. Change password via `ChangePasswordUseCase`.
  4. Send verify email via `VerifyEmailUseCase` and sync via `SyncEmailVerificationUseCase`.
  5. Upload avatar via `UploadProfileImageUseCase(file)` then update profile.
- **Postconditions:** Profile data and verification flags are updated in state/backend.

### 20) View Usage Insights
- **Title:** Generate usage and spending insights
- **Actor:** User
- **Preconditions:** `ProfileUsageStarted`
- **Main Flow:**
  1. `GetUserBookingsUseCase()`.
  2. `GetSpacesByIdsUseCase(spaceIds)`.
  3. Compute usage with `CalculateUsageUseCase`.
  4. Compute spending with `CalculateSpendingUseCase`.
  5. Generate recommendation with `GenerateRecommendationUseCase`.
  6. Emit composed insight object.
- **Postconditions:** Usage insight card data is available.

### 21) Browse Reviews
- **Title:** Load and filter user reviews list
- **Actor:** User
- **Preconditions:** `ReviewsStarted` / `ReviewsFilterChanged`
- **Main Flow:**
  1. `ReviewsBloc` calls `GetReviewsUseCase(...)`.
  2. Applies selected filter and emits updated list.
- **Postconditions:** Filtered reviews list is shown.

### 22) Browse Offers
- **Title:** Load offers and perform text search
- **Actor:** User
- **Preconditions:** `OffersStarted` / `OffersSearchChanged`
- **Main Flow:**
  1. Load all using `GetOffersUseCase`.
  2. Search using `SearchOffersUseCase(query)`.
- **Postconditions:** Offer list is populated/filtered.

### 23) Weekly Plan
- **Title:** Load weekly plan details and activate plan
- **Actor:** User
- **Preconditions:** `WeeklyPlanStarted` / hub change / activate action
- **Main Flow:**
  1. `WeeklyPlanBloc` calls `GetWeeklyPlanUseCase(hubId)`.
  2. On activate calls `ActivatePlanUseCase(selectedHubId)`.
  3. Emits result state.
- **Postconditions:** Plan details shown; activation action executed.

### 24) AI Concierge Conversation
- **Title:** Start and continue AI concierge flow
- **Actor:** User
- **Preconditions:** Concierge events
- **Main Flow:**
  1. Start with `StartConciergeUseCase`.
  2. Quick reply path uses `SelectQuickReplyUseCase(reply)`.
  3. Free text path uses `SubmitAnswerUseCase(answer)`.
  4. Bloc appends messages and updates current step.
- **Postconditions:** Conversation state progresses and suggestions are updated.

### 25) Submit Space Request
- **Title:** Submit request for a new space
- **Actor:** User
- **Preconditions:** `SubmitSpaceRequestEvent(request)`
- **Main Flow:**
  1. `SpaceRequestBloc` calls `SubmitSpaceRequestUseCase(request)`.
  2. Emits success/error state.
- **Postconditions:** Space request is stored in source repository.

### 26) Payments & Receipts
- **Title:** View receipts, monthly spending, and open in-app invoice screen
- **Actor:** User
- **Preconditions:** `PaymentsReceiptsStarted`
- **Main Flow:**
  1. `PaymentsReceiptsBloc` loads receipts via `GetUserReceiptsUseCase`.
  2. Loads monthly totals via `GetMonthlyPaymentsUseCase(year, month)`.
  3. Toggles expanded list using `PaymentsReceiptsToggleViewMoreRequested`.
  4. On invoice action, navigates to `InvoicePage` using selected booking data.
  5. In `InvoicePage`, download/share requests are handled through invoice bloc/usecases.
- **Postconditions:** Receipts UI data is loaded; invoice is displayed inside the app.

### 27) Booking Status Invoice Download
- **Title:** Open invoice from booking status
- **Actor:** User
- **Preconditions:** Booking status page loaded with request data
- **Main Flow:**
  1. Build invoice data from the current booking request and current user profile.
  2. Navigate to `InvoicePage`.
- **Postconditions:** Invoice is rendered in-app from booking data.

### 28) App Connectivity State
- **Title:** Track internet connection state
- **Actor:** User (system-driven)
- **Preconditions:** `InternetBloc` initialized
- **Main Flow:**
  1. `CheckConnection` event calls `CheckInternetConnectionUseCase`.
  2. Emits connected/disconnected state via events (`ConnectionRestored`, `ConnectionLost`).
- **Postconditions:** UI can react to current connectivity state.

---

## Admin Use Cases

### 1) Admin Home KPIs
- **Title:** Load admin spaces, KPIs, and recent activity
- **Actor:** Admin
- **Preconditions:** `AdminHomeStarted`
- **Main Flow:**
  1. `AdminHomeBloc` calls `GetAdminSpacesUseCase`.
  2. Calls `GetAdminRecentActivityUseCase`.
  3. Calls `GetAdminHomeKpisUseCase(spaceId)` for selected space.
- **Postconditions:** Dashboard home widgets are populated.

### 2) Admin Dashboard Data
- **Title:** Load admin dashboard overview/data
- **Actor:** Admin
- **Preconditions:** `AdminDashboardStarted`
- **Main Flow:**
  1. `AdminDashboardBloc` calls `GetAdminDashboardDataUseCase`.
  2. Emits dashboard state including spaces/overview fields.
- **Postconditions:** Admin dashboard renders loaded data.

### 3) Booking Requests Moderation
- **Title:** List booking requests by tab and approve/reject
- **Actor:** Admin
- **Preconditions:** `BookingRequestsStarted` (admin bookings module)
- **Main Flow:**
  1. Load list via `GetBookingsUseCase(status: activeTab)`.
  2. Approve with `AcceptBookingUseCase(bookingId)`.
  3. Reject with `RejectBookingUseCase(bookingId)`.
  4. Reload active tab data.
- **Postconditions:** Request status is updated and reflected in admin list.

### 4) Booking Details Actions
- **Title:** Confirm or cancel booking from admin details page
- **Actor:** Admin
- **Preconditions:** `BookingDetailsStarted(bookingId)` (admin module)
- **Main Flow:**
  1. Load details with `GetBookingDetailsUseCase(bookingId)`.
  2. Confirm action uses `ConfirmBookingUseCase(bookingId)`.
  3. Cancel action uses `CancelBookingUseCase(bookingId, reason)`.
- **Postconditions:** Booking state is updated in source and can be reloaded.

### 5) Reviews & Reports Moderation
- **Title:** Load reviews/reports and moderate responses
- **Actor:** Admin
- **Preconditions:** `ReviewsReportsStarted`
- **Main Flow:**
  1. `ReviewsReportsBloc` calls `GetReviewsUseCase` and `GetReportsUseCase`.
  2. Hide review with `HideReviewUseCase(reviewId)`.
  3. Reply with `ReplyReviewUseCase(reviewId, reply)`.
- **Postconditions:** Moderation actions are persisted and list can refresh.

### 6) Manage My Spaces List
- **Title:** Load owned spaces and perform hide/delete
- **Actor:** Admin/Space Owner
- **Preconditions:** `MySpacesStarted`
- **Main Flow:**
  1. `MySpacesBloc` loads list with `GetMySpacesUseCase`.
  2. Hide toggle via `HideSpaceUseCase(spaceId)`.
  3. Delete via `DeleteSpaceUseCase(spaceId)`.
- **Postconditions:** Space list reflects updates.

### 7) Add/Edit Space Form
- **Title:** Create/update space with detailed editable form
- **Actor:** Admin/Space Owner
- **Preconditions:** `AddEditSpaceStarted` (with optional spaceId)
- **Main Flow:**
  1. Load form via `GetSpaceFormUseCase(spaceId)`.
  2. Load amenity catalog via `GetAmenityCatalogUseCase`.
  3. Add amenity via `AddAmenityUseCase(name)`.
  4. Update many local form fields through bloc events (pricing, location, schedule, policies, images, payment fields).
  5. Save via `SaveSpaceUseCase(form)`.
- **Postconditions:** Space form is persisted.

### 8) Space Management Visibility
- **Title:** Toggle hidden state for a space
- **Actor:** Admin/Space Owner
- **Preconditions:** `SpaceManagementStarted(spaceId)`
- **Main Flow:**
  1. Load current management model via `GetSpaceManagementUseCase(spaceId)`.
  2. Toggle hidden flag via `SetSpaceHiddenUseCase(spaceId, hidden)`.
- **Postconditions:** Space visibility flag is updated.

### 9) Calendar Availability Day Settings
- **Title:** Load and save day availability
- **Actor:** Admin/Space Owner
- **Preconditions:** `CalendarStarted(dayId)`
- **Main Flow:**
  1. Load day by `GetDayUseCase(dayId)`.
  2. Modify closed/special hours in bloc state.
  3. Save via `SaveDayUseCase(day)`.
- **Postconditions:** Day availability configuration is saved.

### 10) Offers Management (Admin)
- **Title:** Load offers, toggle status, and create offer
- **Actor:** Admin/Space Owner
- **Preconditions:** Offers management start event
- **Main Flow:**
  1. Load list via `GetOffersUseCase`.
  2. Toggle active state via `ToggleOfferUseCase(offerId, enabled)`.
  3. Build draft offer through create-form events.
  4. Submit via `CreateOfferUseCase(offer)`.
- **Postconditions:** Offers collection is updated.

### 11) Users Search (Admin)
- **Title:** Search users with query/filter
- **Actor:** Admin
- **Preconditions:** `UsersStarted` or query/filter changes
- **Main Flow:**
  1. `UsersBloc` calls `SearchUsersUseCase(query, filter)`.
  2. Emits returned users list.
- **Postconditions:** Admin users table is filtered by current criteria.

### 12) User Profile Moderation (Admin)
- **Title:** Approve/block user and add internal note
- **Actor:** Admin
- **Preconditions:** `UserProfileStarted(userId)`
- **Main Flow:**
  1. Load profile via `GetUserProfileUseCase(userId)`.
  2. Approve via `ApproveUserUseCase(userId)`.
  3. Block via `BlockUserUseCase(userId)`.
  4. Add note via `AddUserNoteUseCase(userId, note)`.
  5. Reload profile after action.
- **Postconditions:** User moderation fields are updated.

### 13) Payments & Refunds (Admin)
- **Title:** Filter payments, open details, and issue refund
- **Actor:** Admin
- **Preconditions:** `PaymentsStarted` in admin payments module
- **Main Flow:**
  1. Load list via `GetPaymentsUseCase(periodId, status)`.
  2. Open payment details via `GetPaymentDetailsUseCase(paymentId)`.
  3. Issue refund via `IssueRefundUseCase(paymentId)`.
  4. Reload list after refund.
- **Postconditions:** Refund action is executed and list reflects current status.

### 14) Analytics Export (Admin)
- **Title:** Load analytics and export report
- **Actor:** Admin
- **Preconditions:** `AnalyticsStarted`
- **Main Flow:**
  1. Load analytics through `GetAnalyticsUseCase`.
  2. Export action triggers `ExportReportUseCase`.
- **Postconditions:** Analytics data is available and export action executed.

### 15) Admin Logout
- **Title:** Logout from admin settings
- **Actor:** Admin
- **Preconditions:** `AdminSettingsLogoutPressed`
- **Main Flow:**
  1. `AdminSettingsBloc` calls admin `LogoutUseCase`.
  2. Emits logged-out/success state.
- **Postconditions:** Admin session is terminated.

### 16) Sub-admins/Spaces Load
- **Title:** Load admin spaces and related user records for sub-admin screen
- **Actor:** Admin
- **Preconditions:** `LoadSubAdminsEvent`
- **Main Flow:**
  1. `SubAdminsBloc` calls `GetAdminSpacesUseCase`.
  2. Performs user lookup through Firestore API query in bloc.
  3. Emits combined result state.
- **Postconditions:** Sub-admin page has loaded spaces and fetched users data.

---

## Notes on Scope Accuracy
- The scenarios above are based on currently implemented blocs/usecases/actions.
- No unimplemented theoretical behaviors are included.
- Approval/rejection/cancel actions are only documented where corresponding blocs/usecases exist in code.
