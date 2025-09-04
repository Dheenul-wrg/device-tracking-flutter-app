import 'package:device_tracking_flutter_app/core/api/status_code.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/google_sign_in_user_entity.dart';
import 'package:device_tracking_flutter_app/core/model/user_registration_status.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/google_sign_in/google_signin_error_state.dart';
import 'package:device_tracking_flutter_app/features/authentication/data/auth_data_source_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_sign_in_state.g.dart';

@riverpod
class GoogleSignInState extends _$GoogleSignInState {
  final googleSignIn = GoogleSignIn.instance;

  @override
  FutureOr<UserRegistrationStatus?> build() async {
    await googleSignIn.initialize();
    return null;
  }

  Future<void> signInWithGoogle() async {
    try {
      state = AsyncLoading();

      final googleSigninResult = await googleSignIn.authenticate();

      final emailParts = googleSigninResult.email.split('@');

      if (!emailParts[1].contains('whiterabbit.group')) {
        state = AsyncData(null);
        ref.read(googleSigninErrorStateProvider.notifier).error = ApiError(
          status: StatusCode.unauthorized,
          name: 'Invalid work mail',
          message:
              'The entered mail is not a valid work mail. Please try again with valid mail',
        );
        return;
      }

      if (googleSigninResult.id.isEmpty) {
        state = AsyncData(null);
        ref.read(googleSigninErrorStateProvider.notifier).error = ApiError(
          status: StatusCode.badRequest,
          name: 'Google Signin unsuccessful',
          message:
              'Unable to signin using the google account. Please try again later',
        );
        return;
      }

      if (googleSigninResult.authentication.idToken == null) {
        state = AsyncData(null);
        ref.read(googleSigninErrorStateProvider.notifier).error = ApiError(
          status: StatusCode.badRequest,
          name: 'Google Signin unsuccessful',
          message:
              'Unable to signin using the google account. Please try again later',
        );
        return;
      }

      final userResult = await ref
          .read(authDataSourceProvider)
          .getUser(googleSigninResult.id);

      if (!userResult.isSuccess || userResult.error != null) {
        state = AsyncData(
          UserRegistrationStatus(
            userGoogleSignData: googleSigninResult,
            registeredUserData: null,
          ),
        );
        ref.read(googleSigninErrorStateProvider.notifier).error =
            userResult.error;
        return;
      }

      ref.read(authStateProvider.notifier).user = userResult.data;

      ref
          .read(authStateProvider.notifier)
          .saveUserToPreference(userResult.data!);

      state = AsyncData(
        UserRegistrationStatus(
          userGoogleSignData: null,
          registeredUserData: userResult.data,
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      ref.read(googleSigninErrorStateProvider.notifier).error = ApiError(
        status: StatusCode.badRequest,
        name: 'Unknown error',
        message: 'An unknown error occured. Please try again later',
      );
    }
  }

  Future<void> registerNewGoogleUser(GoogleSigninUserEntity entity) async {
    try {
      final response = await ref.read(authDataSourceProvider).register(entity);

      if (!response.isSuccess || response.error != null) {
        state = AsyncData(null);

        ref.read(googleSigninErrorStateProvider.notifier).error =
            response.error;
        return;
      }

      ref.read(authStateProvider.notifier).user = response.data;

      state = AsyncData(
        UserRegistrationStatus(
          userGoogleSignData: null,
          registeredUserData: response.data,
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      ref.read(googleSigninErrorStateProvider.notifier).error = ApiError(
        status: StatusCode.badRequest,
        name: 'Unknown error',
        message: 'An unknown error occured. Please try again later',
      );
    }
  }
}
