class CurrentBooking {
  const CurrentBooking({
    required this.stationId,
    required this.stationName,
    required this.slotId,
    required this.slotLabel,
    required this.bookedAt,
  });

  final String stationId;
  final String stationName;
  final String slotId;
  final String slotLabel;
  final DateTime bookedAt;

  CurrentBooking copyWith({
    String? stationId,
    String? stationName,
    String? slotId,
    String? slotLabel,
    DateTime? bookedAt,
  }) {
    return CurrentBooking(
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      slotId: slotId ?? this.slotId,
      slotLabel: slotLabel ?? this.slotLabel,
      bookedAt: bookedAt ?? this.bookedAt,
    );
  }
}
