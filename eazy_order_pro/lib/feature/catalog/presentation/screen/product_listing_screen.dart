import 'package:core/config/app_colors.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/cart_screen.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  const ProductListingScreen({super.key});

  static const String routeName = '/product_listing';

  @override
  ConsumerState<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  // TEMP dummy data (replace with API later)
  //final List<String> products = List.generate(10, (i) => 'Grill Sandwich ${i + 1}');

  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();

    final homeState = ref.read(homeControllerProvider);
    final businessId = homeState.currentUser.businessId;

    final controller = ref.read(productListingControllerProvider.notifier);

    controller.getactivecategory(businessId).then((_) {
      final categories = ref.read(productListingControllerProvider).categories;
      if (categories.isNotEmpty) {
        controller.getactiveproduct(categories.first.categoryId!);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(productListingControllerProvider);
    final controller = ref.read(productListingControllerProvider.notifier);
    final categories = cartState.categories;
    final products = cartState.products;
    final totalItems =
    cartState.cart.values.fold(0, (sum, qty) => sum + qty);
    final totalPrice =
    cartState.cart.entries.fold(0.0, (sum, e) {
      final product = products
          .firstWhere((p) => p.productId == e.key);
      return sum + (product.price ?? 0) * e.value;
    });



    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [

          /// 🔹 SLIVER APP BAR
          SliverAppBar(
            backgroundColor: AppColors.white,
            pinned: false,
            floating: true,
            elevation: 0,
            title: const Text(
              "Menu",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// 🔹 CATEGORY LIST
          SliverPadding(
            padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 125.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });

                        final categoryId = categories[index].categoryId!;
                        controller.getactiveproduct(categoryId);
                      },

                      child: _categoryItem(
                        cartState.categories[index].categoryName ?? "",
                        isSelected: index == _selectedCategoryIndex,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          /// 🔹 PRODUCTS TITLE
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Products :',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          /// 🔹 PRODUCT LIST
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: cartState.isProductLoading
                ? SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
             )
                : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        final title = product.productName ?? '';
                        final quantity = cartState.cart[title] ?? 0;

                        return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _productItem(
                        title,
                        quantity,
                        controller,
                      ),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),


          /// 🔹 EXTRA SPACE FOR BOTTOM CART BAR
          SliverToBoxAdapter(
            child: SizedBox(height: 90.h),
          ),
        ],
      ),
      bottomNavigationBar: cartState.cart.isNotEmpty
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 🔹 LEFT : PRICE
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹$totalPrice',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 12.w),

                /// 🔹 RIGHT : BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 70.h,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Text(
                          '$totalItems Items added',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 30,),
                        Container(
                          height: 26.h,
                          width: 26.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          : null,
    );
  }

  /// 🔹 CATEGORY ITEM (SQUARE)
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
              "assets/images/restaurant-plate-svgrepo-com.svg",
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.5.sp),
          ),
        ],
      ),
    );
  }

  /// 🔹 PRODUCT ITEM (RECTANGLE)
  Widget _productItem(
      String title,
      int quantity,
      dynamic controller,
      ){
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
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  '₹100/-',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7A4A1D),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'slices of bread',
                  style: TextStyle(fontSize: 15.sp, color: AppColors.grey600),
                ),
              ],
            ),
          ),

          /// RIGHT IMAGE + OVERLAPPING BUTTON
          SizedBox(
            width: 110.w,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    /// IMAGE
                    SizedBox(
                      height: 90.h,
                      width: 110.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/dish.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// ADD / QUANTITY (HALF IN - HALF OUT)
                    Positioned(
                      bottom: -16.h, // 👈 key line
                      child: quantity == 0
                          ? GestureDetector(
                        onTap: () {
                         controller.addItem(title);
                        },
                        child: _addButton(),
                      )
                          : _quantitySelector(
                          title,
                          quantity,
                        controller,
                      ),
                    ),
                  ],
                ),

                /// SPACE so button is not cut
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector(
      String title,
      int quantity,
      dynamic controller,
      ) {
    return Container(
      height: 32.h,
      width: 90.w,
      decoration: BoxDecoration(
        color: const Color(0xFF7A4A1D),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
                  controller.remove(title);
            },
            child: const Icon(Icons.remove, color: Colors.white, size: 16),
          ),
          Text(
            '$quantity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
                controller.addItem(title);
            },
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 32.h,
        width: 75.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF7A4A1D),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'ADD',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
