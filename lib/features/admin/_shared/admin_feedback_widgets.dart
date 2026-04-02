import 'package:flutter/material.dart';
import 'admin_ui.dart';

class AdminEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AdminEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AdminColors.black02,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AdminColors.black10, width: 1),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 26, color: AdminColors.black40),
            ),
            const SizedBox(height: 12),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40)),
          ],
        ),
      ),
    );
  }
}

class AdminListSkeleton extends StatelessWidget {
  final int count;
  final double height;

  const AdminListSkeleton({
    super.key,
    this.count = 5,
    this.height = 92,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AdminColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.black15, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: const BoxDecoration(color: AdminColors.black10, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: AdminColors.black10, borderRadius: BorderRadius.circular(6))),
                  const SizedBox(height: 10),
                  Container(height: 10, width: 180, decoration: BoxDecoration(color: AdminColors.black10, borderRadius: BorderRadius.circular(6))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


