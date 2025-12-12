
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/category_controller.dart';
import '../widgets/category_delete_dialog.dart';
import '../widgets/add_category_dialog.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String businessId;
  const CategoryScreen({super.key,required this.businessId});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final TextEditingController searchCtrl = TextEditingController();
  List<CategoryModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryControllerProvider.notifier).getAllCategories(widget.businessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryControllerProvider);
    final controller = ref.read(categoryControllerProvider.notifier);
    final categories = categoryState.categoriesList;

    filteredList = searchCtrl.text.isEmpty ? categories : categories
        .where((c) => c.categoryName.toLowerCase().contains(searchCtrl.text.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xfff8f8fb),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- HEADER ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 18, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey300),
                ),
                child: const Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 25),



              // ---------------- SEARCH + ADD BUTTON ----------------


            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.grey300),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;

                  return isMobile
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Search :",
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // search box
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: TextField(
                          controller: searchCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: "Search...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Add button (full width)
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: AppButton(
                          text: "+  Add Category",
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => AddCategoryDialog(
                                businessId: widget.businessId,
                              ),
                            );
                            if (result != null) {
                              controller.getAllCategories(widget.businessId);
                            }
                          },
                          color: AppColors.link,
                          width: double.infinity,
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
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 220,
                        child: TextField(
                          controller: searchCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: "    Search...",
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
                          text: "+  Add Category",
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => AddCategoryDialog(
                                businessId: widget.businessId,
                              ),
                            );
                            if (result != null) {
                              controller.getAllCategories(widget.businessId);
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
                  );
                },
              ),
            ),


            const SizedBox(height: 30),

              // ---------------- TABLE ----------------
              Container(
                width: double.infinity,
                color: AppColors.background3,

                child: filteredList.isEmpty
                    ? SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      "No Category Found !",
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
                        headingRowColor:
                        MaterialStateProperty.all(
                            AppColors.grey100),

                        columns: const [
                          DataColumn(
                            label: SizedBox(
                                width: 200,
                                child: Text("Category Name",style: TextStyle(fontSize: 16.5))),
                          ),
                          DataColumn(
                            label: SizedBox(
                                width: 120,
                                child: Text("Action",style: TextStyle(fontSize: 16.5))),
                          ),
                        ],

                        rows: filteredList.map((cat) {
                          return DataRow(
                            cells: [
                              DataCell(Text(cat.categoryName)),

                            DataCell(
                                Row(
                                  children: [
                                    Checkbox(
                                      value: cat.isActive,
                                      onChanged: (val) {
                                        filteredList = filteredList.map((e) {
                                          if(e.categoryId == cat.categoryId) {
                                            e.isActive = val ?? false;
                                          }
                                          return e;
                                        }).toList();
                                        //ToDo::: Needs to remove
                                        setState(() { });
                                        ref.read(categoryControllerProvider.notifier).onActiveInActive(cat.categoryId, val ?? false);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.edit,
                                          color: AppColors.blue),
                                      onPressed: () async {
                                        final result = await showDialog(
                                          context: context,
                                          builder: (_) => AddCategoryDialog(
                                            businessId: widget.businessId,
                                            categoryname: cat.categoryName,
                                            categoryId: cat.categoryId,
                                          ),
                                        );
                                        if (result != null) {
                                          controller.getAllCategories(widget.businessId);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.delete,
                                          color: AppColors.red
                                      ),
                                      onPressed: () async {
                                        final result = await showDialog(
                                            context: context,
                                            builder: (_) => CategoryDeleteDialog(
                                              categoryName: cat.categoryName,
                                            ),
                                        );
                                        if(result == true){
                                          await ref.read(categoryControllerProvider.notifier).deleteCategory(cat.categoryId);
                                          await controller.getAllCategories(widget.businessId);
                                        }
                                     },
                                    ),
                                  ],
                                )),
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
