
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:eazy_order_web/feature/home/applications/product_listing_controller.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/mobile/cart_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  const ProductListingScreen({super.key, required this.businessId});

  static const String routeName = '/product_listing';

  final String businessId;

  @override
  ConsumerState<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {

  @override
  void initState() {
    ref.read(productListingControllerProvider.notifier).getBusinessData(widget.businessId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppConsts.isWeb ? _webUI() : _commonUI();
  }

  Widget _webUI() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 380),
        child: _commonUI(),
      ),
    );
  }

  Widget _commonUI() {
    final state = ref.watch(productListingControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bgColor,
            expandedHeight: 300.h,
            pinned: true,
            floating: false,
            leading: SizedBox.shrink(),
            surfaceTintColor: AppColors.bgColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                state.businessModel?.name ?? '',
                style: GoogleFonts.nunito(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.heading
                ),
              ),
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 25.h),
              background: Container(
                color: Colors.green,
                height: 300.h,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    (state.businessModel?.logo.isNotEmpty ?? false)  ? Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: state.businessModel?.logo ?? '',
                        fit: BoxFit.cover,
                        height: 300.h,
                        alignment: Alignment.center,
                      ),
                    ) : Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.business_rounded,
                        size: 72.sp,
                        color: AppColors.borderColor,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: Text(
                          "+91 ${state.businessModel?.mobile ?? ''}",
                          style: GoogleFonts.nunito(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.heading
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isLoading) ... [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 300,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  )
                ] else ... [
                  if (state.categoryList.isNotEmpty) ... [
                    ListView.builder(
                      itemCount: state.categoryList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = state.categoryList[index];
                        return _category(item, state.cartModel);
                      },
                    ),
                  ] else ... [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          child: Text(
                            'No Products found.!',
                            style: GoogleFonts.nunito(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.black
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: state.cartModel?.cartItems.isNotEmpty ?? false ? BottomAppBar(
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () => ref.read(goRouterProvider).push('${CartScreen.routeName}/${widget.businessId}'),
          child: Container(
            color: AppColors.primaryColor,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '${state.cartModel?.cartItems.length ?? 0} Item added',
                      style: GoogleFonts.nunito(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white
                      ),
                    ),
                    Text(
                      'Total ${AppConsts.currencySymbol} ${state.cartModel?.cartTotal ?? 0}/-',
                      style: GoogleFonts.nunito(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w,),
                Icon(Icons.arrow_circle_right_outlined, size: 24, color: AppColors.white,)
              ],
            ),
          ),
        ),
      ) : SizedBox.shrink(),
    );
  }

  Widget _category(CategoryModel category, CartModel? cartModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 55.h,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category.categoryName,
                    style: GoogleFonts.nunito(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => ref.read(productListingControllerProvider.notifier).openCloseCategory(category.categoryId),
                icon: Icon(category.isOpened ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 24.h,),
              )
            ],
          ),
        ),
        if (category.isOpened) ... [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListView.builder(
              itemCount: category.products.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = category.products[index];
                if (!item.isActive) {
                  return SizedBox.shrink();
                }
                return _item(item, index == category.products.length - 1, cartModel, category);
              },
            ),
          )
        ],
        Container(
          height: 10.h,
          width: double.infinity,
          color: AppColors.background2.withAlpha(128),
        )
      ],
    );
  }

  Widget _item(ProductModel product, bool isLast, CartModel? cartModel, CategoryModel category) {
    ProductModel? itemFromCart = cartModel?.cartItems.firstWhereOrNull((element) => element.productId == product.productId);
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    Text(
                      product.productName,
                      style: GoogleFonts.nunito(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading
                      ),
                    ),
                    SizedBox(height: 4.h,),
                    Text(
                      '${AppConsts.currencySymbol} ${product.price}/-',
                      style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.supporting
                      ),
                    ),
                    SizedBox(height: 4.h,),
                    Text(
                      product.description,
                      style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.supporting
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              SizedBox(width: 24.w,),
              SizedBox(
                height: 130.h,
                width: 130.w,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 15,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        height: 110.h,
                        width: 110.w,
                        child: ProductImage(imageUrls: product.imageUrls),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: itemFromCart != null ? Container(
                        height: 35.h,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.primaryButtonColor,
                            border: Border.all(color: AppColors.screenBgColor, width: 2.w)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 8.w,),
                            GestureDetector(
                              onTap: () => ref.read(productListingControllerProvider.notifier).decreaseQuantity(product),
                              child: Icon(Icons.remove, size: 20.h, color: AppColors.white,),
                            ),
                            Expanded(
                              child: Text(
                                '${itemFromCart.quantity}',
                                style: GoogleFonts.nunito(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(productListingControllerProvider.notifier).increaseQuantity(product),
                              child: Icon(Icons.add, size: 20.h, color: AppColors.white,)
                            ),
                            SizedBox(width: 8.w,),
                          ],
                        ),
                      ) : _addButton(product, category),
                    )
                  ],
                ),
              )
            ],
          ),
          if (!isLast) ... [
            SizedBox(height: 12.h,),
            DashedDivider(color: AppColors.supporting.withAlpha(104),)
          ],
        ],
      ),
    );
  }

  Widget _addButton(ProductModel product, CategoryModel category) {
    return GestureDetector(
      onTap: () => ref.read(productListingControllerProvider.notifier).addToCart(product, category.categoryName),
      child: Container(
        height: 35.h,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.primaryButtonColor,
            border: Border.all(color: AppColors.screenBgColor, width: 2.w)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ADD',
              style: GoogleFonts.nunito(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white
              ),
              textAlign: TextAlign.center,
            ),
            //SizedBox(width: 4.w,),
            //Icon(Icons.add, size: 14.h, color: AppColors.heading,)
          ],
        ),
      ),
    );
  }
}

