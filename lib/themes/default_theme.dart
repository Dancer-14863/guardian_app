import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:sizer/sizer.dart';

class DefaultTheme extends AppTheme {
  DefaultTheme()
      : super(
          id: 'default_theme',
          description: 'Default Theme',
          data: ThemeData.light().copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          options: ThemeOptions(
            primaryColor: const Color(0xFF627D98),
            secondaryColor: const Color(0xFFB33F62),
            textColor: const Color(0xFFFFFFFF),
            textColorOnPrimary: const Color(0xFFFFFFFF),
            textColorOnSecondary: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFF0F1020),
            successColor: const Color(0xFF49CE78),
            warningColor: const Color(0xFFE1B845),
            errorColor: const Color(0xFFDB5B53),
            textSize1: 14.sp,
            textSize2: 12.sp,
            textSize3: 10.sp,
            textSize4: 8.sp,
            textSize5: 6.sp,
          ),
        );
}
