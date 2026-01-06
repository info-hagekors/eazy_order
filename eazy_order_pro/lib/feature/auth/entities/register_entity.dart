
class RegisterEntity {
  final String businessName;
  final String email;
  final String countryCode;
  final String mobile;
  final String gstNo;
  final String password;
  final String confirmPassword;
  final bool isValid;
  final bool isPassVisible;
  final bool isConfirmPassVisible;

  RegisterEntity({
    this.businessName = '',
    this.email = '',
    this.countryCode = '',
    this.mobile = '',
    this.gstNo = '',
    this.password = '',
    this.confirmPassword = '',
    this.isValid = false,
    this.isPassVisible = false,
    this.isConfirmPassVisible = false,
  });

  RegisterEntity copyWith({String? businessName, String? email, String? countryCode, String? mobile,
    String? gstNo, String? password, String? confirmPassword, bool? isValid, bool? isPassVisible,
    bool? isConfirmPassVisible}) {
    return RegisterEntity(
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      mobile: mobile ?? this.mobile,
      gstNo: gstNo ?? this.gstNo,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      isPassVisible: isPassVisible ?? this.isPassVisible,
      isConfirmPassVisible: isConfirmPassVisible ?? this.isConfirmPassVisible,
    );
  }
}