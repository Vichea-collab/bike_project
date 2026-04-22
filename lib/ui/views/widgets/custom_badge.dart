import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';

enum CustomBadgeTone { neutral, success, warning }

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.tone = CustomBadgeTone.neutral,
  });

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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: textColor ?? _textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color get _backgroundColor => switch (tone) {
    CustomBadgeTone.neutral => AppColors.mutedSurface,
    CustomBadgeTone.success => AppColors.successSurface,
    CustomBadgeTone.warning => AppColors.warningSurface,
  };

  Color get _textColor => switch (tone) {
    CustomBadgeTone.neutral => const Color(0xFF645C55),
    CustomBadgeTone.success => AppColors.success,
    CustomBadgeTone.warning => AppColors.warning,
  };
}
