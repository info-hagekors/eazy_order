import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:core/models/category_model.dart';
import 'package:core/models/order_model.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/cart_screen.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  final String? orderId;
  final List<OrderItems> existingItems;
  const ProductListingScreen({super.key, this.orderId, this.existingItems = const []});

  static const String routeName = '/product_listing';

  @override
  ConsumerState<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final homeState = ref.read(homeControllerProvider);
      final businessId = homeState.currentUser.businessId;
      final controller = ref.read(productListingControllerProvider.notifier);

      controller.reset();
      controller.getactivecategory(businessId);
      if (widget.orderId != null && widget.existingItems.isNotEmpty) {
        controller.loadCartFromOrderItems(widget.existingItems);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditOrder = widget.orderId != null;
    ref.listen(productListingControllerProvider, (prev, next) {
      if (prev?.categories.isEmpty == true &&
          next.categories.isNotEmpty &&
          next.selectcategoryId == null) {

        ref.read(productListingControllerProvider.notifier).getactiveproduct(next.categories.first.categoryId!);
      }
    });
    ref.listen(orderListControllerProvider, (prev, next) {
      if (next.isEdit && prev?.items != next.items) {

        ref.read(productListingControllerProvider.notifier).loadCartFromOrderItems(next.items);
      }
    });
    final productState = ref.watch(productListingControllerProvider);
    final controller = ref.read(productListingControllerProvider.notifier);
    final categories = productState.categories;
    final products = productState.products;
    final totalItems = productState.cart.values.fold(0, (sum, qty) => sum + qty);
    final subTotal = productState.cart.entries.fold<double>(0, (sum, entry) {
      final product = productState.allProducts[entry.key];
      if (product == null) return sum;
      return sum + (product.price) * entry.value;
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.white,
            pinned: false,
            floating: true,
            elevation: 0,
            title: Text(
              "Menu",
              style: GoogleFonts.poppins(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectindex(index);

                        final categoryId = categories[index].categoryId!;
                        controller.getactiveproduct(categoryId);
                      },
                      child: _categoryItem(
                        productState.categories[index].categoryName ?? "",
                        isSelected: index == productState.selectindex,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Products :',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: productState.isProductLoading
                ? SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 200.h),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            )
                : products.isEmpty
                ? SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Image.asset(
                      AppImages.noproduct,
                      height: 200.h,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Text("No Products Available !",
                    style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ):SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = products[index];
                  final productId = product.productId;
                  final quantity = productState.cart[productId] ?? 0;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _productItemcard(
                      product,
                      quantity,
                      controller,
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 90.h),
          ),
        ],
      ),
      bottomNavigationBar: productState.cart.isNotEmpty
          ? SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(color: AppColors.black12, blurRadius: 8),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹$subTotal',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      'Total',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 12.w),

                GestureDetector(
                  onTap: () {
                    final productState = ref.read(productListingControllerProvider);

                    final items = productState.cart.entries.map((entry) {
                      final product = productState.allProducts[entry.key];
                      if(product == null){
                        return null;
                      }
                      return OrderItems(
                        orderItemId: product.productId,
                        productName: product.productName,
                        price: product.price,
                        quantity: entry.value,
                        imageUrls: product.imageUrls,
                        description: product.description,
                        categoryName: product.categoryName,
                      );
                    }).whereType<OrderItems>().toList();

                    if (isEditOrder) {
                      Navigator.pop(context, items);
                    } else {
                      ref.read(goRouterProvider).push(CartScreen.routeName);
                    }
                  },
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Text(isEditOrder?'Add item':
                        '$totalItems Items added',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Container(
                          height: 26.h,
                          width: 26.h,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _categoryItem(
      String title, {
        bool isSelected = false,
      }) {
    return Container(
      width: 90.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : AppColors.grey400,
          width: isSelected ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.h,
            width: 50.w,
            child: SvgPicture.asset(
                AppImages.restaurant
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 13.5.sp),
          ),
        ],
      ),
    );
  }

  Widget _productItemcard(
      ProductModel product,
      int quantity,
      ProductListingController controller,
      ){
    final title = product.productName ?? '';
    final price = product.price;
    final productId = product.productId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey400),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  '₹$price/-',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  product.description ?? '',
                  style: GoogleFonts.poppins(fontSize: 15.sp, color: AppColors.grey600),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 110.w,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: 110.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (product.imageUrls != null && product.imageUrls.isNotEmpty)
                            ? CarouselSlider(
                          options: CarouselOptions(
                            height: 90.h,
                            viewportFraction: 1,
                            autoPlay: product.imageUrls.length > 1,
                            enableInfiniteScroll: product.imageUrls.length > 1,
                            autoPlayInterval: const Duration(seconds: 2),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                          items: product.imageUrls.map<Widget>((imgUrl) {
                            return Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                color: AppColors.grey,
                              ),
                            );
                          }).toList(),
                        )
                            : Image.asset(
                          AppImages.dish,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -16.h,
                      child: quantity == 0
                          ? GestureDetector(
                        onTap: () {
                          controller.addItem(productId);
                        },
                        child: _addButton(productId, controller),
                      )
                          : _quantitySelector(productId, quantity, controller),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector(
      String productId,
      int quantity,
      ProductListingController controller,
      ) {
    return Container(
      height: 30.h,
      width: 80.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              controller.removeItem(productId);
            },
            child: const Icon(Icons.remove, color: AppColors.green, size: 17),
          ),
          Text(
            '$quantity',
            style: GoogleFonts.poppins(
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.addItem(productId);
            },
            child: const Icon(Icons.add, color: AppColors.green, size: 17),
          ),
        ],
      ),
    );
  }

  Widget _addButton(
      String productId,
      ProductListingController controller,
      ) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 27.h,
        width: 75.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'ADD',
          style: GoogleFonts.poppins(
            color: AppColors.green,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
