import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;

  /// هذا نفس الموجود عندك (لكن الآن بنستخدمه كـ “label” داخل دائرة)
  final IconData icon;

  final VoidCallback onTap;
  final bool isDestructive;

  /// ✅ إضافات اختيارية (بدون تغيير الاسم):
  /// - label داخل الدائرة (مثل P / B / $ / SD)
  /// - أو icon داخل الدائرة (star/heart)
  /// - للتحكم بالـ divider
  final String? leadingText;
  final IconData? leadingIcon;
  final bool isLast;
  final bool showChevronDown;
  final VoidCallback? onChevronTap;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.leadingText,
    this.leadingIcon,
    this.isLast = false,
    this.showChevronDown = false,
    this.onChevronTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.danger : Colors.black;
    final circleColor = isDestructive
        ? AppColors.danger
        : AppColors.amber;

    final trailing = showChevronDown
        ? Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: 22)
        : Icon(Icons.chevron_right, color: AppColors.textMuted, size: 22);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: leadingIcon != null
                        ? Icon(leadingIcon!, color: Colors.black, size: 18)
                        : Text(
                            (leadingText ?? title.characters.first)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onChevronTap,
                  behavior: HitTestBehavior.opaque,
                  child: trailing,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.borderMedium,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
