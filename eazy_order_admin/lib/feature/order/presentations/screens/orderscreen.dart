import 'package:core/config/app_colors.dart';
import 'package:eazy_order_admin/feature/dashboard/presentation/widgets/header.dart';
import 'package:eazy_order_admin/feature/order/presentations/widgets/order_info_drawer.dart';
import 'package:eazy_order_admin/feature/order/presentations/widgets/order_status_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final TextEditingController _searchctr = TextEditingController();
  String _searchtxt = "";

  int _currentPage = 1;
  final int _rowsPerPage =
      10; //this is for the data which are show in first page........
  int get _totalPages =>
      (_filteredOrders.length / _rowsPerPage).ceil().clamp(1, 999);

  List<Map<String, dynamic>> get _paginatedOrders {
    final start = (_currentPage - 1) * _rowsPerPage;
    final end = start + _rowsPerPage;
    return _filteredOrders.sublist(
      start,
      end > _filteredOrders.length ? _filteredOrders.length : end,
    );
  }

  List<Map<String, dynamic>> orders = [
    {
      "id": "#ORD1001",
      "date": "01 Sep 2025\n09:30 AM",
      "customer": "Rahul Sharma",
      "status": "Pending",
      "amount": "₹ 1,250",
    },
    {
      "id": "#ORD1002",
      "date": "01 Sep 2025\n10:15 AM",
      "customer": "Amit Kumar",
      "status": "Completed",
      "amount": "₹ 980",
    },
    {
      "id": "#ORD1003",
      "date": "01 Sep 2025\n11:05 AM",
      "customer": "Neha Verma",
      "status": "Cancelled",
      "amount": "₹ 2,100",
    },
    {
      "id": "#ORD1004",
      "date": "02 Sep 2025\n09:20 AM",
      "customer": "Kashyap Meghani",
      "status": "Pending",
      "amount": "₹ 750",
    },
    {
      "id": "#ORD1005",
      "date": "02 Sep 2025\n10:40 AM",
      "customer": "Divy Patel",
      "status": "Completed",
      "amount": "₹ 3,450",
    },
    {
      "id": "#ORD1006",
      "date": "02 Sep 2025\n12:10 PM",
      "customer": "Montu Lakhani",
      "status": "In Progress",
      "amount": "₹ 1,890",
    },
    {
      "id": "#ORD1007",
      "date": "03 Sep 2025\n09:00 AM",
      "customer": "Riya Shah",
      "status": "Pending",
      "amount": "₹ 560",
    },
    {
      "id": "#ORD1008",
      "date": "03 Sep 2025\n10:55 AM",
      "customer": "Harsh Patel",
      "status": "Completed",
      "amount": "₹ 2,999",
    },
    {
      "id": "#ORD1009",
      "date": "03 Sep 2025\n01:20 PM",
      "customer": "Sneha Joshi",
      "status": "Cancelled",
      "amount": "₹ 1,120",
    },
    {
      "id": "#ORD1010",
      "date": "04 Sep 2025\n09:45 AM",
      "customer": "Jay Mehta",
      "status": "Pending",
      "amount": "₹ 870",
    },
    {
      "id": "#ORD1011",
      "date": "04 Sep 2025\n11:15 AM",
      "customer": "Ankit Rana",
      "status": "Completed",
      "amount": "₹ 4,250",
    },
    {
      "id": "#ORD1012",
      "date": "04 Sep 2025\n12:40 PM",
      "customer": "Pooja Desai",
      "status": "In Progress",
      "amount": "₹ 1,670",
    },
    {
      "id": "#ORD1013",
      "date": "05 Sep 2025\n09:10 AM",
      "customer": "Suresh Yadav",
      "status": "Pending",
      "amount": "₹ 920",
    },
    {
      "id": "#ORD1014",
      "date": "05 Sep 2025\n10:50 AM",
      "customer": "Nisha Kapoor",
      "status": "Completed",
      "amount": "₹ 2,340",
    },
    {
      "id": "#ORD1015",
      "date": "05 Sep 2025\n01:30 PM",
      "customer": "Vikas Malhotra",
      "status": "Cancelled",
      "amount": "₹ 1,480",
    },
    {
      "id": "#ORD1016",
      "date": "06 Sep 2025\n09:35 AM",
      "customer": "Alok Singh",
      "status": "Pending",
      "amount": "₹ 650",
    },
    {
      "id": "#ORD1017",
      "date": "06 Sep 2025\n10:25 AM",
      "customer": "Mehul Jain",
      "status": "Completed",
      "amount": "₹ 5,120",
    },
    {
      "id": "#ORD1018",
      "date": "06 Sep 2025\n12:05 PM",
      "customer": "Kiran Patel",
      "status": "In Progress",
      "amount": "₹ 1,330",
    },
    {
      "id": "#ORD1019",
      "date": "07 Sep 2025\n09:55 AM",
      "customer": "Rohit Gupta",
      "status": "Pending",
      "amount": "₹ 890",
    },
    {
      "id": "#ORD1020",
      "date": "07 Sep 2025\n11:45 AM",
      "customer": "Ayesha Khan",
      "status": "Completed",
      "amount": "₹ 3,780",
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_searchtxt.isEmpty) return orders;

    final query = _searchtxt.toLowerCase();

    return orders.where((order) {
      return order["id"].toLowerCase().contains(query) ||
          order["customer"].toLowerCase().contains(query) ||
          order["status"].toLowerCase().contains(query) ||
          order["amount"].toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8fb),
      endDrawer: const OrderInfoDrawer(),
      body: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeader(),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.white,
              border: Border.all(color: AppColors.grey300)),
              child: Row(
                children: [
                  const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  Spacer(),

                  //---------search------------
                  SizedBox(
                    height: 40,
                    width: 220,
                    child: TextField(
                      controller: _searchctr,
                      onChanged: (value) {
                        setState(() {
                          _searchtxt = value;
                          _currentPage = 1;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: AppColors.black,
                            width: 1,
                          ),
                        ),
                        hintText: "search order",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.white),
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowHeight: 48,
                    dataRowHeight: 47,
                    columnSpacing: 32,
                    dividerThickness: 0.01,
                    headingRowColor: MaterialStateProperty.all(AppColors.grey300),
                    columns: const [
                      DataColumn(
                        label: Text("Order ID", style: TextStyle(fontSize: 14)),
                      ),
                      DataColumn(
                        label: Text(
                          "Date & Time",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Customer Name",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Order Status",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Total Amount",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text("Action", style: TextStyle(fontSize: 14)),
                      ),
                    ],
                    rows:
                        _paginatedOrders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  order["id"],
                                  style: TextStyle(color: AppColors.black45),
                                ),
                              ),
                              DataCell(
                                Text(
                                  order["date"],
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              DataCell(
                                Text(
                                  order["customer"],
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      order["status"].toString().statusIcon,
                                      size: 15,
                                      color:
                                          order["status"].toString().statusColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      order["status"],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:
                                            order["status"]
                                                .toString()
                                                .statusColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  order["amount"],
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.visibility,
                                            color: AppColors.blue,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            Scaffold.of(context).openEndDrawer();
                                          },
                                        );
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
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.black),
                  onPressed:
                      _currentPage > 1
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
                  icon: const Icon(Icons.chevron_right, color: AppColors.black),
                  onPressed:
                      _currentPage < _totalPages
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
