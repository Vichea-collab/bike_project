import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../models/bike_station.dart';
import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/custom_badge.dart';

class StationMapPanel extends StatelessWidget {
  const StationMapPanel({
    super.key,
    required this.stations,
    required this.selectedStationId,
    required this.onSelect,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    this.fullScreen = false,
    this.showSelectedStationCard = true,
  });

  final List<BikeStation> stations;
  final String? selectedStationId;
  final ValueChanged<String> onSelect;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final bool fullScreen;
  final bool showSelectedStationCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    BikeStation? selectedStation;

    if (selectedStationId != null) {
      for (final station in stations) {
        if (station.id == selectedStationId) {
          selectedStation = station;
          break;
        }
      }
    }

    final map = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(fullScreen ? 0 : AppRadius.sheet),
        boxShadow: fullScreen
            ? null
            : AppShadows.floating(blurRadius: 22, offsetY: 14, alpha: 0.07),
      ),
      child: Padding(
        padding: EdgeInsets.all(fullScreen ? 0 : AppSpacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final reservedBottomSpace = showSelectedStationCard ? 150.0 : 70.0;
            final mapWidth = constraints.maxWidth;
            final mapHeight = constraints.maxHeight;

            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      fullScreen ? 0 : AppRadius.xxl,
                    ),
                    child: SizedBox(
                      width: mapWidth,
                      height: mapHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: const Color(0xFFF3F2F0),
                              child: CustomPaint(
                                size: Size(mapWidth, mapHeight),
                                painter: _MapBackdropPainter(),
                              ),
                            ),
                          ),
                          for (final station in stations)
                            Positioned(
                              left: station.mapX * (mapWidth - 72),
                              top:
                                  station.mapY *
                                  (mapHeight - reservedBottomSpace),
                              child: _StationMarker(
                                station: station,
                                isSelected: selectedStationId == station.id,
                                onTap: () => onSelect(station.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: fullScreen ? AppSpacing.md : AppSpacing.sm,
                  left: fullScreen ? AppSpacing.md : AppSpacing.sm,
                  right: fullScreen ? AppSpacing.md : AppSpacing.sm,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: AppShadows.floating(
                              blurRadius: 14,
                              offsetY: 6,
                              alpha: 0.05,
                            ),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Search stations',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF8A817B),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF8A817B),
                              ),
                              suffixIcon: searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      onPressed: onClearSearch,
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xFF8A817B),
                                      ),
                                    ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedStation != null && showSelectedStationCard)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        boxShadow: AppShadows.floating(
                          blurRadius: 18,
                          offsetY: 10,
                          alpha: 0.08,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppIconTile(
                            icon: Icons.pedal_bike_rounded,
                            size: 52,
                            borderRadius: AppRadius.lg,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedStation.name,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedStation.address,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  runSpacing: AppSpacing.sm,
                                  children: [
                                    CustomBadge(
                                      text:
                                          '${selectedStation.availableBikes} bikes ready',
                                    ),
                                    CustomBadge(
                                      text:
                                          '${selectedStation.totalSlots} total slots',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );

    if (fullScreen) {
      return map;
    }

    return AspectRatio(aspectRatio: 0.86, child: map);
  }
}

class _StationMarker extends StatelessWidget {
  const _StationMarker({
    required this.station,
    required this.isSelected,
    required this.onTap,
  });

  final BikeStation station;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAvailability = station.availableBikes > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE46F2A)
              : hasAvailability
              ? const Color(0xFFFF7E3F)
              : const Color(0xFFC9B3A3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isSelected ? 18 : 10,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.14),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.pedal_bike_rounded,
              color: Colors.white,
              size: isSelected ? 24 : 20,
            ),
            const SizedBox(height: 4),
            Text(
              '${station.availableBikes}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFD8D5D1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = const Color(0xFFE6E3DF)
      ..style = PaintingStyle.fill;

    final river = Path()
      ..moveTo(size.width * 0.72, 0)
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.16,
        size.width * 0.8,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.8,
        size.width * 0.82,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(river, accentPaint);

    final roads = <Path>[
      Path()
        ..moveTo(size.width * 0.05, size.height * 0.14)
        ..quadraticBezierTo(
          size.width * 0.35,
          size.height * 0.2,
          size.width * 0.6,
          size.height * 0.08,
        ),
      Path()
        ..moveTo(size.width * 0.08, size.height * 0.48)
        ..quadraticBezierTo(
          size.width * 0.24,
          size.height * 0.34,
          size.width * 0.55,
          size.height * 0.38,
        )
        ..quadraticBezierTo(
          size.width * 0.74,
          size.height * 0.4,
          size.width * 0.92,
          size.height * 0.26,
        ),
      Path()
        ..moveTo(size.width * 0.16, size.height * 0.88)
        ..quadraticBezierTo(
          size.width * 0.34,
          size.height * 0.72,
          size.width * 0.58,
          size.height * 0.76,
        ),
      Path()
        ..moveTo(size.width * 0.28, size.height * 0.08)
        ..quadraticBezierTo(
          size.width * 0.22,
          size.height * 0.4,
          size.width * 0.3,
          size.height * 0.9,
        ),
      Path()
        ..moveTo(size.width * 0.54, size.height * 0.12)
        ..quadraticBezierTo(
          size.width * 0.52,
          size.height * 0.44,
          size.width * 0.64,
          size.height * 0.94,
        ),
    ];

    for (final road in roads) {
      canvas.drawPath(road, roadPaint);
    }

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFE6E2DE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 6; index++) {
      final path = Path()
        ..moveTo(size.width * (0.1 + index * 0.12), size.height * 0.16)
        ..quadraticBezierTo(
          size.width * (0.18 + index * 0.1),
          size.height * 0.34,
          size.width * (0.1 + index * 0.08),
          size.height * 0.68,
        );
      canvas.drawPath(path, minorRoadPaint);
    }

    for (var index = 0; index < 7; index++) {
      final dx = size.width * (0.12 + index * 0.1);
      final dy = size.height * (0.18 + math.sin(index * 0.82) * 0.1 + 0.28);
      canvas.drawCircle(
        Offset(dx, dy),
        5,
        Paint()..color = const Color(0xFFF1EEEA),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
