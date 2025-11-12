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
  const AddProductDialog({
    super.key,
    required this.businessId,
    required this.categoryId,
  });

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

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgColor2.withOpacity(0.9),
              AppColors.imageBgColor.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🧩 Header Row with Title (left) + Cancel (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Product',
                    style: GoogleFonts.nunito(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: AppColors.primaryColor, size: 26.sp),
                    onPressed: () => ref.read(goRouterProvider).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // 🖼 Image Section
              _imageWidget(state.images),

              SizedBox(height: 20.h),

              // 🧾 Input Fields
              CommonTextField(
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    // Capitalize the first letter and keep rest as typed
                    final capitalized =
                        val[0].toUpperCase() + val.substring(1);
                    controller.onNameChanges(capitalized);
                  } else {
                    controller.onNameChanges('');
                  }
                },
                hintText: 'Product Name',
              ),

              SizedBox(height: 14.h),
              CommonTextField(
                onChanged: (val) => controller.onPriceChanges(val),
                hintText: 'Price',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 14.h),
              SizedBox(
                height: 150.h,
                child: CommonTextField(
                  onChanged: (val) => controller.onDescChanges(val),
                  hintText: 'Description (Optional)',
                  maxLines: 10,
                ),
              ),

              SizedBox(height: 28.h),

              // 🔘 Centered Save Button
              Center(
                child: AppButton(
                  text: 'Save',
                  height: 45.h,
                  width: 180.w,
                  isLoading: state.isLoading,
                  onPressed: state.isValid
                      ? () async {
                    await controller.saveProduct(
                      widget.businessId,
                      widget.categoryId,
                    );
                    ref.read(goRouterProvider).pop(true);
                  }
                      : null,
                  color: AppColors.primaryColor,
                  borderRadius: 14.r,
                  textStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🖼 Image Picker + Carousel Widget
  Widget _imageWidget(List<XFile> images) {
    const size = 190;

    return Column(
      children: [
        Container(
          height: size.h,
          width: size.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFFEEF2FF),
                Color(0xFFF3F4F6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: images.isNotEmpty
              ? ClipOval(
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                autoPlay: images.length > 1,
                autoPlayInterval: Duration(seconds: 4),
                height: size.h,
                viewportFraction: 1,
                onPageChanged: (index, _) {
                  setState(() => _currentIndex = index);
                },
                            ),
                  itemCount: images.length,
                  itemBuilder: (context, itemIndex, _) {
                return Image.file(
                  File(images[itemIndex].path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  );
                 },
                ),
              )
              : Center(
            child: IconButton(
              onPressed: () {
                ref.read(productControllerProvider.notifier).pickImages();
              },
              icon: Icon(Icons.add_a_photo_rounded,
                  size: 42.h,
                  color: AppColors.primaryColor
              ),
            ),
          ),
        ),

        // 🔘 Indicator
        if (images.length > 1) ...[
          SizedBox(height: 10.h),
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: images.length,
            effect: WormEffect(
              dotHeight: 8.h,
              dotWidth: 8.w,
              activeDotColor: AppColors.primaryColor,
              dotColor: AppColors.borderColor,
            ),
          ),
        ],

        // ➕ Add more images
        if (images.isNotEmpty) ...[
          SizedBox(height: 12.h),
          AppButton(
            text: '+ Add More',
            onPressed: () {
              ref.read(productControllerProvider.notifier).pickImages();
            },
            color: AppColors.primaryColor.withOpacity(0.85),
            width: 140.w,
            height: 44.h,
            borderRadius: 14.r,
            textStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}
