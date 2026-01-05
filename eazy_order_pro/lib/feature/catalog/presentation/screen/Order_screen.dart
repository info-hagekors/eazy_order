import 'package:core/config/app_colors.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'order_details_screen.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  static const String routeName = '/orderscreen';

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final homeState = ref.read(homeControllerProvider);
      final businessId = homeState.currentUser.businessId;
      ref.read(orderListControllerProvider.notifier).getorder(businessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderListControllerProvider);
    final orders = orderState.orderlist;

    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('My Orders',
          style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : orders.isEmpty
          ? _emptyOrders()
          : ListView.separated(
        padding: EdgeInsets.symmetric(horizontal:16.w, vertical: 12.h),
        itemCount: orders.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _orderCard(order);
        },
      ),
    );
  }

  /// 🔹 EMPTY STATE
  Widget _emptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long,
              size: 80.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Place your first order to see it here',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 ORDER CARD
  Widget _orderCard(order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context)=> const OrderDetailsScreen()));
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow:  [
            BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 10,
            offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${order.orderId}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                _statusChip(order.orderStatus),
              ],
            ),

            SizedBox(height: 10.h),



            /// ITEMS COUNT
            Row(
              children: [
                Icon(Icons.shopping_bag_rounded,
                  size: 18.sp,
                  color: AppColors.grey600),
                SizedBox(width: 6.w),
                Text(
                  '${order.items.length} items',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Divider(color: AppColors.grey300),
            SizedBox(height: 8.h),
            /// TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.grey600,
                  ),
                ),
                Text(
                  '₹${order.orderTotal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 STATUS CHIP
  Widget _statusChip(String status) {
    final normalized = status.toLowerCase();

    Color color;
    IconData icon;

    switch (normalized) {
      case 'completed':
        color = AppColors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        color = AppColors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = AppColors.confirm;
        icon = Icons.pending_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon,size: 14.sp,color: color),
          SizedBox(width: 4.w),
          Text(
            status.isEmpty ? 'Pending' : status,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
