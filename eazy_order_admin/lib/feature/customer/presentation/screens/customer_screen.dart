import 'package:core/config/app_colors.dart';
import 'package:eazy_order_admin/feature/dashboard/presentation/widgets/header.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late final List<Map<String, dynamic>> customers;
  final TextEditingController _searchctr = TextEditingController();
  List<Map<String, dynamic>> filteredCustomers = [];


  @override
  void initState() {
    super.initState();

    customers = [
      {
        "customerId": "CUST001",
        "customerName": "Rahul Sharma",
        "orderId": "#ORD1001",
        "status": "Active",
      },
      {
        "customerId": "CUST002",
        "customerName": "Neha Verma",
        "orderId": "#ORD1002",
        "status": "Inactive",
      },
      {
        "customerId": "CUST003",
        "customerName": "Amit Patel",
        "orderId": "#ORD1003",
        "status": "Blocked",
      },
    ];
    filteredCustomers = List.from(customers);
  }
  void _onSearch(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredCustomers = List.from(customers);
      } else {
        final query = value.toLowerCase();
        filteredCustomers = customers.where((customer) {
          return customer["customerId"].toLowerCase().contains(query) ||
              customer["customerName"].toLowerCase().contains(query) ||
              customer["orderId"].toLowerCase().contains(query) ||
              customer["status"].toLowerCase().contains(query);
        }).toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background3,
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
        child: Column(
          children: [
            AppHeader(),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black12),
              ),
              child: Row(
                children: [
                  Text(
                    "Customer",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                    ),
                  ),
                  Spacer(),

                  SizedBox(
                    height: 40,
                    width: 220,
                    child: TextField(
                      controller: _searchctr,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: "search name",
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: AppColors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: AppColors.black)
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.white,),
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowHeight: 48,
                  dataRowHeight: 47,
                  columnSpacing: 32,
                  dividerThickness: 0.01,
                  headingRowColor: MaterialStateProperty.all(AppColors.grey300),
                  columns: [
                    DataColumn(
                      label: Text(
                        "customer Id",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "customer Name",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DataColumn(
                      label: Text("Order Id", style: TextStyle(fontSize: 14)),
                    ),
                    DataColumn(
                      label: Text("Action", style: TextStyle(fontSize: 14)),
                    ),
                    DataColumn(
                      label: Text("status", style: TextStyle(fontSize: 14)),
                    ),
                  ],
                  rows: filteredCustomers.isEmpty
                      ? []
                      : filteredCustomers.map((customer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(customer["customerId"])),
                        DataCell(Text(customer["customerName"])),
                        DataCell(Text(customer["orderId"])),

                        DataCell(
                          IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: AppColors.blue,
                              size: 18,
                            ),
                            onPressed: () {

                            },
                          ),
                        ),

                        DataCell(
                          Row(
                            children: [
                              Icon(
                                customer["status"] == "Active"
                                    ? Icons.check_circle
                                    : customer["status"] == "Inactive"
                                    ? Icons.pause_circle
                                    : Icons.block,
                                size: 14,
                                color: customer["status"] == "Active"
                                    ? Colors.green
                                    : customer["status"] == "Inactive"
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                customer["status"],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: customer["status"] == "Active"
                                      ? Colors.green
                                      : customer["status"] == "Inactive"
                                      ? Colors.orange
                                      : Colors.red,
                                ),
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
    );
  }
}
