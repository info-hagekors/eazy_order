import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/core.dart';
import 'package:eazy_order_admin/feature/catalog/application/category_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';

class EditProductDialog extends ConsumerStatefulWidget {
  final String businessId;
  final ProductModel product;

  const EditProductDialog({
    super.key,
    required this.businessId,
    required this.product,
  });

  @override
  ConsumerState<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends ConsumerState<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  List<Uint8List> pickedImages = [];
  List<Uint8List> existingImages = [];

  String? selectedCategoryId; // changed
  bool isLoading = false;

  final labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.productName);
    priceController = TextEditingController(text: widget.product.price.toString());
    descriptionController = TextEditingController(text: widget.product.description);

// For now we don’t have bytes for existing images; keep this as empty.
    existingImages = [];

    // We will set the selectedCategoryId in a microtask
    Future.microtask(() {
      final categoryState = ref.read(categoryControllerProvider);
      final cats = categoryState.categoriesList;

      if (cats.isEmpty) return;

      // match categoryName with product category string
      final found = cats.firstWhere(
            (c) => c.categoryId == widget.product.categoryId,
        orElse: () => cats.first,
      );

      setState(() {
        selectedCategoryId = found.categoryId;
      });
    });
  }

  Future pickNewImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedImages.addAll(result.files.map((f) => f.bytes!).toList());
      });
    }
  }

  void submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }

    setState(() => isLoading = true);

    // 1) Resolve selected category name
    final categoryState = ref.read(categoryControllerProvider);
    final cats = categoryState.categoriesList;
    final selCat = cats.firstWhere(
          (c) => c.categoryId == selectedCategoryId,
      orElse: () => cats.first,
    );

    // 2) Create a new ProductModel with updated fields
    final updatedProduct = ProductModel(
      productId: widget.product.productId,
      productName: nameController.text,
      categoryId: selectedCategoryId!,
      categoryName: selCat.categoryName,
      businessId: widget.product.businessId,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? widget.product.price,
      isActive: widget.product.isActive,
      imageUrls: widget.product.imageUrls, // keep existing URLs for now
      quantity: widget.product.quantity,
      createdAt: widget.product.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    // 3) Call controller to persist
    /*await ref
        .read(productControllerProvider.notifier)
        .updateproductfromcontroller(updatedProduct);*/

    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryControllerProvider);
    final categories = categoryState.categoriesList;

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Center(
        child: Column(
          children: [
            InkWell(
              onTap: pickNewImage,
              child: SizedBox(
                height: 160,
                width: 160,
                child: (existingImages.isEmpty && pickedImages.isEmpty)
                    ? CircleAvatar(
                  radius: 70,
                  backgroundColor: AppColors.background2,
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                )
                    : ClipOval(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      viewportFraction: 1,
                    ),
                    items: [
                      ...existingImages.map(
                            (img) => Image.memory(
                          img,
                          fit: BoxFit.cover,
                          width: 160,
                          height: 160,
                        ),
                      ),
                      ...pickedImages.map(
                            (img) => Image.memory(
                          img,
                          fit: BoxFit.cover,
                          width: 160,
                          height: 160,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      content: Form(
        key: _formKey,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Product Name
              Text('Product Name', style: labelStyle),
              CommonTextFormField(
                controller: nameController,
                hintText: "Enter product name",
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null, onChanged: (String p1) {  },
              ),
              const SizedBox(height: 10),

              /// Category ( dynamic dropdown )
              Text('Category', style: labelStyle),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.background2),
                  color: AppColors.background3,
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.background3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.background3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.borderColor),
                    ),
                  ),
                  iconEnabledColor: AppColors.black,
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.categoryId,
                      child: Text(
                        cat.categoryName,
                        style: labelStyle.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategoryId = value);
                  },
                  validator: (v) =>
                  v == null ? "Please select a category" : null,
                ),
              ),
              const SizedBox(height: 10),

              /// Price
              Text('Price', style: labelStyle),
              CommonTextFormField(
                controller: priceController,
                hintText: "Enter price",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null, onChanged: (String p1) {  },
              ),
              const SizedBox(height: 10),

              /// Description
              Text('Description', style: labelStyle),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: " Enter product description",
                  hintStyle: GoogleFonts.poppins(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: AppColors.primaryButtonColor,
                      width: 2,
                    ),
                  ),
                ),
                minLines: 4,
                maxLines: 8,
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: isLoading ? null : submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          child: isLoading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(
            'Update',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}


