
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:eazy_order_web/feature/home/applications/order_detail_controller.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailWebScreen extends ConsumerStatefulWidget {
  const OrderDetailWebScreen({super.key, required this.orderId});

  static const String routeName = '/order_detail';

  final String orderId;

  @override
  ConsumerState<OrderDetailWebScreen> createState() => _OrderDetailWebScreenState();
}

class _OrderDetailWebScreenState extends ConsumerState<OrderDetailWebScreen> {

  @override
  void initState() {
    ref.read(orderDetailControllerProvider.notifier).getOrderDetails(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppConsts.isWeb ? _webUI() : _commonUI();
  }

  Widget _webUI() {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey.shade50,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppConsts.webAppWidth),
        child: _commonUI(),
      ),
    );
  }

  Widget _commonUI() {
    final state = ref.watch(orderDetailControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: CommonAppBar(
        title: 'Order Details',
        backgroundColor: AppColors.imageBgColor,
        showLeading: false,
        centerTitle: true,
        titleStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      body: Column(
        children: [
          if (state.isLoading) ... [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            )
          ] else ... [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: state.orderModel != null ? Column(
                    children: [
                      SizedBox(height: 12,),
                      _orderStatus(state.orderModel),
                      SizedBox(height: 12,),
                      _orderItems(state.orderModel?.items ?? []),
                      SizedBox(height: 12,),
                      _summary(state.orderModel),
                      SizedBox(height: 12,),
                      _otherDetails(state.orderModel),
                      SizedBox(height: 24,),
                    ],
                  ) : SizedBox.shrink(),
                ),
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: AppButton(
              text: 'New Order',
              height: 42,
              onPressed: () => ref.read(goRouterProvider).go(SplashScreen.routeName),
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(height: AppConsts.bottomPadding,)
        ],
      ),
    );
  }

  Widget _orderItems(List<OrderItems> orderItems) {
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
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white
      ),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: [
          SizedBox(height: 6,),
          Row(
            children: [
              Container(
                height: 35,width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.supporting,),
              ),
              SizedBox(width: 12,),
              Text(
                'Bill Summary',
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.supporting
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Item Total',
                  style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              Text(
                '${AppConsts.currencySymbol} ${orderModel?.orderTotal ?? 0}',
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.supporting
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Paid Amount',
                  style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
                ),
              ),
              Text(
                '${AppConsts.currencySymbol} ${orderModel?.orderTotal ?? 0}',
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.supporting
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _otherDetails(OrderModel? orderModel) {
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
              Container(
                height: 35,width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.supporting,),
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Number',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    '#${orderModel?.orderInvoiceNumber ?? ''}',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                height: 35,width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.dining_outlined, size: 16, color: AppColors.supporting,),
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Preference',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    orderModel?.orderPreference ?? '',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          if (orderModel?.orderPreference == 'Dine In') ... [
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  height: 35,width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withAlpha(55)
                  ),
                  child: Icon(Icons.table_restaurant_outlined, size: 16, color: AppColors.supporting,),
                ),
                SizedBox(width: 12,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Table Number',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.supporting
                      ),
                    ),
                    Text(
                      orderModel?.tableNumber ?? '',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.supporting
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                height: 35,width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.account_circle_outlined, size: 16, color: AppColors.supporting,),
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderModel?.orderUserName ?? '',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    orderModel?.orderMobileNumber ?? '',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                height: 35,width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.payment, size: 16, color: AppColors.supporting,),
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    'Paid via: ${orderModel?.paymentOption ?? ''}',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          if (orderModel?.paymentOption.toLowerCase() == 'online') ... [
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  height: 35,width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withAlpha(55)
                  ),
                  child: Icon(Icons.password, size: 16, color: AppColors.supporting,),
                ),
                SizedBox(width: 12,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Detail',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.supporting
                      ),
                    ),
                    Text(
                      'Transaction Id: ${orderModel?.paymentId ?? ''}',
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.supporting
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                height: 35,width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withAlpha(55)
                ),
                child: Icon(Icons.date_range, size: 16, color: AppColors.supporting,),
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Date',
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                  Text(
                    (orderModel?.createdAt ?? '').formatDate(),
                    style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.supporting
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _orderStatus(OrderModel? orderModel) {
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
                  'Order is ${orderModel?.orderStatus ?? ''}',
                  style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.supporting
                  ),
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

  Widget _item(OrderItems item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} X ',
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading
                  ),
                ),
                Expanded(
                  child: Text(
                    item.productName,
                    style: GoogleFonts.nunito(
                        fontSize: 16,
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
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.supporting
            ),
          ),
        ],
      ),
    );
  }
}

