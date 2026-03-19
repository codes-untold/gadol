import 'package:flutter/material.dart';

class AppPadding {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
}

class AppShadow {
  static BoxShadow small(BuildContext context) {
    return BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
      blurRadius: 2,
      offset: const Offset(0, 1),
    );
  }

  static BoxShadow medium(BuildContext context) {
    return BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow large(BuildContext context) {
    return BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );
  }
}

class AppTypography {
  static TextStyle get heading1 {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
    );
  }

  static TextStyle get heading2 {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
  }

  static TextStyle get body {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  static TextStyle get caption {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );
  }
}
