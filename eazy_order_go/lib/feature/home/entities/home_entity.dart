
import 'package:core/core.dart';

class HomeEntity {
  final BusinessModel? businessModel;
  final bool isLoading;
  final int selectedIndex;

  HomeEntity({
    this.businessModel,
    this.isLoading = false,
    this.selectedIndex = 0,
  });

  HomeEntity copyWith({BusinessModel? businessModel, bool? isLoading, int? selectedIndex}) {
    return HomeEntity(
      businessModel: businessModel ?? this.businessModel,
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}