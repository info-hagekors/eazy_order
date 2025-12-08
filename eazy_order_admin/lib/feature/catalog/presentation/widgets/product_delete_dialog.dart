import 'package:core/config/app_colors.dart';
import 'package:eazy_order_admin/feature/catalog/application/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDeleteDialog extends ConsumerWidget {
  final String productName;
  final String productId;
  final String businessId;

  const ProductDeleteDialog({
    super.key,
    required this.productName,
    required this.productId,
    required this.businessId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(productControllerProvider.notifier);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 35, vertical: 24),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      contentPadding: const EdgeInsets.all(23),
      content: SizedBox(

        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 45,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Delete Product',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 13),

            Text(
              'Are you sure you want to delete this product?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
               fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black.withAlpha(180),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () async {
                    // 1. Delete product
                    await ref.read(productControllerProvider.notifier)
                        .deleteProductfromcontroller(productId);

                    // 2. Refresh list
                    await controller.getAllProductfromController(businessId);

                    // 3. Close dialog and return true
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
