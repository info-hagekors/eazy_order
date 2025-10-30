
import 'package:core/core.dart';
import 'package:image_picker/image_picker.dart';

class AddBusinessEntity {
  final String name;
  final String address;
  final String mobile;
  final String email;
  final String registrationNo;
  final bool isLoading;
  final XFile? selectedImage;
  final bool isValid;
  final UserModel? user;

  AddBusinessEntity({
    this.name = '',
    this.address = '',
    this.mobile = '',
    this.email = '',
    this.registrationNo = '',
    this.isLoading = false,
    this.selectedImage,
    this.isValid = false,
    this.user,
  });

  AddBusinessEntity copyWith({ String? name, String? address, String? mobile, String? email, String? registrationNo,
    bool? isLoading, XFile? selectedImage, bool? isValid, UserModel? user}) {
    return AddBusinessEntity(
      name: name ?? this.name,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      registrationNo: registrationNo ?? this.registrationNo,
      isLoading: isLoading ?? this.isLoading,
      selectedImage: selectedImage ?? this.selectedImage,
      isValid: isValid ?? this.isValid,
      user: user ?? this.user,
    );
  }
}