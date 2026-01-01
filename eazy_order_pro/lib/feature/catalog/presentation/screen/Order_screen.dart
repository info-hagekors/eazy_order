import 'package:core/config/app_colors.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        title: const Text('My Orders',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator(),
      ) :
      orders.isEmpty
          ? _emptyOrders()
          : ListView.separated(
        padding: EdgeInsets.all(16.w),
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
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
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
                  'Order #${order.orderId}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              _statusChip(order.orderStatus),
            ],
          ),

          SizedBox(height: 8.h),

          /// ITEMS COUNT
          Text(
            '${order.items.length} items',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.grey600,
            ),
          ),

          SizedBox(height: 8.h),

          /// TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
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
    );
  }

  /// 🔹 STATUS CHIP
  Widget _statusChip(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.isEmpty ? 'Pending' : status,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
