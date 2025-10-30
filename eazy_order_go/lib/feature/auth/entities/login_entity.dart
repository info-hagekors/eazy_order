
class LoginEntity {
  final String mobile;
  final String pin;
  final bool isValid;
  final String enteredOtp;
  final bool isLoading;

  LoginEntity({
    this.mobile = '',
    this.isValid = false,
    this.pin = '',
    this.enteredOtp = '',
    this.isLoading = false,
  });

  LoginEntity copyWith({String? mobile, bool? isValid, String? pin, String? enteredOtp, bool? isLoading}) {
    return LoginEntity(
      mobile: mobile ?? this.mobile,
      isValid: isValid ?? this.isValid,
      pin: pin ?? this.pin,
      enteredOtp: enteredOtp ?? this.enteredOtp,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}