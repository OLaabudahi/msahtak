import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// شريط بحث الصفحة الرئيسية — تصميم Row يتعامل مع RTL تلقائياً
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onAiTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchTap,
    this.hintText = 'Search',
    this.aiButtonLabel = 'AI Concierge',
    this.height = 54,
  });

  final TextEditingController controller;
  final VoidCallback onAiTap;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchTap;
  final String hintText;
  final String aiButtonLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textMuted, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              onTap: onSearchTap,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onAiTap,
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [AppColors.amber, AppColors.secondary],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                aiButtonLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
