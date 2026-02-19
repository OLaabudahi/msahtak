import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repos/booking_request_repo_dummy.dart';
import 'data/repos/payment_repo_dummy.dart';
import 'domain/entities/booking_request_entity.dart';
import 'domain/repos/booking_request_repo.dart';
import 'domain/repos/payment_repo.dart';
import 'domain/usecases/cancel_booking_request_usecase.dart';
import 'domain/usecases/create_booking_request_usecase.dart';
import 'domain/usecases/get_booking_request_status_usecase.dart';
import 'domain/usecases/get_payment_summary_usecase.dart';
import 'domain/usecases/pay_booking_request_usecase.dart';
import 'domain/usecases/refresh_booking_request_status_usecase.dart';
import 'presentation/booking_request/bloc/booking_request_bloc.dart';
import 'presentation/booking_request/bloc/booking_request_event.dart';
import 'presentation/booking_request/view/booking_status_page.dart';
import 'presentation/booking_request/view/pending_booking_approval_page.dart';
import 'presentation/booking_request/view/request_booking_page.dart';
import 'presentation/payment/bloc/payment_bloc.dart';
import 'presentation/payment/bloc/payment_event.dart';
import 'presentation/payment/view/payment_page.dart';
import 'presentation/payment/view/payment_success_page.dart';

class BookingFeatureRoutes {
  BookingFeatureRoutes._();

  static BookingRequestRepo _bookingRepo() => BookingRequestRepoDummy();
  static PaymentRepo _paymentRepo() => PaymentRepoDummy();

  static BookingRequestBloc _bookingBloc() {
    final repo = _bookingRepo();
    return BookingRequestBloc(
      repo: repo,
      createUseCase: CreateBookingRequestUseCase(repo),
      getStatusUseCase: GetBookingRequestStatusUseCase(repo),
      refreshStatusUseCase: RefreshBookingRequestStatusUseCase(repo),
      cancelUseCase: CancelBookingRequestUseCase(repo),
    );
  }

  static PaymentBloc _paymentBloc() {
    final repo = _paymentRepo();
    return PaymentBloc(
      repo: repo,
      getSummaryUseCase: GetPaymentSummaryUseCase(repo),
      payUseCase: PayBookingRequestUseCase(repo),
    );
  }

  static Route<void> requestBooking({
    required SpaceSummaryEntity space,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => _bookingBloc()
          ..add(
            BookingRequestStarted(
              space: space,
              availableAddOns: const [
                AddOnEntity(
                  id: 'MEETING_ROOM',
                  title: 'Meeting room',
                  price: 20,
                  unitLabel: '/ hour',
                  isSelected: false,
                ),
              ],
            ),
          ),
        child: RequestBookingPage(space: space),
      ),
    );
  }

  static Route<void> pendingApproval({
    required BookingRequestEntity request,
  }) {
    return MaterialPageRoute(
      builder: (_) => PendingBookingApprovalPage(request: request),
    );
  }

  static Route<void> bookingStatus({
    required String requestId,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => _bookingBloc()..add(BookingRequestStatusOpened(requestId)),
        child: BookingStatusPage(requestId: requestId),
      ),
    );
  }

  static Route<void> payment({
    required String requestId,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => _paymentBloc()..add(PaymentStarted(requestId)),
        child: PaymentPage(requestId: requestId),
      ),
    );
  }

  static Route<void> paymentSuccess({
    required PaymentSuccessArgs args,
  }) {
    return MaterialPageRoute(
      builder: (_) => PaymentSuccessPage(args: args),
    );
  }
}

