import 'package:flutter/material.dart';

/// Spicy Behavioral Institute™ Design Tokens
/// Ported from colors_and_type.css
class SBIColors {
  // Brand Core
  static const Color ivory = Color(0xFFFAF7F2);
  static const Color ivoryWarm = Color(0xFFF2EBDD);
  static const Color navy = Color(0xFF0F1C2E);
  static const Color navySoft = Color(0xFF1B2C45);
  static const Color burgundy = Color(0xFF6E0D25);
  static const Color burgundyDeep = Color(0xFF560A1D);
  static const Color gold = Color(0xFFD4A017);
  static const Color goldSoft = Color(0xFFE8C25A);
  static const Color blush = Color(0xFFF4D6DE);

  // Neutral (warm-leaning)
  static const Color stone50 = Color(0xFFFAF7F2);
  static const Color stone100 = Color(0xFFF2EDE3);
  static const Color stone200 = Color(0xFFE5DCC9);
  static const Color stone300 = Color(0xFFC9BCA0);
  static const Color stone400 = Color(0xFF8E8369);
  static const Color stone500 = Color(0xFF5B5340);
  static const Color stone600 = Color(0xFF3A3527);
  static const Color stone700 = Color(0xFF221F17);

  // Status
  static const Color statusSuccess = Color(0xFF2F6B3B);
  static const Color statusWarn = Color(0xFFB07D14);
  static const Color statusDanger = Color(0xFF6E0D25);
  static const Color statusInfo = Color(0xFF1F3E66);

  // Utility
  static Color goldAction = gold.withValues(alpha: 0.10);
  static Color navyBorder = navy.withValues(alpha: 0.10);
  static Color navyBorderStrong = navy.withValues(alpha: 0.20);
}

class SBISpacing {
  static const double sp1 = 4;
  static const double sp2 = 8;
  static const double sp3 = 12;
  static const double sp4 = 16;
  static const double sp5 = 20;
  static const double sp6 = 24;
  static const double sp8 = 32;
  static const double sp10 = 40;
  static const double sp12 = 48;
  static const double sp16 = 64;
  static const double sp20 = 80;
  static const double sp24 = 96;

  static const double pageMargin = 20.0;
  static const double blockGap = 28.0;
}

class SBIRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 18;
  static const double xl = 28;
  static const double pill = 999;
}

class SBIShadows {
  static const BoxShadow xs = BoxShadow(
    color: Color(0x0F0F1C2E),
    offset: Offset(0, 1),
    blurRadius: 2,
  );
  static const BoxShadow sm = BoxShadow(
    color: Color(0x140F1C2E),
    offset: Offset(0, 4),
    blurRadius: 12,
  );
  static const BoxShadow md = BoxShadow(
    color: Color(0x1E0F1C2E),
    offset: Offset(0, 10),
    blurRadius: 30,
  );
  static const BoxShadow lg = BoxShadow(
    color: Color(0x290F1C2E),
    offset: Offset(0, 24),
    blurRadius: 60,
  );
}
