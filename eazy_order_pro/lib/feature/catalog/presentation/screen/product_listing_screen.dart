import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  const ProductListingScreen({super.key});

  static const String routeName = '/product_listing';

  @override
  ConsumerState<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  // TEMP dummy data (replace with API later)
  final List<String> categories = [
    'Tea',
    'Coffee',
    'Snacks',
    'Desserts',
    'Drinks',
    'brunch'
        'lunch dish'
        'dinner dish',
  ];
  bool _showBottomBar = false;
  final Map<String, int> _cart = {};

  int get totalItems => _cart.values.fold(0, (sum, qty) => sum + qty);

  int get totalPrice => _cart.values.fold(0, (sum, qty) => sum + (qty * 100));

  final List<String> products = List.generate(10, (i) => 'Product ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Products", style: TextStyle(color: AppColors.black)),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 CATEGORY LIST (HORIZONTAL)
            SizedBox(
              height: 130.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  return _categoryItem(categories[index]);
                },
              ),
            ),

            SizedBox(height: 24.h),

            /// 🔹 PRODUCT LIST (VERTICAL)
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return _productItem(products[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          _cart.isNotEmpty
              ? Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$totalItems Items | ₹$totalPrice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'View Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }

  /// 🔹 CATEGORY ITEM (SQUARE)
  Widget _categoryItem(String title) {
    return Container(
      width: 125.w,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 75.h,
            width: 75.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset("assets/images/burger.png"),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  /// 🔹 PRODUCT ITEM (RECTANGLE)
  Widget _productItem(String title) {
    final quantity = _cart[title] ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
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
                SizedBox(height: 6.h),
                Text(
                  '₹100/-',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7A4A1D),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Plain dosa in oil',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey600),
                ),
              ],
            ),
          ),

          /// RIGHT IMAGE + CONTROLS
          Column(
            children: [
              Container(
                height: 90.h,
                width: 90.h,
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset("assets/images/dish.png"),
              ),
              SizedBox(height: 8.h),

              /// ➕➖ OR ADD
              quantity == 0
                  ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _cart[title] = 1;
                      });
                    },
                    child: _addButton(),
                  )
                  : _quantitySelector(title, quantity),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector(String title, int quantity) {
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
              setState(() {
                if (quantity == 1) {
                  _cart.remove(title);
                } else {
                  _cart[title] = quantity - 1;
                }
              });
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
              setState(() {
                _cart[title] = quantity + 1;
              });
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
        width: 80.w,
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
