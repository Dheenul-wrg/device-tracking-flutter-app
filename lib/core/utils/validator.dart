typedef Validator = String? Function(String? value);

/// Checking if the [value] is empty and retruning appropriate message
String? emptyValidation(String? value) {
  if (value?.isEmpty == true) {
    return 'The value should not be empty';
  }
  return null;
}

String? multiValidator(String? value, List<Validator> validators) {
  for (final validator in validators) {
    final message = validator(value);
    if (message != null) {
      return message;
    }
  }
  return null;
}

String? validateEmail(String email) {
  final emailRegex = RegExp(r'^[^\s@]+@whiterabbit\.group$');
  if (emailRegex.hasMatch(email)) {
    return null; // Email is valid
  }
  return 'Please use a WRG gmail.'; // Invalid email
}
