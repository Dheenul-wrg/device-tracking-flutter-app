import 'wrg_response.dart';

abstract class ApiValidationStateBase {
  /// Set validation errors
  set error(ApiError? e);

  /// Get validation errors
  ApiError? get error;

  /// Clear calidation errors;
  void clearValidationErrors();
}
