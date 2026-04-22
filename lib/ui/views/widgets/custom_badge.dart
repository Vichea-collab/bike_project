import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';

enum CustomBadgeTone { neutral, accent, success, warning }

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.tone = CustomBadgeTone.neutral,
  });

  const CustomBadge.accent({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : tone = CustomBadgeTone.accent;

  const CustomBadge.success({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : tone = CustomBadgeTone.success;

  const CustomBadge.warning({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : tone = CustomBadgeTone.warning;

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final CustomBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _resolvePalette();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: textColor ?? palette.textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _BadgePalette _resolvePalette() {
    switch (tone) {
      case CustomBadgeTone.neutral:
        return const _BadgePalette(
          backgroundColor: AppColors.mutedSurface,
          textColor: Color(0xFF645C55),
        );
      case CustomBadgeTone.accent:
        return const _BadgePalette(
          backgroundColor: AppColors.warningSurface,
          textColor: AppColors.warning,
        );
      case CustomBadgeTone.success:
        return const _BadgePalette(
          backgroundColor: AppColors.successSurface,
          textColor: AppColors.success,
        );
      case CustomBadgeTone.warning:
        return const _BadgePalette(
          backgroundColor: AppColors.warningSurface,
          textColor: AppColors.warning,
        );
    }
  }
}

class _BadgePalette {
  const _BadgePalette({required this.backgroundColor, required this.textColor});

  final Color backgroundColor;
  final Color textColor;
}
