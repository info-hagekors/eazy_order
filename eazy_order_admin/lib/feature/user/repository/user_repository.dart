
import 'package:core/core.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class UserRepository {

  final AuthService _authService;

  UserRepository(this._authService);

  Future<List<UserModel>> getAllUsersList(String businessId) async {
    final result = await _authService.fetchUserByBusiness(businessId);
    return result;
  }

  Future createUser(UserModel user, String businessId) async {
    final result = await _authService.createUser(model: user);
    UserModel data = UserModel(
      uid: result.uid,
      name: user.name,
      email: user.email,
      isEmailVerified: false,
      mobile: user.mobile,
      isMobileVerified: false,
      role: user.role,
      businessId: businessId,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );
    await _authService.saveUserDetailsToFirestore(data);
    //ToDo::::Send Password Reset Link to email (result.resetLink)
    return result;
  }
}

// Repository provider
final userRepositoryProvider = Provider((ref) => UserRepository(ref.read(authServiceProvider)));
