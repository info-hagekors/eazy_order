import 'package:core/core.dart';
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

import '../../applications/category_controller.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    final catState = ref.watch(categoryControllerProvider);
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddCategoryDialog(
                businessId: state.businessModel?.businessId ?? '',
              );
            },
          ).then((val) {
            if (val ?? false) {
              ref
                  .read(categoryControllerProvider.notifier)
                  .getAllCategories(state.businessModel?.businessId ?? '');
            }
          });
        },
        child: Icon(Icons.add, color: AppColors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 15),
              if (catState.categoryList.isNotEmpty) ...[
                ListView.builder(
                  itemCount: catState.categoryList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final item = catState.categoryList[index];
                    return _categoryCard(
                      item,
                      state.businessModel?.businessId ?? '',
                    );
                  },
                ),
              ] else ...[
                Container(
                  height:
                      MediaQuery.of(context).size.height -
                      (kToolbarHeight * 3.85),
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppImages.icNoCategory,
                    height: 350.h,
                    width: 350.w,
                  ),
                ),
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
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap:
                      () => ref
                          .read(categoryControllerProvider.notifier)
                          .openCloseCategory(category.categoryId),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          category.categoryName,
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () => ref
                                .read(categoryControllerProvider.notifier)
                                .openCloseCategory(category.categoryId),
                        icon: Icon(
                          category.isOpened
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryColor,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (category.isOpened) ...[
                  if (category.products.isEmpty) ...[
                    SizedBox(height: 40.h),
                    Text(
                      'No Products',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      text: '+ Add',
                      onPressed: () {
                        _productDialog(businessId, category.categoryId);
                      },
                      color: AppColors.primaryColor,
                      width: 100.w,
                      height: 35.h,
                      borderRadius: 32.r,
                      textStyle: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ] else ...[
                    ListView.builder(
                      itemCount: category.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final item = category.products[index];
                        return _productCard(
                          item,
                          category,
                          businessId,
                          index == category.products.length - 1,
                        );
                      },
                    ),
                    SizedBox(height: 2.h),

                    Row(
                      children: [
                        // Edit button (PopupMenuButton styled same as Add More)
                        Container(
                          width: 175.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: AppColors.bgColor2,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_calendar,
                                    color: AppColors.primaryColor,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    "   Edit ",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              onSelected: (value) {
                                if (value == 'edit') {
                                  ref
                                      .read(categoryControllerProvider.notifier)
                                      .openCloseCategory(category.categoryId);
                                  addCategory(category, businessId);
                                } else if (value == 'delete') {
                                  ref
                                      .read(categoryControllerProvider.notifier)
                                      .openCloseCategory(category.categoryId);
                                  deleteCategory(
                                    category.categoryId,
                                    businessId,
                                  );
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: AppColors.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Edit Category'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: AppColors.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Delete Category'),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ),
                        ),

                        SizedBox(width: 14.w),

                        // + Add More button
                        AppButton(
                          text: '+ Add More',
                          onPressed: () {
                            _productDialog(businessId, category.categoryId);
                          },
                          color: AppColors.primaryColor,
                          width: 175.w,
                          height: 45.h,
                          borderRadius: 11.r,
                          // fully circular
                          textStyle: GoogleFonts.nunito(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCard(
      ProductModel product,
      CategoryModel category,
      String businessId,
      bool isLast,
      ) {
    final bool isDisabled = !product.isActive;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          // 🟢 Only this Row (the product itself) gets the opacity effect
          Opacity(
            opacity: isDisabled ? 0.4 : 1.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImage(
                  imageUrls: product.imageUrls,
                  height: 150.h,
                  width: 150.w,
                ),
                SizedBox(width: 22.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: GoogleFonts.nunito(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        '${AppConsts.currencySymbol} ${product.price}/-',
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.heading,
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
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const Icon(Icons.arrow_right, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),

                // ---------------- Popup Menu -----------------
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  icon: Icon(Icons.edit, color: AppColors.primaryColor, size: 22.sp),
                  onSelected: (value) async {
                    if (value == 'toggle') {
                      await ref
                          .read(productControllerProvider.notifier)
                          .activeInactiveProduct(
                        category,
                        product.productId,
                        !product.isActive,
                      );

                      // Refresh the product list
                      ref
                          .read(categoryControllerProvider.notifier)
                          .getAllCategories(businessId);
                    } else if (value == 'delete') {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => const DeleteProductDialog(),
                      );

                      if (confirmed ?? false) {
                        await ref
                            .read(productControllerProvider.notifier)
                            .deleteProduct(category, product.productId);

                        ref
                            .read(categoryControllerProvider.notifier)
                            .getAllCategories(businessId);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'toggle',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Active'),
                          CommonSwitch(
                            value: product.isActive,
                            onChanged: (val) async {
                              Navigator.pop(context);
                              await ref
                                  .read(productControllerProvider.notifier)
                                  .activeInactiveProduct(
                                category,
                                product.productId,
                                val,
                              );

                              ref
                                  .read(categoryControllerProvider.notifier)
                                  .getAllCategories(businessId);
                            },
                            activeTrackColor: AppColors.green,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.primaryColor),
                          const SizedBox(width: 8),
                          const Text('Delete Product'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),
          if (!isLast)
            Divider(
              color: AppColors.primaryColor,
              thickness: 0.5,
            )
        ],
      ),
    );
  }


  void _productDialog(String businessId, String categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AddProductDialog(businessId: businessId, categoryId: categoryId);
      },
    ).then((val) {
      if (val ?? false) {
        ref
            .read(categoryControllerProvider.notifier)
            .getAllCategories(businessId);
      }
    });
  }

  void deleteCategory(String categoryId, String businessId) {
    showDialog(
      context: context,
      builder: (context) {
        return const DeleteCategoryDialog();
      },
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
      },
    ).then((val) {
      if (val ?? false) {
        ref
            .read(categoryControllerProvider.notifier)
            .getAllCategories(businessId);
      }
    });
  }
}
