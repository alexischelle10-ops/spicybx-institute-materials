import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cards_data.dart';
import '../models/affirmation_card.dart';
import '../theme/sbi_tokens.dart';
import '../widgets/domain_icon.dart';

class MorningMeetingScreen extends StatefulWidget {
  const MorningMeetingScreen({super.key});

  @override
  State<MorningMeetingScreen> createState() => _MorningMeetingScreenState();
}

class _MorningMeetingScreenState extends State<MorningMeetingScreen> {
  int _currentSlide = 0;
  // Use the "RESPECTFUL" card as the featured card for morning meeting
  final AffirmationCard _card = allCards.firstWhere((c) => c.id == 'L1-respect');

  late final List<Widget> _slides;

  @override
  void initState() {
    super.initState();
    _slides = [
      _CoverSlide(card: _card),
      _AgendaSlide(),
      _BigAffirmationSlide(card: _card),
      _DefinitionSlide(card: _card),
      _LooksLikeSlide(card: _card),
      _RolePlaySlide(card: _card),
      _PracticePlanSlide(card: _card),
      _QuoteMomentSlide(),
      _ReflectionSlide(card: _card),
      _TomorrowPreviewSlide(currentCard: _card),
      _CloseSlide(card: _card),
    ];
  }

  void _nextSlide() {
    if (_currentSlide < _slides.length - 1) {
      setState(() => _currentSlide++);
    }
  }

  void _prevSlide() {
    if (_currentSlide > 0) {
      setState(() => _currentSlide--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _slides[_currentSlide],
              ),
            ),
            // Slide navigation bar
            Container(
              color: SBIColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: SBIColors.ivory),
                    onPressed: _currentSlide > 0 ? _prevSlide : null,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // Progress bar
                        LinearProgressIndicator(
                          value: (_currentSlide + 1) / _slides.length,
                          backgroundColor: SBIColors.navySoft,
                          valueColor: AlwaysStoppedAnimation(SBIColors.gold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SLIDE ${_currentSlide + 1} OF ${_slides.length} · ${_slideLabel(_currentSlide)}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            letterSpacing: 0.15,
                            color: SBIColors.ivory.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: SBIColors.ivory),
                    onPressed: _currentSlide < _slides.length - 1 ? _nextSlide : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _slideLabel(int index) {
    const labels = [
      'Cover', 'Agenda', 'Big Read', 'Definition',
      'Looks Like', 'Role Play', 'Practice Plan',
      'Quote', 'Reflection', 'Tomorrow', 'Close'
    ];
    return labels[index];
  }
}

// ------------- Individual Slides -------------

class _CoverSlide extends StatelessWidget {
  final AffirmationCard card;
  const _CoverSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    final domain = domains[card.domain]!;
    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
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
                                fontFamily: 'Inter', fontSize: 10,
                                fontWeight: FontWeight.w800, color: Colors.white,
                              ),
                            ),
                            Icon(Icons.psychology, size: 12, color: SBIColors.gold),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Eyebrow('Morning Meeting · Today\'s Focus'),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: SBIColors.navy,
                          height: 1.1,
                        ),
                        children: [
                          const TextSpan(text: 'Today we are\npracticing '),
                          TextSpan(
                            text: '${card.word[0]}${card.word.substring(1).toLowerCase()}.',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              color: SBIColors.burgundy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const GoldRule(maxWidth: 100),
                    const SizedBox(height: 12),
                    Text(
                      'A complete lesson for school, work, home, and community.',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: SBIColors.stone500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Featured card preview
              Expanded(
                flex: 4,
                child: _MiniCardPreview(card: card, domain: domain),
              ),
            ],
          ),
          const Spacer(),
          // Tagline ribbon
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: -24),
            color: SBIColors.burgundy,
            child: Center(
              child: Text(
                'BEHAVIOR SCIENCE · REAL SOLUTIONS · FAMILY-CENTERED SUPPORT',
                style: TextStyle(
                  fontFamily: 'Inter', fontSize: 9,
                  fontWeight: FontWeight.w600, letterSpacing: 0.22,
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

class _MiniCardPreview extends StatelessWidget {
  final AffirmationCard card;
  final DomainInfo domain;

  const _MiniCardPreview({required this.card, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        boxShadow: const [SBIShadows.md],
        border: Border.all(color: SBIColors.navyBorder, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: domain.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(domain.label.toUpperCase(),
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.16, color: Colors.white)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: SBIColors.ivory, borderRadius: BorderRadius.circular(99)),
                  child: Text('L${card.level}',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w700, color: domain.color)),
                ),
              ],
            ),
          ),
          Container(height: 4, color: SBIColors.gold),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DomainIconCircle(iconName: card.icon, domainColor: domain.color, softColor: domain.soft, size: 64, iconSize: 28),
                const SizedBox(height: 10),
                Text(card.word,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w800, color: SBIColors.navy)),
                const SizedBox(height: 8),
                const GoldRule(maxWidth: 60),
                const SizedBox(height: 8),
                Text('"${card.affirmation}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                        fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, color: SBIColors.burgundy)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final agenda = [
      _AgendaItem(dur: '02 min', title: 'Welcome', desc: 'Greeting and attendance check.'),
      _AgendaItem(dur: '03 min', title: 'Big Read', desc: 'Read the affirmation three times together.'),
      _AgendaItem(dur: '05 min', title: 'Definition', desc: 'Learn what the word means with examples.'),
      _AgendaItem(dur: '04 min', title: 'Role Play', desc: 'Practice the skill in three scenarios.'),
      _AgendaItem(dur: '01 min', title: 'Reflection', desc: 'Answer the reflection question.'),
    ];

    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Morning Meeting · Agenda'),
          const SizedBox(height: 6),
          Text('Today\'s session', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 14),
          const GoldRule(maxWidth: 100),
          const SizedBox(height: 14),
          ...agenda.map((item) => Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: SBIColors.navyBorder, width: 1.5))),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text(item.dur,
                      style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: SBIColors.burgundy)),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 130,
                  child: Text(item.title,
                      style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: SBIColors.navy)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item.desc,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: SBIColors.stone500, height: 1.4)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _AgendaItem {
  final String dur, title, desc;
  const _AgendaItem({required this.dur, required this.title, required this.desc});
}

