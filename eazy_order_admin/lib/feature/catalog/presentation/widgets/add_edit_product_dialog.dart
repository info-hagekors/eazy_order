import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/core.dart';
import 'package:eazy_order_admin/feature/catalog/application/category_controller.dart';
import 'package:eazy_order_admin/feature/catalog/application/product_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';

class ProductAddEditDialog extends ConsumerStatefulWidget {
  final String businessId;
  final ProductModel? product;

  const ProductAddEditDialog({super.key, required this.businessId, this.product});

  bool get isEdit => product != null;

  @override
  ConsumerState<ProductAddEditDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends ConsumerState<ProductAddEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  String? selectedCategoryId;

  bool isLoading = false;
  bool isHovering = false;

  List<Uint8List> pickedImages = [];
  List<Uint8List> existingImages = [];

  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentIndex = 0;

  final labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      final p = widget.product!;
      nameController = TextEditingController(text: p.productName);
      priceController = TextEditingController(text: p.price.toString());
      descriptionController = TextEditingController(text: p.description);
      existingImages = []; // Load from product if required

      Future.microtask(() {
        final cats = ref.read(categoryControllerProvider).categoriesList;
        if (cats.isEmpty) return;

        final found = cats.firstWhere(
          (c) => c.categoryId == p.categoryId,
          orElse: () => cats.first,
        );

        setState(() => selectedCategoryId = found.categoryId);
      });
    } else {
      nameController = TextEditingController();
      priceController = TextEditingController();
      descriptionController = TextEditingController();

      Future.microtask(() {
        final cats = ref.read(categoryControllerProvider).categoriesList;
        if (cats.isNotEmpty) {
          setState(() => selectedCategoryId = cats.first.categoryId);
        }
      });
    }
  }

  Future pickMultipleImages() async {
    if (pickedImages.length >= 3) {
      ToastUtils.error("You can upload maximum 3 images");
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      int remaining = 3 - pickedImages.length;
      final newFiles = result.files.take(remaining);

      setState(() {
        pickedImages.addAll(newFiles.map((f) => f.bytes!));
      });

      if (result.files.length > remaining) {
        ToastUtils.error("Only 3 images allowed");
      }
    }
  }

  Future pickNewImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedImages.addAll(result.files.map((f) => f.bytes!));
      });
    }
  }

  void deleteCurrentImage() {
    if (pickedImages.isEmpty) return;

    setState(() {
      pickedImages.removeAt(currentIndex);
      currentIndex =
          (currentIndex >= pickedImages.length)
              ? pickedImages.length - 1
              : currentIndex;
    });
  }

  Widget buildImageOval() {
    final bool empty = pickedImages.isEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 160,
          width: 160,
          child:
              empty
                  ? CircleAvatar(
                    radius: 80,
                    backgroundColor: AppColors.background2,
                    child: InkWell(
                      onTap: pickMultipleImages,
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        size: 40,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                  : Stack(
                    children: [
                      ClipOval(
                        child: CarouselSlider(
                          items:
                              pickedImages.map((imgBytes) {
                                return Image.memory(
                                  imgBytes,
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 160,
                                );
                              }).toList(),
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: 160,
                            viewportFraction: 1,
                            autoPlay: !isHovering,
                            autoPlayInterval: const Duration(seconds: 3),
                            enableInfiniteScroll: pickedImages.length > 1,
                            onPageChanged: (index, reason) {
                              setState(() => currentIndex = index);
                            },
                          ),
                        ),
                      ),

                      // Hover overlay
                      Positioned.fill(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => isHovering = true),
                          onExit: (_) => setState(() => isHovering = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color:
                                  isHovering
                                      ? AppColors.white.withAlpha(174)
                                      : AppColors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                // Center Add/Delete buttons
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (pickedImages.length < 3)
                                        Opacity(
                                          opacity: isHovering ? 1 : 0,
                                          child: InkWell(
                                            onTap: pickMultipleImages,
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: AppColors.black,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 5),
                                      Opacity(
                                        opacity: isHovering ? 1 : 0,
                                        child: InkWell(
                                          onTap: deleteCurrentImage,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppColors.black,
                                            child: Icon(
                                              Icons.delete,
                                              color: AppColors.red,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Left arrow
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Visibility(
                                    visible:
                                        isHovering && pickedImages.length > 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentIndex =
                                              (currentIndex -
                                                  1 +
                                                  pickedImages.length) %
                                              pickedImages.length;
                                        });
                                        _carouselController.animateToPage(
                                          currentIndex,
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppColors.black,
                                        child: Icon(
                                          Icons.keyboard_arrow_left_outlined,
                                          color: AppColors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Right arrow
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Visibility(
                                    visible:
                                        isHovering && pickedImages.length > 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentIndex =
                                              (currentIndex + 1) %
                                              pickedImages.length;
                                        });
                                        _carouselController.animateToPage(
                                          currentIndex,
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppColors.black,
                                        child: Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: AppColors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),

        // DOT INDICATOR
        if (!empty && pickedImages.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                pickedImages.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(idx);
                    },
                    child: Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            currentIndex == idx
                                ? AppColors.primaryColor
                                : AppColors.background2,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }

  void submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    final cats = ref.read(categoryControllerProvider).categoriesList;

    final selCat = cats.firstWhere(
      (c) => c.categoryId == selectedCategoryId,
      orElse: () => cats.first,
    );

    if (widget.isEdit) {
      final p = widget.product!;
      p.productName = nameController.text;
      p.price = double.parse(priceController.text);
      p.description = descriptionController.text;
      p.categoryId = selectedCategoryId!;
      p.categoryName = selCat.categoryName;

      await ref.read(productControllerProvider.notifier).updateProduct(p);
    } else {
      await ref
          .read(productControllerProvider.notifier)
          .saveProduct(
            nameController.text,
            widget.businessId,
            selectedCategoryId!,
            selCat.categoryName,
            priceController.text,
            descriptionController.text,
            pickedImages,
          );
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryControllerProvider).categoriesList;
    final productState = ref.watch(productControllerProvider);

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

      title: Center(child: buildImageOval()),

      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Name", style: labelStyle),
                CommonTextFormField(
                  controller: nameController,
                  validator:
                      (v) => v == null || v.trim().isEmpty ? "Required" : null,
                  onChanged: (String p1) {},
                ),
                SizedBox(height: 10),

                Text("Category", style: labelStyle),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.background2),
                    color: AppColors.background3,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
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
                    items:
                        categories.map((cat) {
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
                    validator:
                        (value) =>
                            value == null ? "Please select a category" : null,
                  ),
                ),

                SizedBox(height: 10),
                Text("Price", style: labelStyle),
                CommonTextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator:
                      (v) => v == null || v.trim().isEmpty ? "Required" : null,
                  onChanged: (String p1) {},
                ),

                SizedBox(height: 10),
                Text("Description", style: labelStyle),
                SizedBox(
                  height: 120,
                  child: CommonTextFormField(
                    controller: descriptionController,
                    maxLines: 8,
                    onChanged: (String p1) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: productState.isLoading ? null : () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: productState.isLoading ? null : submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          child: productState.isLoading
                  ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(
                    widget.isEdit ? "Update" : "Save",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        ),
      ],
    );
  }
}
