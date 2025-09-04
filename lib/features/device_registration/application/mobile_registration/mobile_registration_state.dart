import 'package:device_tracking_flutter_app/features/category_device_list/application/category_device_list_state.dart';
import 'package:device_tracking_flutter_app/features/device_list/application/device_list_state.dart';
import 'package:device_tracking_flutter_app/features/device_registration/application/mobile_registration_error/mobile_registration_error_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/status_code.dart';
import '../../../../core/api/wrg_response.dart';
import '../../../../core/model/mobile_info.dart';
import '../../../../core/model/new_device_entity.dart';
import '../../data/mobile_registration_data_source_impl.dart';

part 'mobile_registration_state.g.dart';

@riverpod
class MobileRegistrationState extends _$MobileRegistrationState {
  @override
  Future<MobileInfo?> build() async {
    return null;
  }

  Future<void> registerNewMobile(NewMobileEntity newMobile) async {
    try {
      final result = await ref
          .read(mobileRegistrationDataSourceProvider)
          .registerNewMobile(newMobile);
      if (!result.isSuccess && result.error != null) {
        state = AsyncError(result.error!, StackTrace.current);
        ref.read(mobileRegistrationErrorStateProvider.notifier).error =
            result.error;
      }
      ref.invalidate(categoryDeviceListStateProvider);
      ref.invalidate(deviceListStateProvider);

      await Future.delayed(Duration(seconds: 1));
      state = AsyncData(result.data);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      ref.read(mobileRegistrationErrorStateProvider.notifier).error = ApiError(
        status: StatusCode.badRequest,
        name: 'Unknown error',
        message: 'An unknown error occured. Please try again later',
      );
    }
  }
}
