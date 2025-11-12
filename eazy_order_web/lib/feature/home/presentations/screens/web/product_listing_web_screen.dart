
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

class ProductListingWebScreen extends ConsumerStatefulWidget {
  const ProductListingWebScreen({super.key, required this.businessId});

  static const String routeName = '/product_listing';

  final String businessId;

  @override
  ConsumerState<ProductListingWebScreen> createState() => _ProductListingWebScreenState();
}

class _ProductListingWebScreenState extends ConsumerState<ProductListingWebScreen> {

  final TextEditingController _searchController = TextEditingController();

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
    final state = ref.watch(productListingControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.isLoading) ... [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                ],
              )
            ] else ... [
              SizedBox(height: 12,),
              _storeWidget(state.businessModel),
              SizedBox(height: 12,),
              Container(
                height: 2,
                width: double.infinity,
                color: AppColors.background2.withAlpha(128),
              ),
              SizedBox(height: 12,),
              _searchWidget(state.categoryList),
              if (state.searchedList.isNotEmpty) ... [
                SizedBox(height: 12,),
                Container(
                  height: 2,
                  width: double.infinity,
                  color: AppColors.background2.withAlpha(128),
                ),
                ListView.builder(
                  itemCount: state.searchedList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = state.searchedList[index];
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
                            fontSize: 18,
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
      bottomNavigationBar: state.cartModel?.cartItems.isNotEmpty ?? false
          ? _bottomWidget(state.cartModel) : SizedBox.shrink(),
    );
  }

  Widget _category(CategoryModel category, CartModel? cartModel) {
    return Column(
      key: category.globalKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category.categoryName,
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => ref.read(productListingControllerProvider.notifier).openCloseCategory(category.categoryId),
                icon: Icon(category.isOpened ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 24,),
              )
            ],
          ),
        ),
        if (category.isOpened) ... [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
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
          height: 10,
          width: double.infinity,
          color: AppColors.background2.withAlpha(128),
        )
      ],
    );
  }

  Widget _item(ProductModel product, bool isLast, CartModel? cartModel, CategoryModel category) {
    ProductModel? itemFromCart = cartModel?.cartItems.firstWhereOrNull((element) => element.productId == product.productId);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      product.productName,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      '${AppConsts.currencySymbol} ${product.price}/-',
                      style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.supporting
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      product.description,
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.supporting
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              SizedBox(width: 24,),
              SizedBox(
                height: 130,
                width: 130,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 15,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        height: 110,
                        width: 110,
                        child: ProductImage(
                          imageUrls: product.imageUrls,
                          iconSize: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: itemFromCart != null ? Container(
                        height: 35,
                        padding: EdgeInsets.symmetric(vertical: 6),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.primaryColor,
                            border: Border.all(color: AppColors.screenBgColor, width: 2)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 8,),
                            GestureDetector(
                              onTap: () => ref.read(productListingControllerProvider.notifier).decreaseQuantity(product),
                              child: Icon(Icons.remove, size: 20, color: AppColors.white,),
                            ),
                            Expanded(
                              child: Text(
                                '${itemFromCart.quantity}',
                                style: GoogleFonts.nunito(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(productListingControllerProvider.notifier).increaseQuantity(product),
                              child: Icon(Icons.add, size: 20, color: AppColors.white,)
                            ),
                            SizedBox(width: 8,),
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
            SizedBox(height: 12,),
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
        height: 35,
        padding: EdgeInsets.symmetric(vertical: 6),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.primaryColor,
            border: Border.all(color: AppColors.screenBgColor, width: 2)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ADD',
              style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white
              ),
              textAlign: TextAlign.center,
            ),
            //SizedBox(width: 4,),
            //Icon(Icons.add, size: 14, color: AppColors.heading,)
          ],
        ),
      ),
    );
  }

  Widget _bottomWidget(CartModel? cartModel) {
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
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppConsts.currencySymbol} ${cartModel?.cartTotal ?? 0}',
                  style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black
                  ),
                ),
                Text(
                  'Total',
                  style: GoogleFonts.nunito(
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
                color: AppColors.primaryColor,
                onPressed: () => ref.read(goRouterProvider).push('${CartScreen.routeName}/${widget.businessId}'),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${cartModel?.cartItems.length ?? 0} Items added',
                        style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white
                        ),
                      ),
                      SizedBox(width: 12,),
                      Icon(Icons.arrow_circle_right_outlined, size: 24, color: AppColors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchWidget(List<CategoryModel> menuList) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 40,
              child: CommonTextField(
                onChanged: (val) => ref.read(productListingControllerProvider.notifier).onSearch(val),
                hintText: 'Search Item',
                controller: _searchController,
                hintStyle: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black
                ),
                suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                  onPressed: (){
                    ref.read(productListingControllerProvider.notifier).onSearch('');
                    _searchController.clear();
                  },
                  icon: Icon(Icons.close),
                ) : null,
              ),
            ),
          ),
          SizedBox(width: 16,),
          Expanded(
            flex: 2,
            child: PopupMenuButton(
              onSelected: (val) {
                final category = menuList.firstWhereOrNull((e) => e.categoryName == val.categoryName);
                if (category != null) {
                  Scrollable.ensureVisible(
                    category.globalKey.currentContext!,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 5),
              offset: Offset(0, 50),
              menuPadding: EdgeInsets.only(top: 8, bottom: 8),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              constraints: BoxConstraints(
                minWidth: 150, // Minimum width of the popup
                maxWidth: 150, // Maximum width of the popup
              ),
              itemBuilder: (context) {
                return menuList.map((e) => PopupMenuItem(
                  value: e,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e.categoryName,
                            style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black
                            ),
                          ),
                        ),
                        DashedDivider(color: AppColors.background2,)
                      ],
                    ),
                  ),
                )).toList();
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Menu',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeWidget(BusinessModel? business) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          ProductImage(
            imageUrls: [business?.logo ?? ''],
            height: 100,
            width: 100,
          ),
          SizedBox(width: 12,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business?.name ?? '',
                style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading
                ),
              ),
              SizedBox(height: 4,),
              Text(
                business?.mobile ?? '',
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.supporting
                ),
              ),
              SizedBox(height: 4,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.supporting.withAlpha(104), width: 1)
                ),
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Text(
                  'Open',
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.supporting
                  ),
                ),
              )
            ],
          )
        ]
      ),
    );
  }
}

