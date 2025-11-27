import 'package:core/config/app_colors.dart';
import 'package:core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/edit_product_dialog.dart';
import '../widgets/product_delete_dialog.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];
  List filteredProducts = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterProducts);
    searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = query.isEmpty
          ? products
          : products
          .where((p) =>
      p["name"].toLowerCase().contains(query) ||
          p["category"].toLowerCase().contains(query) ||
          p["price"].toString().contains(query))
          .toList();
    });
  }

  // OPEN ADD PRODUCT DIALOG
  void openAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        onSave: (product) {
          setState(() => products.add(product));
          _filterProducts();
        },
      ),
    );
  }

  // OPEN EDIT PRODUCT DIALOG
  void openEditProductDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        product: products[index],
        onUpdate: (updatedProduct) {
          setState(() => products[index] = updatedProduct);
          _filterProducts();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8fb),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // BOX 1 — TITLE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // BOX 2 — SHOW ENTRIES + SEARCH + ADD BUTTON
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("Show "),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton<int>(
                            underline: const SizedBox(),
                            value: 10,
                            items: const [
                              DropdownMenuItem(
                                value: 10,
                                child: Text("10"),
                              )
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                        const Text(" entries"),
                      ],
                    ),

                    Row(
                      children: [
                        const Text(
                          "Search :  ",
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 220,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "     Search...",
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        SizedBox(
                          height: 40,
                          child: AppButton(
                            text: "+  Add Product",
                            onPressed: openAddProductDialog,
                            color: AppColors.link,
                            width: 170,
                            height: 40,
                            borderRadius: 8,
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // BOX 3 — TABLE OR EMPTY STATE
              Container(
                width: double.infinity,
                child: filteredProducts.isEmpty
                    ? SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      "No Product Found !",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: AppColors.white,
                    width: 1230,
                    child: DataTable(
                      columnSpacing: 60,
                      headingRowHeight: 46,
                      dataRowHeight: 56,
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                      ),
                      headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade100),
                      columns: [
                        DataColumn(
                          label: SizedBox(width: 50, child: Text("Image")),
                        ),
                        DataColumn(
                          label: SizedBox(width: 180, child: Text("Name")),
                        ),
                        DataColumn(
                          label:
                          SizedBox(width: 120, child: Text("Category")),
                        ),
                        DataColumn(
                          label: SizedBox(width: 100, child: Text("Price")),
                        ),
                        DataColumn(
                          label: SizedBox(width: 70, child: Text("Action")),
                        ),
                      ],
                      rows: filteredProducts.map((product) {
                        int index = products.indexOf(product);

                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 50,
                                child: Image.asset(
                                  product["image"],
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                            DataCell(Text(product["name"])),
                            DataCell(Text(product["category"])),
                            DataCell(
                              Text(
                                "₹ ${product["price"]}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 82,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () =>
                                          openEditProductDialog(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async{
                                        final confirm= await showDialog(
                                            context: context,
                                            builder: (context)=>ProductDeleteDialog(productName: '',),);
                                        if(confirm == true){
                                          setState(() {
                                            products.remove(product);
                                            _filterProducts();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
