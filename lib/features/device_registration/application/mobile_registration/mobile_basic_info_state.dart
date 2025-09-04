import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_tracking_flutter_app/features/device_registration/domain/model/device_basic_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/status_code.dart';
import '../../../../core/api/wrg_response.dart';
import '../mobile_registration_error/mobile_registration_error_state.dart';

part 'mobile_basic_info_state.g.dart';

@riverpod
class MobileBasicInfoState extends _$MobileBasicInfoState {
  @override
  Future<DeviceBasicInfo?> build() async {
    return null;
  }

  Future<void> getBasicDeviceInfo() async {
    try {
      state = AsyncLoading();
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidResult = await deviceInfo.androidInfo;

        state = AsyncData(
          DeviceBasicInfo(
            model: androidResult.model,
            name: androidResult.name,
            platform: 'Android',
            brand: androidResult.brand,
          ),
        );
      } else {
        final iosResult = await deviceInfo.iosInfo;
        state = AsyncData(
          DeviceBasicInfo(
            model: iosResult.model,
            name: iosResult.name,
            platform: 'iOS',
            brand: 'Apple',
          ),
        );
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      ref.read(mobileRegistrationErrorStateProvider.notifier).error = ApiError(
        status: StatusCode.badRequest,
        name: 'Unknown error',
        message: 'An unknown error occured. Please try again later',
      );
    }
  }

  void resetState() {
    state = AsyncData(null);
  }
}
