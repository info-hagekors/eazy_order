
import 'package:core/core.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class SignInRepository {

  final AuthService _authService;

  SignInRepository(this._authService);

  Future<Either<String, UserModel>> userLogin(String email, String password) async {
    final result = await _authService.loginWithEmail(email, password);
    if (result.isLeft) {
      return Left(result.left);
    }
    final loginData = result.right;
    final user = await _authService.getUser(loginData.uid);
    debugPrint(user.toMap().toString());
    if (user.uid.isEmpty) {
      return Left('User not found.!');
    }
    return Right(user);
  }
}

// Repository provider
final signInRepositoryProvider = Provider((ref) => SignInRepository(ref.read(authServiceProvider)));
