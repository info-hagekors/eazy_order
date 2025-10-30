
import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/business/entities/add_business_entity.dart';
import 'package:eazy_order_admin/feature/business/repository/business_repository.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'add_business_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class AddBusinessController extends _$AddBusinessController {

  @override
  AddBusinessEntity build() {
    ref.keepAlive();
    return AddBusinessEntity();
  }

  void onNameChanges(String val) {
    state = state.copyWith(name: val.trim());
    onValidate();
  }

  void onAddressChanged(String val) {
    state = state.copyWith(address: val.trim());
  }

  void onRegistrationNoChanged(String val) {
    state = state.copyWith(registrationNo: val.trim());
  }

  void onValidate() {
    state = state.copyWith(isValid: state.name.length > 2);
  }

  void selectImage() async {
    final image = await ref.read(firebaseStorageServiceProvider).pickImageFromGallery();
    state = state.copyWith(
      selectedImage: image,
    );
  }

  void saveBusiness() async {
    state = state.copyWith(isLoading: true, mobile: state.user?.mobile ?? '');
    String uploadedUrl = '';
    if (state.selectedImage != null) {
      uploadedUrl = await ref.read(firebaseStorageServiceProvider).uploadBusinessImage(
          state.selectedImage!, state.user?.mobile ?? '') ?? '';
    }

    final businessRepo = ref.read(businessRepositoryProvider);
    BusinessModel business = BusinessModel(
      businessId: _generateRequestId(),
      adminId: state.user?.uid ?? '',
      name: state.name,
      mobile: state.user?.mobile ?? '',
      address: state.address,
      registrationNo: state.registrationNo,
      logo: uploadedUrl,
      isSetupCompleted: true,
      token: '',
      orderPreference: [],
      paymentOptions: [],
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    await businessRepo.addNewBusiness(business);
    state = state.copyWith(isLoading: false);
    ref.read(goRouterProvider).go(MainScreen.routeName);
  }

  String _generateRequestId() {
    return const Uuid().v4();
  }

  Future  getCurrentUser() async {
    await Future.delayed(Duration(milliseconds: 50));
    final businessRepo = ref.read(businessRepositoryProvider);
    final user = await businessRepo.getCurrentUser();
    state = state.copyWith(user: user);
  }
}
