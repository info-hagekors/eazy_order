
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImage extends StatefulWidget {
  const ProductImage({super.key, required this.imageUrls, this.width = 130, this.height = 130, this.iconSize = 12});

  final List<String> imageUrls;
  final double width;
  final double height;
  final double iconSize;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  int _currentIndex = 0;
  late final List<String> imageUrls = widget.imageUrls;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AppConsts.isWeb ? widget.height : widget.height.h,
          width: AppConsts.isWeb ? widget.width : widget.width.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.isWeb ? 12 : 12.r),
              color: AppColors.screenBgColor
          ),
          child: imageUrls.isNotEmpty ? CarouselSlider.builder(
            carouselController: _carouselController,
            options: CarouselOptions(
              autoPlay: imageUrls.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 5),
              height: AppConsts.isWeb ? widget.height : widget.height.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, itemIndex, pageviewIndex) {
              return ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(AppConsts.isWeb ? 12 : 12.r),
                child: AppConsts.isWeb ? Image.network(imageUrls[itemIndex]) : CachedNetworkImage(
                  imageUrl: imageUrls[itemIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ) : Icon(
            Icons.image_not_supported,
            size: AppConsts.isWeb ? widget.iconSize : widget.iconSize.h,
            color: AppColors.borderColor,
          ),
        ),
        if (imageUrls.length > 1) ... [
          Positioned(
            right: 5,
            top: 2,
            child: AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: imageUrls.length,
              effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.primaryButtonColor,
                  spacing: AppConsts.isWeb ? 2 : 2.r,
                  dotColor: AppColors.heading
              ),
              onDotClicked: (index) {
                _carouselController.animateToPage(index);
              },
            ),
          )
        ]
      ],
    );
  }
}
