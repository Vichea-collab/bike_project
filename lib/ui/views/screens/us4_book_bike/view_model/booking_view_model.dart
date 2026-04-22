import 'package:flutter/foundation.dart';

import '../../../../../models/bike_slot.dart';
import '../../../../../models/current_booking.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../utils/async_value.dart';
import '../../../../viewmodels/ride_app_view_model.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({required RideAppViewModel appViewModel, required this.slot})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final BikeSlot slot;
  AsyncValue<void> _state = const AsyncValue.success(null);

  AsyncValue<void> get state => _state;
  bool get isBusy => _state.isLoading;
  String? get actionError => _state.errorMessage;

  String get stationName => _appViewModel.state.selectedStation?.name ?? '-';
  String get slotLabel => slot.label;
  bool get hasActivePass => _appViewModel.state.hasActivePass;
  bool get canConfirm => hasActivePass;

  String get accessTitle {
    if (hasActivePass) {
      return 'Active pass';
    }
    return 'Choose access';
  }

  String get accessDescription {
    if (hasActivePass) {
      final pass = _appViewModel.state.activePass;
      if (pass == null) {
        return 'Ride access is active for this booking.';
      }
      return '${pass.type.title} active until ${formatDateLong(pass.expirationDate)}.';
    }
    return 'Buy one single ticket for this reservation or choose a pass for ongoing access.';
  }

  void clearActionError() {
    if (!_state.hasError) {
      return;
    }
    _setState(const AsyncValue.success(null));
  }

  Future<bool> confirmBooking() async {
    if (!canConfirm) {
      return false;
    }
    return _completeBooking('Unable to confirm the booking.');
  }

  Future<bool> paySingleTicketAndConfirmBooking() async {
    return _completeBooking(
      'Unable to complete payment and confirm the booking.',
    );
  }

  Future<bool> _completeBooking(String failureMessage) async {
    final station = _appViewModel.state.selectedStation;
    final currentUser = _appViewModel.state.currentUser;
    if (station == null || currentUser == null) {
      return false;
    }

    _setState(const AsyncValue.loading());

    try {
      _appViewModel.setErrorMessage(null);
      final updatedUser = currentUser.copyWith(
        currentBooking: _buildCurrentBooking(station),
      );
      await _appViewModel.bookBike(
        stationId: station.id,
        slotId: slot.id,
        updatedUser: updatedUser,
      );
      _setState(const AsyncValue.success(null));
      return true;
    } catch (_) {
      _appViewModel.setErrorMessage(failureMessage);
      _setState(AsyncValue.error(failureMessage));
      return false;
    }
  }

  CurrentBooking _buildCurrentBooking(dynamic station) {
    return CurrentBooking(
      stationId: station.id,
      stationName: station.name,
      slotId: slot.id,
      slotLabel: slot.label,
      bookedAt: DateTime.now(),
    );
  }

  void _setState(AsyncValue<void> nextState) {
    _state = nextState;
    notifyListeners();
  }

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _appViewModel.removeListener(_handleAppStateChanged);
    super.dispose();
  }
}
