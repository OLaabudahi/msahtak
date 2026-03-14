import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';

class LocationCard extends StatelessWidget {
  final double? lat;
  final double? lng;
  final VoidCallback onPick;

  const LocationCard({
    super.key,
    required this.lat,
    required this.lng,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final has = lat != null && lng != null;
    return AdminCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AdminColors.primaryBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(AdminIconMapper.mapPin(), size: 18, color: AdminColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location (Lat/Lng)', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  has ? '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}' : 'Not set',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AdminColors.black15, width: 1),
              ),
              child: Text('Pick', style: AdminText.body14(w: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
