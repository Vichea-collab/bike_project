import '../../models/current_booking.dart';

class CurrentBookingDto {
  const CurrentBookingDto({
    required this.stationId,
    required this.stationName,
    required this.slotId,
    required this.slotLabel,
    required this.bookedAtIso,
  });

  final String stationId;
  final String stationName;
  final String slotId;
  final String slotLabel;
  final String bookedAtIso;

  factory CurrentBookingDto.fromDomain(CurrentBooking booking) {
    return CurrentBookingDto(
      stationId: booking.stationId,
      stationName: booking.stationName,
      slotId: booking.slotId,
      slotLabel: booking.slotLabel,
      bookedAtIso: booking.bookedAt.toIso8601String(),
    );
  }

  factory CurrentBookingDto.fromMap(Map<Object?, Object?> source) {
    return CurrentBookingDto(
      stationId: (source['stationId'] ?? '').toString(),
      stationName: (source['stationName'] ?? '').toString(),
      slotId: (source['slotId'] ?? '').toString(),
      slotLabel: (source['slotLabel'] ?? '').toString(),
      bookedAtIso: (source['bookedAtIso'] ?? '').toString(),
    );
  }

  CurrentBooking toDomain() {
    final bookedAt = DateTime.tryParse(bookedAtIso) ?? DateTime.now();

    return CurrentBooking(
      stationId: stationId,
      stationName: stationName,
      slotId: slotId,
      slotLabel: slotLabel,
      bookedAt: bookedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stationId': stationId,
      'stationName': stationName,
      'slotId': slotId,
      'slotLabel': slotLabel,
      'bookedAtIso': bookedAtIso,
    };
  }
}
