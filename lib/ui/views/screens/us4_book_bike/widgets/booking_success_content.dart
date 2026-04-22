import 'package:flutter/material.dart';

import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_section_header.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/section_card.dart';
import 'booking_flow_shared.dart';
import '../view_model/booking_view_model.dart';

class BookingSuccessContent extends StatelessWidget {
  const BookingSuccessContent({
    super.key,
    required this.viewModel,
    required this.onOpenStation,
  });

  final BookingViewModel viewModel;
  final VoidCallback onOpenStation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: SectionCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            28,
            AppSpacing.xxl,
            AppSpacing.xxl,
          ),
          backgroundColor: AppColors.panelSurface,
          borderSide: const BorderSide(color: AppColors.panelBorder),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.successSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 46,
                    color: AppColors.success,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: AppSectionHeader(
                  title: 'Reservation complete',
                  subtitle: 'Your bike is now reserved and ready for pickup.',
                  titleStyle: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 28,
                  ),
                  subtitleStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.subduedText,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.panelBorder),
                ),
                child: Column(
                  children: [
                    BookingFlowDetailRow(
                      label: 'Station',
                      value: viewModel.stationName,
                    ),
                    const SizedBox(height: 12),
                    BookingFlowDetailRow(
                      label: 'Slot',
                      value: viewModel.slotLabel,
                    ),
                    const SizedBox(height: 12),
                    const BookingFlowDetailRow(
                      label: 'Status',
                      value: 'Ready for pickup',
                      valueColor: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(onPressed: onOpenStation, text: 'View station'),
            ],
          ),
        ),
      ),
    );
  }
}
