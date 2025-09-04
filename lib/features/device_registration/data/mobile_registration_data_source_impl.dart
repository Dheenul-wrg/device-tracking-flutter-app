import 'package:device_tracking_flutter_app/core/api/api_service/api_service.dart';
import 'package:device_tracking_flutter_app/core/api/endpoints.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/mobile_info.dart';
import 'package:device_tracking_flutter_app/core/model/new_device_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/data_source/mobile_registration_data_source.dart';

part 'mobile_registration_data_source_impl.g.dart';

@riverpod
MobileRegistrationDataSource mobileRegistrationDataSource(Ref ref) {
  return MobileRegistrationDataSourceImpl(
    apiService: ref.read(devicetrackingApiServiceProvider),
  );
}

class MobileRegistrationDataSourceImpl implements MobileRegistrationDataSource {
  final ApiService apiService;

  MobileRegistrationDataSourceImpl({required this.apiService});
  @override
  Future<WrgResponse<MobileInfo>> registerNewMobile(
    NewMobileEntity entity,
  ) async {
    final result = await apiService.post(
      endpoint: DeviceTrackerEndpoints.mobileRegistration,
      body: entity.toJson(),
      decoder: (data) => MobileInfo.fromJson(data['device']),
    );
    return result;
  }
}
