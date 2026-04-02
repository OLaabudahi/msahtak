import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/booking_request_bloc.dart';
import '../bloc/booking_request_event.dart';
import '../domain/entities/booking_request_entity.dart';
import 'pages/request_booking_page.dart';
import 'pages/pending_booking_approval_page.dart';
import 'pages/booking_status_page.dart';

class BookingRequestRoutes {
  BookingRequestRoutes._();

  static Route<void> requestBooking({
    required BookingRequestBloc bloc,
    required SpaceSummaryEntity space,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: bloc
          ..add(
            BookingRequestStarted(
              space: space,
              availableAddOns: const [],
            ),
          ),
        child: RequestBookingPage(space: space),
      ),
    );
  }
  static Route<void> pendingApproval({
    required BookingRequestBloc bloc,
    required BookingRequestEntity request,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: PendingBookingApprovalPage(request: request),
      ),
    );
  }


  static Route<void> bookingStatus({
    required BookingRequestBloc bloc,
    required String bookingId,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: bloc..add(BookingRequestStatusOpened(bookingId)),
        child: BookingStatusPage(bookingId: bookingId),
      ),
    );
  }

}

