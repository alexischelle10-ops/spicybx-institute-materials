import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/deck_state.dart';
import 'providers/app_state.dart';
import 'theme/sbi_tokens.dart';

// ── Screens ───────────────────────────────────────────────────────────────────
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/learner_mode_screen.dart';
import 'screens/adult_mode_screen.dart';
import 'screens/todays_skill_screen.dart';
import 'screens/focus_cards_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/print_shop_screen.dart';
import 'screens/card_deck_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeckState()..loadFromPrefs()),
        ChangeNotifierProvider(create: (_) => AppState()..loadFromPrefs()),
      ],
      child: const SBISuccessCardsApp(),
    ),
  );
}

// ─── Root App ─────────────────────────────────────────────────────────────────
class SBISuccessCardsApp extends StatelessWidget {
  const SBISuccessCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SBI Success Cards™',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const _AppRoot(),
    );
  }

  ThemeData _buildTheme() {
    final base = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SBIColors.burgundy,
        surface: SBIColors.ivory,
        primary: SBIColors.navy,
        secondary: SBIColors.gold,
      ),
      textTheme: base,
      scaffoldBackgroundColor: SBIColors.ivory,
      appBarTheme: const AppBarTheme(
        backgroundColor: SBIColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SBIRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SBIRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SBIRadius.sm),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SBIRadius.lg),
        ),
      ),
    );
  }
}

// ─── App Root (Auth Gate) ─────────────────────────────────────────────────────
class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  // 'landing' | 'login' | 'app'
  String _view = 'landing';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // If state loaded and user is already logged in, go straight to app
        if (appState.isLoggedIn && _view != 'app') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _view = 'app');
          });
        }

        switch (_view) {
          case 'landing':
            return LandingScreen(
              onLogin: () => setState(() => _view = 'login'),
              onPreview: () => setState(() => _view = 'app'),
            );
          case 'login':
            return LoginScreen(
              onLoginSuccess: () => setState(() => _view = 'app'),
              onPreview: () => setState(() => _view = 'app'),
            );
          case 'app':
          default:
            return const MainNavigationShell();
        }
      },
    );
  }
}

