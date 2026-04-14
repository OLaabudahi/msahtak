import 'package:bloc/bloc.dart';

import '../../domain/usecases/download_invoice_usecase.dart';
import '../../domain/usecases/generate_invoice_pdf_usecase.dart';
import '../../domain/usecases/share_invoice_usecase.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GenerateInvoicePdfUseCase generateInvoicePdfUseCase;
  final DownloadInvoiceUseCase downloadInvoiceUseCase;
  final ShareInvoiceUseCase shareInvoiceUseCase;

  InvoiceBloc({
    required this.generateInvoicePdfUseCase,
    required this.downloadInvoiceUseCase,
    required this.shareInvoiceUseCase,
  }) : super(InvoiceState.initial()) {
    on<InvoiceDownloadRequested>(_onDownloadRequested);
    on<InvoiceShareRequested>(_onShareRequested);
  }

  Future<void> _onDownloadRequested(
    InvoiceDownloadRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearMessages: true));
    try {
      await generateInvoicePdfUseCase.call(event.invoice);
      final file = await downloadInvoiceUseCase.call(event.invoice);
      emit(
        state.copyWith(
          loading: false,
          savedPath: file.path,
          successKey: 'downloadInvoice',
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onShareRequested(
    InvoiceShareRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearMessages: true));
    try {
      await generateInvoicePdfUseCase.call(event.invoice);
      await shareInvoiceUseCase.call(event.invoice);
      emit(state.copyWith(loading: false, successKey: 'shareInvoice'));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
