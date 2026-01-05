
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/home/applications/order_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/new_order_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/cash_collection_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/order_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final statusList = ['All', 'Placed', 'Confirmed', 'Completed', 'Cancelled'];
    final state = ref.watch(orderControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.primaryColor,
        onPressed: () {
          ref.read(goRouterProvider).push(NewOrderScreen.routeName);
        },
        child: Icon(Icons.add, color: AppColors.white,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 15),
              if (state.isLoading) ... [
                Container(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              ] else ... [
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Today's Order",
                        style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black
                        ),
                      ),
                    ),
                    Text(
                      "Order History",
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_rounded, size: 20.h, color: AppColors.secondary,)
                  ],
                ),
                SizedBox(height: 16.h,),
                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    itemCount: statusList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = statusList[index];
                      bool isSelected = item == state.selectedOrderStatus;
                      return GestureDetector(
                        onTap: () => ref.read(orderControllerProvider.notifier).onSelectOrderStatus(item),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: isSelected ? AppColors.imageBgColor : AppColors.white,
                              border: Border.all(
                                  color: isSelected ? AppColors.white : AppColors.black
                              )
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          alignment: Alignment.centerRight,
                          child: Text(
                            item,
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: isSelected ? AppColors.white : AppColors.black.withAlpha(128)
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h,),
                if (state.ordersList.isNotEmpty) ... [
                  ListView.builder(
                    itemCount: state.ordersList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = state.ordersList[index];
                      return _orderCard(item);
                    },
                  )
                ] else ... [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppImages.icNoOrders,
                      height: 300.h,
                      width: 300.w,
                    ),
                  )
                ]
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderCard(OrderModel orderModel) {
    Color statusColor = AppColors.placed;
    if (orderModel.orderStatus.toLowerCase() == 'confirmed') {
      statusColor = AppColors.confirm;
    } else if (orderModel.orderStatus.toLowerCase() == 'completed') {
      statusColor = AppColors.complete;
    } else if (orderModel.  orderStatus.toLowerCase() == 'cancelled') {
      statusColor = AppColors.cancel;
    } else {
      statusColor = AppColors.placed;
    }
    final optList = ['Online', 'Cash'];
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Card(
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        elevation: 4,
        child: Column(
          children: [
            Padding(
              //padding: EdgeInsets.only(top: 12.h, bottom: 12.h, left: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    height: 35.h,width: 35.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withAlpha(55)
                    ),
                    child: Icon(Icons.account_circle_outlined, size: 20.h, color: AppColors.supporting,),
                  ),
                  SizedBox(width: 8.w,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderModel.orderUserName,
                          style: GoogleFonts.nunito(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          orderModel.orderMobileNumber,
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withAlpha(128)
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.primaryColor
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    child: Text(
                      '#${orderModel.orderInvoiceNumber}',
                      style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white
                      ),
                    ),
                  ),
                  if (orderModel.orderPreference == 'Dine In') ... [
                    SizedBox(width: 8.w,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.primaryColor
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      child: Text(
                        'Table #${orderModel.tableNumber}',
                        style: GoogleFonts.nunito(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white
                        ),
                      ),
                    ),
                  ],
                  /*PopupMenuButton(
                    itemBuilder: (context) {
                      return ['Edit'].map((e) {
                        return PopupMenuItem(
                          value: e,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Text(
                              e,
                              style: GoogleFonts.nunito(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black
                              ),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.more_vert_rounded, size: 20.h,),
                    ),
                  )*/
                ],
              ),
            ),
            DashedDivider(),
            Container(
              height: 20.h,
              alignment: Alignment.center,
              color: statusColor.withAlpha(128),
              child: Text(
                orderModel.orderStatus.capitalize(),
                style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black
                ),
              ),
            ),
            SizedBox(height: 12.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orderModel.items.length,
                itemBuilder: (context, index) {
                  final item = orderModel.items[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.quantity} x ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.productName,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h,),
            Container(
              height: 1.h,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              color: AppColors.background2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (orderModel.createdAt).formatDate(),
                          style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withAlpha(128)
                          ),
                        ),
                        SizedBox(height: 4.h,),
                        GestureDetector(
                          onTap: () => ref.read(orderControllerProvider.notifier).showPaymentDetails(orderModel.orderId, !orderModel.showPaymentDetails),
                          child: Row(
                            children: [
                              if (orderModel.paymentStatus.toLowerCase() == 'paid') ... [
                                Icon(Icons.check_circle_outline, size: 16.h, color: AppColors.green,)
                              ] else if (orderModel.paymentStatus.toLowerCase() == 'pending') ... [
                                Icon(Icons.pending_outlined, size: 16.h, color: AppColors.primaryButtonColor,)
                              ] else ... [
                                Icon(Icons.sms_failed_outlined, size: 16.h, color: AppColors.lightRed,)
                              ],
                              SizedBox(width: 4.w,),
                              Text(
                                'Payment ${orderModel.paymentStatus}',
                                style: GoogleFonts.nunito(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black
                                ),
                              ),
                              SizedBox(width: 4.w,),
                              Icon(!orderModel.showPaymentDetails ? Icons.arrow_drop_down_sharp : Icons.arrow_drop_up, size: 20.h, color: AppColors.black,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${AppConsts.currencySymbol} ${orderModel.orderTotal}',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black
                    ),
                  ),
                ],
              ),
            ),
            if (orderModel.showPaymentDetails) ... [
              if (orderModel.paymentStatus.toLowerCase() == 'pending') ... [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: optList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = optList[index];
                          return RadioListTile(
                            onChanged: (val) {
                              ref.read(orderControllerProvider.notifier).onUpdateOrderPaymentMode(val ?? '', orderModel.orderId);
                            },
                            value: item,
                            groupValue: orderModel.selectedPaymentOption,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primaryColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item,
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black
                                    ),
                                  ),
                                ),
                                if (item == 'Cash' && orderModel.selectedPaymentOption == 'Cash') ... [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () => showCashCollectionDialog(orderModel),
                                      child: Text(
                                        'Collect Cash Payment',
                                        style: GoogleFonts.nunito(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.link,
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppColors.link
                                        ),
                                      ),
                                    ),
                                  ),
                                ] else if (item == 'Online' && orderModel.selectedPaymentOption == 'Online')... [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () => ref.read(orderControllerProvider.notifier).makePaymentForOrder(orderModel, context),
                                      child: Text(
                                        'Pay Now',
                                        style: GoogleFonts.nunito(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.link,
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppColors.link
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h,),
                    ],
                  ),
                ),
              ] else ... [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Paid via: ${orderModel.paymentType}',
                          style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                        ),
                      ),
                      if (orderModel.paymentType.toLowerCase() == 'online') ... [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Transaction Id: ${orderModel.paymentId}',
                            style: GoogleFonts.nunito(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 12.h,),
                    ],
                  ),
                ),
              ],
            ],
            OrderStatusWidget(orderModel: orderModel),
          ],
        ),
      ),
    );
  }

  void showCashCollectionDialog(OrderModel orderModel) {
    showDialog(
        context: context,
        builder: (context) {
          return CashCollectionDialog(
            message: "Please collect the cash payment before pressing 'OK' button.!\nNote: This action can't be undone.",
          );
        }
    ).then((val) {
      if (val ?? false) {
        ref.read(orderControllerProvider.notifier).receivedCashForOrder(orderModel);
      }
    });
  }
}
