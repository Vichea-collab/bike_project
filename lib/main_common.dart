import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/bike/bike_repository.dart';
import 'data/repositories/pass/pass_repository.dart';
import 'data/repositories/station/station_repository.dart';
import 'data/repositories/user/user_repository.dart';
import 'ui/theme/app_theme.dart';
import 'ui/viewmodels/ride_app_view_model.dart';
import 'ui/views/screens/app_shell_screen.dart';

class RideRepositories {
  const RideRepositories({
    required this.bikeRepository,
    required this.passRepository,
    required this.stationRepository,
    required this.userRepository,
  });

  final BikeRepository bikeRepository;
  final PassRepository passRepository;
  final StationRepository stationRepository;
  final UserRepository userRepository;
}

Future<void> mainCommon({required RideRepositories repositories}) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RideRentalApp(repositories: repositories));
}

class RideRentalApp extends StatelessWidget {
  const RideRentalApp({super.key, required this.repositories});

  final RideRepositories repositories;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RideAppViewModel>(
      create: (_) {
        final viewModel = RideAppViewModel(
          bikeRepository: repositories.bikeRepository,
          passRepository: repositories.passRepository,
          stationRepository: repositories.stationRepository,
          userRepository: repositories.userRepository,
        );
        viewModel.initialize();
        return viewModel;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RideFlow',
        theme: AppTheme.light(),
        home: const AppShellScreen(),
      ),
    );
  }
}
