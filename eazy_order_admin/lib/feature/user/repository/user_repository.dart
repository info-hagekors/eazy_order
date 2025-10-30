
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
}

// Repository provider
final userRepositoryProvider = Provider((ref) => UserRepository(ref.read(authServiceProvider)));
