import '../../features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../features/home/domain/usecases/get_recommended_spaces_usecase.dart';
import '../../features/home/domain/usecases/get_nearby_spaces_usecase.dart';
import '../../features/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/home/domain/usecases/get_featured_spaces_usecase.dart';
import '../../features/home/domain/repos/home_repo.dart';
import '../../features/home/data/sources/home_firebase_source.dart';
import '../../features/home/data/repos/home_repo_firebase.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/booking_details/domain/usecases/update_booking_status_usecase.dart' as user_booking_details_update;
import '../../features/booking_details/domain/usecases/get_booking_details_usecase.dart' as user_booking_details_get;
import '../../features/booking_details/domain/usecases/cancel_booking_usecase.dart' as user_booking_details_cancel;
import '../../features/booking_details/domain/repos/booking_details_repo.dart';
import '../../features/booking_details/data/sources/booking_details_source.dart';
import '../../features/booking_details/data/sources/booking_details_firebase_source.dart';
import '../../features/booking_details/data/repos/booking_details_repo_firebase.dart';
import '../../features/booking_details/bloc/booking_details_bloc.dart' as user_booking_details_bloc;
import '../../features/bookings/domain/usecases/listen_bookings_updates_usecase.dart';
import '../../features/bookings/domain/usecases/get_bookings_usecase.dart' as user_bookings_usecase;
import '../../features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import '../../features/bookings/domain/usecases/cancel_booking_usecase.dart';
import '../../features/bookings/domain/repos/bookings_repo.dart';
import '../../features/bookings/data/sources/bookings_source.dart';
import '../../features/bookings/data/sources/bookings_firebase_source.dart';
import '../../features/bookings/data/repos/bookings_repo_impl.dart';
import '../../features/bookings/bloc/bookings_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/admin/bookings/booking_requests/bloc/booking_requests_bloc.dart';
import '../../features/admin/bookings/booking_requests/data/repos/admin_bookings_repo_impl.dart';
import '../../features/admin/bookings/booking_requests/data/sources/admin_bookings_firebase_source.dart';
import '../../features/admin/bookings/booking_requests/domain/usecases/accept_booking_usecase.dart';
import '../../features/admin/bookings/booking_requests/domain/usecases/get_bookings_usecase.dart';
import '../../features/admin/bookings/booking_requests/domain/usecases/reject_booking_usecase.dart';
import '../../features/app_start/bloc/app_start_bloc.dart';
import '../../features/app_start/data/repos/app_start_repo_firebase.dart';
import '../../features/app_start/domain/usecases/initialize_startup_usecase.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/data/repos/auth_repo_firebase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/login_with_google_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/booking_request/bloc/booking_request_bloc.dart';
import '../../features/booking_request/data/repos/booking_request_repo_firebase.dart';
import '../../features/booking_request/data/sources/booking_request_firebase_source.dart';
import '../../features/booking_request/domain/usecases/cancel_booking_request_usecase.dart';
import '../../features/booking_request/domain/usecases/create_booking_request_usecase.dart';
import '../../features/booking_request/domain/usecases/get_booking_request_status_usecase.dart';
import '../../features/booking_request/domain/usecases/refresh_booking_request_status_usecase.dart';
import '../../features/language/bloc/language_bloc.dart';
import '../../features/notifications/bloc/notifications_bloc.dart';
import '../../features/notifications/data/repos/notifications_repo_impl.dart';
import '../../features/notifications/data/sources/notifications_firebase_source.dart';
import '../../features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import '../../features/notifications/domain/usecases/get_notification_settings_usecase.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/listen_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/save_fcm_token_usecase.dart';
import '../../features/notifications/domain/usecases/save_notification_settings_usecase.dart';
import '../../features/payment/bloc/payment_bloc.dart';
import '../../features/payment/data/repos/payment_repo_firebase.dart';
import '../../features/payment/data/sources/payment_firebase_source.dart';
import '../../features/payment/domain/usecases/get_payment_summary_usecase.dart';
import '../../features/payment/domain/usecases/verify_payment_usecase.dart';
import '../../features/payment/domain/usecases/upload_payment_receipt_usecase.dart';
import '../../features/payment/domain/usecases/submit_payment_usecase.dart';
import '../../features/payment/domain/usecases/get_payment_details_usecase.dart';
import '../../features/payment/domain/usecases/pay_booking_request_usecase.dart';
import '../../features/internet/bloc/internet_bloc.dart';
import '../../features/internet/data/repos/internet_repo_impl.dart';
import '../../features/internet/data/sources/internet_source.dart';
import '../../features/internet/data/sources/internet_source_connectivity.dart';
import '../../features/internet/domain/repos/internet_repo.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../services/local_storage_service.dart';
import '../services/firebase/firebase_messaging_service.dart';
import '../services/firestore_api.dart';
import '../services/network/connectivity_service.dart';
import '../services/startup/app_initializer_service.dart';

