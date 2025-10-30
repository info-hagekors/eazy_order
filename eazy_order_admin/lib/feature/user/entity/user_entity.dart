
import 'package:core/core.dart';

class UserEntity {
  final List<UserModel> usersList;
  final bool isLoading;

  UserEntity({
    this.usersList = const [],
    this.isLoading = false,
  });

  UserEntity copyWith({ List<UserModel>? usersList, bool? isLoading}) {
    return UserEntity(
      usersList: usersList ?? this.usersList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}