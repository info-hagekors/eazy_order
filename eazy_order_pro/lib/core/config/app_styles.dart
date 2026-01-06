
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eazy_order_pro/core/config/app_colors.dart';

class AppStyles {

  static Color primary = AppColors.primaryColor;

  static final trafficTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary, // Deep Blue
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      primary: primary, // Deep Blue
      secondary: const Color(0xFFF97316), // Traffic Orange
      //surface: const Color(0xFF374151), // Asphalt Gray
      //error: const Color(0xFFDC2626), // Warning Red
      //onPrimary: Colors.white,
      //onSecondary: Colors.white,
      //onSurface: AppColors.black,
      //onError: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF10B981), // Neon Green
    scaffoldBackgroundColor: const Color(0xFF1F2937), // Dark Gray
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F2937),
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF10B981), // Neon Green
      secondary: const Color(0xFF06B6D4), // Cyan
      surface: const Color(0xFF111827), // Almost Black
      error: const Color(0xFFEF4444), // Bright Red
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
  );

  static final professionalTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E40AF), // Navy Blue
    scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Light Gray
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E40AF),
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1E40AF), // Navy Blue
      secondary: const Color(0xFFF97316), // Safety Orange
      surface: const Color(0xFF374151), // Charcoal
      error: const Color(0xFFB91C1C), // Dark Red
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
  );


  static final buttonStyle = GoogleFonts.poppins(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.white
  );

  static final headerStyle = GoogleFonts.poppins(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500
  );

  static final smallButtonStyle = GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.white
  );

  static final smallBodyStyle = GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.black
  );
}