import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/best_for_you_space.dart';

class SpacePreviewCard extends StatelessWidget {
  final BestForYouSpace space;
  final VoidCallback onView;

  const SpacePreviewCard(
      {super.key, required this.space, required this.onView});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 90,
                    height: 85,
                    color: AppColors.secondary,
                    child: const Icon(Icons.business,
                        color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(space.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(space.location,
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11)),
                      Text(space.distance,
                          style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('â‚ھ${space.pricePerDay}/day',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${space.rating} ',
                                    style: const TextStyle(
                                        color: Color(0xFFF5A623),
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 12)),
                                const Icon(Icons.star,
                                    color: AppColors.amber,
                                    size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: const Text('View',
                  style: TextStyle(
                      color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
