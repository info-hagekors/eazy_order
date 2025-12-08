import 'package:core/config/app_colors.dart';
import 'package:core/widgets/app_button.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/catalog/application/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({
    super.key,
    required this.businessId,
    this.categoryname = '',
    this.categoryId = '',
  });

  final String businessId;
  final String categoryname;
  final String categoryId;

  @override
  ConsumerState<AddCategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController categoryCtrl;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    categoryCtrl = TextEditingController(text: widget.categoryname);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoryId.isNotEmpty;

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEdit ? "Update Category" : "Create Category",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 13)
        ],
      ),

      content: SizedBox(
        width: 400,
        height: 90,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Text(
                "Category Name :",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 8),

              // TextField (same UI as Add User dialog)
              TextFormField(
                controller: categoryCtrl,
                decoration: InputDecoration(
                  hintText: "Enter Category Name",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.background2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Required" : null,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final newValue =
                        value[0].toUpperCase() + value.substring(1);
                    if (newValue != value) {
                      categoryCtrl.value = TextEditingValue(
                        text: newValue,
                        selection: TextSelection.collapsed(offset: newValue.length),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),


      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),

        SizedBox(
          width: 110,   // adjust if needed
          height: 35,
          child: AppButton(
            text: isLoading ? '' : (isEdit ? "Update" : "Save"),
            color: AppColors.primaryColor,
            borderRadius: 25,
            isLoading: isLoading,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: AppColors.white,
              fontSize: 16,
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              setState(() => isLoading = true);

              final controller = ref.read(categoryControllerProvider.notifier);
              final text = categoryCtrl.text.trim();

              if (isEdit) {
                await controller.updateCategory(text, widget.categoryId,);
              } else {
                await controller.savaCategory(text, widget.businessId,);
              }
              ref.read(goRouterProvider).pop(true);
            },
          ),
        ),
      ],
    );
  }
}
