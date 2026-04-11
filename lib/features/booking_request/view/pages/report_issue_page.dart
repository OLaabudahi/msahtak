import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/i18n/app_i18n.dart';
import '../../domain/entities/booking_request_entity.dart';

class ReportIssuePage extends StatefulWidget {
  final String bookingId;
  final String spaceName;
  final BookingRequestStatus bookingStatus;

  const ReportIssuePage({
    super.key,
    required this.bookingId,
    required this.spaceName,
    required this.bookingStatus,
  });

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _customReasonCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  String _selectedReason = '';
  bool _submitting = false;

  @override
  void dispose() {
    _customReasonCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitIssue(List<String> reasons) async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack(context.t('reportIssueLoginRequired'));
      return;
    }

    setState(() => _submitting = true);

    try {
      final now = DateTime.now();
      final issueId = 'ISS-${now.millisecondsSinceEpoch}';

      final otherReason = reasons.last;
      final reasonText = _selectedReason == otherReason
          ? _customReasonCtrl.text.trim()
          : _selectedReason;

      await FirebaseFirestore.instance.collection('issues').doc(issueId).set({
        'issueId': issueId,
        'bookingId': widget.bookingId,
        'spaceName': widget.spaceName,
        'bookingStatus': widget.bookingStatus.name,
        'reasonCategory': _selectedReason,
        'reasonText': reasonText,
        'description': _descriptionCtrl.text.trim(),
        'status': 'open',
        'userId': user.uid,
        'userEmail': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _notifySuperAdmins(
        issueId: issueId,
        bookingId: widget.bookingId,
        spaceName: widget.spaceName,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
      _showSnack(context.t('reportIssueSubmitted'));
    } catch (_) {
      _showSnack(context.t('reportIssueFailed'));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _notifySuperAdmins({
    required String issueId,
    required String bookingId,
    required String spaceName,
  }) async {
    final admins = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'super_admin')
        .get();

    if (admins.docs.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    final now = DateTime.now();

    for (final adminDoc in admins.docs) {
      final notifRef = FirebaseFirestore.instance
          .collection('admin_notifications')
          .doc('${adminDoc.id}_$issueId');

      batch.set(notifRef, {
        'id': notifRef.id,
        'adminId': adminDoc.id,
        'type': 'issue_reported',
        'title': context.t('newIssueReportedTitle'),
        'subtitle': 'Issue $issueId for booking $bookingId in $spaceName',
        'issueId': issueId,
        'bookingId': bookingId,
        'isRead': false,
        'createdAt': now,
      });
    }

    await batch.commit();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final reasons = <String>[
      context.t('issueReasonPaymentRefMismatch'),
      context.t('issueReasonReceiptUnclear'),
      context.t('issueReasonAccountNameMismatch'),
      context.t('issueReasonRejectedByMistake'),
      context.t('issueReasonOther'),
    ];

    if (_selectedReason.isEmpty || !reasons.contains(_selectedReason)) {
      _selectedReason = reasons.first;
    }

    final needsCustomReason = _selectedReason == reasons.last;

    return Scaffold(
      appBar: AppBar(title: Text(context.t('reportIssueTitle'))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _kv(context.t('spaceLabel'), widget.spaceName),
            _kv(context.t('bookingIdLabelShort'), widget.bookingId),
            _kv(context.t('currentStatusLabel'), widget.bookingStatus.name),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: InputDecoration(
                labelText: context.t('issueReason'),
                border: const OutlineInputBorder(),
              ),
              items: reasons
                  .map(
                    (reason) => DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedReason = value);
              },
            ),
            if (needsCustomReason) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _customReasonCtrl,
                decoration: InputDecoration(
                  labelText: context.t('customReason'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (!needsCustomReason) return null;
                  if (value == null || value.trim().isEmpty) {
                    return context.t('pleaseEnterCustomReason');
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionCtrl,
              minLines: 4,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: context.t('issueDetails'),
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 10) {
                  return context.t('issueDescriptionMin');
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitting ? null : () => _submitIssue(reasons),
              icon: _submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(
                _submitting ? context.t('submitting') : context.t('submitIssue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
