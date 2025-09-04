import 'package:device_tracking_flutter_app/core/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRegistrationStatus {
  final GoogleSignInAccount? userGoogleSignData;
  final User? registeredUserData;

  UserRegistrationStatus({
    required this.userGoogleSignData,
    required this.registeredUserData,
  });
}
