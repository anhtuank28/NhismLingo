import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Tiêu đề số lượng lớn (XP, Gems, Streak, Điểm số)
  static TextStyle displayHero = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // Heading màn hình chính
  static TextStyle heading1 = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Label các nút bấm 3D
  static TextStyle buttonLabel = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.6,
    color: Colors.white,
  );

  // Nội dung bài học và thẻ từ vựng
  static TextStyle body = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyBold = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
}