final GetIt getIt = GetIt.instance;

void setupInjector() {
  if (getIt.isRegistered<LocalStorageService>()) return;

  getIt.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  getIt.registerLazySingleton<FirestoreApi>(() => FirestoreApi());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirebaseMessagingService>(() => FirebaseMessagingService.instance);
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<AppInitializerService>(() => AppInitializerService());

  getIt.registerLazySingleton<LanguageService>(() => LanguageService(getIt<LocalStorageService>()));

  // auth
  getIt.registerLazySingleton<AuthRepoFirebase>(() => AuthRepoFirebase(getIt<LocalStorageService>()));
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt<AuthRepoFirebase>()));
  getIt.registerFactory<SignUpUseCase>(() => SignUpUseCase(getIt<AuthRepoFirebase>()));
  getIt.registerFactory<ResetPasswordUseCase>(() => ResetPasswordUseCase(getIt<AuthRepoFirebase>()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt<AuthRepoFirebase>()));
  getIt.registerFactory<LoginWithGoogleUseCase>(() => LoginWithGoogleUseCase(getIt<AuthRepoFirebase>()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        signUpUseCase: getIt<SignUpUseCase>(),
        resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        googleUseCase: getIt<LoginWithGoogleUseCase>(),
      ));

  // app start + language
  getIt.registerFactory<InitializeStartupUseCase>(() => InitializeStartupUseCase(getIt<AppInitializerService>()));
  getIt.registerFactory<AppStartBloc>(() => AppStartBloc(
        AppStartRepoFirebase(getIt<LocalStorageService>()),
        initializeStartupUseCase: getIt<InitializeStartupUseCase>(),
      ));
  getIt.registerFactory<LanguageBloc>(() => LanguageBloc(getIt<LanguageService>()));

  // internet
  getIt.registerFactory<InternetSource>(() => InternetSourceConnectivity(getIt<ConnectivityService>()));
  getIt.registerFactory<InternetRepo>(() => InternetRepoImpl(getIt<InternetSource>()));
  getIt.registerFactory<InternetBloc>(() => InternetBloc(repo: getIt<InternetRepo>()));

  // notifications
  getIt.registerLazySingleton<NotificationsFirebaseSource>(() => NotificationsFirebaseSource());
  getIt.registerLazySingleton<NotificationsRepoImpl>(() => NotificationsRepoImpl(getIt<NotificationsFirebaseSource>()));
  getIt.registerFactory<GetNotificationsUseCase>(() => GetNotificationsUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<GetNotificationSettingsUseCase>(() => GetNotificationSettingsUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<SaveNotificationSettingsUseCase>(() => SaveNotificationSettingsUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<GetFcmTokenUseCase>(() => GetFcmTokenUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<SaveFcmTokenUseCase>(() => SaveFcmTokenUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<ListenNotificationsUseCase>(() => ListenNotificationsUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<MarkAllNotificationsReadUseCase>(() => MarkAllNotificationsReadUseCase(getIt<NotificationsRepoImpl>()));
  getIt.registerFactory<NotificationsBloc>(() => NotificationsBloc(
        getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
        getNotificationSettingsUseCase: getIt<GetNotificationSettingsUseCase>(),
        saveNotificationSettingsUseCase: getIt<SaveNotificationSettingsUseCase>(),
        getFcmTokenUseCase: getIt<GetFcmTokenUseCase>(),
        saveFcmTokenUseCase: getIt<SaveFcmTokenUseCase>(),
        listenNotificationsUseCase: getIt<ListenNotificationsUseCase>(),
        markAllNotificationsReadUseCase: getIt<MarkAllNotificationsReadUseCase>(),
      ));

  // home
  getIt.registerFactory<HomeSource>(() => HomeFirebaseSource(getIt<FirestoreApi>()));
  getIt.registerFactory<HomeRepo>(() => HomeRepoFirebase(getIt<HomeSource>()));
  getIt.registerFactory<GetHomeDataUseCase>(() => GetHomeDataUseCase(getIt<HomeRepo>()));
  getIt.registerFactory<GetRecommendedSpacesUseCase>(() => GetRecommendedSpacesUseCase(getIt<HomeRepo>()));
  getIt.registerFactory<GetNearbySpacesUseCase>(() => GetNearbySpacesUseCase(getIt<HomeRepo>()));
  getIt.registerFactory<GetFeaturedSpacesUseCase>(() => GetFeaturedSpacesUseCase(getIt<HomeRepo>()));
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        getHomeDataUseCase: getIt<GetHomeDataUseCase>(),
        getRecommendedSpacesUseCase: getIt<GetRecommendedSpacesUseCase>(),
        getNearbySpacesUseCase: getIt<GetNearbySpacesUseCase>(),
        getFeaturedSpacesUseCase: getIt<GetFeaturedSpacesUseCase>(),
        getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      ));

  // user bookings
  getIt.registerFactory<BookingsSource>(() => BookingsFirebaseSource(
        api: getIt<FirestoreApi>(),
        authService: getIt<AuthService>(),
      ));
  getIt.registerFactory<BookingsRepo>(() => BookingsRepoImpl(getIt<BookingsSource>()));
  getIt.registerFactory<user_bookings_usecase.GetBookingsUseCase>(() => user_bookings_usecase.GetBookingsUseCase(getIt<BookingsRepo>()));
  getIt.registerFactory<GetBookingByIdUseCase>(() => GetBookingByIdUseCase(getIt<BookingsRepo>()));
  getIt.registerFactory<CancelBookingUseCase>(() => CancelBookingUseCase(getIt<BookingsRepo>()));
  getIt.registerFactory<ListenBookingsUpdatesUseCase>(() => ListenBookingsUpdatesUseCase(getIt<BookingsRepo>()));
  getIt.registerFactory<BookingsBloc>(() => BookingsBloc(
        getBookings: getIt<user_bookings_usecase.GetBookingsUseCase>(),
        cancelBooking: getIt<CancelBookingUseCase>(),
        listenBookingsUpdates: getIt<ListenBookingsUpdatesUseCase>(),
      ));

  // user booking details
  getIt.registerFactory<BookingDetailsSource>(() => BookingDetailsFirebaseSource(getIt<FirestoreApi>()));
  getIt.registerFactory<BookingDetailsRepo>(() => BookingDetailsRepoFirebase(source: getIt<BookingDetailsSource>()));
  getIt.registerFactory<user_booking_details_get.GetBookingDetailsUseCase>(() => user_booking_details_get.GetBookingDetailsUseCase(getIt<BookingDetailsRepo>()));
  getIt.registerFactory<user_booking_details_cancel.CancelBookingUseCase>(() => user_booking_details_cancel.CancelBookingUseCase(getIt<BookingDetailsRepo>()));
  getIt.registerFactory<user_booking_details_update.UpdateBookingStatusUseCase>(() => user_booking_details_update.UpdateBookingStatusUseCase(getIt<BookingDetailsRepo>()));
  getIt.registerFactory<user_booking_details_bloc.BookingDetailsBloc>(() => user_booking_details_bloc.BookingDetailsBloc(
        getBookingDetailsUseCase: getIt<user_booking_details_get.GetBookingDetailsUseCase>(),
      ));

  // booking request
  getIt.registerFactory<BookingRequestFirebaseSource>(() => BookingRequestFirebaseSource(getIt<FirestoreApi>()));
  getIt.registerFactory<BookingRequestRepoFirebase>(() => BookingRequestRepoFirebase(source: getIt<BookingRequestFirebaseSource>()));
  getIt.registerFactory<CreateBookingRequestUseCase>(() => CreateBookingRequestUseCase(getIt<BookingRequestRepoFirebase>()));
  getIt.registerFactory<GetBookingRequestStatusUseCase>(() => GetBookingRequestStatusUseCase(getIt<BookingRequestRepoFirebase>()));
  getIt.registerFactory<RefreshBookingRequestStatusUseCase>(() => RefreshBookingRequestStatusUseCase(getIt<BookingRequestRepoFirebase>()));
  getIt.registerFactory<CancelBookingRequestUseCase>(() => CancelBookingRequestUseCase(getIt<BookingRequestRepoFirebase>()));
  getIt.registerFactory<BookingRequestBloc>(() => BookingRequestBloc(
        repo: getIt<BookingRequestRepoFirebase>(),
        createUseCase: getIt<CreateBookingRequestUseCase>(),
        getStatusUseCase: getIt<GetBookingRequestStatusUseCase>(),
        refreshStatusUseCase: getIt<RefreshBookingRequestStatusUseCase>(),
        cancelUseCase: getIt<CancelBookingRequestUseCase>(),
      ));

  // payment
  getIt.registerFactory<PaymentFirebaseSource>(() => PaymentFirebaseSource(getIt<FirestoreApi>()));
  getIt.registerFactory<PaymentRepoFirebase>(() => PaymentRepoFirebase(source: getIt<PaymentFirebaseSource>()));
  getIt.registerFactory<GetPaymentSummaryUseCase>(() => GetPaymentSummaryUseCase(getIt<PaymentRepoFirebase>()));
  getIt.registerFactory<PayBookingRequestUseCase>(() => PayBookingRequestUseCase(getIt<PaymentRepoFirebase>()));
  getIt.registerFactory<GetPaymentDetailsUseCase>(() => GetPaymentDetailsUseCase(getIt<PaymentRepoFirebase>()));
  getIt.registerFactory<SubmitPaymentUseCase>(() => SubmitPaymentUseCase(getIt<PaymentRepoFirebase>()));
  getIt.registerFactory<VerifyPaymentUseCase>(() => VerifyPaymentUseCase(getIt<PaymentRepoFirebase>()));
  getIt.registerFactory<UploadPaymentReceiptUseCase>(() => UploadPaymentReceiptUseCase(getIt<PaymentRepoFirebase>()));
  getIt.registerFactory<PaymentBloc>(() => PaymentBloc(
        getPaymentDetailsUseCase: getIt<GetPaymentDetailsUseCase>(),
        submitPaymentUseCase: getIt<SubmitPaymentUseCase>(),
        verifyPaymentUseCase: getIt<VerifyPaymentUseCase>(),
        uploadPaymentReceiptUseCase: getIt<UploadPaymentReceiptUseCase>(),
      ));

  // admin booking requests
  getIt.registerFactory<AdminBookingsFirebaseSource>(() => AdminBookingsFirebaseSource());
  getIt.registerFactory<AdminBookingsRepoImpl>(() => AdminBookingsRepoImpl(getIt<AdminBookingsFirebaseSource>()));
  getIt.registerFactory<GetBookingsUseCase>(() => GetBookingsUseCase(getIt<AdminBookingsRepoImpl>()));
  getIt.registerFactory<AcceptBookingUseCase>(() => AcceptBookingUseCase(getIt<AdminBookingsRepoImpl>()));
  getIt.registerFactory<RejectBookingUseCase>(() => RejectBookingUseCase(getIt<AdminBookingsRepoImpl>()));
  getIt.registerFactory<BookingRequestsBloc>(() => BookingRequestsBloc(
        getBookings: getIt<GetBookingsUseCase>(),
        acceptBooking: getIt<AcceptBookingUseCase>(),
        rejectBooking: getIt<RejectBookingUseCase>(),
      ));
}

class AppInjector {
  static BookingsBloc createBookingsBloc() => getIt<BookingsBloc>();

  static user_booking_details_bloc.BookingDetailsBloc createUserBookingDetailsBloc() => getIt<user_booking_details_bloc.BookingDetailsBloc>();

  static BookingRequestBloc createBookingBloc() => getIt<BookingRequestBloc>();

  static PaymentBloc createPaymentBloc() => getIt<PaymentBloc>();

  static NotificationsBloc createNotificationsBloc() => getIt<NotificationsBloc>();

  static BookingRequestsBloc createAdminBookingRequestsBloc() => getIt<BookingRequestsBloc>();
}
