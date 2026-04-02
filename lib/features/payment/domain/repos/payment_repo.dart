import 'dart:typed_data';

import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../entities/payment_summary_entity.dart';

abstract class PaymentRepo {
  /// ط¬ظ„ط¨ ط·ط±ظ‚ ط§ظ„ط¯ظپط¹ ظ…ظ† ظ…ط³ط§ط­ط© ط§ظ„ط­ط¬ط²
  Future<List<PaymentMethodEntity>> getMethods({required String bookingId});

  Future<PaymentSummaryEntity> getSummary({required String bookingId});

  /// طھط£ظƒظٹط¯ ط§ظ„ط¯ظپط¹ ظ…ط¹ ط±ظپط¹ ط¥ط´ط¹ط§ط± ط§ظ„ط¯ظپط¹ ط£ظˆ طھظپط§طµظٹظ„ ط§ظ„ط¨ط·ط§ظ‚ط©
  Future<PaymentReceiptEntity> pay({
    required String bookingId,
    required PaymentMethodType method,
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
    Uint8List? receiptBytes,
    String? receiptFileName,
  });
}


