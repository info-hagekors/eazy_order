
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/applications/order_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/cash_collection_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/order_cancel_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStatusWidget extends ConsumerWidget {
  const OrderStatusWidget({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orderModel.orderStatus.toLowerCase() == 'completed' || orderModel.orderStatus.toLowerCase() == 'cancelled') {
      return SizedBox.shrink();
    }
    String orderStatus = '';
    String displayStatus = '';
    if (orderModel.orderStatus.toLowerCase() == 'placed') {
      orderStatus = 'confirmed';
      displayStatus = 'Confirm';
    } else if (orderModel.orderStatus.toLowerCase() == 'confirmed') {
      orderStatus = 'completed';
      displayStatus = 'Complete';
    } else {
      orderStatus = 'placed';
      displayStatus = 'Placed';
    }
    return Column(
      children: [
        DashedDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (orderModel.orderStatus.toLowerCase() == 'confirmed' && orderModel.paymentType.toLowerCase() == 'cash') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CashCollectionDialog();
                          }
                      ).then((val) {
                        if (val ?? false) {
                          ref.read(orderControllerProvider.notifier).updateOrderStatus(orderModel.orderId, orderStatus);
                        }
                      });
                    } else if (orderModel.orderStatus.toLowerCase() == 'confirmed' && orderModel.paymentStatus.toLowerCase() == 'pending') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CashCollectionDialog(
                              title: 'Payment Received?',
                              message: 'Please collect the payment before completing the order.!',
                            );
                          }
                      );
                    } else {
                      ref.read(orderControllerProvider.notifier).updateOrderStatus(orderModel.orderId, orderStatus);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 20.w, color: AppColors.green,),
                      SizedBox(width: 4.w,),
                      Text(
                        displayStatus,
                        style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.green
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20.h,
                width: 1.w,
                color: AppColors.background2,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (orderModel.orderStatus != 'Complete') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return OrderCancelPopup();
                        }
                      ).then((val) {
                        if (val ?? false) {
                          ref.read(orderControllerProvider.notifier).updateOrderStatus(orderModel.orderId, 'cancelled');
                        }
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close, size: 20.w, color: AppColors.lightRed,),
                      SizedBox(width: 4.w,),
                      Text(
                        'Cancel',
                        style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightRed
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
