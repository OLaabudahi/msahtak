import 'package:flutter/material.dart';

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
    this.aiShadow = const BoxShadow(
      color: Color(0x33000000), // ظل خفيف
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
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
  final BoxShadow aiShadow;

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
                color: const Color(0xFFEEF3F6),
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
                    color: Color(0xFFA5A5A5),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFA5A5A5),
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
                      Color(0xFFFBAD20),
                      Color(0xFFECA92D),
                      Color(0xFFDAA43C),
                      Color(0xFF5682AF),
                    ],
                    stops: [0.0, 0.297, 0.467, 1.0],
                  ),
                  boxShadow: [aiShadow], // ✅ ظل خفيف
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
