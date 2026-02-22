import 'package:flutter/material.dart';

class MapRadiusBadge extends StatelessWidget {
  final double radiusKm;
  const MapRadiusBadge({super.key, required this.radiusKm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Showing Results Within ${radiusKm.toStringAsFixed(1)} Km',
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