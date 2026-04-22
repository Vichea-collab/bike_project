import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/bike/bike_slot_repository.dart';
import 'data/repositories/pass/ride_pass_repository.dart';
import 'data/repositories/station/bike_station_repository.dart';
import 'data/repositories/user/app_user_repository.dart';
import 'ui/theme/app_theme.dart';
import 'ui/viewmodels/ride_app_view_model.dart';
import 'ui/views/screens/app_shell_screen.dart';
import 'ui/views/screens/splash_screen.dart';

class RideRepositories {
  const RideRepositories({
    required this.bikeSlotRepository,
    required this.ridePassRepository,
    required this.bikeStationRepository,
    required this.appUserRepository,
  });

  final BikeSlotRepository bikeSlotRepository;
  final RidePassRepository ridePassRepository;
  final BikeStationRepository bikeStationRepository;
  final AppUserRepository appUserRepository;
}

Future<void> mainCommon({required RideRepositories repositories}) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RideRentalApp(repositories: repositories));
}

class RideRentalApp extends StatelessWidget {
  const RideRentalApp({
    super.key,
    required this.repositories,
    this.splashDuration = const Duration(seconds: 3),
  });

  final RideRepositories repositories;
  final Duration splashDuration;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RideAppViewModel>(
      create: (_) {
        final viewModel = RideAppViewModel(
          bikeSlotRepository: repositories.bikeSlotRepository,
          ridePassRepository: repositories.ridePassRepository,
          bikeStationRepository: repositories.bikeStationRepository,
          appUserRepository: repositories.appUserRepository,
        );
        viewModel.initialize();
        return viewModel;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BikeRental',
        theme: AppTheme.light(),
        home: splashDuration > Duration.zero
            ? SplashScreen(duration: splashDuration)
            : const AppShellScreen(),
      ),
    );
  }
}
