import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../../models/current_booking.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../utils/async_value.dart';

class RideAppState {
  const RideAppState({
    this.status = const AsyncValue.loading(),
    this.currentTabIndex = 0,
    this.passTypes = const [],
    this.stations = const [],
    this.currentUser,
    this.selectedStation,
  });

  final AsyncValue<void> status;
  final int currentTabIndex;
  final List<PassType> passTypes;
  final List<BikeStation> stations;
  final AppUser? currentUser;
  final BikeStation? selectedStation;

  bool get isLoading => status.isLoading;
  String? get errorMessage => status.errorMessage;

  RidePass? get activePass => currentUser?.activePass;
  CurrentBooking? get currentBooking => currentUser?.currentBooking;
  bool get hasCurrentBooking => currentBooking != null;

  bool get hasActivePass =>
      activePass != null && activePass!.expirationDate.isAfter(DateTime.now());

  RideAppState copyWith({
    AsyncValue<void>? status,
    int? currentTabIndex,
    List<PassType>? passTypes,
    List<BikeStation>? stations,
    Object? currentUser = _unset,
    Object? selectedStation = _unset,
  }) {
    return RideAppState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      passTypes: passTypes ?? this.passTypes,
      stations: stations ?? this.stations,
      currentUser: identical(currentUser, _unset)
          ? this.currentUser
          : currentUser as AppUser?,
      selectedStation: identical(selectedStation, _unset)
          ? this.selectedStation
          : selectedStation as BikeStation?,
    );
  }
}

const _unset = Object();
