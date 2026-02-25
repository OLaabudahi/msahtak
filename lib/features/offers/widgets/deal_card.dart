import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/offer.dart';
import 'flag_tag_painter.dart';

class DealCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback onDealTap;

  const DealCard({super.key, required this.offer, required this.onDealTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _buildImageStack(),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo()),
              ],
            ),
          ),
          _buildDealButton(),
        ],
      ),
    );
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 110,
            height: 100,
            color: AppColors.secondaryTint30,
            child: const Icon(Icons.business,
                color: AppColors.secondary, size: 32),
          ),
        ),
        // علامة الخصم
        Positioned(
          top: 10,
          left: 0,
          child: CustomPaint(
            painter: FlagTagPainter(),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 6, right: 14, top: 4, bottom: 4),
              child: Text(
                '-${offer.discountPercent}%',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            ),
          ),
        ),
        // تقييم النجوم
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.ratingBadgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${offer.rating} ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                const Icon(Icons.star,
                    color: AppColors.amber, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(offer.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 3),
        Text(offer.location,
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          '₪${offer.originalPrice}/day',
          style: const TextStyle(
            color: Color(0xFF5B8FB9),
            fontSize: 12,
            decoration: TextDecoration.lineThrough,
            decorationColor: Color(0xFF5B8FB9),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              '₪${offer.discountedPrice}',
              style: const TextStyle(
                  color: Color(0xFFF5A623),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(' /day',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildDealButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onDealTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
        child: const Text('Deal',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
