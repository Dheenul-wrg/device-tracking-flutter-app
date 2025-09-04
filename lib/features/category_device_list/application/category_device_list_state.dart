import 'package:device_tracking_flutter_app/core/model/mobile_info.dart';
import 'package:device_tracking_flutter_app/features/category_device_list/data/category_device_list_data_source_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_device_list_state.g.dart';

@riverpod
class CategoryDeviceListState extends _$CategoryDeviceListState {
  @override
  Future<List<MobileInfo>?> build() async {
    try {
      state = AsyncLoading();
      final result = await ref
          .read(categoryDeviceListDataSourceProvider)
          .getAllMobiles();
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
