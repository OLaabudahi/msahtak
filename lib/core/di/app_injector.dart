import '../../features/booking_request/bloc/booking_request_bloc.dart';
import '../../features/booking_request/data/repos/booking_request_repo_firebase.dart';
import '../../features/booking_request/data/sources/booking_request_firebase_source.dart';
import '../../features/booking_request/domain/usecases/create_booking_request_usecase.dart';
import '../../features/booking_request/domain/usecases/get_booking_request_status_usecase.dart';
import '../../features/booking_request/domain/usecases/refresh_booking_request_status_usecase.dart';
import '../../features/booking_request/domain/usecases/cancel_booking_request_usecase.dart';

import '../../features/notifications/bloc/notifications_bloc.dart';
import '../../features/payment/bloc/payment_bloc.dart';
import '../../features/payment/data/repos/payment_repo_firebase.dart';
import '../../features/payment/data/sources/payment_firebase_source.dart';
import '../../features/payment/domain/usecases/get_payment_summary_usecase.dart';
import '../../features/payment/domain/usecases/pay_booking_request_usecase.dart';

import '../../features/notifications/data/repos/notifications_repo_dummy.dart';
import '../../features/notifications/data/sources/notifications_firebase_source.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/get_notification_settings_usecase.dart';
import '../../features/notifications/domain/usecases/save_notification_settings_usecase.dart';

import '../services/firestore_api.dart';

class AppInjector {
  
  static BookingRequestBloc createBookingBloc() {
    final source = BookingRequestFirebaseSource(FirestoreApi());
    final repo = BookingRequestRepoFirebase(source: source);

    return BookingRequestBloc(
      repo: repo,
      createUseCase: CreateBookingRequestUseCase(repo),
      getStatusUseCase: GetBookingRequestStatusUseCase(repo),
      refreshStatusUseCase: RefreshBookingRequestStatusUseCase(repo),
      cancelUseCase: CancelBookingRequestUseCase(repo),
    );
  }

  
  static PaymentBloc createPaymentBloc() {
    final source = PaymentFirebaseSource(FirestoreApi());
    final repo = PaymentRepoFirebase(source: source);

    return PaymentBloc(
      repo: repo,
      getSummaryUseCase: GetPaymentSummaryUseCase(repo),
      payUseCase: PayBookingRequestUseCase(repo),
    );
  }

  
  static NotificationsBloc createNotificationsBloc() {
    final source = NotificationsFirebaseSource();
    final repo = NotificationsRepoDummy(source);

    return NotificationsBloc(
      getNotificationsUseCase: GetNotificationsUseCase(repo),
      getNotificationSettingsUseCase: GetNotificationSettingsUseCase(repo),
      saveNotificationSettingsUseCase: SaveNotificationSettingsUseCase(repo),
    );
  }
}
