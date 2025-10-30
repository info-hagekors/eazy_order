
import 'dart:io';

import 'package:core/core.dart';
import 'package:eazy_order_admin/feature/auth/presentation/widgets/common_card.dart';
import 'package:eazy_order_admin/feature/business/applications/add_business_controller.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddBusinessScreen extends ConsumerStatefulWidget {
  const AddBusinessScreen({super.key});

  static const String routeName = '/add_business';

  @override
  ConsumerState<AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends ConsumerState<AddBusinessScreen> {

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive.isDesktop(context) ? Center(
          child: contentDesktopWidget(),
        ) : contentMobileWidget()
    );
  }

  Widget contentDesktopWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonCard(
          //width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          'Eazy Order',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text('Setup Your Business',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: 350,
                          child: SvgPicture.asset('assets/icons/main.svg', semanticsLabel: ''),
                        )
                      ],
                    )),
                const VerticalDivider(
                  width: 1,
                  color: AppColors.white,
                ),
                Expanded(
                  flex: 2,
                  child: _addBusinessFormWidget(),
                )
              ]),
        )
      ],
    );
  }

  Widget _addBusinessFormWidget() {
    final double imageSize = 120;
    final state = ref.watch(addBusinessControllerProvider);
    final controller = ref.read(addBusinessControllerProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: state.selectedImage != null
                      ? Image.file(
                      //state.selectedImage!,
                      File(''),
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover
                  ) : Container(
                    width: imageSize,
                    height: imageSize,
                    color: AppColors.bgColor,
                    child: Icon(Icons.store, size: (imageSize/2), color: AppColors.white),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => controller.selectImage(),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.edit, size: 16, color: AppColors.white),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            CommonTextField(
              width: double.infinity,
              onChanged: controller.onNameChanges,
              hintText: 'Business Name*',
              backgroundColor: AppColors.white,
            ),
            SizedBox(height: 16),
            CommonTextField(
              width: double.infinity,
              onChanged: (val) {},
              hintText: 'Email Address*',
              controller: _emailController,
              enabled: false,
              backgroundColor: AppColors.background2,
            ),
            SizedBox(height: 16),
            CommonTextField(
              width: double.infinity,
              onChanged: (val) {},
              hintText: 'Mobile Number*',
              controller: _mobileController,
              enabled: false,
              backgroundColor: AppColors.background2,
            ),
            SizedBox(height: 16),
            CommonTextField(
              width: double.infinity,
              onChanged: controller.onRegistrationNoChanged,
              hintText: 'Registration No.',
              backgroundColor: AppColors.white,
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: CommonTextField(
                width: double.infinity,
                onChanged: controller.onAddressChanged,
                hintText: 'Address (Optional)',
                maxLines: 4,
                backgroundColor: AppColors.white,
              ),
            ),
            SizedBox(height: 16),
            AppButton(
              text: 'Save',
              isLoading: state.isLoading,
              onPressed: state.isValid ? () {
                controller.saveBusiness();
              } : null,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget contentMobileWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: _addBusinessFormWidget()
    );
  }

  void getCurrentUser() async {
    await ref.read(addBusinessControllerProvider.notifier).getCurrentUser();
    final state = ref.read(addBusinessControllerProvider);
    _mobileController.text = state.user?.mobile ?? '';
    _emailController.text = state.user?.email ?? '';
  }
}