class _BigAffirmationSlide extends StatelessWidget {
  final AffirmationCard card;
  const _BigAffirmationSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      isDark: true,
      isBurgundy: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'READ TOGETHER · THREE TIMES · CALMLY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter', fontSize: 12,
              fontWeight: FontWeight.w600, letterSpacing: 0.24, color: SBIColors.gold),
          ),
          const SizedBox(height: 28),
          Text(
            '"${card.affirmation}"',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 34, fontWeight: FontWeight.w800, color: SBIColors.ivory, height: 1.2),
          ),
          const SizedBox(height: 24),
          const GoldRule(maxWidth: 120),
          const SizedBox(height: 20),
          Text(
            'Say it slowly. Say it clearly.\nMean it.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18, fontStyle: FontStyle.italic, color: SBIColors.ivory.withValues(alpha: 0.85), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _DefinitionSlide extends StatelessWidget {
  final AffirmationCard card;
  const _DefinitionSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    final domain = domains[card.domain]!;
    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('What it means'),
          const SizedBox(height: 8),
          Text(card.word,
              style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 16),
          const GoldRule(maxWidth: 100),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  card.definition,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 20, fontStyle: FontStyle.italic, color: SBIColors.navy, height: 1.4),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: SBIColors.ivoryWarm,
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                    border: Border(left: BorderSide(color: SBIColors.gold, width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.format_quote, color: SBIColors.gold, size: 28),
                      const SizedBox(height: 8),
                      Text('"${card.affirmation}"',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, color: SBIColors.navy)),
                      const SizedBox(height: 10),
                      Text(
                        '${card.word.toUpperCase()} · ${domain.label.toUpperCase()}',
                        style: TextStyle(
                            fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w700,
                            letterSpacing: 0.16, color: SBIColors.burgundy),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LooksLikeSlide extends StatelessWidget {
  final AffirmationCard card;
  const _LooksLikeSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Behavior Examples'),
          const SizedBox(height: 6),
          Text('Looks like vs. Not like', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 14),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4EC),
                      borderRadius: BorderRadius.circular(SBIRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOOKS LIKE',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                                letterSpacing: 0.18, color: SBIColors.statusSuccess)),
                        const SizedBox(height: 12),
                        ...card.looksLike.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('✓ ',
                                  style: TextStyle(fontSize: 14, color: SBIColors.statusSuccess, fontWeight: FontWeight.w700)),
                              Expanded(
                                child: Text(item,
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: SBIColors.stone600, height: 1.4)),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E8EA),
                      borderRadius: BorderRadius.circular(SBIRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NOT LIKE',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                                letterSpacing: 0.18, color: SBIColors.burgundy)),
                        const SizedBox(height: 12),
                        ...card.notLike.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('✕ ',
                                  style: TextStyle(fontSize: 14, color: SBIColors.burgundy, fontWeight: FontWeight.w700)),
                              Expanded(
                                child: Text(item,
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: SBIColors.stone600, height: 1.4)),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePlaySlide extends StatelessWidget {
  final AffirmationCard card;
  const _RolePlaySlide({required this.card});

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      _RoleData(num: '01', title: 'At school', desc: 'A teacher asks you to redo an assignment.'),
      _RoleData(num: '02', title: 'At work', desc: 'A supervisor gives you feedback on your task.'),
      _RoleData(num: '03', title: 'In the community', desc: 'Someone in a store asks you to wait in line.'),
    ];

    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Practice scenarios'),
          const SizedBox(height: 6),
          Text('Role play it', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 14),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: scenarios.map((s) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: SBIColors.ivory,
                            borderRadius: BorderRadius.circular(SBIRadius.md),
                            border: Border(
                              top: BorderSide(color: SBIColors.gold, width: 4),
                              left: BorderSide(color: SBIColors.navyBorder, width: 1),
                              right: BorderSide(color: SBIColors.navyBorder, width: 1),
                              bottom: BorderSide(color: SBIColors.navyBorder, width: 1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.num, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: SBIColors.burgundy)),
                              const SizedBox(height: 6),
                              Text(s.title, style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.w700, color: SBIColors.navy)),
                              const SizedBox(height: 4),
                              Text(s.desc, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: SBIColors.stone500, height: 1.4)),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SBIColors.navy,
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.format_quote, color: SBIColors.gold, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          card.practice,
                          style: GoogleFonts.cormorantGaramond(
                              fontSize: 15, fontStyle: FontStyle.italic, color: SBIColors.ivory, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleData {
  final String num, title, desc;
  const _RoleData({required this.num, required this.title, required this.desc});
}

class _PracticePlanSlide extends StatelessWidget {
  final AffirmationCard card;
  const _PracticePlanSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    final times = [
      _TimeData(icon: Icons.wb_sunny_outlined, time: 'Morning', desc: 'Read the affirmation together. Set your intention.'),
      _TimeData(icon: Icons.wb_cloudy_outlined, time: 'Mid-day', desc: 'Check in. Did you get a chance to practice?'),
      _TimeData(icon: Icons.bedtime_outlined, time: 'End of day', desc: 'Answer the reflection question together.'),
    ];

    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Daily practice plan'),
          const SizedBox(height: 6),
          Text('Practice at every time of day', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 14),
          const GoldRule(maxWidth: 100),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: times.map((t) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SBIColors.ivoryWarm,
                      borderRadius: BorderRadius.circular(SBIRadius.md),
                      border: Border.all(color: SBIColors.navyBorder, width: 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: SBIColors.gold.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(t.icon, color: SBIColors.burgundy, size: 26),
                        ),
                        const SizedBox(height: 12),
                        Text(t.time, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: SBIColors.burgundy)),
                        const SizedBox(height: 6),
                        Text(t.desc, textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: SBIColors.stone500, height: 1.4)),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeData {
  final IconData icon;
  final String time, desc;
  const _TimeData({required this.icon, required this.time, required this.desc});
}

class _QuoteMomentSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      isDark: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('"',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 100, fontWeight: FontWeight.w900, color: SBIColors.gold.withValues(alpha: 0.7), height: 0.5)),
            const SizedBox(height: 24),
            Text(
              'Behavior is communication.\nLet us give you the words.',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontStyle: FontStyle.italic, color: SBIColors.ivory, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const SizedBox(height: 24),
            const GoldRule(maxWidth: 100),
            const SizedBox(height: 16),
            Text(
              'SPICY BEHAVIORAL INSTITUTE\u2122',
              style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 0.24, color: SBIColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReflectionSlide extends StatelessWidget {
  final AffirmationCard card;
  const _ReflectionSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('End of session'),
          const SizedBox(height: 6),
          Text('Reflection time', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 20),
          const GoldRule(maxWidth: 100),
          const SizedBox(height: 20),
          ...[
            card.reflection,
            'Name one time you showed this skill today.',
            'What is one goal for tomorrow?',
          ].asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.value,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18, fontWeight: FontWeight.w700, color: SBIColors.navy, height: 1.3)),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: SBIColors.stone200,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          )),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: SBIColors.navy,
              borderRadius: BorderRadius.circular(SBIRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment_turned_in_outlined, color: SBIColors.ivory, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Share one answer with the group before closing.',
                      style: GoogleFonts.cormorantGaramond(
                          fontSize: 14, fontStyle: FontStyle.italic, color: SBIColors.ivory)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TomorrowPreviewSlide extends StatelessWidget {
  final AffirmationCard currentCard;
  const _TomorrowPreviewSlide({required this.currentCard});

  @override
  Widget build(BuildContext context) {
    // Pick upcoming cards
    final upcoming = allCards.where((c) => c.domain != currentCard.domain).take(3).toList();

    return _SlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Coming up'),
          const SizedBox(height: 6),
          Text('What is next', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: SBIColors.navy)),
          const SizedBox(height: 14),
          const GoldRule(maxWidth: 100),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: upcoming.asMap().entries.map((entry) {
                final c = entry.value;
                final d = domains[c.domain]!;
                final isNext = entry.key == 1;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      transform: isNext ? (Matrix4.identity()..translate(0.0, -10.0)) : Matrix4.identity(),
                      decoration: BoxDecoration(
                        color: SBIColors.ivory,
                        borderRadius: BorderRadius.circular(SBIRadius.md),
                        border: Border.all(
                          color: isNext ? SBIColors.gold : SBIColors.navyBorder,
                          width: isNext ? 2 : 1,
                        ),
                        boxShadow: isNext ? const [SBIShadows.md] : const [SBIShadows.xs],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: d.color,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(SBIRadius.md),
                                topRight: Radius.circular(SBIRadius.md),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(color: d.soft, shape: BoxShape.circle),
                                  child: Icon(iconForName(c.icon), color: d.color, size: 26),
                                ),
                                const SizedBox(height: 8),
                                Text(c.word,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 14, fontWeight: FontWeight.w800, color: SBIColors.navy)),
                                const SizedBox(height: 4),
                                Text('"${c.affirmation}"',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.cormorantGaramond(
                                        fontSize: 11, fontStyle: FontStyle.italic, color: SBIColors.burgundy)),
                                if (isNext) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: SBIColors.gold.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text('NEXT UP',
                                        style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w700,
                                            letterSpacing: 0.16, color: SBIColors.gold)),
                                  ),
                                ],
                              ],
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
        ],
      ),
    );
  }
}

