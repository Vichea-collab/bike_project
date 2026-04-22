import 'package:flutter/material.dart';

import '../../../../../models/pass_type.dart';
import '../../../../theme/app_design_tokens.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';

class PassOptionCard extends StatefulWidget {
  const PassOptionCard({
    super.key,
    required this.passType,
    required this.isActive,
    required this.onPressed,
  });

  final PassType passType;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  State<PassOptionCard> createState() => _PassOptionCardState();
}

class _PassOptionCardState extends State<PassOptionCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: (isHovering && !widget.isActive)
              ? Matrix4.diagonal3Values(1.02, 1.02, 1)
              : Matrix4.identity(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            border: Border.all(color: _getBorderColor(), width: 1.5),
            boxShadow: isHovering && !widget.isActive
                ? [
                    BoxShadow(
                      color: Colors.orange.withAlpha(40),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.md),
              _buildDescription(),
              const SizedBox(height: AppSpacing.md),
              _buildBenefit(),
              const SizedBox(height: AppSpacing.lg),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AppIconTile(
          icon: Icons.pedal_bike_rounded,
          size: 46,
          iconSize: 24,
          backgroundColor: _getIconBackgroundColor(),
          iconColor: _getIconColor(),
          borderRadius: AppRadius.sm,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            widget.passType.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _getTitleColor(),
            ),
          ),
        ),
        if (widget.isActive)
          const CustomBadge.success(
            text: 'Active',
            backgroundColor: AppColors.success,
            textColor: Colors.white,
          ),
      ],
    );
  }

  Widget _buildDescription() {
    if (widget.isActive) {
      return Text(
        'Expires ${_getExpirationDate()}',
        style: TextStyle(color: _getTextColor(), fontSize: 14),
      );
    }
    return Text(
      widget.passType.subtitle,
      style: TextStyle(color: _getTextColor(), fontSize: 14),
    );
  }

  Widget _buildBenefit() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: _getBenefitBackgroundColor(),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: _getBorderColor().withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, color: _getIconColor(), size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              _getBenefitText(),
              style: TextStyle(color: _getTextColor(), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(
          widget.passType.priceLabel,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _getPriceColor(),
          ),
        ),
        const Spacer(),
        if (!widget.isActive)
          PrimaryButton(
            onPressed: widget.onPressed,
            text: 'Select',
            backgroundColor: _getButtonColor(),
            minimumSize: const Size(100, 46),
          ),
      ],
    );
  }

  Color _getBackgroundColor() {
    if (widget.isActive) return const Color(0xFFE8F5E9);
    if (isHovering) return const Color(0xFFFFF4EC);
    return Colors.white;
  }

  Color _getBorderColor() {
    if (widget.isActive) return const Color(0xFFA5D6A7);
    if (isHovering) return AppColors.accent;
    return AppColors.panelBorder;
  }

  Color _getTitleColor() {
    if (widget.isActive) return const Color(0xFF1B5E20);
    if (isHovering) return const Color(0xFFE46F2A);
    return const Color(0xFF2A2725);
  }

  Color _getTextColor() {
    if (widget.isActive) return const Color(0xFF2E7D32);
    if (isHovering) return const Color(0xFFE46F2A);
    return const Color(0xFF59534F);
  }

  Color _getIconBackgroundColor() {
    if (widget.isActive) return const Color(0xFFC8E6C9);
    if (isHovering) return AppColors.iconSurface;
    return AppColors.mutedSurface;
  }

  Color _getIconColor() {
    if (widget.isActive) return const Color(0xFF1B5E20);
    if (isHovering) return const Color(0xFFE46F2A);
    return const Color(0xFF2E2A27);
  }

  Color _getBenefitBackgroundColor() {
    if (widget.isActive) return const Color(0xFFC8E6C9);
    if (isHovering) return AppColors.iconSurface;
    return AppColors.softSurface;
  }

  Color _getPriceColor() {
    if (widget.isActive) return const Color(0xFF1B5E20);
    if (isHovering) return const Color(0xFFE46F2A);
    return const Color(0xFF2A2725);
  }

  Color _getButtonColor() {
    return AppColors.accent;
  }

  String _getExpirationDate() {
    final date = DateTime.now().add(
      Duration(days: widget.passType.validityDays),
    );
    return formatDateLong(date);
  }

  String _getBenefitText() {
    switch (widget.passType) {
      case PassType.day:
        return 'Unlimited short rides for 24 hours';
      case PassType.monthly:
        return 'Unlimited access for your monthly commute';
      case PassType.annual:
        return 'Best value for long-term daily riders';
    }
  }
}
