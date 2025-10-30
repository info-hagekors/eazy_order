
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:eazy_order_web/feature/home/applications/order_detail_controller.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  static const String routeName = '/order_detail';

  final String orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {

  @override
  void initState() {

    ref.read(orderDetailControllerProvider.notifier).getOrderDetails(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: CommonAppBar(
        title: 'Order Details',
        backgroundColor: AppColors.white,
        titleStyle: GoogleFonts.interTight(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: state.orderModel != null ? Column(
                  children: [
                    SizedBox(height: 12.h,),
                    _orderStatus(state.orderModel),
                    SizedBox(height: 12.h,),
                    _orderItems(state.orderModel?.items ?? []),
                    SizedBox(height: 12.h,),
                    _summary(state.orderModel),
                    SizedBox(height: 12.h,),
                    _otherDetails(state.orderModel),
                  ],
                ) : SizedBox.shrink(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: AppButton(
              text: 'New Order',
              onPressed: () => ref.read(goRouterProvider).go('${SplashScreen.routeName}/${state.orderModel?.businessId ?? ''}'),
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 20.h,),
          SizedBox(height: AppConsts.bottomPadding,)
        ],
      ),
    );
  }

  Widget _orderItems(List<OrderItems> orderItems) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          ListView.builder(
            itemCount: orderItems.length,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return _item(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _summary(OrderModel? orderModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          Row(
            children: [
              Container(
                height: 35.h,width: 35.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.inventory_2_outlined, size: 16.h, color: AppColors.supporting,),
              ),
              SizedBox(width: 12.w,),
              Text(
                'Bill Summary',
                style: GoogleFonts.nunito(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.supporting
                ),
              )
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Item Total',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              Text(
                '${orderModel?.orderTotal ?? 0}',
                style: GoogleFonts.nunito(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.supporting
                ),
              )
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Paid',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              Text(
                '${orderModel?.orderTotal ?? 0}',
                style: GoogleFonts.nunito(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.supporting
                ),
              )
            ],
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _otherDetails(OrderModel? orderModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          Row(
            children: [
              Container(
                height: 35.h,width: 35.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.account_circle_outlined, size: 16.h, color: AppColors.supporting,),
              ),
              SizedBox(width: 12.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderModel?.orderUserName ?? '',
                    style: GoogleFonts.nunito(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    orderModel?.orderMobileNumber ?? '',
                    style: GoogleFonts.nunito(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            children: [
              Container(
                height: 35.h,width: 35.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.payment, size: 16.h, color: AppColors.supporting,),
              ),
              SizedBox(width: 12.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: GoogleFonts.nunito(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    'Paid via: ${orderModel?.paymentType ?? ''}',
                    style: GoogleFonts.nunito(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            children: [
              Container(
                height: 35.h,width: 35.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.date_range, size: 16.h, color: AppColors.supporting,),
              ),
              SizedBox(width: 12.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Date',
                    style: GoogleFonts.nunito(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    (orderModel?.createdAt ?? '').formatDate(),
                    style: GoogleFonts.nunito(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _orderStatus(OrderModel? orderModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          Row(
            children: [
              Icon(Icons.description_rounded, size: 20.h, color: AppColors.supporting,),
              SizedBox(width: 12.w,),
              Expanded(
                child: Text(
                  'Order was Delivered',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              SizedBox(width: 12.w,),
            ],
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _item(OrderItems item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          /*ProductImage(
            imageUrls: item.imageUrls,
            width: 30,
            height: 30,
          ),*/
          //SizedBox(width: 12.w,),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} X ',
                  style: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading
                  ),
                ),
                Expanded(
                  child: Text(
                    item.productName,
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${AppConsts.currencySymbol} ${item.price * item.quantity}/-',
            style: GoogleFonts.nunito(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.supporting
            ),
          ),
        ],
      ),
    );
  }
}

