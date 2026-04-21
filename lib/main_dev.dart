import 'data/repositories/bike/bike_repository.dart';
import 'data/repositories/pass/pass_repository.dart';
import 'data/repositories/station/station_repository.dart';
import 'data/repositories/user/user_repository.dart';
import 'main_common.dart';

Future<void> main() async {
  const databaseUrl =
      'https://bikerental-255c4-default-rtdb.asia-southeast1.firebasedatabase.app/';

  await mainCommon(
    repositories: RideRepositories(
      bikeRepository: BikeRestRepository(databaseUrl: databaseUrl),
      passRepository: const PassRestRepository(),
      stationRepository: StationRestRepository(databaseUrl: databaseUrl),
      userRepository: UserRestRepository(databaseUrl: databaseUrl),
    ),
  );
}
