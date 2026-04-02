import '../models/payment_model.dart';
import '../models/payment_details_model.dart';

abstract class PaymentsSource {
  Future<List<PaymentModel>> fetchPayments({required String periodId, required String status});
  Future<PaymentDetailsModel> fetchPaymentDetails({required String paymentId});
  Future<void> issueRefund({required String paymentId});
}


