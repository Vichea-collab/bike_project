import 'data/repositories/bike/bike_slot_repository.dart';
import 'data/repositories/pass/ride_pass_repository.dart';
import 'data/repositories/station/bike_station_repository.dart';
import 'data/repositories/user/app_user_repository.dart';
import 'main_common.dart';

Future<void> main() async {
  const databaseUrl =
      'https://bikerental-255c4-default-rtdb.asia-southeast1.firebasedatabase.app/';

  await mainCommon(
    repositories: RideRepositories(
      bikeSlotRepository: BikeSlotRestRepository(databaseUrl: databaseUrl),
      ridePassRepository: const RidePassRestRepository(),
      bikeStationRepository: BikeStationRestRepository(databaseUrl: databaseUrl),
      appUserRepository: AppUserRestRepository(databaseUrl: databaseUrl),
    ),
  );
}
