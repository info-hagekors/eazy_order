import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String? orderId;

  static const String routeName = '/order-details';

  const OrderDetailsScreen({super.key, this.orderId});
  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}
class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderListControllerProvider);
    final order = orderState.orderlist.firstWhere(
      (o) => o.orderId == widget.orderId,
    );
    if (order == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 22.sp,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          "order details",
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: AppColors.white,
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey600.withAlpha(40),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.primaryColor,
                                        size: 20.sp,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        'Customer Info :',
                                        style: GoogleFonts.poppins(
                                          fontSize: 17.sp,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.red.withAlpha(40),
                                        border: Border.all(
                                          color: AppColors.grey600,
                                        ),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          'INV: #${order.orderInvoiceNumber}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 5.h),

                              Text(
                                "👤   ${order.orderUserName}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5.h),

                              Text(
                                "📞   +91 ${order.orderMobileNumber}",
                                style: GoogleFonts.poppins(fontSize: 16.sp),
                              ),
                              SizedBox(height: 10.h),

                              Text(
                                "⏰   ${order.createdAt}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: AppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: AppColors.white,
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              if (order.orderPreference.toLowerCase() == 'dine_in') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.grey600,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Table no : ${order.tableNumber}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                              ],

                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.grey600),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    order.orderPreference,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    _itemDetailsCard(order),

                    SizedBox(height: 8.h),

                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: AppColors.white,
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey600.withAlpha(40),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Icon(
                                        Icons.payment,
                                        size: 20.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Payment Details :',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryColor,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 5.h),

                              _paymentCard('Order Status', order.orderStatus),
                              _paymentCard(
                                'Payment option',
                                order.paymentOption,
                              ),
                              _paymentCard(
                                'Payment Status',
                                order.paymentStatus,
                              ),
                              _paymentCard('Payment Type', order.paymentType),
                              _paymentCard(
                                'Payment Signature',
                                order.paymentSignature,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: AppColors.white,
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount :',
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₹ ${order.orderTotal.toStringAsFixed(0)} /-',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDetailsCard(order) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.grey600.withAlpha(40),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Icon(
                      Icons.menu_book_sharp,
                      size: 20.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Order Summary :',
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),


            ...List.generate(order.items.length, (index) {
              final item = order.items[index];

              return Card(
                color: AppColors.white,
                elevation: 2,
                margin: EdgeInsets.only(bottom: 8.h),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          AppImages.dish,
                          height: 50.w,
                          width: 65.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.productName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "₹${item.price}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            Text(
                              "Qty : ${item.quantity}",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
