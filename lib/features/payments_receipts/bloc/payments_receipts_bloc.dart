import 'package:bloc/bloc.dart';

import '../domain/usecases/get_monthly_payments_usecase.dart';
import '../domain/usecases/get_user_receipts_usecase.dart';
import 'payments_receipts_event.dart';
import 'payments_receipts_state.dart';

class PaymentsReceiptsBloc
    extends Bloc<PaymentsReceiptsEvent, PaymentsReceiptsState> {
  final GetUserReceiptsUseCase getUserReceiptsUseCase;
  final GetMonthlyPaymentsUseCase getMonthlyPaymentsUseCase;

  PaymentsReceiptsBloc({
    required this.getUserReceiptsUseCase,
    required this.getMonthlyPaymentsUseCase,
  }) : super(PaymentsReceiptsState.initial()) {
    on<PaymentsReceiptsStarted>(_onStarted);
    on<PaymentsReceiptsToggleViewMoreRequested>(_onToggleViewMore);
  }

  Future<void> _onStarted(
    PaymentsReceiptsStarted event,
    Emitter<PaymentsReceiptsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final now = DateTime.now();
      final receipts = await getUserReceiptsUseCase.call();
      final monthly = await getMonthlyPaymentsUseCase.call(
        year: now.year,
        month: now.month,
      );

      emit(state.copyWith(
        loading: false,
        error: null,
        receipts: receipts,
        monthlyPayments: monthly,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onToggleViewMore(
    PaymentsReceiptsToggleViewMoreRequested event,
    Emitter<PaymentsReceiptsState> emit,
  ) {
    emit(state.copyWith(showAllReceipts: !state.showAllReceipts));
  }
}
