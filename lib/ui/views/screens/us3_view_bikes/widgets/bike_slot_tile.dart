import 'package:flutter/material.dart';

import '../../../../../models/bike_slot.dart';
import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/custom_button.dart';

class BikeSlotTile extends StatelessWidget {
  const BikeSlotTile({
    super.key,
    required this.slot,
    required this.onTap,
    this.bookingLocked = false,
  });

  final BikeSlot slot;
  final VoidCallback? onTap;
  final bool bookingLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = bookingLocked || !slot.isAvailable;
    final buttonText = bookingLocked
        ? 'Complete ride first'
        : slot.isAvailable
        ? 'Book now'
        : 'Unavailable';
    final buttonColor = isDisabled
        ? const Color(0xFFCFC8C1)
        : const Color(0xFFFF7E3F);
    final statusColor = slot.isAvailable
        ? const Color(0xFF2F6A46)
        : const Color(0xFF9A8E84);
    final bikeIconColor = slot.isAvailable
        ? const Color(0xFFE46F2A)
        : const Color(0xFF9A8E84);
    final bikeTileColor = slot.isAvailable
        ? const Color(0xFFFFEFE4)
        : const Color(0xFFF3EFEB);

    return InkWell(
      onTap: bookingLocked ? null : onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: slot.isAvailable
                ? const Color(0xFFEBDDD0)
                : const Color(0xFFE2D9D1),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: Row(
          children: [
            AppIconTile(
              icon: slot.isAvailable
                  ? Icons.pedal_bike_rounded
                  : Icons.block_rounded,
              iconColor: bikeIconColor,
              backgroundColor: bikeTileColor,
              size: 64,
              iconSize: 30,
              borderRadius: AppRadius.lg,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        slot.isAvailable ? 'Available' : 'Empty',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6E655E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              onPressed: bookingLocked ? null : onTap,
              minimumSize: const Size(132, 44),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              backgroundColor: buttonColor,
              text: buttonText,
            ),
          ],
        ),
      ),
    );
  }
}
