import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/deck_state.dart';
import 'screens/home_screen.dart';
import 'screens/card_deck_screen.dart';
import 'screens/morning_meeting_screen.dart';
import 'screens/binder_cover_screen.dart';
import 'theme/sbi_tokens.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DeckState()..loadFromPrefs(),
      child: const AffirmationCardsApp(),
    ),
  );
}

class AffirmationCardsApp extends StatelessWidget {
  const AffirmationCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Positive Affirmation & Success Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SBIColors.burgundy,
          surface: SBIColors.ivory,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: SBIColors.ivory,
        appBarTheme: AppBarTheme(
          backgroundColor: SBIColors.navy,
          foregroundColor: SBIColors.ivory,
          elevation: 0,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onOpenCardDeck: () => _navigateTo(1),
        onOpenMorningMeeting: () => _navigateTo(2),
        onOpenBinder: () => _navigateTo(3),
      ),
      const CardDeckScreen(),
      const MorningMeetingScreen(),
      const BinderCoverScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: _SBINavBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
      ),
    );
  }
}

class _SBINavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _SBINavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'System Index'),
      _NavItem(icon: Icons.layers_outlined, activeIcon: Icons.layers, label: 'Card Deck'),
      _NavItem(icon: Icons.present_to_all_outlined, activeIcon: Icons.present_to_all, label: 'Morning'),
      _NavItem(icon: Icons.book_outlined, activeIcon: Icons.book, label: 'Binder'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: SBIColors.navy,
        border: Border(
          top: BorderSide(color: SBIColors.gold, width: 1.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = currentIndex == i;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive ? SBIColors.gold : Colors.transparent,
                      borderRadius: BorderRadius.circular(SBIRadius.pill),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive ? SBIColors.navy : SBIColors.ivory.withValues(alpha: 0.7),
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.08,
                            color: isActive ? SBIColors.navy : SBIColors.ivory.withValues(alpha: 0.7),
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
