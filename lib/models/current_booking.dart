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
}
