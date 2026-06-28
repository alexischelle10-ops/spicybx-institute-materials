import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cards_data.dart';
import '../theme/sbi_tokens.dart';
import '../widgets/domain_icon.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenCardDeck;
  final VoidCallback onOpenMorningMeeting;
  final VoidCallback onOpenBinder;

  const HomeScreen({
    super.key,
    required this.onOpenCardDeck,
    required this.onOpenMorningMeeting,
    required this.onOpenBinder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBIColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroBlock(
                onOpenDeck: onOpenCardDeck,
                onOpenMeeting: onOpenMorningMeeting,
              ),
              _SectionDivider(
                eyebrow: 'System Index',
                title: 'Materials in this volume',
                subtitle: 'Everything you need to teach, practice, and generalize positive skills.',
              ),
              _MaterialsGrid(
                onOpenDeck: onOpenCardDeck,
                onOpenMeeting: onOpenMorningMeeting,
                onOpenBinder: onOpenBinder,
              ),
              _SectionDivider(
                eyebrow: 'Vocabulary Domains',
                title: 'Eight color-coded domains',
                subtitle: 'Cards are organized by skill area so you can teach and filter by domain.',
              ),
              _DomainsGrid(),
              _DailyRhythmSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  final VoidCallback onOpenDeck;
  final VoidCallback onOpenMeeting;

  const _HeroBlock({required this.onOpenDeck, required this.onOpenMeeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.xl),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.6), width: 1.5),
        boxShadow: const [SBIShadows.md],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SBI seal placeholder
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: SBIColors.navy,
                    shape: BoxShape.circle,
                    border: Border.all(color: SBIColors.gold, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SBI\u2122',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.1,
                          ),
                        ),
                        Icon(Icons.psychology, size: 16, color: SBIColors.gold),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Eyebrow('Spicy Behavioral Institute\u2122'),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: SBIColors.navy,
                      height: 1.1,
                    ),
                    children: [
                      const TextSpan(text: 'Positive Affirmation '),
                      TextSpan(
                        text: '& Success',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: SBIColors.burgundy,
                          height: 1.1,
                        ),
                      ),
                      const TextSpan(text: '\nCards.'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const GoldRule(maxWidth: 80),
                const SizedBox(height: 12),
                Text(
                  'A complete vocabulary and affirmation card system for transition-age learners, young adults, and adults with developmental disabilities.',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: SBIColors.stone500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _CTAButton(
                        label: 'Open the card deck',
                        isPrimary: true,
                        onTap: onOpenDeck,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CTAButton(
                        label: 'Morning Meeting',
                        isPrimary: false,
                        onTap: onOpenMeeting,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    _StatCard(number: '60', label: 'Affirmation cards'),
                    const SizedBox(width: 8),
                    _StatCard(number: '100+', label: 'Total curriculum', goldPlus: true),
                    const SizedBox(width: 8),
                    _StatCard(number: '8', label: 'Domains'),
                    const SizedBox(width: 8),
                    _StatCard(number: '3', label: 'Levels'),
                  ],
                ),
              ],
            ),
          ),
          // Tagline ribbon
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: SBIColors.burgundy,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(SBIRadius.xl),
                bottomRight: Radius.circular(SBIRadius.xl),
              ),
            ),
            child: Center(
              child: Text(
                'BEHAVIOR SCIENCE · REAL SOLUTIONS · FAMILY-CENTERED SUPPORT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                  color: SBIColors.ivory,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final bool goldPlus;

  const _StatCard({
    required this.number,
    required this.label,
    this.goldPlus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: SBIColors.ivoryWarm,
          borderRadius: BorderRadius.circular(SBIRadius.md),
          border: Border(
            left: BorderSide(color: SBIColors.gold, width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: goldPlus ? number.replaceAll('+', '') : number,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: SBIColors.burgundy,
                    ),
                  ),
                  if (goldPlus)
                    TextSpan(
                      text: '+',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: SBIColors.gold,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                color: SBIColors.stone500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _CTAButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? SBIColors.burgundy : Colors.transparent,
          borderRadius: BorderRadius.circular(SBIRadius.pill),
          border: Border.all(
            color: isPrimary ? SBIColors.burgundy : SBIColors.navy,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.08,
                  color: isPrimary ? SBIColors.ivory : SBIColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward,
              size: 14,
              color: isPrimary ? SBIColors.ivory : SBIColors.navy,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _SectionDivider({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        children: [
          Eyebrow(eyebrow),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: SBIColors.navy,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          const GoldRule(maxWidth: 100),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: SBIColors.stone500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialsGrid extends StatelessWidget {
  final VoidCallback onOpenDeck;
  final VoidCallback onOpenMeeting;
  final VoidCallback onOpenBinder;

  const _MaterialsGrid({
    required this.onOpenDeck,
    required this.onOpenMeeting,
    required this.onOpenBinder,
  });

  @override
  Widget build(BuildContext context) {
    final materials = [
      _MaterialData(
        tag: 'PRIMARY',
        icon: Icons.layers_outlined,
        title: 'Card Deck',
        body: '60 cards · Levels 1, 2 & 3',
        format: '4 × 6 cards',
        isPrimary: true,
        onTap: onOpenDeck,
      ),
      _MaterialData(
        tag: 'TEACHING',
        icon: Icons.present_to_all_outlined,
        title: 'Morning Meeting',
        body: '12 slides · 15 min lesson',
        format: '16:9 deck',
        isPrimary: false,
        onTap: onOpenMeeting,
      ),
      _MaterialData(
        tag: 'PRINT',
        icon: Icons.book_outlined,
        title: 'Binder Cover',
        body: 'Front, spine & back cover',
        format: '8.5 × 11 + spine',
        isPrimary: false,
        onTap: onOpenBinder,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // Primary card full width
          _MaterialCard(data: materials[0]),
          const SizedBox(height: 10),
          // Other cards
          Row(
            children: [
              Expanded(child: _MaterialCard(data: materials[1])),
              const SizedBox(width: 10),
              Expanded(child: _MaterialCard(data: materials[2])),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaterialData {
  final String tag;
  final IconData icon;
  final String title;
  final String body;
  final String format;
  final bool isPrimary;
  final VoidCallback onTap;

  const _MaterialData({
    required this.tag,
    required this.icon,
    required this.title,
    required this.body,
    required this.format,
    required this.isPrimary,
    required this.onTap,
  });
}

class _MaterialCard extends StatelessWidget {
  final _MaterialData data;

  const _MaterialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final bgColor = data.isPrimary ? SBIColors.navy : SBIColors.ivory;
    final textColor = data.isPrimary ? SBIColors.ivory : SBIColors.navy;
    final subColor = data.isPrimary ? SBIColors.ivory.withValues(alpha: 0.7) : SBIColors.stone500;
    final iconBg = data.isPrimary ? SBIColors.navySoft : SBIColors.ivoryWarm;
    final iconColor = data.isPrimary ? SBIColors.gold : SBIColors.burgundy;

    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(SBIRadius.lg),
          border: Border.all(
            color: data.isPrimary ? SBIColors.gold.withValues(alpha: 0.5) : SBIColors.navyBorder,
            width: 1.5,
          ),
          boxShadow: const [SBIShadows.sm],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(data.icon, color: iconColor, size: 22),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.isPrimary ? SBIColors.gold.withValues(alpha: 0.2) : SBIColors.ivoryWarm,
                    borderRadius: BorderRadius.circular(SBIRadius.pill),
                  ),
                  child: Text(
                    data.tag,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.18,
                      color: data.isPrimary ? SBIColors.gold : SBIColors.stone500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.body,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: subColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.format,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: subColor,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'OPEN',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.14,
                        color: data.isPrimary ? SBIColors.gold : SBIColors.burgundy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 12,
                      color: data.isPrimary ? SBIColors.gold : SBIColors.burgundy,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final domainList = domains.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemCount: domainList.length,
        itemBuilder: (context, i) {
          final domain = domainList[i].value;
          final cardCount = allCards.where((c) => c.domain == domain.key).length;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SBIColors.ivory,
              borderRadius: BorderRadius.circular(SBIRadius.md),
              border: Border(
                top: BorderSide(color: domain.color, width: 4),
                left: BorderSide(color: SBIColors.navyBorder, width: 1),
                right: BorderSide(color: SBIColors.navyBorder, width: 1),
                bottom: BorderSide(color: SBIColors.navyBorder, width: 1),
              ),
              boxShadow: const [SBIShadows.xs],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: domain.soft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconForName(domain.icon),
                    color: domain.color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        domain.label,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: SBIColors.navy,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$cardCount CARDS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.12,
                          color: domain.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DailyRhythmSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepData(
        num: '01',
        icon: Icons.wb_sunny_outlined,
        title: 'Morning read',
        body: 'Read the affirmation aloud three times.',
      ),
      _StepData(
        num: '02',
        icon: Icons.present_to_all_outlined,
        title: 'Morning Meeting',
        body: 'Teach the concept as a group lesson.',
      ),
      _StepData(
        num: '03',
        icon: Icons.task_alt_outlined,
        title: 'Practice',
        body: 'Complete the daily practice activity.',
      ),
      _StepData(
        num: '04',
        icon: Icons.psychology_outlined,
        title: 'Reflect',
        body: 'Answer the reflection question.',
      ),
    ];

    return Column(
      children: [
        _SectionDivider(
          eyebrow: 'Daily Routine',
          title: 'A simple daily rhythm',
          subtitle: 'Four steps. Fifteen minutes. Real behavior change.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: steps.length,
            itemBuilder: (context, i) {
              final step = steps[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: SBIColors.ivory,
                  borderRadius: BorderRadius.circular(SBIRadius.md),
                  border: Border(
                    top: BorderSide(color: SBIColors.gold, width: 3),
                    left: BorderSide(color: SBIColors.navyBorder, width: 1),
                    right: BorderSide(color: SBIColors.navyBorder, width: 1),
                    bottom: BorderSide(color: SBIColors.navyBorder, width: 1),
                  ),
                  boxShadow: const [SBIShadows.xs],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.num,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: SBIColors.burgundy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Icon(step.icon, size: 24, color: SBIColors.navy),
                    const SizedBox(height: 4),
                    Text(
                      step.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: SBIColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        step.body,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: SBIColors.stone500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StepData {
  final String num;
  final IconData icon;
  final String title;
  final String body;

  const _StepData({
    required this.num,
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: SBIColors.navyBorder, width: 1.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, size: 20, color: SBIColors.navy),
                    const SizedBox(width: 6),
                    Eyebrow('Spicy Behavioral Institute\u2122'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Behavior Science · Real Solutions',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: SBIColors.stone500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'VOLUME I · 2026 EDITION',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                  color: SBIColors.stone400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'FOR INSTRUCTIONAL PREVIEW',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  letterSpacing: 0.12,
                  color: SBIColors.stone400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
