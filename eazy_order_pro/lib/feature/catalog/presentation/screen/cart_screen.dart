import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  final Map<String, int> cart;

  const CartScreen({
    super.key,
    required this.cart
  });

  int get totalPrice => cart.values.fold(0, (sum, qty) => sum + (qty * 100));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text("My Cart", style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
      ),
      body:
      cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: cart.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final title = cart.keys.elementAt(index);
          final qty = cart[title]!;

          return Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.grey400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₹${qty * 100}  x$qty',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        color: AppColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₹$totalPrice',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Checkout  ->',style: TextStyle(color: AppColors.white,fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}
