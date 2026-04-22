import 'package:flutter/material.dart';

import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/app_section_header.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/section_card.dart';
import 'booking_flow_shared.dart';
import '../view_model/booking_view_model.dart';

class PurchaseTicketContent extends StatelessWidget {
  const PurchaseTicketContent({
    super.key,
    required this.viewModel,
    required this.onPay,
    required this.onCancel,
  });

  final BookingViewModel viewModel;
  final VoidCallback onPay;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.screenPaddingWide,
      child: Column(
        children: [
          Expanded(
            child: SectionCard(
              backgroundColor: AppColors.panelSurface,
              borderRadius: AppRadius.xxl,
              borderSide: const BorderSide(color: AppColors.panelBorder),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionHeader(
                    title: 'Payment summary',
                    subtitle:
                        'For ${viewModel.stationName}, slot ${viewModel.slotLabel}.',
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: AppColors.panelBorder),
                    ),
                    child: Column(
                      children: [
                        const BookingFlowDetailRow(
                          label: 'Ride access',
                          value: 'Single ticket',
                        ),
                        const SizedBox(height: 12),
                        BookingFlowDetailRow(
                          label: 'Station',
                          value: viewModel.stationName,
                        ),
                        const SizedBox(height: 12),
                        BookingFlowDetailRow(
                          label: 'Slot',
                          value: viewModel.slotLabel,
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        const BookingFlowDetailRow(
                          label: 'Total',
                          value: '\$2.00',
                          emphasize: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.softSurface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppIconTile(
                          icon: Icons.receipt_long_rounded,
                          iconColor: AppColors.accentStrong,
                          backgroundColor: Color(0xFFF6E8DC),
                          size: 42,
                          iconSize: 22,
                          borderRadius: AppRadius.sm,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Payment applies only to this reservation and completes the booking immediately.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF5F5751),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.actionError != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      viewModel.actionError!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            onPressed: onPay,
            text: 'Pay \$2.00',
            isLoading: viewModel.isBusy,
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            onPressed: onCancel,
            text: 'Back',
            isLoading: viewModel.isBusy,
          ),
        ],
      ),
    );
  }
}
