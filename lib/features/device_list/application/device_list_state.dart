import 'package:device_tracking_flutter_app/core/model/category_details.dart';
import 'package:device_tracking_flutter_app/features/device_list/data/device_list_data_source_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_list_state.g.dart';

@riverpod
class DeviceListState extends _$DeviceListState {
  @override
  Future<List<CategoryDetails>?> build() async {
    try {
      state = AsyncLoading();
      final result = await ref
          .read(deviceListDataSourceProvider)
          .allRegisteredDevicesCount();
      if (!result.isSuccess) {
        state = AsyncError(result.error!, StackTrace.current);
      }
      state = AsyncData(result.data);
      return result.data;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }
}
