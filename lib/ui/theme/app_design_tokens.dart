import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 30;

  static const EdgeInsets screenPadding = EdgeInsets.all(xl);
  static const EdgeInsets screenPaddingWide = EdgeInsets.fromLTRB(
    xl,
    md,
    xl,
    28,
  );
}

class AppRadius {
  static const double sm = 14;
  static const double md = 16;
  static const double lg = 18;
  static const double xl = 20;
  static const double xxl = 24;
  static const double sheet = 30;
  static const double pill = 999;
}

class AppColors {
  static const Color panelBorder = Color(0xFFE8DED4);
  static const Color panelSurface = Color(0xFFFCFAF7);
  static const Color softSurface = Color(0xFFF7F4F0);
  static const Color mutedSurface = Color(0xFFF7F2EC);
  static const Color iconSurface = Color(0xFFFFE9DE);
  static const Color accent = Color(0xFFE46F2A);
  static const Color accentStrong = Color(0xFFC56B2A);
  static const Color success = Color(0xFF2F6A46);
  static const Color successSurface = Color(0xFFEAF4EC);
  static const Color warning = Color(0xFF935A2B);
  static const Color warningSurface = Color(0xFFF8EFE6);
  static const Color error = Color(0xFFD05C2A);
  static const Color errorSurface = Color(0xFFFFEFEA);
  static const Color errorBorder = Color(0xFFF2C1B1);
  static const Color subduedText = Color(0xFF655E58);
  static const Color handle = Color(0xFFE5DDD6);
}

class AppShadows {
  static List<BoxShadow> floating({
    double blurRadius = 24,
    double offsetY = 12,
    double alpha = 0.10,
  }) {
    return [
      BoxShadow(
        blurRadius: blurRadius,
        offset: Offset(0, offsetY),
        color: Colors.black.withValues(alpha: alpha),
      ),
    ];
  }
}
