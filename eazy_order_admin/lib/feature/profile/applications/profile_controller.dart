import 'package:eazy_order_admin/feature/profile/entities/profile_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  ProfileEntity build() {
    ref.keepAlive();
    return ProfileEntity();
  }

  void saveprofile({required String username, required String role}) {
    state = state.copyWith(username: username, role: role);
    Fluttertoast.showToast(msg: "profile save successfully");
    debugPrint("profile save successfully");
  }

  void editprofile({String? username, String? role}) {
    state = state.copyWith(username: username, role: role);
    Fluttertoast.showToast(msg: "profile edited");
    debugPrint("profile edited");
  }

  ProfileEntity getprofile() {
    return ProfileEntity();
  }

  void Logoutprofile() {
    state = ProfileEntity();
    Fluttertoast.showToast(msg: "logout successfully");
  }
}
