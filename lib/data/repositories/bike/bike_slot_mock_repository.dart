import '../mock/mock_ride_store.dart';
import 'bike_slot_repository.dart';

class BikeSlotMockRepository implements BikeSlotRepository {
  const BikeSlotMockRepository({required MockRideStore store}) : _store = store;

  final MockRideStore _store;

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final updatedStations = _store.stations.map((station) {
      if (station.id != stationId) {
        return station;
      }

      final slots = station.slots
          .map(
            (slot) =>
                slot.id == slotId ? slot.copyWith(isAvailable: false) : slot,
          )
          .toList();

      return station.copyWith(slots: slots);
    }).toList();

    _store.updateStations(updatedStations);
  }
}
