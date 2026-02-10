import 'package:core/config/app_colors.dart';
import 'package:core/core.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/CurvedAppBar.dart';
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

    Future.microtask(() {                                   //here we can not use the async and await in initstate so here use the Future.microtask...
      final homeState = ref.read(homeControllerProvider);
      final businessId = homeState.currentUser.businessId;
      ref.read(orderListControllerProvider.notifier).getorder(businessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderListControllerProvider);
    final orders = orderState.orderlist;            // because OrderModel passed in orderlist in OrderEntity, so here this store in orders variable.....

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : orders.isEmpty
          ? _emptyOrders()
          : Column(
        children: [
          CurvedAppBar(
            title: 'My Orders',
          ),
          Padding(padding: EdgeInsets.only(left: 18.w,right: 18.h),
          child: _ordertabs()
          ),
          SizedBox(height: 12.h,),
          Divider(color: AppColors.black12),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal:16.w, vertical: 12.h),
              itemCount: orders.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _orderCard(order);
              },
            ),
          ),
        ],
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
    final controller = ref.read(orderListControllerProvider.notifier);
    return Card(
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
                _statusChip(order.orderStatus),
              ],
            ),
            SizedBox(height: 15.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem('Txn ID', '#${order.orderInvoiceNumber}'),
                _infoItem('Order Date', controller.formatDate(DateTime.parse(order.createdAt))),  // format date
                _infoItem('Amount', '₹${order.orderTotal}'),
              ],
            ),
            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              ],
            ),
            SizedBox(height: 5.h),
            Divider(color: AppColors.grey300),
            SizedBox(height: 8.h),

            Row(
              children: [
                Expanded(
                  child: _outlineButton(
                    text: 'Details',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder:(context)=>  OrderDetailsScreen(orderId: order.orderId)
                        )
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _primaryButton(
                    text: 'Re-Order',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
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
  Widget _outlineButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black26),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
  Widget _infoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: AppColors.grey600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _tabItem({
    required String title,
    required int index
  })
  {
     final selecttabs = ref.watch(orderListControllerProvider).selectedTab;

      return GestureDetector(
        onTap: () {
          ref.read(orderListControllerProvider.notifier).selectedtab(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.only(left: 4,right: 4,top: 6,bottom: 6),
          decoration: BoxDecoration(
            border: Border.all(color: selecttabs == index ? AppColors.grey600 : AppColors.black26),
            color: selecttabs == index ? AppColors.primaryColor : AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: selecttabs == index
                ? [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : [],
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: selecttabs == index ? AppColors.white : Colors.grey,
            ),
          ),
        ),
      );
  }
  Widget _ordertabs(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _tabItem(title: ' Completed  ', index: 0),
          SizedBox(width: 10.w),
          _tabItem(title: ' Cancelled ', index: 1),
          SizedBox(width: 10.w),
          _tabItem(title: ' Pending ', index: 2),
          SizedBox(width: 10.w),
          _tabItem(title: ' Preparing ', index: 3),
          SizedBox(width: 10.w),
          _tabItem(title: ' Ready ', index: 4)
        ],
      ),
    );
  }
}
