import 'package:core/config/app_colors.dart';
import 'package:eazy_order_admin/feature/order/presentations/widgets/order_info_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();

}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  int get _totalPages => (orders.length / _rowsPerPage).ceil();

  List<Map<String, dynamic>> get _paginatedOrders {
    final start = (_currentPage - 1) * _rowsPerPage;
    final end = start + _rowsPerPage;
    return orders.sublist(
      start,
      end > orders.length ? orders.length : end,
    );
  }

  int _currentPage = 1;
  final int _rowsPerPage = 5;

  List<Map<String, dynamic>> orders = [
    {
      "id": "#ORD-1001",
      "date": "12 Sep 2025\n10:30 AM",
      "customer": "Rahul Sharma",
      "status": "Pending",
      "amount": "₹ 1,250",
    },
    {
      "id": "#ORD-1002",
      "date": "13 Sep 2025\n11:00 AM",
      "customer": "Amit Kumar",
      "status": "Completed",
      "amount": "₹ 980",
    },
    {
      "id": "#ORD-1003",
      "date": "14 Sep 2025\n09:15 AM",
      "customer": "Neha Verma",
      "status": "Pending",
      "amount": "₹ 2,100",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8fb),
      endDrawer: const OrderInfoDrawer(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
              decoration: BoxDecoration(color: AppColors.white,
              border: Border.all(color: AppColors.black26)
              ),
              child: const Text(
                "Activity Feed",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black26),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("search  :  ", style: TextStyle(fontSize: 16),),
                  SizedBox(
                    height: 40,
                    width: 220,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),),
                        hintText: "    search..",
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black26),
              ),
              child: DataTable(
                headingRowHeight: 48,
                dataRowHeight: 56,
                columnSpacing: 32,
                headingRowColor: MaterialStateProperty.all(
                  AppColors.grey100,
                ),
                columns: const [
                  DataColumn(label: Text("Order ID")),
                  DataColumn(label: Text("Date & Time")),
                  DataColumn(label: Text("Customer Name")),
                  DataColumn(label: Text("Order Status")),
                  DataColumn(label: Text("Total Amount")),
                  DataColumn(label: Text("Action")),
                ],
                rows: _paginatedOrders.map((order) {
                  return DataRow(
                    cells: [
                      DataCell(Text(order["id"],style: TextStyle(color: AppColors.black45),)),
                      DataCell(Text(order["date"],style: TextStyle(fontSize: 13))),
                      DataCell(Text(order["customer"])),
                      DataCell(Text(order["status"],style: TextStyle(color: order["status"] == "completed" ? AppColors.green : AppColors.red),),),
                      DataCell(Text(order["amount"])),
                      DataCell(
                        Row(
                          children: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(Icons.visibility, color: AppColors.blue),
                                  onPressed: () {
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                );
                              },
                            ),
                            IconButton(
                          onPressed: () {  },
                              icon: Icon(Icons.more_vert, color: AppColors.black38),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left,color: AppColors.black,),
                  onPressed: _currentPage > 1
                      ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                      : null,
                ),
                Text(
                  "Page $_currentPage of $_totalPages",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right,color: AppColors.black,),
                  onPressed: _currentPage < _totalPages
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}