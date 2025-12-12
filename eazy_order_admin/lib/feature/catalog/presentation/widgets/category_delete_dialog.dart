import 'package:core/config/app_colors.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDeleteDialog extends ConsumerWidget {
  final String categoryName;
  const CategoryDeleteDialog({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goroute = ref.read(goRouterProvider);
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7)),
      contentPadding: EdgeInsets.all(23),

      // 🔹 Modern Warning Dialog UI (same as DeleteDialogCategory)
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔸 Warning icon inside circular background
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
            SizedBox(height: 12),
        
            // 🔸 Title
            Text(
              'Delete Category',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 13),
        
            // 🔸 Confirmation message
            Text(
              'Are you sure you want to delete this category?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black.withAlpha(180),
              ),
            ),
            SizedBox(height: 10),
        
            // 🔸 Info note (similar to old file)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 12,
                  color: AppColors.supporting,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'By deleting this category, all products associated with it will also be deleted.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.black.withAlpha(150),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
        
            // 🔸 Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => ref.read(goRouterProvider).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
        
                SizedBox(width: 12),
        
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
        
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
