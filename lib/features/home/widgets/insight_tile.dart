import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class InsightTile extends StatelessWidget {
  final String imageAsset;
  // final String? imageUrl; // ✅ للـ API لاحقاً
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const InsightTile({
    super.key,
    required this.imageAsset,
    // this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  /// ✅ بناء كارد Insight (صورة + تدرج + نص)
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: imageAsset.startsWith('http')
                  ? Image.network(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Image.asset('assets/images/home.png', fit: BoxFit.cover),
                    )
                  : Image.asset(imageAsset, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.55),
                      Colors.black.withOpacity(.05),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.95),
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
