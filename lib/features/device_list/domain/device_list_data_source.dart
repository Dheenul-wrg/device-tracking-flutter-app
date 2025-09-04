import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/category_details.dart';

abstract class DeviceListDataSource {
  Future<WrgResponse<List<CategoryDetails>>> allRegisteredDevicesCount();
}
