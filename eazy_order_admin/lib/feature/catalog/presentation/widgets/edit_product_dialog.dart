import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProductDialog extends StatefulWidget {
  final Map product;
  final Function(Map<String, dynamic>) onUpdate;

  const EditProductDialog({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  late String category;
  //String imagePath = "assets/images/for no image.png";

  final List<String> categoryList = [
    "Electronics",
    "Clothes",
    "Shoes",
    "Grocery",
  ];

  bool isLoading = false;

  final labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product["name"]);
    priceController = TextEditingController(text: widget.product["price"]);
    descriptionController = TextEditingController(
      text: widget.product["description"],
    );

    category = widget.product["category"];
  }

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);

      final updatedProduct = {
        "image": "assets/images/for no image.png",
        "name": nameController.text,
        "category": category,
        "price": priceController.text,
        "description": descriptionController.text,
      };

      await widget.onUpdate(updatedProduct);

      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),

            InkWell(
              onTap: (){

              },
              child: CircleAvatar(
                  radius: 70,
                  backgroundColor: AppColors.background2,
                  child: Icon(Icons.add_a_photo_rounded,color: AppColors.white,size: 35),
                  //backgroundImage: AssetImage(imagePath),
                ),
            ),
            SizedBox(height: 10,)
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
              // Product Name
              Text('Product Name', style: labelStyle),
              CommonTextFormField(
                controller: nameController,
                hintText: "Enter product name",
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (String p1) {},
              ),
              const SizedBox(height: 10),

              // Category
              Text('Category', style: labelStyle),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.background2),
                  color: AppColors.background3,
                ),
                child: DropdownButtonFormField(
                  value: category,
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
                      categoryList
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: labelStyle.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => category = val ?? ""),
                ),
              ),
              const SizedBox(height: 10),

              // Price
              Text('Price', style: labelStyle),
              CommonTextFormField(
                controller: priceController,
                hintText: "Enter price",
                keyboardType: TextInputType.number,
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (String p1) {},
              ),
              const SizedBox(height: 10),

              // Description
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
                    borderSide: BorderSide(color: AppColors.primaryButtonColor, width: 2), // when focused
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
          child:
              isLoading
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
