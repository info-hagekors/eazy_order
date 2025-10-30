
import 'package:image_picker/image_picker.dart';

class BusinessSetupEntity {
  final String logo;
  final String name;
  final String mobile;
  final String address;
  final bool isValid;
  final XFile? selectedImage;
  final bool isLoading;
  final List<String> selectedOrderPrefs;
  final List<String> selectedPaymentOptions;

  BusinessSetupEntity({
    this.logo = '',
    this.name = '',
    this.mobile = '',
    this.address = '',
    this.isValid = false,
    this.selectedImage,
    this.isLoading = false,
    this.selectedOrderPrefs = const [],
    this.selectedPaymentOptions = const [],
  });

  BusinessSetupEntity copyWith({String? logo, String? name, String? mobile, String? address,
    bool? isValid, XFile? selectedImage, bool? isLoading, List<String>? selectedOrderPrefs,
    List<String>? selectedPaymentOptions}) {
    return BusinessSetupEntity(
      logo: logo ?? this.logo,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      isValid: isValid ?? this.isValid,
      selectedImage: selectedImage ?? this.selectedImage,
      isLoading: isLoading ?? this.isLoading,
      selectedOrderPrefs: selectedOrderPrefs ?? this.selectedOrderPrefs,
      selectedPaymentOptions: selectedPaymentOptions ?? this.selectedPaymentOptions,
    );
  }
}