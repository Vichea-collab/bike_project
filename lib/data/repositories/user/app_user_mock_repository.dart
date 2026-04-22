import '../../../models/app_user.dart';
import '../mock/mock_ride_store.dart';
import 'app_user_repository.dart';

class AppUserMockRepository implements AppUserRepository {
  const AppUserMockRepository({required MockRideStore store}) : _store = store;

  final MockRideStore _store;

  @override
  Future<AppUser> fetchCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _store.currentUser;
  }

  @override
  Future<void> saveCurrentUser(AppUser user) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _store.currentUser = user;
  }
}
