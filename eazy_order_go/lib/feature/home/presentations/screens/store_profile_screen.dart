
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreProfileScreen extends ConsumerStatefulWidget {
  const StoreProfileScreen({super.key});

  @override
  ConsumerState<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends ConsumerState<StoreProfileScreen> {

  final imageSize = 150;
  late final TextEditingController _mobileController = TextEditingController(
    text: ref.read(homeControllerProvider).businessModel?.mobile ?? ''
  );

  late final TextEditingController _nameController = TextEditingController(
      text: ref.read(homeControllerProvider).businessModel?.name ?? ''
  );

  late final TextEditingController _addressController = TextEditingController(
      text: ref.read(homeControllerProvider).businessModel?.address ?? ''
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    return Scaffold(
        backgroundColor: AppColors.screenBgColor,
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBar(
          title: '',
          leading: SizedBox.shrink(),
          backgroundColor: AppColors.screenBgColor,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(28.r),
                              child: (state.businessModel?.logo.isNotEmpty ?? false)
                                  ? CachedNetworkImage(
                                  imageUrl: state.businessModel?.logo ?? '',
                                  width: imageSize.w,
                                  height: imageSize.h,
                                  fit: BoxFit.cover
                              ) : Container(
                                width: imageSize.w,
                                height: imageSize.h,
                                color: AppColors.bgColor,
                                child: Icon(Icons.store, size: (imageSize/2).h, color: AppColors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                //onTap: () => controller.selectImage(),
                                child: CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Icon(Icons.edit, size: 16.h, color: AppColors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 40.h),
                        CommonTextField(
                          onChanged: (val){},
                          hintText: 'Business Name',
                          controller: _nameController,
                          enabled: false,
                        ),
                        SizedBox(height: 16.h),
                        CommonTextField(
                          onChanged: (val) {},
                          hintText: 'Mobile Number',
                          controller: _mobileController,
                          enabled: false,
                          backgroundColor: AppColors.background2,
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 200.h,
                          child: CommonTextField(
                            onChanged: (val){},
                            hintText: 'Address (Optional)',
                            maxLines: 10,
                            controller: _addressController,
                            enabled: false,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _orderPreference(state.businessModel?.orderPreference ?? []),
                        SizedBox(height: 16.h),
                        _paymentOptions(state.businessModel?.paymentOptions ?? []),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              if (false) ... [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AppButton(
                    text: 'Save Changes',
                    onPressed: () {},
                    textStyle: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white
                    ),
                    color: AppColors.primaryButtonColor,
                  ),
                ),
              ] else ... [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AppButton(
                    text: 'Logout',
                    onPressed: () => ref.read(homeControllerProvider.notifier).logout(),
                    textStyle: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white
                    ),
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
              SizedBox(height: AppConsts.bottomPadding,)
            ],
          ),
        )
    );
  }

  Widget _orderPreference(List<String> selectedOpt) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          Row(
            children: [
              Icon(Icons.description_rounded, size: 20.h, color: AppColors.supporting,),
              SizedBox(width: 12.w,),
              Expanded(
                child: Text(
                  'Order Preference',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              SizedBox(width: 12.w,),
            ],
          ),
          SizedBox(height: 8.h,),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: AppConsts.orderPreference.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = AppConsts.orderPreference[index];
              return CheckboxListTile(
                onChanged: (val) {
                  //ref.read(businessSetupControllerProvider.notifier).onOrderPreferenceChanged(item);
                },
                value: selectedOpt.contains(item),
                activeColor: AppColors.primaryColor,
                title: Text(
                  item,
                  style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _paymentOptions(List<String> selectedOpt) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 20.h, color: AppColors.supporting,),
              SizedBox(width: 12.w,),
              Expanded(
                child: Text(
                  'Payment Options',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              SizedBox(width: 12.w,),
            ],
          ),
          SizedBox(height: 8.h,),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: AppConsts.paymentOptions.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = AppConsts.paymentOptions[index];
              return CheckboxListTile(
                onChanged: (val) {

                },
                value: selectedOpt.contains(item),
                activeColor: AppColors.primaryColor,
                title: Text(
                  item,
                  style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
