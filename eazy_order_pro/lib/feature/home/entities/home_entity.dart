
class HomeEntity {
  final bool isLoading;
  final int selectedPage;

  HomeEntity({
    this.isLoading = false,
    this.selectedPage = 0,
  });

  HomeEntity copyWith({bool? isLoading, int? selectedPage}) {
    return HomeEntity(
      isLoading: isLoading ?? this.isLoading,
      selectedPage: selectedPage ?? this.selectedPage,
    );
  }
}