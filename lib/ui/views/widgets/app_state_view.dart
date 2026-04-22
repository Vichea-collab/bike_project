import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';
import 'custom_button.dart';

class AppStateView extends StatelessWidget {
  const AppStateView.loading({
    super.key,
    this.title = 'Loading',
    this.message = 'Please wait a moment.',
  }) : icon = Icons.hourglass_top_rounded,
       actionLabel = null,
       onAction = null,
       iconColor = AppColors.accent;

  const AppStateView.empty({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : icon = Icons.search_off_rounded,
       iconColor = AppColors.accent;

  const AppStateView.error({
    super.key,
    required this.message,
    this.title = 'Something went wrong',
    this.actionLabel,
    this.onAction,
  }) : icon = Icons.error_outline_rounded,
       iconColor = AppColors.error;

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            boxShadow: AppShadows.floating(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.subduedText,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(onPressed: onAction, text: actionLabel!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
