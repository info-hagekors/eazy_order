
class SigninEntity {
  final String email;
  final String password;
  final bool isValid;
  final bool isLoading;

  SigninEntity({
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.isLoading = false,
  });

  SigninEntity copyWith({ String? email, String? password, bool? isValid, bool? isLoading}) {
    return SigninEntity(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}