import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/app_injector.dart';
import '../../payments_receipts/bloc/payments_receipts_bloc.dart';
import '../../payments_receipts/bloc/payments_receipts_event.dart';
import '../../payments_receipts/view/payments_receipts_page.dart' as feature;

class PaymentsReceiptsPage extends StatelessWidget {
  const PaymentsReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentsReceiptsBloc>(
      create: (_) => getIt<PaymentsReceiptsBloc>()
        ..add(
          const PaymentsReceiptsStarted(),
        ),
      child: const feature.PaymentsReceiptsPage(),
    );
  }
}
