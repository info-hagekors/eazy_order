import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/config/app_colors.dart';
import 'package:core/core.dart';
import 'package:core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/product_controller.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/edit_product_dialog.dart';
import '../widgets/product_delete_dialog.dart';

class ProductScreen extends ConsumerStatefulWidget {

  final String businessId;
  final String categoryId;

  const ProductScreen({
    super.key,
    required this.businessId,
    required this.categoryId
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {

  List product = [];
  List<ProductModel> filteredProducts = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(productControllerProvider.notifier).getAllProducts(widget.businessId);
      _filterProducts();
      searchController.addListener(_filterProducts);
    });
  }


  @override
  void dispose() {
    searchController.removeListener(_filterProducts);
    searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final state = ref.read(productControllerProvider);
    final allProductsForCategory = state.products;

// apply search filter
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredProducts = query.isEmpty
          ? allProductsForCategory
          : allProductsForCategory.where((p) {
        final name = p.productName.toLowerCase();
        final category = p.categoryName.toLowerCase(); // or categoryName if you have one
        final price = p.price.toString();

        return name.contains(query) ||
            category.contains(query) ||
            price.contains(query);
        }).toList();
    });
  }


  Future loadProducts() async {
    await ref.read(productControllerProvider.notifier).getAllProducts(widget.businessId);
    _filterProducts();
  }

  @override
  Widget build(BuildContext context) {
    final controller= ref.read(productControllerProvider.notifier);
    final state = ref.watch(productControllerProvider);
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
                  border: Border.all(color: AppColors.grey300),
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
                  border: Border.all(color: AppColors.grey300),
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
                            border: Border.all(color: AppColors.grey400),
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
                            onPressed: () async{
                              final result = await showDialog(
                                  context: context,
                                  builder: (context)=> AddProductDialog(
                                      businessId: widget.businessId
                                  )
                              );
                              if(result == true){
                                await loadProducts();
                              }
                            },
                            color: AppColors.link,
                            width: 170,
                            height: 40,
                            borderRadius: 8,
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
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
                    : Container(
                      color: AppColors.white,
                      width: double.infinity,
                      child: DataTable(
                        columnSpacing: 24,
                        headingRowHeight: 46,
                        dataRowHeight: 56,
                        border: TableBorder.all(
                          color: AppColors.grey300,
                        ),
                        headingRowColor: MaterialStateProperty.all(
                            AppColors.grey100),
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
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: (product.imageUrls != null && product.imageUrls.isNotEmpty)
                                      ? CarouselSlider(
                                    options: CarouselOptions(
                                      height: 50,
                                      autoPlay: true,
                                      viewportFraction: 1,
                                      enableInfiniteScroll: true,
                                      autoPlayInterval: const Duration(seconds: 2),
                                      autoPlayAnimationDuration: const Duration(seconds: 2),
                                      scrollPhysics: const NeverScrollableScrollPhysics(),
                                    ),
                                    items: product.imageUrls.map<Widget>((imageUrls) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          imageUrls,
                                          width: 60,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }).toList(),
                                  )
                                      : Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.background2,
                                    ),
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 20,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(product.productName)),
                              DataCell(Text(product.categoryName.isNotEmpty ? product.categoryName : '-'),),
                              DataCell(
                                Text(
                                  "₹ ${product.price}",
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Checkbox(
                                      value: product.isActive,
                                      onChanged: (val) {
                                        filteredProducts = filteredProducts.map((e) {
                                          if(e.productId == product.productId) {
                                            e.isActive = val ?? false;
                                          }
                                          return e;
                                        }).toList();
                                        //ToDo::: Needs to remove
                                        setState(() { });
                                        ref.read(productControllerProvider.notifier).onActiveInActive(product.productId, val ?? false);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: AppColors.blue),
                                      onPressed: ()async {
                                        showDialog(
                                            context: context,
                                            builder: (context)=> EditProductDialog(
                                                businessId: widget.businessId,
                                                product: product
                                            )
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: AppColors.red),

                                      onPressed: () async{
                                        final result= await showDialog(
                                          context: context,
                                          builder: (context)=>ProductDeleteDialog(
                                            productId: product.productId,
                                            businessId: widget.businessId,
                                            productName: product.productName,
                                          ),
                                        );
                                        if(result == true){


                                         await controller.deleteProduct(product.productId);

                                          await controller.getAllProducts(widget.businessId);
                                          setState(() {
                                            _filterProducts();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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