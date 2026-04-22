import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bike_slot.dart';
import '../../../models/bike_station.dart';
import '../../../models/current_booking.dart';
import '../../theme/app_design_tokens.dart';
import '../../viewmodels/ride_app_view_model.dart';
import 'us1_select_pass/pass_selection_screen.dart';
import 'us2_view_stations/stations_screen.dart';
import 'us3_view_bikes/bikes_screen.dart';
import 'us4_book_bike/booking_screen.dart';
import '../widgets/app_icon_tile.dart';
import '../widgets/app_state_view.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RideAppViewModel>();
    final appState = viewModel.state;

    if (appState.isLoading) {
      return const Scaffold(
        body: AppStateView.loading(
          title: 'Loading RideFlow',
          message: 'Getting stations and account details ready.',
        ),
      );
    }

    if (appState.errorMessage != null && appState.stations.isEmpty) {
      return Scaffold(
        body: AppStateView.error(
          message: appState.errorMessage!,
          actionLabel: 'Retry',
          onAction: viewModel.initialize,
        ),
      );
    }

    final headerTitle = buildAppShellHeaderTitle(appState.currentTabIndex);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFBF6), Color(0xFFF6F2EC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  10,
                  AppSpacing.xl,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            headerTitle,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    const AppIconTile(
                      icon: Icons.person_outline_rounded,
                      backgroundColor: Colors.white,
                      iconColor: Color(0xFF2E2A27),
                      size: 46,
                      iconSize: 24,
                      borderRadius: AppRadius.md,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: appState.currentTabIndex,
                  children: [
                    StationsScreen(
                      onOpenBikes: (station) => _openBikes(context, station),
                    ),
                    const PassSelectionScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (appState.currentBooking != null)
            _CurrentRidePanel(
              booking: appState.currentBooking!,
              onCompleteRide: () => _completeRide(context),
            ),
          NavigationBar(
            selectedIndex: appState.currentTabIndex,
            onDestinationSelected: viewModel.changeTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map_rounded),
                label: 'Stations',
              ),
              NavigationDestination(
                icon: Icon(Icons.confirmation_num_outlined),
                selectedIcon: Icon(Icons.confirmation_num_rounded),
                label: 'Passes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openBooking(BuildContext context, BikeSlot slot) async {
    final viewModel = context.read<RideAppViewModel>();
    if (viewModel.state.hasCurrentBooking) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Complete your current ride before booking another bike.',
          ),
        ),
      );
      return;
    }

    final booked = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => BookingScreen(slot: slot)),
    );

    if (booked == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bike booked at ${viewModel.state.selectedStation?.name}.',
          ),
        ),
      );
    }
  }

  Future<void> _openBikes(BuildContext context, BikeStation station) async {
    final viewModel = context.read<RideAppViewModel>();
    viewModel.selectStation(station.id);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            BikesScreen(onBookBike: (slot) => _openBooking(context, slot)),
      ),
    );
  }

  Future<void> _completeRide(BuildContext context) async {
    final viewModel = context.read<RideAppViewModel>();
    final currentUser = viewModel.state.currentUser;
    if (currentUser == null || currentUser.currentBooking == null) {
      return;
    }

    await viewModel.saveUser(currentUser.copyWith(currentBooking: null));

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ride completed.')));
  }
}

String buildAppShellHeaderTitle(int index) {
  switch (index) {
    case 0:
      return 'Stations';
    case 1:
      return 'Passes';
    default:
      return 'RideFlow';
  }
}

class _CurrentRidePanel extends StatelessWidget {
  const _CurrentRidePanel({
    required this.booking,
    required this.onCompleteRide,
  });

  final CurrentBooking booking;
  final VoidCallback onCompleteRide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.panelSurface,
        border: Border(
          top: BorderSide(color: AppColors.handle),
          bottom: BorderSide(color: AppColors.handle),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            const AppIconTile(
              icon: Icons.directions_bike_rounded,
              size: 42,
              iconSize: 22,
              borderRadius: AppRadius.sm,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    booking.stationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Slot ${booking.slotLabel}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF655E58),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            FilledButton(
              onPressed: onCompleteRide,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                backgroundColor: AppColors.successSurface,
                foregroundColor: AppColors.success,
                textStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Complete ride'),
            ),
          ],
        ),
      ),
    );
  }
}
