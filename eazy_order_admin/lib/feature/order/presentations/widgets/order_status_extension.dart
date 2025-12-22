import 'package:flutter/material.dart';
import 'package:core/config/app_colors.dart';

extension OrderStatusExtension on String {
  Color get statusColor {
    switch (toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return AppColors.green;
      case 'cancelled':
        return Colors.red;
        case 'in progress':
        return Colors.blue;
      default:
        return AppColors.black;
    }
  }

  IconData get statusIcon {
    switch (toLowerCase()) {
      case 'pending':
        return Icons.autorenew_sharp;
      case 'completed':
        return Icons.checklist;
      case 'cancelled':
        return Icons.cancel;
        case 'in progress':
        return Icons.autorenew_sharp;
      default:
        return Icons.info;
    }
  }
}
