
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:eazy_order_go/feature/home/applications/new_order_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/add_user_details_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/product_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key, required this.businessId});

  static const String routeName = '/cart';

  final String businessId;

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

  bool agreed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newOrderControllerProvider);
    final homeState = ref.read(homeControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: CommonAppBar(
        title: 'Cart',
        backgroundColor: AppColors.imageBgColor,
        titleStyle: GoogleFonts.interTight(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 12,),
              _cartItems(state.cartModel?.cartItems ?? []),
              SizedBox(height: 12,),
              _summary(state.cartModel),
              SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 12,),
                  Container(
                    margin: EdgeInsets.only(top: 1),
                    child: Icon(Icons.info_outline, size: 12, color: AppColors.supporting,),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Text(
                      'Please enter your WhatsApp number to receive your order updates...',
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                ],
              ),
              SizedBox(height: 12,),
              _orderPreference(homeState.businessModel?.orderPreference ?? [], state.selectedOrderPreference),
              SizedBox(height: 12,),
              _paymentOption(homeState.businessModel?.paymentOptions ?? [], state.selectedPaymentOption),
              SizedBox(height: 12,),
              _total(state.cartModel),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: state.cartModel?.cartItems.isNotEmpty ?? false
          ? _bottomWidget(state.cartModel, state.isCartLoading) : SizedBox.shrink(),
    );
  }

  Widget _cartItems(List<ProductModel> cartItems) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 6,),
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
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () => ref.read(goRouterProvider).pop(),
            child: Row(
              children: [
                SizedBox(width: 4,),
                Icon(Icons.add, size: 20, color: AppColors.supporting,),
                SizedBox(width: 8,),
                Text(
                  'Add more items',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _summary(CartModel? cartModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12,),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 6,),
          InkWell(
            onTap: () {
              _userDetailDialog();
            },
            child: Row(
              children: [
                Icon(Icons.call, size: 20, color: AppColors.supporting,),
                SizedBox(width: 12,),
                Expanded(
                  child: cartModel?.mobile.isNotEmpty ?? false ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartModel?.userName ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.supporting
                        ),
                      ),
                      Text(
                        '+91 ${cartModel?.mobile ?? ''}',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.supporting
                        ),
                      ),
                    ],
                  ) : Text(
                    'Enter Mobile Number',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 20, color: AppColors.supporting,),
                SizedBox(width: 12,),
              ],
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _total(CartModel? cartModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12,),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 6,),
          Row(
            children: [
              Icon(Icons.description_rounded, size: 20, color: AppColors.supporting,),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grand Total',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.supporting
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${AppConsts.currencySymbol} ${cartModel?.cartTotal ?? 0}/-',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.supporting
                ),
              ),
              SizedBox(width: 12,),
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _item(ProductModel product) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            imageUrls: product.imageUrls,
            width: 50,
            height: 50,
          ),
          SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading
                  ),
                ),
                Text(
                  '${AppConsts.currencySymbol} ${product.price * product.quantity}/-',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.supporting
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 25,
            width: 90,
            margin: EdgeInsets.only(top: 8),
            //padding: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8,),
                color: AppColors.primaryButtonColor,
                border: Border.all(color: AppColors.screenBgColor, width: 2)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8,),
                GestureDetector(
                  onTap: () => ref.read(newOrderControllerProvider.notifier).decreaseQuantity(product),
                  child: Icon(Icons.remove, size: 16, color: AppColors.white,),
                ),
                Expanded(
                  child: Text(
                    '${product.quantity}',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                    onTap: () => ref.read(newOrderControllerProvider.notifier).increaseQuantity(product),
                    child: Icon(Icons.add, size: 16, color: AppColors.white,)
                ),
                SizedBox(width: 8,),
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
          return AddUserDetailsDialog();
        }
    ).then((val) {
      if (val != null && val is Map<String, String>) {
        final String name = val['name'] ?? '';
        final String mobile = val['mobile'] ?? '';
        ref.read(newOrderControllerProvider.notifier).updateUserDetails(mobile, name);
      }
    });
  }

  Widget _bottomWidget(CartModel? cartModel, bool isCartLoading) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50), // Adjust opacity as needed
            offset: Offset(0, -6), // Shadow above the widget
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: BottomAppBar(
        color: AppColors.white,
        height: 120,
        elevation: 10,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: Checkbox(
                      value: agreed,
                      checkColor: AppColors.white,
                      activeColor: AppColors.primaryColor,
                      onChanged: (val) => setState(() => agreed = val ?? false),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'I agree to the ',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(AppConsts.termsCondition)),
                          child: Text(
                              "Terms & Conditions",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline
                              )
                          ),
                        ),
                        Text(
                          ' and ',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(AppConsts.privacyPolicy)),
                          child: Text(
                              "Privacy Policy",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline
                              )
                          ),
                        ),
                        Text(
                          ' and ',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchUrl(Uri.parse(AppConsts.refundPolicy)),
                          child: Text(
                              "Refund Policy",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.background2,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppConsts.currencySymbol} ${cartModel?.cartTotal ?? 0}',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black
                        ),
                      ),
                      Text(
                        'Grand Total',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w,),
                  Expanded(
                    child: AppButton(
                      text: '',
                      isLoading: isCartLoading,
                      color: AppColors.primaryColor,
                      onPressed: agreed ? () {
                        if (cartModel?.mobile.isEmpty ?? true) {
                          _userDetailDialog();
                          return;
                        }
                        ref.read(newOrderControllerProvider.notifier).checkout(widget.businessId, context);
                      } : null,
                      child: Text(
                        'Pay Now',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderPreference(List<String> optList, String selectedItem) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 6,),
          Row(
            children: [
              Icon(Icons.description_rounded, size: 20, color: AppColors.supporting,),
              SizedBox(width: 12,),
              Expanded(
                child: Text(
                  'Order Preference',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              SizedBox(width: 12,),
            ],
          ),
          SizedBox(height: 8,),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: optList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = optList[index];
              return RadioListTile(
                onChanged: (val) {
                  ref.read(newOrderControllerProvider.notifier).onOrderPreferenceSelection(item);
                },
                value: item,
                groupValue: selectedItem,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryColor,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(
                  item,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _paymentOption(List<String> optList, String selectedItem) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 6,),
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 20, color: AppColors.supporting,),
              SizedBox(width: 12,),
              Expanded(
                child: Text(
                  'Payment Options',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              SizedBox(width: 12,),
            ],
          ),
          SizedBox(height: 8,),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: optList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = optList[index];
              return RadioListTile(
                onChanged: (val) {
                  ref.read(newOrderControllerProvider.notifier).onPaymentOptionSelection(item);
                },
                value: item,
                groupValue: selectedItem,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryColor,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(
                  item,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

