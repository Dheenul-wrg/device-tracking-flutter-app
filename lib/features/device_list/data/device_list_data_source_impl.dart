import 'package:device_tracking_flutter_app/core/api/api_service/api_service.dart';
import 'package:device_tracking_flutter_app/core/api/endpoints.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/category_details.dart';
import 'package:device_tracking_flutter_app/features/device_list/domain/device_list_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/status_code.dart';

part 'device_list_data_source_impl.g.dart';

@riverpod
DeviceListDataSource deviceListDataSource(Ref ref) {
  return DeviceListDataSourceImpl(
    apiService: ref.read(devicetrackingApiServiceProvider),
  );
}

class DeviceListDataSourceImpl implements DeviceListDataSource {
  final ApiService apiService;

  DeviceListDataSourceImpl({required this.apiService});
  @override
  Future<WrgResponse<List<CategoryDetails>>> allRegisteredDevicesCount() async {
    try {
      final result = await apiService.get(
        endpoint: DeviceTrackerEndpoints.deviceCountDetails,
        params: Map.from({}),
        decoder: (data) => CategoryDetails.fromJsonToList(data['data']),
      );

      return result;
    } catch (e) {
      return WrgResponse(
        error: ApiError(
          status: StatusCode.unknownError,
          name: 'An nknown error.',
          message:
              'Unknown error occured while fetching devices ${e.toString()}',
        ),
      );
    }
  }
}
