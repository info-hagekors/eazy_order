import 'package:core/config/app_colors.dart';
import 'package:core/core.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/edit_order_screen.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title:  Text('My Orders',
          style: GoogleFonts.poppins(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600
          ),
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
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Place your first order to see it here',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(
            builder:(context)=>  OrderDetailsScreen(orderId: order.orderId)
          )
        );
      },
      child: Card(
        color: AppColors.white,
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${order.orderUserName}',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _statusChip(order.orderStatus),

                  SizedBox(width: 10.w),

                  Icon(Icons.arrow_forward_ios,color: AppColors.black,size: 15.sp),
                ],
              ),
              SizedBox(height: 5.h),

              Row(
                children: [
                  Text('# ${order.orderInvoiceNumber} / ${order.orderPreference}')
                ],
              ),
              SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🛍️  ${order.items.length} items',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context)=> EditOrderScreen(orderId: order.orderId))
                       );
                      },
                    child: Container(
                        decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey600),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("✏️  Edit order",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Divider(color: AppColors.grey400),
              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                  Text(
                    '₹${order.orderTotal.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final normalized = status.toLowerCase();

    Color color;
    IconData icon;

    switch (normalized) {
      case 'completed':
        color = AppColors.complete;
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        color = AppColors.cancel;
        icon = Icons.cancel_outlined;
        break;
      case 'preparing':
        color = AppColors.confirm;
        icon = Icons.query_builder;
        break;
      case 'ready':
        color = AppColors.confirm;
        icon = Icons.next_plan_rounded;
        break;

      default:
        color = AppColors.placed;
        icon = Icons.place_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon,size: 14.sp,color: color),
          SizedBox(width: 4.w),
          Text(
            status.isNotEmpty ? 'placed' : status,
            style: GoogleFonts.poppins(
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
