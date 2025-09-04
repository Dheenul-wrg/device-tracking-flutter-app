import 'package:device_tracking_flutter_app/core/api/api_service/api_service.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/device_history.dart';
import 'package:device_tracking_flutter_app/core/model/user.dart';
import 'package:device_tracking_flutter_app/features/device_details/domain/device_data_source.dart';
import 'package:device_tracking_flutter_app/features/device_details/domain/model/assign_device_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/api/status_code.dart';

part 'device_data_source_impl.g.dart';

@riverpod
DeviceDataSource deviceDataSource(Ref ref) {
  return DeviceDataSourceImpl(
    apiService: ref.read(devicetrackingApiServiceProvider),
  );
}

class DeviceDataSourceImpl extends DeviceDataSource {
  final ApiService apiService;

  DeviceDataSourceImpl({required this.apiService});

  @override
  Future<WrgResponse<DeviceHistory>> assignDevice(
    AssignDeviceEntity enttity,
  ) async {
    try {
      final response = await apiService.post(
        endpoint: DeviceTrackerEndpoints.assignDevice,
        body: enttity.toJson(),
        decoder: (data) => DeviceHistory.fromJson(data['result']),
      );

      return response;
    } catch (e) {
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message: 'Unknown error occured while assigning the device',
        ),
      );
    }
  }

  @override
  Future<WrgResponse<DeviceHistory>> unAssignDevice(int trackingId) async {
    try {
      final response = await apiService.post(
        endpoint: DeviceTrackerEndpoints.unAssignDevice,
        body: {'track_id': trackingId},
        decoder: (data) => DeviceHistory.fromJson(data['result']),
      );

      return response;
    } catch (e) {
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message: 'Unknown error occured while unassigning the device',
        ),
      );
    }
  }

  @override
  Future<WrgResponse<List<User>>> searchUser(String searchQuery) async {
    try {
      final response = await apiService.get(
        endpoint: '${DeviceTrackerEndpoints.searchUser}$searchQuery',
        params: Map.from({}),
        decoder: (data) => User.fromJsonList(data['data']['users']),
      );

      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return WrgResponse(data: []);
      }
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message: 'Unknown error occured while searching user',
        ),
      );
    }
  }
}
