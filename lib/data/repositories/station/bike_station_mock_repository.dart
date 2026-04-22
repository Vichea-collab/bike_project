import '../../../models/bike_station.dart';
import '../mock/mock_ride_store.dart';
import 'bike_station_repository.dart';

class BikeStationMockRepository implements BikeStationRepository {
  const BikeStationMockRepository({required MockRideStore store})
    : _store = store;

  final MockRideStore _store;

  @override
  Future<List<BikeStation>> fetchStations() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<BikeStation>.from(_store.stations);
  }

  @override
  Stream<List<BikeStation>> watchStations() => _store.stationsStream;
}
