
import 'package:core/core.dart';
import 'package:either_dart/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class SignupRepository {

  final AuthService _authService;

  SignupRepository(this._authService);

  Future<Either<String, UserModel>> userSignup(Map<String, String> userDetails) async {
    final result = await _authService.linkEmailToCurrentUser(userDetails['email'] ?? '', userDetails['password'] ?? '');
    if (result.isLeft) {
      return Left(result.left);
    }
    final signUpData = result.right;
    UserModel user = UserModel(
      uid: signUpData.uid,
      name: userDetails['name'] ?? '',
      email: userDetails['email'] ?? '',
      isEmailVerified: true,
      mobile: userDetails['mobile'] ?? '',
      isMobileVerified: true,
      role: 'admin',
      businessId: '',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );
    await _authService.saveUserDetailsToFirestore(user);
    return Right(user);
  }

  void sendPhoneOtp(String mobile, Function(String)? onCodeSent) {
    _authService.sendPhoneOtp(mobile, onCodeSent: (verificationId) {
      onCodeSent?.call(verificationId);
    });
  }

  Future<Either<String, UserModel>> loginWithPhone(String verificationId, String otp) async {
    final result = await _authService.loginWithPhone(verificationId, otp);
    return result;
  }

  Future<Either<String, bool>> isUserExists(String email, String mobile) async {
    final result = await _authService.isUserExists(email, mobile);
    return result;
  }
}

// Auth Repository provider
final signupRepositoryProvider = Provider((ref) => SignupRepository(ref.read(authServiceProvider)));
