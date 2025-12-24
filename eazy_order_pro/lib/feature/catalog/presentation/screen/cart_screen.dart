import 'package:core/config/app_colors.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(productListingControllerProvider);
    final cartController = ref.read(productListingControllerProvider.notifier);
    final totalPrice =
    cartState.cart.entries.fold<double>(0, (sum, e) {
      final product = cartState.products
          .where((p) => p.productId == e.key)
          .isNotEmpty
          ? cartState.products.firstWhere((p) => p.productId == e.key)
          : null;

      if (product == null) return sum;
      return sum + (product.price ?? 0) * e.value;
    });


    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// 🔹 BODY
      body: cartState.cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          /// 🔹 CART ITEMS
          _cartItemsCard(
            cartState,
            cartController,
          ),

          SizedBox(height: 16.h),

          /// 🔹 CONTACT CARD
          _contactCard(),

          SizedBox(height: 10.h),

          Text(
            'Please enter your WhatsApp number to receive order updates.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.grey600,
            ),
          ),

          SizedBox(height: 16.h),

          _simpleTile(Icons.receipt_long, 'Order Preference'),
          SizedBox(height: 12.h),
          _simpleTile(Icons.payment, 'Payment Options'),

          SizedBox(height: 12.h),

          /// 🔹 GRAND TOTAL
          _grandTotalCard(totalPrice),

          SizedBox(height: 100.h),
        ],
      ),

      /// 🔹 BOTTOM BAR
      bottomNavigationBar: cartState.cart.isEmpty
          ? null
          : Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            /// TOTAL
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹$totalPrice',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Grand Total',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),

            SizedBox(width: 16.w),

            /// PAY NOW
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4A2D),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 CART ITEMS CARD
  Widget _cartItemsCard(
      dynamic cartState,
      dynamic controller,
      ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          ...cartState.cart.entries.map((e) {
            final product = cartState.products
                .where((p) => p.productId == e.key)
                .isNotEmpty
                ? cartState.products.firstWhere((p) => p.productId == e.key)
                : null;

            if (product == null) return const SizedBox();
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  /// IMAGE
                  Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.restaurant),
                  ),

                  SizedBox(width: 12.w),

                  /// NAME & PRICE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '₹${product.price ?? 0}/-',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// QTY BUTTON
                  _qtyButton(
                    product.productId!,
                    e.value,
                    controller,
                  ),
                ],
              ),
            );
          }),

          const Divider(),

          /// ADD MORE ITEMS
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Text(
                  '+  Add more items',
                  style: TextStyle(
                    color: const Color(0xFF6B4A2D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 QTY BUTTON
  Widget _qtyButton(
      String title,
      int qty,
      dynamic controller,
      ) {
    return Container(
      height: 28.h,
      width: 80.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => controller.removeItem(title),
            child: const Icon(Icons.remove,
                size: 16, color: Colors.white),
          ),
          Text(
            '$qty',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          GestureDetector(
            onTap: () => controller.addItem(title),
            child: const Icon(Icons.add,
                size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// 🔹 CONTACT CARD
  Widget _contactCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.call),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Divy Patel',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '+91 8755088550',
                  style: TextStyle(color: AppColors.grey600),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  /// 🔹 SIMPLE TILE
  Widget _simpleTile(IconData icon, String title) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(fontSize: 15.sp),
          ),
        ],
      ),
    );
  }

  /// 🔹 GRAND TOTAL CARD
  Widget _grandTotalCard(double totalPrice) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Grand Total',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '₹${totalPrice.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
