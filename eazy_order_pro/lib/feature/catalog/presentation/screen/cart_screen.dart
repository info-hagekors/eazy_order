import 'package:core/config/app_colors.dart';
import 'package:core/models/order_model.dart';
import 'package:eazy_order_pro/feature/catalog/application/orderlist_controller.dart';
import 'package:eazy_order_pro/feature/catalog/application/product_listing_controller.dart';
import 'package:eazy_order_pro/feature/catalog/entity/product_list_entity.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/contact_dialog.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/widget/order_confirm_dialog.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? userName;
  String? mobileNumber;

  // -------------------- HELPERS --------------------

  double _calculateTotal(ProductListEntity cartState) {
    return cartState.cart.entries.fold<double>(0, (sum, e) {
      final product = cartState.allProducts[e.key];
      return sum + ((product?.price ?? 0) * e.value);
    });
  }

  List<OrderItems> _buildOrderItems(ProductListEntity productState) {
    return productState.cart.entries.map((entry) {
      final product = productState.allProducts[entry.key]!;

      return OrderItems(
        orderItemId: const Uuid().v4(),
        productName: product.productName,
        price: product.price,
        quantity: entry.value,
        categoryName: product.categoryName ?? '',
        description: product.description,
        imageUrls: product.imageUrls,
      );
    }).toList();
  }

  Future<void> _placeOrder(double totalPrice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const OrderConfirmDialog(),
    );

    if (confirmed != true || !mounted) return;

    final homeState = ref.read(homeControllerProvider);
    final productState = ref.read(productListingControllerProvider);

    final orderId = const Uuid().v4();
    final invoiceNumber = 'INV-${DateTime.now().millisecondsSinceEpoch}';

    await ref.read(orderListControllerProvider.notifier).orderPlace(
      homeState.currentUser.businessId,
      orderId,
      invoiceNumber,
      userName?.trim().isNotEmpty == true ? userName! : '',
      mobileNumber?.trim().isNotEmpty == true ? mobileNumber! : '',
      _buildOrderItems(productState),
      totalPrice,
    );

    ref.read(productListingControllerProvider.notifier).clearCart();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // -------------------- UI --------------------

  Widget _emptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/empty-cart.svg',
            height: 200.h,
          ),
          SizedBox(height: 20.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items from the menu to start ordering',
            style: TextStyle(fontSize: 13.sp, color: AppColors.grey600),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding:
              EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
            ),
            child: const Text('Browse Menu',style: TextStyle(color: AppColors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(productListingControllerProvider);
    final cartController =
    ref.read(productListingControllerProvider.notifier);
    final totalPrice = _calculateTotal(cartState);

    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('My Cart',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w600),),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,size: 22.sp)),
      ),
      body: cartState.cart.isEmpty
          ? _emptyCartView(context)
          : ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _cartItemsCard(cartState, cartController),
          SizedBox(height: 16.h),
          _contactCard(),
          SizedBox(height: 10.h),
          Text(
            'Please enter your WhatsApp number to receive order updates.',
            style:
            TextStyle(fontSize: 12.sp, color: AppColors.grey600),
          ),
          SizedBox(height: 16.h),
          _simpleTile(Icons.receipt_long, 'Order Preference'),
          SizedBox(height: 12.h),
          _simpleTile(Icons.payment, 'Payment Options'),
          SizedBox(height: 12.h),
          _grandTotalCard(totalPrice),
          SizedBox(height: 100.h),
        ],
      ),
      bottomNavigationBar: cartState.cart.isEmpty
          ? null
          : _bottomBar(totalPrice),
    );
  }

  Widget _cartItemsCard(
      ProductListEntity cartState,
      ProductListingController controller,
      ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
                  Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.restaurant),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.productName ?? '',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 4.h),
                        Text('₹${product.price ?? 0}/-',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.grey600)),
                      ],
                    ),
                  ),
                  _qtyButton(product.productId!, e.value, controller),
                ],
              ),
            );
          }),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    //border: Border.all(color: AppColors.grey600,width: 1),
                      borderRadius: BorderRadius.circular(12.r)
                  ),
                  child: const Text(
                    '+  Add items',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(
      String productId,
      int qty,
      ProductListingController controller,
      ) {
    return Container(
      height: 28.h,
      width: 80.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey600),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => controller.removeItem(productId),
            child: const Icon(Icons.remove, size: 16, color: AppColors.green),
          ),
          Text('$qty',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.black)),
          GestureDetector(
            onTap: () => controller.addItem(productId),
            child: const Icon(Icons.add, size: 16, color: AppColors.green),
          ),
        ],
      ),
    );
  }

  Widget _contactCard() {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const ContactDialog(),
        );

        if (result != null) {
          setState(() {
            userName = result['name'];
            mobileNumber = result['mobile'];
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            const Icon(Icons.call, size: 25, color: AppColors.green),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName ?? 'username',
                      style: const TextStyle(color: AppColors.grey600)),
                  Text(mobileNumber ?? '+91 XXXXXXXX',
                      style: const TextStyle(color: AppColors.grey600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16,color: AppColors.black,fontWeight: FontWeight.w600,),
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon,color: AppColors.grey600,),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Grand Total',
              style: TextStyle(fontWeight: FontWeight.w600)),
          Text('₹${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _bottomBar(double totalPrice) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('₹$totalPrice',
                  style: TextStyle(
                      fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Text('Grand Total',
                  style:
                  TextStyle(fontSize: 12.sp, color: AppColors.grey600)),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _placeOrder(totalPrice),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: const Text('Place order',style: TextStyle(color: AppColors.white,fontSize: 15,fontWeight: FontWeight.w600),),
            ),
          ),
        ],
      ),
    );
  }
}
