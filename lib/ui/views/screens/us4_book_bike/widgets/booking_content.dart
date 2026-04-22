import 'package:flutter/material.dart';

import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/app_section_header.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/section_card.dart';
import '../view_model/booking_view_model.dart';

class BookingContent extends StatelessWidget {
  const BookingContent({
    super.key,
    required this.viewModel,
    required this.onBuyTicket,
    required this.onBuyPass,
    required this.onConfirm,
  });

  final BookingViewModel viewModel;
  final VoidCallback onBuyTicket;
  final VoidCallback onBuyPass;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: AppSpacing.screenPaddingWide,
      children: [
        SectionCard(
          backgroundColor: AppColors.panelSurface,
          borderSide: const BorderSide(color: AppColors.panelBorder),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSectionHeader(
                title: 'Booking Bike',
                subtitle: 'Check the pickup details.',
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.panelBorder),
                ),
                child: Row(
                  children: [
                    const AppIconTile(
                      icon: Icons.pedal_bike_rounded,
                      iconColor: AppColors.accentStrong,
                      backgroundColor: Color(0xFFF6E8DC),
                      size: 56,
                      iconSize: 28,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected bike',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ready for pickup',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF746C65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _InfoPill(
                      label: 'Station',
                      value: viewModel.stationName,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoPill(label: 'Slot', value: viewModel.slotLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          backgroundColor: Colors.white,
          borderSide: const BorderSide(color: AppColors.panelBorder),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: viewModel.accessTitle,
                trailing: viewModel.canConfirm
                    ? const CustomBadge.success(text: 'Ready')
                    : const CustomBadge.warning(text: 'Choose one'),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.softSurface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Row(
                  children: [
                    AppIconTile(
                      icon: viewModel.canConfirm
                          ? Icons.verified_rounded
                          : Icons.lock_open_rounded,
                      backgroundColor: viewModel.canConfirm
                          ? AppColors.successSurface
                          : const Color(0xFFF6E8DC),
                      iconColor: viewModel.canConfirm
                          ? AppColors.success
                          : theme.colorScheme.primary,
                      size: 46,
                      iconSize: 24,
                      borderRadius: AppRadius.md,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        viewModel.canConfirm
                            ? viewModel.accessDescription
                            : 'Pay for this ride or choose a pass to continue.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF5D5650),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (!viewModel.canConfirm) ...[
                PrimaryButton(
                  onPressed: onBuyTicket,
                  text: 'Pay \$2.00 for this ride',
                  isLoading: viewModel.isBusy,
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  onPressed: onBuyPass,
                  text: 'Choose a pass',
                  isLoading: viewModel.isBusy,
                ),
              ] else ...[
                PrimaryButton(
                  onPressed: onConfirm,
                  text: 'Finish reservation',
                  isLoading: viewModel.isBusy,
                ),
                if (viewModel.hasActivePass) ...[
                  const SizedBox(height: 10),
                  SecondaryButton(
                    onPressed: onBuyPass,
                    text: 'Change pass',
                    isLoading: viewModel.isBusy,
                  ),
                ],
              ],
            ],
          ),
        ),
        if (viewModel.actionError != null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.errorSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.errorBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.error),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    viewModel.actionError!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFA34820),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7A726B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
