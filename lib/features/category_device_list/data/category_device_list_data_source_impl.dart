import 'package:device_tracking_flutter_app/core/api/api_service/api_service.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/mobile_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/api/status_code.dart';
import '../domain/category_device_list_data_source.dart';

part 'category_device_list_data_source_impl.g.dart';

@riverpod
CategoryDeviceListDataSource categoryDeviceListDataSource(Ref ref) {
  return CategoryDeviceListDataSourceImpl(
    apiService: ref.read(devicetrackingApiServiceProvider),
  );
}

class CategoryDeviceListDataSourceImpl implements CategoryDeviceListDataSource {
  final ApiService apiService;

  CategoryDeviceListDataSourceImpl({required this.apiService});
  @override
  Future<WrgResponse<List<MobileInfo>>> getAllMobiles() async {
    try {
      final result = await apiService.get(
        endpoint: DeviceTrackerEndpoints.mobiles,
        params: Map.from({}),
        decoder: (data) => MobileInfo.listFromJson(data),
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
