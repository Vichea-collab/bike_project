import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';

class RidePassDto {
  const RidePassDto({
    required this.typeName,
    required this.purchasedAtIso,
    required this.expirationDateIso,
  });

  final String typeName;
  final String purchasedAtIso;
  final String expirationDateIso;

  factory RidePassDto.fromDomain(RidePass pass) {
    return RidePassDto(
      typeName: pass.type.name,
      purchasedAtIso: pass.purchasedAt.toIso8601String(),
      expirationDateIso: pass.expirationDate.toIso8601String(),
    );
  }

  factory RidePassDto.fromMap(Map<Object?, Object?> source) {
    final typeName = (source['typeName'] ?? '').toString();
    final purchasedAtIso = (source['purchasedAtIso'] ?? '').toString();
    final fallbackExpirationDateIso = _deriveExpirationDateIso(
      typeName: typeName,
      purchasedAtIso: purchasedAtIso,
    );

    return RidePassDto(
      typeName: typeName,
      purchasedAtIso: purchasedAtIso,
      expirationDateIso:
          (source['expirationDateIso'] ?? fallbackExpirationDateIso).toString(),
    );
  }

  RidePass toDomain() {
    final passType = PassType.values.firstWhere(
      (item) => item.name == typeName,
      orElse: () => PassType.day,
    );

    return RidePass(
      type: passType,
      purchasedAt: DateTime.parse(purchasedAtIso),
      expirationDate: DateTime.tryParse(expirationDateIso),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeName': typeName,
      'purchasedAtIso': purchasedAtIso,
      'expirationDateIso': expirationDateIso,
    };
  }
}

String _deriveExpirationDateIso({
  required String typeName,
  required String purchasedAtIso,
}) {
  final passType = PassType.values.firstWhere(
    (item) => item.name == typeName,
    orElse: () => PassType.day,
  );
  final purchasedAt = DateTime.tryParse(purchasedAtIso) ?? DateTime.now();
  return purchasedAt
      .add(Duration(days: passType.validityDays))
      .toIso8601String();
}
