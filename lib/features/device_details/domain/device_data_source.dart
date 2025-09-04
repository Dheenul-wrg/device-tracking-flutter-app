import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/device_history.dart';
import 'package:device_tracking_flutter_app/core/model/user.dart';

import 'model/assign_device_entity.dart';

abstract class DeviceDataSource {
  Future<WrgResponse<DeviceHistory>> assignDevice(AssignDeviceEntity enttity);
  Future<WrgResponse<DeviceHistory>> unAssignDevice(int trackingId);
  Future<WrgResponse<List<User>>> searchUser(String searchQuery);
}
