
import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/auth/entity/signin_entity.dart';
import 'package:eazy_order_admin/feature/auth/entity/signup_entity.dart';
import 'package:eazy_order_admin/feature/auth/repository/signin_repository.dart';
import 'package:eazy_order_admin/feature/auth/repository/signup_repository.dart';
import 'package:eazy_order_admin/feature/business/presentations/screens/add_business_screen.dart';
import 'package:eazy_order_admin/feature/main_screen/applications/main_screen_controller.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:eazy_order_admin/feature/user/entity/user_entity.dart';
import 'package:eazy_order_admin/feature/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class UserController extends _$UserController {

  @override
  UserEntity build() {
    ref.keepAlive();
    return UserEntity();
  }

  void getUserData() async {
    await Future.delayed(Duration(milliseconds: 50));
    state = state.copyWith(
      isLoading: true,
    );
    final businessId = ref.read(mainScreenControllerProvider.notifier).businessId;
    final listData = await ref.read(userRepositoryProvider).getAllUsersList(businessId);
    state = state.copyWith(
      usersList: listData,
      isLoading: false,
    );
  }
}
