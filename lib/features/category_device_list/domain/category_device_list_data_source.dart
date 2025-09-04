import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/mobile_info.dart';

abstract class CategoryDeviceListDataSource {
  Future<WrgResponse<List<MobileInfo>>> getAllMobiles();
}
