import 'package:equatable/equatable.dart';

abstract class PaymentsReceiptsEvent extends Equatable {
  const PaymentsReceiptsEvent();

  @override
  List<Object?> get props => [];
}

class PaymentsReceiptsStarted extends PaymentsReceiptsEvent {
  const PaymentsReceiptsStarted();
}

class PaymentsReceiptsToggleViewMoreRequested extends PaymentsReceiptsEvent {
  const PaymentsReceiptsToggleViewMoreRequested();
}
