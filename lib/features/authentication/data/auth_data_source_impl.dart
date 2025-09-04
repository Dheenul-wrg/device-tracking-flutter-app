import 'package:device_tracking_flutter_app/core/api/api_service/api_service.dart';
import 'package:device_tracking_flutter_app/core/api/endpoints.dart';
import 'package:device_tracking_flutter_app/core/api/status_code.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/google_sign_in_user_entity.dart';
import 'package:device_tracking_flutter_app/core/model/user.dart';
import 'package:device_tracking_flutter_app/features/authentication/domain/auth_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/model/user_login_track_entity.dart';

part 'auth_data_source_impl.g.dart';

@riverpod
AuthDataSource authDataSource(Ref ref) {
  return RemoteAuthDataSourceImplementation(
    apiService: ref.read(devicetrackingApiServiceProvider),
  );
}

class RemoteAuthDataSourceImplementation implements AuthDataSource {
  final ApiService apiService;

  RemoteAuthDataSourceImplementation({required this.apiService});
  @override
  Future<WrgResponse<User>> getUser(String userId) async {
    try {
      final response = await apiService.get(
        endpoint: '${DeviceTrackerEndpoints.getUserDetails}/$userId',
        params: Map.from({}),
        decoder: (data) => User.fromJson(data['data']),
      );

      return response;
    } catch (e) {
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message: 'Unknown error occured while fetching user details',
        ),
      );
    }
  }

  @override
  Future<WrgResponse<bool>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<WrgResponse<User>> register(GoogleSigninUserEntity entity) async {
    try {
      final response = await apiService.post(
        endpoint: DeviceTrackerEndpoints.registerUser,
        body: entity.toJson(),
        decoder: (data) => User.fromJson(data['data']),
      );

      return response;
    } catch (e) {
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message: 'Unknown error occured while fetching user details',
        ),
      );
    }
  }

  @override
  Future<WrgResponse<bool>> login(UserLoginTrackEntity entity) async {
    try {
      final response = await apiService.post(
        endpoint: DeviceTrackerEndpoints.trackDeviceLogin,
        body: entity.toJson(),
        decoder: (data) => data['data'] != null,
      );

      return response;
    } catch (e) {
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message: 'Unknown error occured while fetching user details',
        ),
      );
    }
  }
}
