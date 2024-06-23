import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/themes/colors.dart';

class CustomTextStyle{
  static const TextStyle textStyle1 = TextStyle(
      color: AppColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.w600);
  static TextStyle textStyle2 = GoogleFonts.getFont('Roboto', fontSize: 14, color: AppColors.fontColor1);
  static TextStyle textStyle3 = GoogleFonts.getFont('Roboto', fontSize: 15, color: AppColors.fontColor1);
  static TextStyle textStyle4 = GoogleFonts.getFont('Roboto', color: AppColors.primary, fontSize: 15);
  static TextStyle textStyle5 = GoogleFonts.getFont('Roboto', fontSize: 14, color: AppColors.fontColor1);
  static TextStyle textStyle6 = GoogleFonts.getFont('Roboto', fontSize: 12, color: AppColors.fontColor1);
  static TextStyle textStyle7 = GoogleFonts.getFont('Roboto', color: Colors.black);
  static TextStyle textStyle8 = GoogleFonts.getFont('Roboto', color: AppColors.primary, fontSize: 15);
  static TextStyle textStyle9 = GoogleFonts.getFont('Roboto', color: AppColors.primary, fontSize: 14);
  static const TextStyle textStyle10 = TextStyle(color: AppColors.primary, fontSize: 20,);
}