// ─── Main Navigation Shell ────────────────────────────────────────────────────
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // 9 nav items:
  // 0 Home (Card Library), 1 Learner Mode, 2 Adult Mode,
  // 3 Today's Skill, 4 Focus Cards, 5 Progress,
  // 6 Print Deck, 7 Account
  // We use a drawer for items 5-7 to keep bottom nav clean (max 5)
  // Bottom nav: Home, Learner, Adult, Today's Skill, More

  static const _bottomNavCount = 5; // indices 0-4 are in bottom nav

  List<Widget> get _screens => [
    const CardDeckScreen(),         // 0 — Library (original deck)
    const LearnerModeScreen(),      // 1 — Learner Mode
    const AdultModeScreen(),        // 2 — Adult Mode
    const TodaysSkillScreen(),      // 3 — Today's Skill
    const FocusCardsScreen(),       // 4 — Focus Cards
    const ProgressScreen(),         // 5 — Progress
    const PrintShopScreen(),        // 6 — Print Deck
    const _AccountScreen(),         // 7 — Account
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _SBIBottomNav(
        currentIndex: _currentIndex < _bottomNavCount ? _currentIndex : 0,
        onTap: (i) {
          if (i == 4) {
            // "More" opens drawer
            Scaffold.of(context).openDrawer();
          } else {
            setState(() => _currentIndex = i);
          }
        },
        showMoreDot: _currentIndex >= _bottomNavCount,
      ),
      drawer: _SBIDrawer(
        currentIndex: _currentIndex,
        onNavigate: (i) {
          setState(() => _currentIndex = i);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── SBI Bottom Nav ───────────────────────────────────────────────────────────
class _SBIBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool showMoreDot;

  const _SBIBottomNav({
    required this.currentIndex,
    required this.onTap,
    this.showMoreDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.layers_outlined, activeIcon: Icons.layers, label: 'Library'),
      _NavItem(icon: Icons.school_outlined, activeIcon: Icons.school, label: 'Learner'),
      _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Instructor'),
      _NavItem(icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny, label: 'Today'),
      _NavItem(icon: Icons.star_outline, activeIcon: Icons.star, label: 'Focus'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: SBIColors.navy,
        border: Border(top: BorderSide(color: SBIColors.gold, width: 1.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = currentIndex == i && !showMoreDot;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isActive ? SBIColors.gold : Colors.transparent,
                      borderRadius: BorderRadius.circular(SBIRadius.pill),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isActive ? item.activeIcon : item.icon,
                              color: isActive
                                  ? SBIColors.navy
                                  : SBIColors.ivory.withValues(alpha: 0.70),
                              size: 22,
                            ),
                            // Show dot for "Focus" (index 4) when in More section
                            if (i == 4 && showMoreDot)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: SBIColors.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.05,
                            color: isActive
                                ? SBIColors.navy
                                : SBIColors.ivory.withValues(alpha: 0.70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─── SBI Drawer ───────────────────────────────────────────────────────────────
class _SBIDrawer extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onNavigate;

  const _SBIDrawer({required this.currentIndex, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SBIColors.navy,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(SBISpacing.sp4),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SBIColors.burgundy,
                      border: Border.all(color: SBIColors.gold, width: 1.5),
                    ),
                    child: const Center(
                      child: Text(
                        'SBI',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: SBIColors.gold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SBI Success Cards™',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: SBIColors.gold,
                          ),
                        ),
                        Consumer<AppState>(
                          builder: (_, state, __) => Text(
                            state.isLoggedIn ? state.userEmail : 'Preview mode',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: SBIColors.gold.withValues(alpha: 0.25), height: 1),
            const SizedBox(height: SBISpacing.sp2),
            // ── Nav Items ────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp2),
                children: [
                  _DrawerGroup(title: 'PRACTICE'),
                  _DrawerItem(icon: Icons.layers_outlined, activeIcon: Icons.layers, label: 'Card Library', index: 0, current: currentIndex, onTap: onNavigate),
                  _DrawerItem(icon: Icons.school_outlined, activeIcon: Icons.school, label: 'Learner Mode', index: 1, current: currentIndex, onTap: onNavigate),
                  _DrawerItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Instructor Mode', index: 2, current: currentIndex, onTap: onNavigate),
                  _DrawerItem(icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny, label: "Today's Skill", index: 3, current: currentIndex, onTap: onNavigate),
                  _DrawerItem(icon: Icons.star_outline, activeIcon: Icons.star, label: 'My Focus Cards', index: 4, current: currentIndex, onTap: onNavigate),
                  const SizedBox(height: SBISpacing.sp3),
                  _DrawerGroup(title: 'TOOLS'),
                  _DrawerItem(icon: Icons.show_chart_outlined, activeIcon: Icons.show_chart, label: 'Progress', index: 5, current: currentIndex, onTap: onNavigate),
                  _DrawerItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Print Deck', index: 6, current: currentIndex, onTap: onNavigate),
                  const SizedBox(height: SBISpacing.sp3),
                  _DrawerGroup(title: 'ACCOUNT'),
                  _DrawerItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Account', index: 7, current: currentIndex, onTap: onNavigate),
                ],
              ),
            ),
            // ── Footer ───────────────────────────────────────────────────
            Divider(color: SBIColors.gold.withValues(alpha: 0.20), height: 1),
            Padding(
              padding: const EdgeInsets.all(SBISpacing.sp3),
              child: Text(
                '© Spicy Behavioral Institute™',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerGroup extends StatelessWidget {
  final String title;

  const _DrawerGroup({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: SBIColors.gold.withValues(alpha: 0.60),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = current == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? SBIColors.gold.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(SBIRadius.sm),
          border: Border.all(
            color: isActive ? SBIColors.gold.withValues(alpha: 0.40) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 20,
              color: isActive ? SBIColors.gold : Colors.white.withValues(alpha: 0.65),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? SBIColors.gold : Colors.white.withValues(alpha: 0.80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Account Screen ───────────────────────────────────────────────────────────
class _AccountScreen extends StatelessWidget {
  const _AccountScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: SBIColors.ivory,
          appBar: AppBar(
            backgroundColor: SBIColors.navy,
            foregroundColor: Colors.white,
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(SBISpacing.sp4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── User info ──────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(SBISpacing.sp5),
                  decoration: BoxDecoration(
                    color: SBIColors.navy,
                    borderRadius: BorderRadius.circular(SBIRadius.xl),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SBIColors.burgundy,
                          border: Border.all(color: SBIColors.gold, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            state.isLoggedIn && state.userName.isNotEmpty
                                ? state.userName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: SBIColors.gold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),
                      Text(
                        state.isLoggedIn ? state.userName : 'Preview User',
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        state.isLoggedIn ? state.userEmail : 'Not logged in',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.60),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),
                      if (!state.isLoggedIn)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: SBIColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: SBIColors.gold.withValues(alpha: 0.40)),
                          ),
                          child: const Text(
                            'Preview Mode',
                            style: TextStyle(
                              fontSize: 12,
                              color: SBIColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: SBISpacing.sp5),

                // ── Stats ──────────────────────────────────────────────────
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SBIColors.navy,
                  ),
                ),
                const SizedBox(height: SBISpacing.sp3),
                Row(
                  children: [
                    Expanded(child: _AccountStat(label: 'Practiced', value: state.totalPracticed, color: SBIColors.statusInfo)),
                    const SizedBox(width: SBISpacing.sp3),
                    Expanded(child: _AccountStat(label: 'Mastered', value: state.totalMastered, color: SBIColors.statusSuccess)),
                    const SizedBox(width: SBISpacing.sp3),
                    Expanded(child: _AccountStat(label: 'Focus Cards', value: state.focusCards.length, color: SBIColors.gold)),
                  ],
                ),
                const SizedBox(height: SBISpacing.sp5),

                // ── Mode toggle ────────────────────────────────────────────
                const Text(
                  'Default Mode',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SBIColors.navy,
                  ),
                ),
                const SizedBox(height: SBISpacing.sp3),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SBIRadius.lg),
                    border: Border.all(color: SBIColors.navy.withValues(alpha: 0.10)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => state.setLearnerMode(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: state.isLearnerMode ? SBIColors.navy : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(SBIRadius.lg)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.school_outlined, size: 20, color: state.isLearnerMode ? SBIColors.gold : SBIColors.navy.withValues(alpha: 0.5)),
                                const SizedBox(height: 4),
                                Text(
                                  'Learner Mode',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: state.isLearnerMode ? Colors.white : SBIColors.navy.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => state.setLearnerMode(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !state.isLearnerMode ? SBIColors.burgundy : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(SBIRadius.lg)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.menu_book_outlined, size: 20, color: !state.isLearnerMode ? SBIColors.gold : SBIColors.navy.withValues(alpha: 0.5)),
                                const SizedBox(height: 4),
                                Text(
                                  'Instructor Mode',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: !state.isLearnerMode ? Colors.white : SBIColors.navy.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SBISpacing.sp5),

                // ── Actions ────────────────────────────────────────────────
                if (state.isLoggedIn) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        state.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You have been logged out.')),
                        );
                      },
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Log Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SBIColors.burgundy,
                        side: const BorderSide(color: SBIColors.burgundy),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SBIRadius.md),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to login by rebuilding from root
                        // We use a dialog since we're inside the nav shell
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => _LoginDialog(),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Log In to Your Account'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SBIColors.gold,
                        foregroundColor: SBIColors.navy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SBIRadius.md),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SBISpacing.sp3),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Visit spicybehavioralinstitute.com to purchase access'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('Purchase in Resource Library'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SBIColors.burgundy,
                        side: const BorderSide(color: SBIColors.burgundy),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SBIRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: SBISpacing.sp8),
                Center(
                  child: Text(
                    '© Spicy Behavioral Institute™\nAll rights reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: SBIColors.navy.withValues(alpha: 0.40), height: 1.5),
                  ),
                ),
                const SizedBox(height: SBISpacing.sp4),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _AccountStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SBISpacing.sp3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: SBIColors.navy.withValues(alpha: 0.55)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Login Dialog (used inside app shell) ────────────────────────────────────
class _LoginDialog extends StatefulWidget {
  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final appState = context.read<AppState>();
    final ok = await appState.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _error = 'Could not log in. Please check your credentials.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.xl)),
      title: const Text(
        'Log In',
        style: TextStyle(fontFamily: 'PlayfairDisplay', color: SBIColors.navy, fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(fontSize: 13, color: SBIColors.burgundy)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: SBIColors.gold,
            foregroundColor: SBIColors.navy,
          ),
          child: _loading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: SBIColors.navy))
              : const Text('Log In'),
        ),
      ],
    );
  }
}

// ─── Nav Item ─────────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
