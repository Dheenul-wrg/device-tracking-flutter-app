import 'package:device_tracking_flutter_app/core/model/google_sign_in_user_entity.dart';

import '../../../core/api/wrg_response.dart';
import '../../../core/model/user.dart';
import '../../../core/model/user_login_track_entity.dart';

abstract class AuthDataSource {
  Future<WrgResponse<User>> register(GoogleSigninUserEntity entity);

  Future<WrgResponse<bool>> login(UserLoginTrackEntity entity);

  Future<WrgResponse<bool>> logout();

  Future<WrgResponse<User>> getUser(String googleUserId);
}
