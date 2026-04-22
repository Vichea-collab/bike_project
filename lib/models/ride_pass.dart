import 'pass_type.dart';

class RidePass {
  RidePass({
    required this.type,
    required this.purchasedAt,
    DateTime? expirationDate,
  }) : expirationDate =
           expirationDate ??
           purchasedAt.add(Duration(days: type.validityDays));

  final PassType type;
  final DateTime purchasedAt;
  final DateTime expirationDate;
}
