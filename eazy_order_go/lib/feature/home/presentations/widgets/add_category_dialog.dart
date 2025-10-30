
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/home/applications/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({super.key, required this.businessId, this.categoryName = '', this.categoryId = ''});

  final String businessId;
  final String categoryName;
  final String categoryId;

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {

  late final TextEditingController _controller = TextEditingController(text: widget.categoryName);

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(categoryControllerProvider.notifier);
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              '${widget.categoryId.isNotEmpty ? 'Update' : 'Create'} Category',
              style: GoogleFonts.nunito(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black
              )
            ),
            SizedBox(height: 6.h,),
            Text(
                widget.categoryId.isNotEmpty ? 'Update category name' : 'Create Category to add products in it',
                style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black.withAlpha(128)
                )
            ),
            SizedBox(height: 24.h,),
            CommonTextField(
              controller: _controller,
              onChanged: (val) {},
              hintText: 'Category Name',
            ),
            SizedBox(height: 24.h),
            Container(
              alignment: Alignment.centerRight,
              child: AppButton(
                text: 'Save',
                onPressed: () async {
                  if (widget.categoryId.isNotEmpty) {
                    await controller.updateCategoryName(_controller.text, widget.categoryId);
                  } else {
                    await controller.saveCategory(_controller.text, widget.businessId);
                  }
                  ref.read(goRouterProvider).pop(true);
                },
                color: AppColors.primaryButtonColor,
                width: 130.w,
                height: 45.h,
                borderRadius: 12.r,
                textStyle: GoogleFonts.nunito(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
