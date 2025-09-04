class NewUserEntity {
  final String name;
  final String email;
  final String mobileNumber;
  final String role;
  final String googleSigninId;
  final String googleSigninToken;

  NewUserEntity({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.role,
    required this.googleSigninId,
    required this.googleSigninToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'role': role,
      'google_signin_id': googleSigninId,
      'google_signin_token': googleSigninToken,
    };
  }
}
