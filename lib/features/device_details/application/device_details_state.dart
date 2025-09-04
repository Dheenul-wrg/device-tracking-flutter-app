import 'package:device_tracking_flutter_app/core/model/mobile_info.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:device_tracking_flutter_app/features/category_device_list/application/category_device_list_state.dart';
import 'package:device_tracking_flutter_app/features/device_details/data/device_data_source_impl.dart';
import 'package:device_tracking_flutter_app/features/device_details/domain/model/assign_device_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_details_state.g.dart';

@riverpod
class DeviceDetailsState extends _$DeviceDetailsState {
  @override
  FutureOr<MobileInfo> build(int id) {
    state = AsyncLoading();
    final value = [...ref.read(categoryDeviceListStateProvider).value!];
    final selectedDevice = value.firstWhere((data) => data.id == id);
    return selectedDevice;
  }

  Future<bool> assignDevice({
    required int assignToUserId,
    required int assignedByUserId,
  }) async {
    try {
      state = AsyncLoading();
      final entity = AssignDeviceEntity(
        deviceId: state.value!.deviceId,
        assignedToUserId: assignToUserId,
        assignedByAdminId: assignedByUserId,
      );

      final result = await ref
          .read(deviceDataSourceProvider)
          .assignDevice(entity);

      if (!result.isSuccess) {
        state = AsyncError(result.error!, StackTrace.current);
        return false;
      }

      // Update the device history with the new assignment
      final updatedHistory = [result.data!, ...state.value!.deviceHistory];
      final updatedDevice = state.value!.copyWith(
        deviceHistory: updatedHistory,
      );

      state = AsyncData(updatedDevice);

      // Invalidate related providers to refresh data
      ref.invalidate(categoryDeviceListStateProvider);
      ref.invalidate(authStateProvider);

      // Force refresh user data to get latest assigned devices
      print('🔄 Forcing user data refresh after assignment...');
      await ref.read(authStateProvider.notifier).refreshUserData();

      // Additional invalidation to ensure UI updates
      ref.invalidate(authStateProvider);
      print('🔄 Auth state invalidated again for immediate UI update');

      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> unAssignDevice() async {
    try {
      print('🚀 Starting unassign device process...');
      state = AsyncLoading();

      if (state.value?.deviceHistory.isEmpty ?? true) {
        print('❌ No device history found');
        state = AsyncError('No device history found', StackTrace.current);
        return false;
      }

      final trackingId = state.value!.deviceHistory.first.trackId;
      print('📱 Device tracking ID: $trackingId');
      print(
        '📱 Device current state: ${state.value!.deviceHistory.first.unassignedAt != null ? 'Available' : 'Assigned'}',
      );

      // Check if device is actually assigned
      if (state.value!.deviceHistory.first.unassignedAt != null) {
        print('❌ Device is already available (not assigned)');
        state = AsyncError(
          'Device is already available and cannot be unassigned',
          StackTrace.current,
        );
        return false;
      }

      final result = await ref
          .read(deviceDataSourceProvider)
          .unAssignDevice(trackingId);

      print(
        '📡 Unassign API result - Success: ${result.isSuccess}, Error: ${result.error}',
      );

      if (!result.isSuccess) {
        print('❌ Unassign failed with error: ${result.error}');
        state = AsyncError(result.error!, StackTrace.current);
        return false;
      }

      print('✅ Unassign successful, updating device state...');

      // Update the device history with the unassignment
      final updatedHistory = [result.data!, ...state.value!.deviceHistory];
      final updatedDevice = state.value!.copyWith(
        deviceHistory: updatedHistory,
      );

      state = AsyncData(updatedDevice);
      print('🔄 Device state updated successfully');

      // Invalidate related providers to refresh data
      ref.invalidate(categoryDeviceListStateProvider);
      ref.invalidate(authStateProvider);
      print('🔄 Related providers invalidated');

      // Force refresh user data to get latest assigned devices
      print('🔄 Forcing user data refresh...');
      await ref.read(authStateProvider.notifier).refreshUserData();

      // Additional invalidation to ensure UI updates
      ref.invalidate(authStateProvider);
      print('🔄 Auth state invalidated again for immediate UI update');

      return true;
    } catch (e) {
      print('💥 Exception in unassign device: $e');
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  void refreshDevice() {
    ref.invalidateSelf();
  }
}