class _CloseSlide extends StatelessWidget {
  final AffirmationCard card;
  const _CloseSlide({required this.card});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      isDark: true,
      isBurgundy: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CLOSING', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700,
                letterSpacing: 0.24, color: SBIColors.gold)),
            const SizedBox(height: 20),
            Text('"${card.affirmation}"',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(fontSize: 30, fontWeight: FontWeight.w800, color: SBIColors.ivory, height: 1.2)),
            const SizedBox(height: 24),
            const GoldRule(maxWidth: 100),
            const SizedBox(height: 20),
            Text('Great job today.',
                style: GoogleFonts.cormorantGaramond(fontSize: 20, fontStyle: FontStyle.italic, color: SBIColors.ivory.withValues(alpha: 0.85))),
            const SizedBox(height: 32),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: SBIColors.gold.withValues(alpha: 0.5), width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SBI\u2122', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                    Icon(Icons.psychology, size: 16, color: SBIColors.gold),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Slide base layout
class _SlideBase extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final bool isBurgundy;

  const _SlideBase({required this.child, this.isDark = false, this.isBurgundy = false});

  @override
  Widget build(BuildContext context) {
    Color bg;
    if (isBurgundy) {
      bg = SBIColors.burgundy;
    } else if (isDark) {
      bg = SBIColors.navy;
    } else {
      bg = SBIColors.ivory;
    }

    return Container(
      color: bg,
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
