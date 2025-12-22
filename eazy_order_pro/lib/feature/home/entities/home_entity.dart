
import 'package:core/models/user_model.dart';

class HomeEntity {
  final bool isLoading;
  final int selectedPage;
  final UserModel currentUser;

  HomeEntity({
    this.isLoading = false,
    this.selectedPage = 0,
    required this.currentUser
  });

  HomeEntity copyWith({bool? isLoading, int? selectedPage, UserModel? currentUser}) {
    return HomeEntity(
      isLoading: isLoading ?? this.isLoading,
      selectedPage: selectedPage ?? this.selectedPage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}