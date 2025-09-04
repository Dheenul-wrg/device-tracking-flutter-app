import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/api_error_validation_state_base.dart';
import '../../../../core/api/wrg_response.dart';

part 'mobile_registration_error_state.g.dart';

@riverpod
class MobileRegistrationErrorState extends _$MobileRegistrationErrorState
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
