import 'package:device_tracking_flutter_app/core/api/api_error_validation_state_base.dart';
import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_signin_error_state.g.dart';

@riverpod
class GoogleSigninErrorState extends _$GoogleSigninErrorState
    implements ApiValidationStateBase {
  @override
  ApiError? build() {
    return null;
  }

  @override
  ApiError? get error => state;

  @override
  set error(ApiError? e) => state = e;

  @override
  void clearValidationErrors() {
    state = null;
  }
}
