import '../../../models/pass_type.dart';
import 'ride_pass_repository.dart';

class RidePassMockRepository implements RidePassRepository {
  const RidePassMockRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return PassType.values;
  }
}
