import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badge,
    this.trailing,
    this.titleStyle,
    this.subtitleStyle,
    this.gap = AppSpacing.md,
  });

  final String title;
  final String? subtitle;
  final Widget? badge;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badge != null) ...[badge!, SizedBox(height: gap)],
              Text(
                title,
                style:
                    titleStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style:
                      subtitleStyle ??
                      theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.subduedText,
                      ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.md),
          trailing!,
        ],
      ],
    );
  }
}
