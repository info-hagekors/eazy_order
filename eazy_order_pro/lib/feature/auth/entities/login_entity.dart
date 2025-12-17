
class LoginEntity {
  final String email;
  final String password;
  final bool isValid;
  final bool isPasswordVisible;
  final bool isLoginWithEmail;
  final String countryCode;
  final String mobile;
  final String enteredOtp;

  LoginEntity({
    this.email = '',
    this.isValid = false,
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoginWithEmail = true,
    this.countryCode = '',
    this.mobile = '',
    this.enteredOtp = '',
  });

  LoginEntity copyWith({String? email, bool? isValid, String? password, bool? isPasswordVisible,
    bool? isLoginWithEmail, String? countryCode, String? mobile, String? enteredOtp}) {
    return LoginEntity(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoginWithEmail: isLoginWithEmail ?? this.isLoginWithEmail,
      countryCode: countryCode ?? this.countryCode,
      mobile: mobile ?? this.mobile,
      enteredOtp: enteredOtp ?? this.enteredOtp,
    );
  }
}