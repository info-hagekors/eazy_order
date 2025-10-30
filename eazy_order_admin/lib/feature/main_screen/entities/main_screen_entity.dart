
import 'package:core/core.dart';
import 'package:image_picker/image_picker.dart';

class MainScreenEntity {
  final BusinessModel? business;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailed;

  MainScreenEntity({
    this.business,
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailed = false,
  });

  MainScreenEntity copyWith({ BusinessModel? business, bool? isLoading, bool? isSuccess, bool? isFailed}) {
    return MainScreenEntity(
      business: business ?? this.business,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}