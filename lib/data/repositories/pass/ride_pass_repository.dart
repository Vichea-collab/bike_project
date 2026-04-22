import '../../../models/pass_type.dart';

export 'ride_pass_mock_repository.dart';

abstract class RidePassRepository {
  Future<List<PassType>> fetchPassTypes();
}

class RidePassRestRepository implements RidePassRepository {
  const RidePassRestRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async => PassType.values;
}
