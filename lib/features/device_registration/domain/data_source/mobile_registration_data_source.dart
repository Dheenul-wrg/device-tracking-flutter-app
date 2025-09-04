import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/mobile_info.dart';
import 'package:device_tracking_flutter_app/core/model/new_device_entity.dart';

abstract class MobileRegistrationDataSource {
  Future<WrgResponse<MobileInfo>> registerNewMobile(NewMobileEntity entity);
}
