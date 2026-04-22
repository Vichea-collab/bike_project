import 'current_booking.dart';
import 'ride_pass.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    this.activePass,
    this.currentBooking,
  });

  final String id;
  final String name;
  final RidePass? activePass;
  final CurrentBooking? currentBooking;

  AppUser copyWith({
    String? id,
    String? name,
    Object? activePass = _unset,
    Object? currentBooking = _unset,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      activePass: identical(activePass, _unset)
          ? this.activePass
          : activePass as RidePass?,
      currentBooking: identical(currentBooking, _unset)
          ? this.currentBooking
          : currentBooking as CurrentBooking?,
    );
  }
}

const _unset = Object();
