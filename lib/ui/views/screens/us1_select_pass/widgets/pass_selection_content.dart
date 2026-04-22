import 'package:flutter/material.dart';

import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_section_header.dart';
import '../../../widgets/custom_badge.dart';
import '../view_model/pass_selection_view_model.dart';
import 'pass_option_card.dart';

class PassSelectionContent extends StatelessWidget {
  const PassSelectionContent({
    super.key,
    required this.viewModel,
    required this.onSelectPass,
    required this.onCancelPass,
  });

  final PassSelectionViewModel viewModel;
  final ValueChanged<int> onSelectPass;
  final VoidCallback onCancelPass;

  @override
  Widget build(BuildContext context) {
    final activePass = viewModel.activePassType;
    final hasActivePass = activePass != null;
    final isSelectionMode = viewModel.selectionMode;

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        _buildHeader(hasActivePass, isSelectionMode),
        const SizedBox(height: AppSpacing.xl),
        if (hasActivePass && !isSelectionMode) ...[
          PassOptionCard(
            passType: activePass,
            isActive: true,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onCancelPass,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Cancel subscription'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[700],
              side: BorderSide(color: Colors.red[300]!),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        if (!hasActivePass || isSelectionMode) ...[
          Text(
            isSelectionMode ? 'Choose a pass' : 'Available passes',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isSelectionMode
                ? 'Select a pass to continue with your booking'
                : 'Choose a pass to unlock unlimited rides',
            style: const TextStyle(fontSize: 14, color: Color(0xFF655E58)),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (int i = 0; i < viewModel.passTypes.length; i++)
            Column(
              children: [
                PassOptionCard(
                  passType: viewModel.passTypes[i],
                  isActive: false,
                  onPressed: () => onSelectPass(i),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
        ],
      ],
    );
  }

  Widget _buildHeader(bool hasActivePass, bool isSelectionMode) {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EC),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: const Color(0xFFF1DACA)),
      ),
      child: AppSectionHeader(
        badge: isSelectionMode
            ? const CustomBadge(
                text: 'Step 2',
                backgroundColor: Color(0xFFF2ECE5),
                textColor: Color(0xFF2C2521),
              )
            : null,
        title: isSelectionMode
            ? 'Choose your pass access'
            : 'Get unlimited rides',
        subtitle: isSelectionMode
            ? (hasActivePass
                  ? 'You have an active pass. You can keep it or choose a different one.'
                  : 'Pick a pass to continue with your reservation.')
            : (hasActivePass
                  ? 'Your pass is active and ready to use'
                  : 'Choose a pass that fits your riding style'),
        titleStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2C2521),
        ),
        subtitleStyle: const TextStyle(fontSize: 15, color: Color(0xFF6B625B)),
      ),
    );
  }
}
