
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/core/services/firebase_notification_service.dart';
import 'package:eazy_order_go/core/services/firebase_storage_service.dart';
import 'package:eazy_order_go/feature/business/entities/business_setup_entity.dart';
import 'package:eazy_order_go/feature/business/repository/business_setup_repository.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'business_setup_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class BusinessSetupController extends _$BusinessSetupController {

  @override
  BusinessSetupEntity build() {
    ref.keepAlive();
    return BusinessSetupEntity(
      selectedOrderPrefs: AppConsts.orderPreference,
      selectedPaymentOptions: AppConsts.paymentOptions,
    );
  }

  void onNameChanges(String val) {
    state = state.copyWith(name: val.trim());
    onValidate();
  }

  void onAddressChanged(String val) {
    state = state.copyWith(address: val.trim());
  }

  void onValidate() {
    state = state.copyWith(isValid: state.name.length > 2 && state.selectedPaymentOptions.isNotEmpty && state.selectedOrderPrefs.isNotEmpty);
  }

  void onOrderPreferenceChanged(String val) {
    if (state.selectedOrderPrefs.contains(val)) {
      state = state.copyWith(selectedOrderPrefs: state.selectedOrderPrefs.where((element) => element != val).toList());
    } else {
      state = state.copyWith(selectedOrderPrefs: [...state.selectedOrderPrefs, val]);
    }
    onValidate();
  }

  void onPaymentOptionChanged(String val) {
    if (state.selectedPaymentOptions.contains(val)) {
      state = state.copyWith(selectedPaymentOptions: state.selectedPaymentOptions.where((element) => element != val).toList());
    } else {
      state = state.copyWith(selectedPaymentOptions: [...state.selectedPaymentOptions, val]);
    }
    onValidate();
  }

  void selectImage() async {
    final image = await ref.read(firebaseStorageServiceProvider).pickImageFromGallery();
    state = state.copyWith(
      selectedImage: image,
    );
  }

  void saveBusiness(String mobile) async {
    state = state.copyWith(isLoading: true, mobile: mobile);
    String uploadedUrl = '';
    if (state.selectedImage != null) {
      uploadedUrl = await ref.read(firebaseStorageServiceProvider).uploadBusinessImage(
          state.selectedImage!, state.mobile) ?? '';
    }

    final businessRepo = ref.read(businessSetupRepositoryProvider);
    BusinessModel business = BusinessModel(
      logo: uploadedUrl,
      name: state.name,
      address: state.address,
      businessId: _generateRequestId(),
      mobile: state.mobile,
      isSetupCompleted: true,
      token: FirebaseNotificationService.token,
      orderPreference: state.selectedOrderPrefs,
      paymentOptions: state.selectedPaymentOptions,
    );
    await businessRepo.addNewBusiness(business);
    state = state.copyWith(isLoading: false);
    ref.read(goRouterProvider).go(HomeScreen.routeName);
  }

  String _generateRequestId() {
    return const Uuid().v4();
  }
}
