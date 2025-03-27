
import 'package:flutter/material.dart';
import 'package:gezz_ai/utils/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle title = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static TextStyle message = GoogleFonts.roboto(
    fontSize: 16,
    color: AppColors.text,
  );

  static TextStyle time = GoogleFonts.roboto(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}
