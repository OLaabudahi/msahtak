import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/payment_status.dart';
import '../domain/usecases/get_payment_details_usecase.dart';
import '../domain/usecases/get_payments_usecase.dart';
import '../domain/usecases/issue_refund_usecase.dart';
import 'payments_event.dart';
import 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetPaymentsUseCase getPayments;
  final GetPaymentDetailsUseCase getDetails;
  final IssueRefundUseCase refund;

  PaymentsBloc({
    required this.getPayments,
    required this.getDetails,
    required this.refund,
  }) : super(PaymentsState.initial()) {
    on<PaymentsStarted>(_onLoad);
    on<PaymentsPeriodChanged>(_onPeriod);
    on<PaymentsStatusChanged>(_onStatus);
    on<PaymentsOpenDetails>(_onOpenDetails);
    on<PaymentsIssueRefund>(_onRefund);
  }

  Future<void> _load(Emitter<PaymentsState> emit, {String? periodId, PaymentStatus? status}) async {
    final p = periodId ?? state.periodId;
    final s = status ?? state.filter;
    emit(state.copyWith(status: PaymentsStatusView.loading, periodId: p, filter: s, error: null));
    try {
      final list = await getPayments(periodId: p, status: s);
      emit(state.copyWith(status: PaymentsStatusView.ready, payments: list));
    } catch (e) {
      emit(state.copyWith(status: PaymentsStatusView.failure, error: e.toString()));
    }
  }

  Future<void> _onLoad(PaymentsStarted event, Emitter<PaymentsState> emit) async => _load(emit);
  Future<void> _onPeriod(PaymentsPeriodChanged event, Emitter<PaymentsState> emit) async => _load(emit, periodId: event.periodId);
  Future<void> _onStatus(PaymentsStatusChanged event, Emitter<PaymentsState> emit) async => _load(emit, status: event.status);

  Future<void> _onOpenDetails(PaymentsOpenDetails event, Emitter<PaymentsState> emit) async {
    emit(state.copyWith(status: PaymentsStatusView.acting, error: null));
    try {
      final d = await getDetails(paymentId: event.paymentId);
      emit(state.copyWith(status: PaymentsStatusView.ready, details: d));
    } catch (e) {
      emit(state.copyWith(status: PaymentsStatusView.failure, error: e.toString()));
    }
  }

  Future<void> _onRefund(PaymentsIssueRefund event, Emitter<PaymentsState> emit) async {
    emit(state.copyWith(status: PaymentsStatusView.acting, error: null));
    try {
      await refund(paymentId: event.paymentId);
      emit(state.copyWith(status: PaymentsStatusView.ready));
      add(const PaymentsStarted());
    } catch (e) {
      emit(state.copyWith(status: PaymentsStatusView.failure, error: e.toString()));
    }
  }
}


