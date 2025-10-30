
class SignupEntity {
  final String fullName;
  final String email;
  final String mobile;
  final String otpEmail;
  final String otpPhone;
  final String password;
  final String confirmPass;
  final bool isStep1Validated;
  final bool isStep2Validated;
  final bool isStep3Validated;
  final int currentStep;
  final bool isAgree;
  final bool isLoading1;
  final bool isLoading2;
  final bool isLoading3;
  final String verificationId;

  SignupEntity({
    this.fullName = '',
    this.email = '',
    this.mobile = '',
    this.otpEmail = '',
    this.otpPhone = '',
    this.password = '',
    this.confirmPass = '',
    this.isStep1Validated = false,
    this.isStep2Validated = false,
    this.isStep3Validated = false,
    this.currentStep = 1,
    this.isAgree = false,
    this.isLoading1 = false,
    this.isLoading2 = false,
    this.isLoading3 = false,
    this.verificationId = '',
  });

  SignupEntity copyWith({String? fullName, String? email, String? mobile, String? otpEmail, String? otpPhone, String? password,
    String? confirmPass, bool? isStep1Validated, bool? isStep2Validated, bool? isStep3Validated,
    int? currentStep, bool? isAgree, bool? isLoading1, bool? isLoading2, bool? isLoading3, String? verificationId}) {
    return SignupEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      otpEmail: otpEmail ?? this.otpEmail,
      otpPhone: otpPhone ?? this.otpPhone,
      password: password ?? this.password,
      confirmPass: confirmPass ?? this.confirmPass,
      isStep1Validated: isStep1Validated ?? this.isStep1Validated,
      isStep2Validated: isStep2Validated ?? this.isStep2Validated,
      isStep3Validated: isStep3Validated ?? this.isStep3Validated,
      currentStep: currentStep ?? this.currentStep,
      isAgree: isAgree ?? this.isAgree,
      isLoading1: isLoading1 ?? this.isLoading1,
      isLoading2: isLoading2 ?? this.isLoading2,
      isLoading3: isLoading3 ?? this.isLoading3,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}