import 'package:flutter/material.dart';

import '../../../../../models/bike_station.dart';
import '../../../../theme/app_design_tokens.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/app_state_view.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../view_model/stations_view_model.dart';
import 'station_map_panel.dart';

class StationsContent extends StatelessWidget {
  const StationsContent({
    super.key,
    required this.viewModel,
    required this.onOpenBikes,
  });

  final StationsViewModel viewModel;
  final ValueChanged<BikeStation> onOpenBikes;

  @override
  Widget build(BuildContext context) {
    final station = viewModel.selectedStation;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: StationMapPanel(
            stations: viewModel.filteredStations,
            selectedStationId: station?.id,
            onSelect: viewModel.selectStation,
            accessLabel: viewModel.hasActivePass ? 'Pass active' : 'Buy ticket',
            searchController: viewModel.searchController,
            onSearchChanged: viewModel.updateSearchQuery,
            onClearSearch: viewModel.clearSearch,
            fullScreen: true,
            showSelectedStationCard: false,
          ),
        ),
        if (viewModel.hasSearchQuery &&
            viewModel.filteredStations.isEmpty &&
            station == null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: AppStateView.empty(
                title: 'No stations found',
                message: 'No stations match "${viewModel.searchQuery}".',
              ),
            ),
          ),
        if (station != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 720, maxHeight: 300),
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sheet),
                boxShadow: AppShadows.floating(alpha: 0.12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.handle,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppIconTile(
                                icon: Icons.location_on_rounded,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station.name,
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      station.address,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: AppColors.mutedSurface,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                  onTap: viewModel.clearSelectedStation,
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Color(0xFF6F6660),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              CustomBadge(
                                text: '${station.availableBikes} bikes ready',
                              ),
                              CustomBadge(
                                text: '${station.totalSlots} total slots',
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Open the bike list to choose a slot and continue booking.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PrimaryButton(
                            onPressed: () => onOpenBikes(station),
                            text: 'View bikes',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
