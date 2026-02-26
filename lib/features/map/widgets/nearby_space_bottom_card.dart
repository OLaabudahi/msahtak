import 'package:flutter/material.dart';
import 'package:masahtak_app/constants/app_assets.dart';
import '../domain/entities/nearby_space_entity.dart';

class NearbySpaceBottomCard extends StatelessWidget {
  final NearbySpaceEntity space;
  final VoidCallback onView;

  const NearbySpaceBottomCard({
    super.key,
    required this.space,
    required this.onView,
  });

  static const _primary = Color(0xFFFBAD20);
  static const _secondary = Color(0xFF5682AF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ✅ يضمن أن الكارد له عرض محدد داخل PageView
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 8),
              color: Color(0x22000000),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ صورة بنفس ستايل التصميم: ارتفاع ثابت + عرض كامل
            SizedBox(
              height: 78,
              width: double.infinity,
              child: Image.network(
                space.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF3F3F3),
                  alignment: Alignment.center,
                  child: Image.asset(AppAssets.home),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _Info(space: space),
                  ),
                  const SizedBox(width: 12),

                  // ✅ أهم تعديل: زر بعرض ثابت + تعطيل minimumSize الافتراضي
                  SizedBox(
                    width: 80,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onView,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero, // ✅ يمنع فرض أبعاد افتراضية
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'View',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
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

class _Info extends StatelessWidget {
  final NearbySpaceEntity space;

  const _Info({required this.space});

  static const _primary = Color(0xFFFBAD20);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          space.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          space.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              space.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.star, size: 14, color: _primary),
            const SizedBox(width: 14),
            Text(
              '${space.distanceKm.toStringAsFixed(1)} km',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}