import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:core/models/order_model.dart';
import 'package:core/widgets/app_button.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/product_listing_screen.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/contact_dialog.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/order_confirm_dialog.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends ConsumerStatefulWidget {
  static const String routeName = '/cartscreen';

  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(productListingControllerProvider);
    final productState = ref.watch(productListingControllerProvider);
    final cartController = ref.read(productListingControllerProvider.notifier);
    final totalPrice = cartState.cart.entries.fold<double>(0, (sum, e) {
      final product = cartState.allProducts[e.key];

      if (product == null) return sum;
      return sum + (product.price ?? 0) * e.value;
    });

    return Scaffold(
      backgroundColor: AppColors.white,
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
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: cartState.cart.isEmpty &&
          !cartState.isLoading &&
          ModalRoute.of(context)?.isCurrent == true
              ? _emptyCartView(context)
              : ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  _cartItemsCard(cartState, cartController),

                  SizedBox(height: 16.h),

                  _contactCard(productState),

                  SizedBox(height: 10.h),

                  Text(
                    'Please enter your WhatsApp number to receive order updates.',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: const [
                        BoxShadow(color: AppColors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt_long, color: AppColors.grey600),
                            SizedBox(width: 16.w),
                            Text(
                              'Order Preference',
                              style: GoogleFonts.poppins(fontSize: 15.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(productListingControllerProvider.notifier,).orderpreference('dine_in');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color:
                                        productState.orderpreference == 'dine_in'
                                            ? AppColors.green.withAlpha(38)
                                            : AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color:
                                          productState.orderpreference ==
                                                  'dine_in'
                                              ? AppColors.green
                                              : AppColors.grey400,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.dining_outlined,
                                        size: 18,
                                        color: productState.orderpreference ==
                                                    'dine_in'
                                                ? AppColors.green
                                                : AppColors.black,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Dine In',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: productState.orderpreference ==
                                                      'dine_in'
                                                  ? AppColors.green
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(productListingControllerProvider.notifier).orderpreference('take_away');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color:
                                        productState.orderpreference ==
                                                'take_away'
                                            ? AppColors.green.withAlpha(38)
                                            : AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color:
                                          productState.orderpreference ==
                                                  'take_away'
                                              ? AppColors.green
                                              : AppColors.grey400,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.restaurant_menu_rounded,
                                        size: 18,
                                        color:
                                            productState.orderpreference ==
                                                    'take_away'
                                                ? AppColors.green
                                                : AppColors.black,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Take Away',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              productState.orderpreference ==
                                                      'take_away'
                                                  ? AppColors.green
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  _paymentcard(Icons.payment, 'Payment Options'),

                  SizedBox(height: 20.h),

                  _grandTotalCard(totalPrice),

                  SizedBox(height: 70.h),
                ],
              ),

      bottomNavigationBar:
          cartState.cart.isEmpty
              ? null
              : Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(color: AppColors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹$totalPrice',
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Grand Total',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),

                      Expanded(
                        child: AppButton(
                          height: 50.h,
                          color: AppColors.primaryColor,
                          isLoading: cartState.isLoading,
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const OrderConfirmDialog(),
                            );

                            if (result == true && context.mounted) {
                              final homeState = ref.read(homeControllerProvider);
                              final productState = ref.read(productListingControllerProvider);
                              final controller = ref.read(productListingControllerProvider.notifier);
                              final selectedCategoryName = productState.categories.firstWhere((c) =>
                              c.categoryId == productState.selectcategoryId).categoryName;

                            final orderItems = productState.cart.entries.map((entry) {
                            final product = productState.allProducts[entry.key]!;
                                  return OrderItems(
                                    orderItemId: product.productId,
                                    productName: product.productName,
                                    price: product.price,
                                    quantity: entry.value,
                                    categoryName: selectedCategoryName,
                                    description: product.description,
                                    imageUrls: product.imageUrls,
                                  );
                                }).toList();

                              await controller.orderPlace(
                                    homeState.currentUser.businessId,
                                    orderItems,
                                    totalPrice,
                                  );
                              ref.read(goRouterProvider).pop(ProductListingScreen.routeName);
                                controller.clearCart();
                            }
                          },
                          text: 'Place order',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _cartItemsCard(dynamic cartState, dynamic controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: AppColors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          ...cartState.cart.entries.map((e) {
            final product = cartState.allProducts[e.key];

            if (product == null) return const SizedBox();
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      height: 40.h,
                      width: 70.h,
                      child: Image.asset(AppImages.dish, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '₹${product.price ?? 0}/-',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _qtyButton(product.productId!, e.value, controller),
                ],
              ),
            );
          }),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.grey600, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '+  Add items',
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.emptycart,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items from the menu to start ordering',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 20.h),
          AppButton(
            color: AppColors.blue,
            height: 45.h,
            width: 150.w,
            onPressed: ref.read(goRouterProvider).pop,
            text: 'Browse Menu',
            textStyle: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(String title, int qty, dynamic controller) {
    return Container(
      height: 28.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey600),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => controller.removeItem(title),
            child: const Icon(Icons.remove, size: 16, color: AppColors.green),
          ),
          Text(
            '$qty',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          GestureDetector(
            onTap: () => controller.addItem(title),
            child: const Icon(Icons.add, size: 16, color: AppColors.green),
          ),
        ],
      ),
    );
  }

  Widget _contactCard(dynamic productState) {
    final controller = ref.read(productListingControllerProvider.notifier);
    return GestureDetector(                                    //open dialog.......
      onTap: () async {
        final result = await showDialog<Map<String, String>>(    //firstly wait and than check value is return completely like here 'name' : namecontroller.text.trim()...<String, String>....
          context: context,
          builder: (context) => const ContactDialog(),
        );

        if (result != null) {            // this is read the return Map value, after result does not equal to null than save it in controller function.......
          controller.updateContact(
                name: result['name'] ?? '',        //name: is store the value in variable which is in result['name']......
                number: result['mobile'] ?? '',
              );
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [BoxShadow(color: AppColors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            const Icon(Icons.call, color: AppColors.green, size: 25),
            SizedBox(width: 20.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productState.username.isEmpty
                        ? 'username'
                        : productState.username,
                    style: GoogleFonts.poppins(color: AppColors.black,fontSize: 16.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    productState.mobilenumber.isEmpty
                        ? '+91 XXXXXXXX'
                        : productState.mobilenumber,
                    style: GoogleFonts.poppins(color: AppColors.black,fontSize: 16.sp),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentcard(IconData icon, String title) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: AppColors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey600),
          SizedBox(width: 16.w),
          Text(title, style: GoogleFonts.poppins(fontSize: 15.sp)),
        ],
      ),
    );
  }

  Widget _grandTotalCard(double totalPrice) {
    return Container(
      height: 55.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: AppColors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Grand Total',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '₹${totalPrice.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
