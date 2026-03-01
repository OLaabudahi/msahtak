import 'payments_source.dart';
import '../models/payment_model.dart';
import '../models/payment_details_model.dart';

class PaymentsDummySource implements PaymentsSource {
  final List<PaymentModel> _all = [
    const PaymentModel(id: 'p1', date: 'Feb 25, 2026', amount: '\$200', status: 'paid', userName: 'Sarah Johnson', bookingId: 'b1'),
    const PaymentModel(id: 'p2', date: 'Feb 26, 2026', amount: '\$120', status: 'pending', userName: 'Mike Chen', bookingId: 'b2'),
    const PaymentModel(id: 'p3', date: 'Feb 20, 2026', amount: '\$90', status: 'refunded', userName: 'Emily Brown', bookingId: 'b5'),
  ];

  @override
  Future<List<PaymentModel>> fetchPayments({required String periodId, required String status}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return _all.where((e) => e.status == status).toList(growable: false);
  }

  @override
  Future<PaymentDetailsModel> fetchPaymentDetails({required String paymentId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return PaymentDetailsModel(
      id: paymentId,
      date: 'Feb 25, 2026',
      amount: '\$200',
      status: 'Paid',
      method: 'Visa',
      reference: 'REF-118822',
      userName: 'Sarah Johnson',
      bookingId: 'b1',
    );
  }

  @override
  Future<void> issueRefund({required String paymentId}) async => Future<void>.delayed(const Duration(milliseconds: 160));
}
