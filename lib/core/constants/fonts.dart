import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static TextStyle headingStyle(Color color, {double fontSize = 24}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle subheadingStyle(Color color, {double fontSize = 16}) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle bodyStyle(Color color, {double fontSize = 14}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }
}
