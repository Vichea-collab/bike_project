import '../../models/app_user.dart';
import 'current_booking_dto.dart';
import 'ride_pass_dto.dart';

class AppUserDto {
  const AppUserDto({
    required this.id,
    required this.name,
    this.activePass,
    this.currentBooking,
  });

  final String id;
  final String name;
  final RidePassDto? activePass;
  final CurrentBookingDto? currentBooking;

  factory AppUserDto.fromDomain(AppUser user) {
    final activePass = user.activePass;
    final currentBooking = user.currentBooking;

    return AppUserDto(
      id: user.id,
      name: user.name,
      activePass: activePass == null ? null : RidePassDto.fromDomain(activePass),
      currentBooking: currentBooking == null
          ? null
          : CurrentBookingDto.fromDomain(currentBooking),
    );
  }

  factory AppUserDto.fromMap(String id, Map<Object?, Object?> source) {
    final rawActivePass = source['activePass'];
    final rawCurrentBooking = source['currentBooking'];

    return AppUserDto(
      id: id,
      name: (source['name'] ?? source['fullName'] ?? 'Guest Rider').toString(),
      activePass: rawActivePass is Map
          ? RidePassDto.fromMap(Map<Object?, Object?>.from(rawActivePass))
          : null,
      currentBooking: rawCurrentBooking is Map
          ? CurrentBookingDto.fromMap(
              Map<Object?, Object?>.from(rawCurrentBooking),
            )
          : null,
    );
  }

  AppUser toDomain() {
    return AppUser(id: id, name: name, activePass: activePass?.toDomain(), currentBooking: currentBooking?.toDomain());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'activePass': activePass?.toMap(),
      'currentBooking': currentBooking?.toMap(),
    };
  }
}
