
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/applications/category_controller.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:eazy_order_go/feature/home/applications/product_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/add_category_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/add_product_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/delete_category_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/delete_product_dialog.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {

  @override
  void initState() {
    //ref.read(categoryControllerProvider.notifier).getAllCategories(business.businessId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final catState = ref.watch(categoryControllerProvider);
    final state = ref.watch(homeControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.primaryColor,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AddCategoryDialog(businessId: state.businessModel?.businessId ?? '',);
              }
          ).then((val) {
            if (val ?? false) {
              ref.read(categoryControllerProvider.notifier).getAllCategories(state.businessModel?.businessId ?? '');
            }
          });
        },
        child: Icon(Icons.add, color: AppColors.white,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              if (catState.categoryList.isNotEmpty) ... [
                SizedBox(height: 12.h,),
                ListView.builder(
                  itemCount: catState.categoryList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final item = catState.categoryList[index];
                    return _categoryCard(item, state.businessModel?.businessId ?? '');
                  },
                )
              ] else ... [
                Container(
                  height: MediaQuery.of(context).size.height - (kToolbarHeight * 2),
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppImages.icNoCategory,
                    height: 350.h,
                    width: 350.w,
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(CategoryModel category, String businessId) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Card(
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              SizedBox(height: 4.h,),
              GestureDetector(
                onTap: () => ref.read(categoryControllerProvider.notifier).openCloseCategory(category.categoryId),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.categoryName,
                        style: GoogleFonts.nunito(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(categoryControllerProvider.notifier).openCloseCategory(category.categoryId);
                        addCategory(category, businessId);
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.h),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primaryColor
                              )
                          ),
                          child: Icon(Icons.edit, size: 16.h, color: AppColors.primaryColor,)
                      ),
                    ),
                    SizedBox(width: 8.w,),
                    InkWell(
                      onTap: () {
                        ref.read(categoryControllerProvider.notifier).openCloseCategory(category.categoryId);
                        deleteCategory(category.categoryId, businessId);
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.h),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.lightRed
                              )
                          ),
                          child: Icon(Icons.delete_outline_rounded, size: 16.h, color: AppColors.lightRed,)
                      ),
                    ),
                    IconButton(
                      onPressed: () => ref.read(categoryControllerProvider.notifier).openCloseCategory(category.categoryId),
                      icon: Icon(category.isOpened ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 24.h,),
                    )
                  ],
                ),
              ),
              if (category.isOpened) ... [
                if (category.products.isEmpty) ... [
                  SizedBox(height: 40.h,),
                  Text(
                    'No Products',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 12.h,),
                  AppButton(
                    text: '+ Add',
                    onPressed: () {
                      _productDialog(businessId, category.categoryId);
                    },
                    color: AppColors.imageBgColor,
                    width: 100.w,
                    height: 35.h,
                    borderRadius: 32.r,
                    textStyle: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 40.h,),
                ] else ... [
                  ListView.builder(
                    itemCount: category.products.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final item = category.products[index];
                      return _productCard(item, category, businessId, index == category.products.length - 1);
                    },
                  ),
                  SizedBox(height: 4.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      AppButton(
                        text: '+ Add More',
                        onPressed: () {
                          _productDialog(businessId, category.categoryId);
                        },
                        color: AppColors.accentColor,
                        width: 130.w,
                        height: 35.h,
                        borderRadius: 32.r,
                        textStyle: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h,),
                ]
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(ProductModel product, CategoryModel category, String businessId, bool isLast) {
    return Column(
      children: [
        SizedBox(height: 12.h,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(
              imageUrls: product.imageUrls,
              height: 70,
              width: 70,
            ),
            SizedBox(width: 16.w,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h,),
                  Text(
                    product.productName,
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black
                    ),
                  ),
                  Text(
                    '${AppConsts.currencySymbol} ${product.price}/-',
                    style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.heading
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Edit',
                        style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          decoration: TextDecoration.underline
                        ),
                      ),
                      Icon(Icons.arrow_right, size: 20,)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w,),
            Column(
              children: [
                SizedBox(height: 3.h,),
                CommonSwitch(
                  value: product.isActive,
                  onChanged: (val) {
                    ref.read(productControllerProvider.notifier).activeInactiveProduct(
                        category, product.productId, !product.isActive);
                  },
                  activeTrackColor: AppColors.green,
                ),
                SizedBox(height: 8.w,),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withAlpha(204)
                  ),
                  height: 30.h,
                  width: 30.w,
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteProductDialog();
                          }
                      ).then((val) async {
                        if (val ?? false) {
                          await ref.read(productControllerProvider.notifier).deleteProduct(category, product.productId);
                        }
                      });
                    },
                    focusColor: AppColors.lightRed,
                    icon: Icon(Icons.delete, size: 14.h, color: AppColors.white,),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h,),
        if (!isLast) ... [
          DashedDivider(color: AppColors.borderColor,),
        ],
        //Divider(color: AppColors.heading, thickness: 0.3.h,),
      ],
    );
  }

  void _productDialog(String businessId, String categoryId) {
    showDialog(
        context: context,
        builder: (context) {
          return AddProductDialog(businessId: businessId, categoryId: categoryId,);
        }
    ).then((val) {
      if (val ?? false) {
        ref.read(categoryControllerProvider.notifier).getAllCategories(businessId);
      }
    });
  }

  void deleteCategory(String categoryId, String businessId) {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteCategoryDialog();
        }
    ).then((val) async {
      if (val ?? false) {
        final controller = ref.read(categoryControllerProvider.notifier);
        await controller.deleteCategory(categoryId);
        controller.getAllCategories(businessId);
      }
    });
  }

  void addCategory(CategoryModel category, String businessId) {
    showDialog(
        context: context,
        builder: (context) {
          return AddCategoryDialog(
            businessId: businessId,
            categoryId: category.categoryId,
            categoryName: category.categoryName,
          );
        }
    ).then((val) {
      if (val ?? false) {
        ref.read(categoryControllerProvider.notifier).getAllCategories(businessId);
      }
    });
  }
}
