import 'package:Msahtak/features/payment/view/payment_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../features/language/bloc/language_bloc.dart';
import '../../../../services/language_service.dart';
import '../../bloc/payment_bloc.dart';
import '../../bloc/payment_event.dart';
import '../../bloc/payment_state.dart';
import '../../widgets/payment_booking_summary_card.dart';
import '../../widgets/payment_method_tile.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;

  const PaymentPage({super.key, required this.bookingId});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(context.t('paymentMethodTitle')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PaymentBloc, PaymentState>(
          listenWhen: (p, c) => p.uiStatus != c.uiStatus,
          listener: (context, state) {
            if (state.uiStatus == PaymentUiStatus.failure && state.errorMessage != null) {
              // استخدم context.read بدلاً من context.t لأن الـ listener خارج build
              final langCode = context.read<LanguageBloc>().state.code;
              final msg = switch (state.errorMessage) {
                  'paymentReceiptRequired' => LanguageService.tr(langCode, 'paymentReceiptRequired'),
                  'paymentSelectMethodRequired' => LanguageService.tr(langCode, 'paymentSelectMethodRequired'),
                  _ => state.errorMessage!,
                };
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
            }
            if (state.uiStatus == PaymentUiStatus.success && state.receipt != null) {
              Navigator.of(context).pushReplacement(
                PaymentRoutes.paymentSuccess(
                  args: PaymentSuccessArgs(
                    bookingId: state.receipt!.bookingId,
                    amountPaid: state.receipt!.amountPaid,
                    currency: state.receipt!.currency,
                    paidAt: state.receipt!.paidAt,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isBusy = state.uiStatus == PaymentUiStatus.loading ||
                state.uiStatus == PaymentUiStatus.paying;

            return AbsorbPointer(
              absorbing: isBusy,
              child: ListView(
                padding: _pagePadding,
                children: [
                  if (isBusy) const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 10),

                  PaymentBookingSummaryCard(summary: state.summary),
                  const SizedBox(height: 14),

                  // ── طرق الدفع ──
                  Text(context.t('paymentMethodTitle'),
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),

                  if (state.uiStatus == PaymentUiStatus.ready && state.methods.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(context.t('paymentNoMethods'),
                          style: const TextStyle(color: Color(0xFFB8860B))),
                    ),

                  ...state.methods.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PaymentMethodTile(
                          title: m.title,
                          selected: state.selectedMethod == m.type,
                          onTap: () =>
                              context.read<PaymentBloc>().add(PaymentMethodSelected(m.type)),
                        ),
                      )),

                  // ── تفاصيل الحساب عند اختيار الطريقة ──
                  if (state.selectedMethodEntity?.details.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    _AccountDetailsCard(
                      title: context.t('paymentMethodDetails'),
                      details: state.selectedMethodEntity!.details,
                    ),
                    const SizedBox(height: 10),
                  ],

                  const SizedBox(height: 6),

                  // ── إدخال بيانات البطاقة أو رفع إشعار الدفع ──
                  if (state.isCardPayment)
                    _CardDetailsForm(state: state)
                  else ...[
                    _ReceiptUploadButton(
                      hasReceipt: state.receiptBytes != null,
                      fileName: state.receiptFileName,
                      onPick: () => _pickReceipt(context),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.t('paymentOrEnterTransferData'),
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    _TransferDetailsForm(state: state),
                  ],

                  const SizedBox(height: 14),

                  // ── زر إتمام الدفع ──
                  AppButton(
                    label: context.t('paymentCompleteBtn'),
                    onPressed: state.canPay
                        ? () => context.read<PaymentBloc>().add(PayNowPressed(bookingId))
                        : null,
                    loading: state.uiStatus == PaymentUiStatus.paying,
                    height: 52,
                    borderRadius: 26,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickReceipt(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (context.mounted) {
      context.read<PaymentBloc>().add(PaymentReceiptPicked(bytes: bytes, fileName: file.name));
    }
  }
}

class _AccountDetailsCard extends StatelessWidget {
  final String title;
  final String details;

  const _AccountDetailsCard({required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBD6F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.account_balance_outlined, size: 16, color: Color(0xFF1565C0)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF1565C0), fontSize: 13),
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          const SizedBox(height: 8),
          Text(details, style: const TextStyle(fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}

/// نموذج إدخال بيانات بطاقة الائتمان/الخصم
class _CardDetailsForm extends StatefulWidget {
  final PaymentState state;
  const _CardDetailsForm({required this.state});

  @override
  State<_CardDetailsForm> createState() => _CardDetailsFormState();
}

class _CardDetailsFormState extends State<_CardDetailsForm> {
  late final TextEditingController _numberCtrl;
  late final TextEditingController _expiryCtrl;
  late final TextEditingController _cvvCtrl;
  late final TextEditingController _holderCtrl;

  @override
  void initState() {
    super.initState();
    _numberCtrl = TextEditingController(text: widget.state.cardNumber);
    _expiryCtrl = TextEditingController(text: widget.state.cardExpiry);
    _cvvCtrl = TextEditingController(text: widget.state.cardCvv);
    _holderCtrl = TextEditingController(text: widget.state.cardHolder);
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    context.read<PaymentBloc>().add(PaymentCardFieldChanged(
      cardNumber: _numberCtrl.text,
      cardExpiry: _expiryCtrl.text,
      cardCvv: _cvvCtrl.text,
      cardHolder: _holderCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBD6F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.credit_card, size: 18, color: Color(0xFF1565C0)),
            const SizedBox(width: 6),
            Text(
              context.t('paymentCardDetails'),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1565C0),
                fontSize: 13,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          _CardField(
            controller: _numberCtrl,
            label: context.t('paymentCardNumber'),
            hint: '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            maxLength: 19,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: _CardField(
                controller: _expiryCtrl,
                label: context.t('paymentCardExpiry'),
                hint: 'MM/YY',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryFormatter(),
                ],
                maxLength: 5,
                onChanged: (_) => _notify(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CardField(
                controller: _cvvCtrl,
                label: context.t('paymentCardCvv'),
                hint: '•••',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 4,
                obscure: true,
                onChanged: (_) => _notify(),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          _CardField(
            controller: _holderCtrl,
            label: context.t('paymentCardHolder'),
            hint: 'CARD HOLDER NAME',
            keyboardType: TextInputType.name,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
            onChanged: (_) => _notify(),
          ),
        ],
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscure;
  final ValueChanged<String>? onChanged;

  const _CardField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.obscure = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1565C0))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          obscureText: obscure,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, letterSpacing: 1.2),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26, letterSpacing: 0),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBBD6F7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBBD6F7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// يضيف مسافة كل 4 أرقام في رقم البطاقة
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return next.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

/// يضيف / بعد شهرين في حقل الصلاحية
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll('/', '');
    if (digits.isEmpty) return next.copyWith(text: '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return next.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _TransferDetailsForm extends StatefulWidget {
  final PaymentState state;
  const _TransferDetailsForm({required this.state});

  @override
  State<_TransferDetailsForm> createState() => _TransferDetailsFormState();
}

class _TransferDetailsFormState extends State<_TransferDetailsForm> {
  late final TextEditingController _holderCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _refCtrl;

  @override
  void initState() {
    super.initState();
    _holderCtrl = TextEditingController(text: widget.state.transferAccountHolder);
    _timeCtrl = TextEditingController(text: widget.state.transferTime);
    _refCtrl = TextEditingController(text: widget.state.transferReference);
  }

  @override
  void dispose() {
    _holderCtrl.dispose();
    _timeCtrl.dispose();
    _refCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    context.read<PaymentBloc>().add(
          PaymentTransferDetailsChanged(
            accountHolder: _holderCtrl.text,
            transferTime: _timeCtrl.text,
            referenceNumber: _refCtrl.text,
          ),
        );
  }

  Future<void> _pickTransferDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (pickedTime == null) return;

    final dt = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    _timeCtrl.text = '$dd/$mm/${dt.year} $hh:$mi';
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCE7FF)),
      ),
      child: Column(
        children: [
          _CardField(
            controller: _holderCtrl,
            label: context.t('paymentPayerAccountName'),
            hint: context.t('paymentPayerAccountNameHint'),
            keyboardType: TextInputType.name,
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 8),
          _DateTimePickerField(
            controller: _timeCtrl,
            label: context.t('paymentTransferTime'),
            hint: context.t('paymentTransferTimeHint'),
            onTap: _pickTransferDateTime,
          ),
          const SizedBox(height: 8),
          _CardField(
            controller: _refCtrl,
            label: context.t('paymentReferenceNumber'),
            hint: context.t('paymentReferenceNumberHint'),
            keyboardType: TextInputType.text,
            onChanged: (_) => _notify(),
          ),
        ],
      ),
    );
  }
}

class _DateTimePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final VoidCallback onTap;

  const _DateTimePickerField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1565C0))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: const Icon(Icons.alarm),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBBD6F7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBBD6F7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptUploadButton extends StatelessWidget {
  final bool hasReceipt;
  final String? fileName;
  final VoidCallback onPick;

  const _ReceiptUploadButton({
    required this.hasReceipt,
    required this.fileName,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasReceipt ? Colors.green : AppColors.amber,
            width: hasReceipt ? 1.5 : 1.5,
          ),
          color: hasReceipt ? const Color(0xFFF0FFF4) : const Color(0xFFFFFBF0),
        ),
        child: Row(
          children: [
            Icon(
              hasReceipt ? Icons.check_circle : Icons.upload_file_outlined,
              color: hasReceipt ? Colors.green : AppColors.amber,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasReceipt
                        ? context.t('paymentReceiptUploaded')
                        : context.t('paymentUploadReceipt'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: hasReceipt ? Colors.green : AppColors.amber,
                    ),
                  ),
                  if (fileName != null)
                    Text(fileName!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (hasReceipt)
              Flexible(
                child: Text(context.t('paymentChangeReceipt'),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ),
    );
  }
}
