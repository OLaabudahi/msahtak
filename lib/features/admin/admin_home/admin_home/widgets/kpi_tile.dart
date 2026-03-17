import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';

class KpiTile extends StatelessWidget {
  final String title;
  final String value;
  final String delta;

  const KpiTile({
    super.key,
    required this.title,
    required this.value,
    required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t(title), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w500)),
          const SizedBox(height: AdminSpace.s8),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.h2()),
          const SizedBox(height: AdminSpace.s4),
          Text(context.t(delta), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40)),
        ],
      ),
    );
  }
}
