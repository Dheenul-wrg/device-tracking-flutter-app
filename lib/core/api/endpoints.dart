class DeviceTrackerEndpoints {
  DeviceTrackerEndpoints._();

  ///devices
  static final devices = 'devices/';
  static final registerDevices = 'devices/register';
  static final deviceCountDetails = 'devices/device-category-counts';

  //Mobile
  static final mobiles = 'mobiles/';
  static final mobileRegistration = 'mobiles/register';
  static final assignDevice = 'mobiles/assign';
  static final unAssignDevice = 'mobiles/unassign';

  ///users api
  static const getUserDetails = 'users/';
  static const registerUser = 'users/registerUser';
  static const searchUser = 'users/search?q=';

  ///device tracking
  static const trackDeviceLogin = '/track/deviceLogin';
  static const trackDeviceLogout = '/track/deviceLogout';
}
