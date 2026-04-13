import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum AppButtonType { primary, secondary, disabled }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.height = 50,
    this.width,
    this.borderRadius = 25,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final double height;
  final double? width;
  final double borderRadius;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = type == AppButtonType.disabled || onPressed == null;

    final background = switch (type) {
      AppButtonType.primary => AppColors.amber,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.disabled => AppColors.borderMedium,
    };

    final foreground = switch (type) {
      AppButtonType.primary => Colors.white,
      AppButtonType.secondary => AppColors.secondary,
      AppButtonType.disabled => Colors.white,
    };

    final border = switch (type) {
      AppButtonType.secondary => AppColors.secondary,
      _ => Colors.transparent,
    };

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled || loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: background,
          disabledBackgroundColor: AppColors.borderMedium,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: border),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
