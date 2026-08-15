import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (variant) {
        case AppButtonVariant.primary:
          return AppColors.primary;
        case AppButtonVariant.secondary:
          return AppColors.surfaceLight;
        case AppButtonVariant.outline:
        case AppButtonVariant.ghost:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      switch (variant) {
        case AppButtonVariant.primary:
          return Colors.white;
        case AppButtonVariant.secondary:
          return AppColors.textPrimary;
        case AppButtonVariant.outline:
          return AppColors.primary;
        case AppButtonVariant.ghost:
          return AppColors.textSecondary;
      }
    }

    BorderSide getBorderSide() {
      if (variant == AppButtonVariant.outline) {
        return const BorderSide(color: AppColors.primary, width: 1.5);
      }
      if (variant == AppButtonVariant.secondary) {
        return const BorderSide(color: AppColors.surfaceBorder, width: 1);
      }
      return BorderSide.none;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: getTextColor()),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          text,
          style: AppTypography.labelLarge.copyWith(color: getTextColor()),
        ),
      ],
    );

    Widget button = Material(
      color: getBackgroundColor(),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.fromBorderSide(getBorderSide()),
          ),
          child: content,
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
