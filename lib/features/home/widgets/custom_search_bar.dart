import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onAiTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchTap,
    this.hintText = 'Search',
    this.width = 364.5,
    this.height = 58,
    this.fieldWidth = 295.958,
    this.slotWidth = 106.5,
    this.aiButtonWidth = 97,
    this.aiButtonHeight = 38,
    this.aiRightInset = 0,
    this.aiShadow,
  });

  /// ✅ للتحكم بالنص (search)
  final TextEditingController controller;

  /// ✅ عند الضغط على زر AI (الانتقال/فتح الشات)
  final VoidCallback onAiTap;

  /// ✅ عند تغيير النص
  final ValueChanged<String>? onSearchChanged;

  /// ✅ عند ضغط Enter/Submit
  final ValueChanged<String>? onSearchSubmitted;

  /// ✅ لو بدك الضغط على الحقل يفتح صفحة بحث مثلاً
  final VoidCallback? onSearchTap;

  final String hintText;

  /// ✅ أبعاد مطابقة للـ SVG بشكل افتراضي
  final double width;
  final double height;
  final double fieldWidth;
  final double slotWidth;
  final double aiButtonWidth;
  final double aiButtonHeight;

  /// ✅ تحكم بمسافة زر AI من اليمين
  final double aiRightInset;

  /// ✅ ظل الزر (خفيف)
  final BoxShadow? aiShadow;

  @override
  Widget build(BuildContext context) {
    final topInset = (height - aiButtonHeight) / 2; // (58-38)/2 = 10
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // 1) حقل البحث الرمادي
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: fieldWidth,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
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
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // 2) الخلفية البيضاء (slot) تحت زر AI
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: slotWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),

          // 3) زر AI (مع ظل)
          Positioned(
            right: aiRightInset,
            top: topInset,
            child: InkWell(
              onTap: onAiTap,
              borderRadius: BorderRadius.circular(aiButtonHeight / 2),
              child: Container(
                width: aiButtonWidth,
                height: aiButtonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(aiButtonHeight / 2),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      AppColors.primary,
                      AppColors.amber,
                      AppColors.amber,
                      AppColors.dotInactive,
                    ],
                    stops: [0.0, 0.297, 0.467, 1.0],
                  ),
                  boxShadow: [
                    aiShadow ??
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                  ], // ✅ ظل خفيف
                ),
                alignment: Alignment.center,
                child: const Text(
                  "AI Concierge",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
