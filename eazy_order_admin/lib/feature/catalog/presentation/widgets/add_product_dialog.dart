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

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({
    super.key,
    required this.businessId,
    this.productname="",
    this.productId=""
  });
  final String businessId;
  final String productname;
  final String productId;


  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController productctrl;
  String? selectedCategoryId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // removed the old hard-coded category string/list to avoid confusion

  bool isLoading = false;
  bool isHovering = false;

  final labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  List<Uint8List> pickedImages = [];

  final CarouselSliderController _carouselController =
  CarouselSliderController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    productctrl = TextEditingController(text: widget.productname);
    // initialize selectedCategoryId from provider if available
    Future.microtask(() {
      final categoryState = ref.read(categoryControllerProvider);
      final cats = categoryState.categoriesList;
      if (cats.isNotEmpty) {
        setState(() {
          selectedCategoryId = cats.first.categoryId;
        });
      }
    });
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
      // LIMIT: remaining allowed images
      int remaining = 3 - pickedImages.length;
      // take only allowed amount
      final newImages = result.files.take(remaining).toList();
      setState(() {
        pickedImages.addAll(newImages.map((f) => f.bytes ?? Uint8List(0)).toList());
      });

      // If user picked more than allowed → show message
      if (result.files.length > remaining) {
        ToastUtils.error('Only 3 images allowed');
      }
    }
  }

  /// ------------------------------
  /// FIXED DELETE FUNCTION
  /// ------------------------------
  void deleteCurrentImage() {
    if (pickedImages.isEmpty) return;

    setState(() {
      pickedImages.removeAt(currentIndex);

      if (pickedImages.isEmpty) {
        currentIndex = 0;
        return;
      }

      if (currentIndex >= pickedImages.length) {
        currentIndex = pickedImages.length - 1;
      }

      // Move carousel smoothly
      _carouselController.animateToPage(currentIndex);
    });
  }

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Ensure a category is selected
      final categoryState = ref.read(categoryControllerProvider);
      final cats = categoryState.categoriesList;
      if (selectedCategoryId == null || cats.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a category")),
        );
        return;
      }

      // find selected category name (your ProductScreen expects category name)
      final selCat = cats.firstWhere(
            (c) => c.categoryId == selectedCategoryId,
        orElse: () => cats.first,
      );
      final selectedCategoryName = selCat.categoryName;

      setState(() => isLoading = true);

      final newProduct = {
        "bytes": pickedImages,
        "name": nameController.text,
        "category": selectedCategoryName,
        // store name (matches your ProductScreen)
        "price": priceController.text,
        "description": descriptionController.text,
      };

      //await widget.onSave(newProduct);

      if (context.mounted) Navigator.pop(context);
    }
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
            SizedBox(
              height: 160,
              width: 160,
              child:
              pickedImages.isEmpty
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
                          pickedImages[currentIndex],
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
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            // Center buttons: Add & Delete
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
                                          backgroundColor: Colors.black,
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
                                        backgroundColor: Colors.black,
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
                                isHovering &&
                                    pickedImages.length > 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentIndex =
                                          (currentIndex -
                                              1 +
                                              pickedImages.length) %
                                              pickedImages.length;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.black,
                                    child: Icon(
                                      Icons
                                          .keyboard_arrow_left_outlined,
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
                                isHovering &&
                                    pickedImages.length > 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentIndex =
                                          (currentIndex + 1) %
                                              pickedImages.length;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.black,
                                    child: Icon(
                                      Icons
                                          .keyboard_arrow_right_outlined,
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

            if (pickedImages.isNotEmpty) ...[
              const SizedBox(height: 8),

              /// ------------------------------
              /// DOT INDICATOR WITH TAP NAVIGATION
              /// ------------------------------
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
        ),
      ),

      content: Form(
        key: _formKey,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Name', style: labelStyle),
              CommonTextFormField(
                controller: nameController,
                hintText: "Enter product name",
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (String p1) {},
              ),
              const SizedBox(height: 10),

              Text('select category', style: labelStyle),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.background2),
                  color: AppColors.background3,
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(
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
                      child: Text(cat.categoryName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategoryId = value);
                  },
                  validator:
                      (value) =>
                  value == null ? 'Please select a category' : null,
                ),
              ),
              const SizedBox(height: 10),

              Text('Price', style: labelStyle),
              CommonTextFormField(
                controller: priceController,
                hintText: "Enter price",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (String p1) {},
              ),
              const SizedBox(height: 10),

              Text('Description', style: labelStyle),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 8,
                  expands: false,
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
                ),
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
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if(!_formKey.currentState!.validate()) return;
            setState(() {
              isLoading = true;
            });

            final controller = ref.read(productControllerProvider.notifier);
            final cats = ref.read(categoryControllerProvider).categoriesList;
            final selCat = cats.firstWhere(
                  (c) => c.categoryId == selectedCategoryId,
              orElse: () => cats.first,
            );
            final selectedCategoryName = selCat.categoryName;

            await controller.saveProduct(
              nameController.text,
              widget.businessId,
              selectedCategoryId!,
              selectedCategoryName,
              priceController.text,
              descriptionController.text,
              pickedImages
            );
            if (context.mounted) Navigator.of(context, rootNavigator: true).pop(true);

          },

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
            'Save',
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