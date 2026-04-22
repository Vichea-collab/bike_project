import 'package:bike_project/data/repositories/mock/mock_ride_store.dart';
import 'package:bike_project/data/repositories/bike/bike_slot_repository.dart';
import 'package:bike_project/data/repositories/pass/ride_pass_repository.dart';
import 'package:bike_project/data/repositories/station/bike_station_repository.dart';
import 'package:bike_project/data/repositories/user/app_user_repository.dart';
import 'package:bike_project/main_common.dart';
import 'package:bike_project/models/app_user.dart';
import 'package:bike_project/models/bike_station.dart';
import 'package:bike_project/models/current_booking.dart';
import 'package:bike_project/models/pass_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RideRentalApp', () {
    testWidgets('does not show a current ride panel before any booking', (
      WidgetTester tester,
    ) async {
      await _pumpApp(tester);

      expect(find.text('Slot A4'), findsNothing);
      expect(find.text('Riverfront Hub'), findsNothing);
    });

    testWidgets('shows the booked station and slot in the current ride panel', (
      WidgetTester tester,
    ) async {
      await _pumpApp(
        tester,
        currentUser: AppUser(
          id: 'u-001',
          name: 'Sok Dara',
          currentBooking: CurrentBooking(
            stationId: 'st-1',
            stationName: 'Riverfront Hub',
            slotId: 's1-4',
            slotLabel: 'A4',
            bookedAt: DateTime(2026, 4, 22),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Riverfront Hub'), findsOneWidget);
      expect(find.text('Slot A4'), findsOneWidget);
      expect(find.text('Complete ride'), findsOneWidget);
    });

    testWidgets('complete ride clears the current ride panel', (
      WidgetTester tester,
    ) async {
      await _pumpApp(
        tester,
        currentUser: AppUser(
          id: 'u-001',
          name: 'Sok Dara',
          currentBooking: CurrentBooking(
            stationId: 'st-1',
            stationName: 'Riverfront Hub',
            slotId: 's1-4',
            slotLabel: 'A4',
            bookedAt: DateTime(2026, 4, 22),
          ),
        ),
      );

      await tester.tap(find.text('Complete ride'));
      await tester.pumpAndSettle();

      expect(find.text('Riverfront Hub'), findsNothing);
      expect(find.text('Slot A4'), findsNothing);
      expect(find.text('Complete ride'), findsNothing);
    });
  });
}

Future<void> _pumpApp(WidgetTester tester, {AppUser? currentUser}) async {
  final store = MockRideStore();
  if (currentUser != null) {
    store.currentUser = currentUser;
  }

  await tester.pumpWidget(
    RideRentalApp(
      splashDuration: Duration.zero,
      repositories: RideRepositories(
        bikeSlotRepository: const _ImmediateBikeSlotRepository(),
        ridePassRepository: const _ImmediateRidePassRepository(),
        bikeStationRepository: _ImmediateBikeStationRepository(store),
        appUserRepository: _ImmediateAppUserRepository(store),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

class _ImmediateRidePassRepository implements RidePassRepository {
  const _ImmediateRidePassRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async => PassType.values;
}

class _ImmediateBikeStationRepository implements BikeStationRepository {
  const _ImmediateBikeStationRepository(this.store);

  final MockRideStore store;

  @override
  Future<List<BikeStation>> fetchStations() async =>
      List<BikeStation>.from(store.stations);

  @override
  Stream<List<BikeStation>> watchStations() async* {
    yield List<BikeStation>.from(store.stations);
  }
}

class _ImmediateBikeSlotRepository implements BikeSlotRepository {
  const _ImmediateBikeSlotRepository();

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {}
}

class _ImmediateAppUserRepository implements AppUserRepository {
  const _ImmediateAppUserRepository(this.store);

  final MockRideStore store;

  @override
  Future<AppUser> fetchCurrentUser() async => store.currentUser;

  @override
  Future<void> saveCurrentUser(AppUser user) async {
    store.currentUser = user;
  }
}
