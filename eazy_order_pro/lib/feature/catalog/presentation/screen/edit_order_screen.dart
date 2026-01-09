import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:core/core.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/product_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditOrderScreen extends ConsumerStatefulWidget {
  final String? orderId;

  const EditOrderScreen({super.key, this.orderId});

  @override
  ConsumerState<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends ConsumerState<EditOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderListControllerProvider);
    final productState = ref.watch(productListingControllerProvider);
    final controller = ref.read(productListingControllerProvider.notifier);
    final ordercontroller = ref.read(orderListControllerProvider.notifier);
    final order = orderState.orderlist.firstWhere(
      (o) => o.orderId == widget.orderId,
    );
    if (order == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
          "Edit order",
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                                        "items",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17.sp,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 5.h),

                              Text(
                                "order preference",
                                style: GoogleFonts.poppins(
                                  color: AppColors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                "order items :",
                                style: GoogleFonts.poppins(
                                  color: AppColors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                "items count:",
                                style: GoogleFonts.poppins(
                                  color: AppColors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "selected items : ",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ...List.generate(order.items.length, (index) {
                      final item = order.items[index];
                    //  final qty = order.cart[item.orderItemId] ?? item.quantity;
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

                                        //quantity portion here..............................................
                                        Container(
                                          height: 28.h,
                                          width: 80.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: AppColors.grey600,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap:
                                                    () => controller.removeItem(
                                                      order.items[index].orderItemId,
                                                    ),
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                  color: AppColors.green,
                                                ),
                                              ),
                                              Text(
                                                '${item.quantity}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => controller.addItem(
                                                      order.items[index].orderItemId,
                                                    ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: AppColors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Qty : ${item.quantity}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "₹${item.price}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Divider(color: AppColors.grey600),
                    SizedBox(height: 10.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50.h,
                          width: 200.w,
                          child: AppButton(
                            color: AppColors.primaryColor,
                            text: '+  Add more items',
                            textStyle: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductListingScreen(
                                        orderId: order.orderId,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
