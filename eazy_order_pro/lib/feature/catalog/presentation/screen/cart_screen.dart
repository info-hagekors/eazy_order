import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:core/core.dart';
import 'package:core/models/order_model.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/contact_dialog.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/order_confirm_dialog.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String selectedOrderPreference = 'dine_in';

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(productListingControllerProvider);
    final orderState = ref.watch(orderListControllerProvider);
    final orderItems =
        cartState.cart.entries.map((e) {
          final products = cartState.allProducts[e.key]!;


          return OrderItems(
            orderItemId: '',
            productName: products.productName,
            price: products.price,
            quantity: e.value,
            categoryName: products.categoryName,
            description: products.description,
            imageUrls: products.imageUrls,
          );
        }).toList();
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
            onPressed: (){
                Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,)),
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// 🔹 BODY
      body:
          cartState.cart.isEmpty
              ? _emptyCartView(context)
              : ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  /// 🔹 CART ITEMS
                  _cartItemsCard(cartState, cartController),

                  SizedBox(height: 16.h),

                  /// 🔹 CONTACT CARD
                  _contactCard(orderState),

                  SizedBox(height: 10.h),

                  Text(
                    'Please enter your WhatsApp number to receive order updates.',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.grey600),
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
                        /// TITLE
                        Row(
                          children: [
                            Icon(Icons.receipt_long, color: AppColors.grey600),
                            SizedBox(width: 16.w),
                            Text(
                              'Order Preference',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        Row(
                          children: [
                            /// DINE IN
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(orderListControllerProvider.notifier).orderpreference('dine_in');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: orderState.orderpreference == 'dine_in'
                                        ? AppColors.green.withAlpha(38)
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: orderState.orderpreference == 'dine_in'
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
                                        color: orderState.orderpreference == 'dine_in'
                                            ? AppColors.green
                                            : AppColors.black,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Dine In',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: orderState.orderpreference == 'dine_in'
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

                            /// TAKE AWAY
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(orderListControllerProvider.notifier).orderpreference('take_away');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: orderState.orderpreference == 'take_away'
                                        ? AppColors.green.withAlpha(38)
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: orderState.orderpreference == 'take_away'
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
                                        color: orderState.orderpreference == 'take_away'
                                            ? AppColors.green
                                            : AppColors.black,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Take Away',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: orderState.orderpreference == 'take_away'
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
                  _simpleTile(Icons.payment, 'Payment Options'),

                  SizedBox(height: 20.h),

                  _grandTotalCard(totalPrice),

                  SizedBox(height: 70.h),
                ],
              ),

      bottomNavigationBar:
          cartState.cart.isEmpty
              ? null
              : Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [BoxShadow(color: AppColors.black12, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    /// TOTAL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹$totalPrice',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 16.w),

                    /// PAY NOW
                    Expanded(
                      child: AppButton(
                        color: AppColors.primaryColor,
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const OrderConfirmDialog(),
                          );

                          if (result == true && context.mounted) {
                            final homeState = ref.read(homeControllerProvider);
                            final productState = ref.read(productListingControllerProvider);

                            final orderItems =
                                productState.cart.entries.map((entry) {
                                  final product =
                                      productState.allProducts[entry.key]!;
                                  return OrderItems(
                                    orderItemId: product.productId,
                                    productName: product.productName,
                                    price: product.price,
                                    quantity: entry.value,
                                    categoryName: product.categoryName ?? '',
                                    description: product.description,
                                    imageUrls: product.imageUrls,
                                  );
                                }).toList();

                            await ref.read(orderListControllerProvider.notifier).orderPlace(
                                  homeState.currentUser.businessId,
                                  orderState.username,
                                  orderState.mobilenumber,
                                  orderItems,
                                  totalPrice,
                                  orderState.orderpreference
                                );
                            
                            ref.read(productListingControllerProvider.notifier).clearCart();
                            ref.read(orderListControllerProvider.notifier).clear();

                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        },

                        text: 'Place order',
                        textStyle: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
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
                      height: 50.h,
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
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '₹${product.price ?? 0}/-',
                          style: TextStyle(
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
                    horizontal: 13,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.grey600, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Text(
                    '+  Add items',
                    style: TextStyle(
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
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items from the menu to start ordering',
            style: TextStyle(fontSize: 13.sp, color: AppColors.grey600),
          ),
          SizedBox(height: 20.h),
          AppButton(
            color: AppColors.blue,
            height: 45.h,
            width: 150.w,
            onPressed: () => Navigator.pop(context),
            text: 'Browse Menu',
            textStyle: TextStyle(
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
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

  Widget _contactCard(dynamic orderState) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => const ContactDialog(),
        );

        if (result != null) {
          ref.read(orderListControllerProvider.notifier).updateContact(
              username: result['name'] ?? '',
              mobilenumber: result['mobile'] ?? ''
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(15.w),
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
                     orderState.username.isEmpty
                         ? 'username': orderState.username,
                    style: TextStyle(color: AppColors.black),
                  ),
                  Text(
                    orderState.mobilenumber.isEmpty
                        ? '+91 XXXXXXXX': orderState.mobilenumber,
                    style: const TextStyle(color: AppColors.black),
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

  Widget _simpleTile(IconData icon, String title) {
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
          Text(title, style: TextStyle(fontSize: 15.sp)),
        ],
      ),
    );
  }

  Widget _grandTotalCard(double totalPrice) {
    return Container(
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
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            '₹${totalPrice.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
