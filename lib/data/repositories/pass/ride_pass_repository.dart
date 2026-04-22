import '../../../models/pass_type.dart';

abstract class RidePassRepository {
  Future<List<PassType>> fetchPassTypes();
}

class RidePassRestRepository implements RidePassRepository {
  const RidePassRestRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async => PassType.values;
}

class RidePassMockRepository implements RidePassRepository {
  const RidePassMockRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return PassType.values;
  }
}
