import 'package:equatable/equatable.dart';

import '../../domain/entities/user_receipt_entity.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class InvoiceDownloadRequested extends InvoiceEvent {
  final UserReceiptEntity invoice;

  const InvoiceDownloadRequested(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

class InvoiceShareRequested extends InvoiceEvent {
  final UserReceiptEntity invoice;

  const InvoiceShareRequested(this.invoice);

  @override
  List<Object?> get props => [invoice];
}
