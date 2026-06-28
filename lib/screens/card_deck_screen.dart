import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/deck_state.dart';
import '../data/cards_data.dart';
import '../theme/sbi_tokens.dart';
import '../widgets/affirmation_card_widget.dart';
import '../widgets/domain_icon.dart';

class CardDeckScreen extends StatelessWidget {
  const CardDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBIColors.ivory,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Masthead(),
            _Toolbar(),
            Expanded(child: _CardGrid()),
          ],
        ),
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deck = Provider.of<DeckState>(context);
    final count = deck.filteredCards.length;

    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        border: Border(
          top: BorderSide(color: SBIColors.burgundy, width: 4),
          bottom: BorderSide(color: SBIColors.navyBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Left: logo placeholder
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SBIColors.navy,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'SBI',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Center: titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow('Spicy Behavioral Institute\u2122'),
                Text(
                  'Affirmation & Success Cards',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: SBIColors.navy,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Building Confidence · Respect · Independence',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: SBIColors.stone500,
                  ),
                ),
              ],
            ),
          ),
          // Right: meta
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Volume I',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SBIColors.burgundy,
                ),
              ),
              Text(
                'Levels 1 · 2 · 3',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 0.1,
                  color: SBIColors.stone500,
                ),
              ),
              Text(
                '$count cards · 8 domains',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 0.1,
                  color: SBIColors.stone500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deck = Provider.of<DeckState>(context);
    final totalCount = deck.filteredCards.length;
    final allCount = 60;

    return Container(
      color: SBIColors.ivoryWarm,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level filter row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isActive: deck.filterLevel == null,
                  onTap: () => deck.setLevel(null),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: 'Level 1',
                  isActive: deck.filterLevel == 1,
                  onTap: () => deck.setLevel(1),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: 'Level 2',
                  isActive: deck.filterLevel == 2,
                  onTap: () => deck.setLevel(2),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: 'Level 3',
                  isActive: deck.filterLevel == 3,
                  onTap: () => deck.setLevel(3),
                ),
                const SizedBox(width: 12),
                // Count display
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: SBIColors.stone500,
                    ),
                    children: [
                      TextSpan(
                        text: '$totalCount',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: SBIColors.burgundy,
                        ),
                      ),
                      TextSpan(text: ' of $allCount'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Domain filter + action buttons row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _DomainChip(
                  label: 'All',
                  color: SBIColors.stone400,
                  isActive: deck.filterDomain == null,
                  onTap: () => deck.setDomain(null),
                ),
                const SizedBox(width: 5),
                ...domains.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: _DomainChip(
                    label: _shortDomainLabel(entry.value.label),
                    color: entry.value.color,
                    isActive: deck.filterDomain == entry.key,
                    onTap: () => deck.setDomain(entry.key),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Action buttons
          Row(
            children: [
              _ActionButton(
                label: deck.isDense ? 'Standard' : 'Dense',
                onTap: () => deck.toggleDense(),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                label: deck.flippedAll ? 'Show Fronts' : 'Flip All',
                onTap: () => deck.flipAll(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortDomainLabel(String label) {
    final parts = label.split(' ');
    return parts.first;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? SBIColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(SBIRadius.pill),
          border: Border.all(
            color: isActive ? SBIColors.navy : SBIColors.stone300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? SBIColors.ivory : SBIColors.stone600,
          ),
        ),
      ),
    );
  }
}

class _DomainChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _DomainChip({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? SBIColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(SBIRadius.pill),
          border: Border.all(
            color: isActive ? SBIColors.navy : SBIColors.stone300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isActive ? SBIColors.gold : color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? SBIColors.ivory : SBIColors.stone600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(SBIRadius.pill),
          border: Border.all(color: SBIColors.navy, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: SBIColors.navy,
          ),
        ),
      ),
    );
  }
}

class _CardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deck = Provider.of<DeckState>(context);
    final cards = deck.filteredCards;

    if (cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers_outlined, size: 48, color: SBIColors.stone300),
            const SizedBox(height: 12),
            Text(
              'No cards match this filter.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: SBIColors.stone500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 340,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 4 / 6,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return AffirmationCardWidget(
          card: card,
          isFlipped: deck.isFlipped(card.id),
          isDense: deck.isDense,
          onFlip: () => deck.flipCard(card.id),
        );
      },
    );
  }
}
