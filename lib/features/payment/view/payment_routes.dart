import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import 'pages/payment_page.dart';
import 'pages/payment_success_page.dart';

class PaymentRoutes {
  PaymentRoutes._();

  static Route<void> payment({
    required PaymentBloc bloc,
    required String requestId,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: bloc..add(PaymentStarted(requestId)),
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