import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';

class OrderInfoDrawer extends StatefulWidget {
  const OrderInfoDrawer({super.key});

  @override
  State<OrderInfoDrawer> createState() => _OrderInfoDrawerState();
}

class _OrderInfoDrawerState extends State<OrderInfoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const Text(
              "Order Details",
              style: TextStyle(color: AppColors.black),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.background2,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Order Info"),
                  _infoRow("Order ID", "#ORD-1001"),
                  _infoRow("Date & Time", "12 Sep 2025 • 10:30 AM"),
                  _infoRow("Order Status", "Pending"),

                  const SizedBox(height: 24),

                  _sectionTitle("Customer Info"),
                  _infoRow("Name", "Rahul Sharma"),
                  _infoRow("Phone", "+91 9876543210"),
                  _infoRow("Email", "rahul@gmail.com"),

                  const SizedBox(height: 24),

                  _sectionTitle("Payment Details"),
                  _infoRow("Payment Method", "UPI"),
                  _infoRow("Payment Status", "Paid"),
                  _infoRow("Transaction ID", "TXN987654321"),

                  const SizedBox(height: 24),

                  _sectionTitle("Order Summary"),
                  _infoRow("Subtotal", "₹ 1,100"),
                  _infoRow("Tax", "₹ 150"),
                  const Divider(height: 32),
                  _infoRow(
                    "Total Amount",
                    "₹ 1,250",
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI Helpers ----------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
