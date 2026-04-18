import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';

class MapRadiusBadge extends StatelessWidget {
  final double radiusKm;
  const MapRadiusBadge({super.key, required this.radiusKm});

  @override
  Widget build(BuildContext context) {
    final text = context
        .t('mapShowingWithin')
        .replaceFirst('{radius}', radiusKm.toStringAsFixed(1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
