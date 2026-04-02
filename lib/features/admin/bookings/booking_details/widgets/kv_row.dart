import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';

class KvRow extends StatelessWidget {
  final String label;
  final String value;
  final bool last;

  const KvRow({
    super.key,
    required this.label,
    required this.value,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: last ? BorderSide.none : const BorderSide(color: AdminColors.black10, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AdminText.body14(color: AdminColors.black75),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}


