
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:eazy_order_web/feature/home/applications/product_listing_controller.dart';
import 'package:eazy_order_web/feature/home/presentations/widgets/add_user_details_dialog.dart';
import 'package:eazy_order_web/feature/home/presentations/widgets/product_image.dart';
import 'package:eazy_order_web/feature/home/presentations/widgets/web/add_user_details_web_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key, required this.businessId});

  static const String routeName = '/cart';

  final String businessId;

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

  @override
  void initState() {
    ref.read(productListingControllerProvider.notifier).getBusinessData(widget.businessId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListingControllerProvider);
    if (state.cartModel?.cartItems.isEmpty ?? false) {
      ref.read(productListingControllerProvider.notifier).goBackOnEmptyCart();
    }
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: CommonAppBar(
        title: 'Cart',
        backgroundColor: AppColors.white,
        titleStyle: GoogleFonts.interTight(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            children: [
              SizedBox(height: 12.h,),
              _cartItems(state.cartModel?.cartItems ?? []),
              SizedBox(height: 12.h,),
              _summary(state.cartModel),
              SizedBox(height: 8.h,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 12.w,),
                  Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Icon(Icons.info_outline, size: 12.h, color: AppColors.supporting,),
                  ),
                  SizedBox(width: 8.w,),
                  Expanded(
                    child: Text(
                      'Please enter your WhatsApp number to receive your order updates...',
                      style: GoogleFonts.nunito(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w,),
                ],
              ),
              SizedBox(height: 12.h,),
              _total(state.cartModel),
            ],
          ),
        ),
      ),
      bottomNavigationBar: state.cartModel?.cartItems.isNotEmpty ?? false ? BottomAppBar(
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () {
            if (state.cartModel?.mobile.isEmpty ?? true) {
              _userDetailDialog();
              return;
            }
            ref.read(productListingControllerProvider.notifier).checkout(widget.businessId, context);
          },
          child: Container(
            color: AppColors.primaryColor,
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'Pay Now',
                  style: GoogleFonts.nunito(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white
                  ),
                ),
                Text(
                  'Total ${AppConsts.currencySymbol} ${state.cartModel?.cartTotal ?? 0}/-',
                  style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : SizedBox.shrink(),
    );
  }

  Widget _cartItems(List<ProductModel> cartItems) {
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
            itemCount: cartItems.length,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _item(item);
            },
          ),
          SizedBox(height: 10.h,),
          GestureDetector(
            onTap: () => ref.read(goRouterProvider).pop(),
            child: Row(
              children: [
                SizedBox(width: 4.w,),
                Icon(Icons.add, size: 20.h, color: AppColors.supporting,),
                SizedBox(width: 8.w,),
                Text(
                  'Add more items',
                  style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _summary(CartModel? cartModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          SizedBox(height: 6.h,),
          InkWell(
            onTap: () {
              _userDetailDialog();
            },
            child: Row(
              children: [
                Icon(Icons.call, size: 20.h, color: AppColors.supporting,),
                SizedBox(width: 12.w,),
                Expanded(
                  child: cartModel?.mobile.isNotEmpty ?? false ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartModel?.userName ?? '',
                        style: GoogleFonts.nunito(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.supporting
                        ),
                      ),
                      Text(
                        '+91 ${cartModel?.mobile ?? ''}',
                        style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.supporting
                        ),
                      ),
                    ],
                  ) : Text(
                    'Enter Mobile Number',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 20.h, color: AppColors.supporting,),
                SizedBox(width: 12.w,),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _total(CartModel? cartModel) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grand Total',
                      style: GoogleFonts.nunito(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.supporting
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${AppConsts.currencySymbol} ${cartModel?.cartTotal ?? 0}/-',
                style: GoogleFonts.nunito(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.supporting
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

  Widget _item(ProductModel product) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
              imageUrls: [],
            width: 50,
            height: 50,
          ),
          SizedBox(width: 12.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading
                  ),
                ),
                Text(
                  '${AppConsts.currencySymbol} ${product.price * product.quantity}/-',
                  style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.supporting
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 25.h,
            width: 90.w,
            margin: EdgeInsets.only(top: 8.h),
            //padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primaryButtonColor,
                border: Border.all(color: AppColors.screenBgColor, width: 2.w)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8.w,),
                GestureDetector(
                  onTap: () => ref.read(productListingControllerProvider.notifier).decreaseQuantity(product),
                  child: Icon(Icons.remove, size: 16.h, color: AppColors.white,),
                ),
                Expanded(
                  child: Text(
                    '${product.quantity}',
                    style: GoogleFonts.nunito(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                    onTap: () => ref.read(productListingControllerProvider.notifier).increaseQuantity(product),
                    child: Icon(Icons.add, size: 16.h, color: AppColors.white,)
                ),
                SizedBox(width: 8.w,),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _userDetailDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AppConsts.isWeb ? Center( // Ensures dialog is centered on larger screens
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 380),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AddUserDetailsWebDialog(), // Your dialog content
                ),
              ),
            ),
          ) : AddUserDetailsDialog();
        }
    ).then((val) {
      if (val != null && val is Map<String, String>) {
        final String name = val['name'] ?? '';
        final String mobile = val['mobile'] ?? '';
        ref.read(productListingControllerProvider.notifier).updateUserDetails(mobile, name);
      }
    });
  }
}

