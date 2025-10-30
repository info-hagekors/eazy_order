
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/home/applications/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key, required this.businessId, required this.categoryId});

  final String businessId;
  final String categoryId;

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);
    final controller = ref.read(productControllerProvider.notifier);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.h),
              _imageWidget(state.images),
              SizedBox(height: 12.h,),
              CommonTextField(
                onChanged: (val) => controller.onNameChanges(val),
                hintText: 'Product Name',
              ),
              SizedBox(height: 12.h,),
              CommonTextField(
                onChanged: (val) => controller.onPriceChanges(val),
                hintText: 'Price',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h,),
              SizedBox(
                height: 150.h,
                child: CommonTextField(
                  onChanged: (val) => controller.onDescChanges(val),
                  hintText: 'Description (Optional)',
                  maxLines: 10,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      onPressed: () => ref.read(goRouterProvider).pop(),
                      color: AppColors.white.withAlpha(205),
                      height: 45.h,
                      borderRadius: 12.r,
                      textStyle: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w,),
                  Expanded(
                    child: AppButton(
                      text: 'Save',
                      height: 45.h,
                      isLoading: state.isLoading,
                      onPressed: state.isValid ? () async {
                        await controller.saveProduct(widget.businessId, widget.categoryId);
                        ref.read(goRouterProvider).pop(true);
                      } : null,
                      color: AppColors.primaryColor,
                      borderRadius: 12.r,
                      textStyle: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageWidget(List<XFile> images) {
    const size = 200;
    return Column(
      children: [
        Container(
          height: size.h,
          width: size.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.screenBgColor
          ),
          child: images.isNotEmpty ? CarouselSlider.builder(
            carouselController: _carouselController,
            options: CarouselOptions(
              autoPlay: images.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 5),
              height: size.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              aspectRatio: 0.8,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemCount: images.length,
            itemBuilder: (context, itemIndex, pageviewIndex) {
              return ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  File(images[itemIndex].path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ) : IconButton(
            onPressed: () {
              ref.read(productControllerProvider.notifier).pickImages();
            },
            icon: Icon(Icons.add, size: 48.h,),
          ),
        ),
        if (images.length > 1) ... [
          SizedBox(height: 12.h),
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: images.length,
            effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primaryButtonColor,
                spacing: 2.r,
                dotColor: AppColors.heading
            ),
            onDotClicked: (index) {
              _carouselController.animateToPage(index);
            },
          )
        ],
        SizedBox(height: 12.h),
        if (images.isNotEmpty) ... [
          AppButton(
            text: '+ Add More',
            onPressed: () {
              ref.read(productControllerProvider.notifier).pickImages();
            },
            color: AppColors.primaryColor.withAlpha(128),
            width: 120.w,
            height: 30.h,
            borderRadius: 12.r,
            textStyle: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white
            ),
          ),
          SizedBox(height: 12.h,),
        ],
      ],
    );
  }
}
