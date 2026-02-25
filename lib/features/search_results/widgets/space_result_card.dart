import 'package:flutter/material.dart';
import '../domain/entities/space_entity.dart';

class SpaceResultCard extends StatelessWidget {
  final SpaceEntity space;

  const SpaceResultCard({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 70,
                height: 70,
                color: const Color(0xFFEFEFEF),
                child: const Icon(Icons.image, size: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(space.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${space.locationName} • ${space.distanceKm.toStringAsFixed(1)} km'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: -6,
                    children: space.tags.map((t) => Chip(label: Text(t), visualDensity: VisualDensity.compact)).toList(),
                  ),
                  const SizedBox(height: 6),
                  Text('₪${space.pricePerDay.toStringAsFixed(0)}/day'),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Text(space.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}