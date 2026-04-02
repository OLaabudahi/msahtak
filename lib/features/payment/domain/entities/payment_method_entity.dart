import 'package:equatable/equatable.dart';

/// ظ…ط¹ط±ظ‘ظپ ط·ط±ظٹظ‚ط© ط§ظ„ط¯ظپط¹ â€” String ط¨ط¯ظ„ط§ظ‹ ظ…ظ† enum ظ„ط¯ط¹ظ… ط§ظ„ط·ط±ظ‚ ط§ظ„ط¯ظٹظ†ط§ظ…ظٹظƒظٹط© ظ…ظ† Firebase
typedef PaymentMethodType = String;

class PaymentMethodEntity extends Equatable {
  final PaymentMethodType type;
  final String title;
  final String details; // طھظپط§طµظٹظ„ ط§ظ„ط­ط³ط§ط¨ ط§ظ„طھظٹ ظٹط¯ط®ظ„ظ‡ط§ ط§ظ„ط£ط¯ظ…ظ†

  const PaymentMethodEntity({
    required this.type,
    required this.title,
    this.details = '',
  });

  @override
  List<Object?> get props => [type, title, details];
}


