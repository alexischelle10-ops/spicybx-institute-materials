import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/sbi_tokens.dart';
import '../widgets/domain_icon.dart';

class BinderCoverScreen extends StatelessWidget {
  const BinderCoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBIColors.ivory,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BinderMasthead(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Binder layout: back | spine | front
                    _BinderSetPreview(),
                    const SizedBox(height: 24),
                    // Print note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: SBIColors.gold.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(SBIRadius.md),
                        border: Border(left: BorderSide(color: SBIColors.gold, width: 3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.print_outlined, color: SBIColors.burgundy, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PRINT READY',
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                                        letterSpacing: 0.16, color: SBIColors.burgundy)),
                                const SizedBox(height: 2),
                                Text('This binder set is formatted for 8.5 × 11 paper with a 2-inch spine. Print double-sided for a professional finish.',
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: SBIColors.navy, height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _BinderMasthead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: SBIColors.navy, shape: BoxShape.circle,
                border: Border.all(color: SBIColors.gold, width: 1.5)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SBI\u2122', style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                  Icon(Icons.psychology, size: 12, color: SBIColors.gold),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow('Spicy Behavioral Institute\u2122'),
                Text('Binder Cover Set',
                    style: GoogleFonts.playfairDisplay(fontSize: 17, fontWeight: FontWeight.w800, color: SBIColors.navy)),
                Text('Front cover · Spine · Back cover',
                    style: GoogleFonts.cormorantGaramond(fontSize: 12, fontStyle: FontStyle.italic, color: SBIColors.stone500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Volume I', style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.w700, color: SBIColors.burgundy)),
              Text('8.5 × 11 + spine',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: SBIColors.stone500, letterSpacing: 0.08)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BinderSetPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Front cover
        _FrontCover(),
        const SizedBox(height: 16),
        // Spine
        _Spine(),
        const SizedBox(height: 16),
        // Back cover
        _BackCover(),
      ],
    );
  }
}

class _FrontCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.7), width: 1.5),
        boxShadow: const [SBIShadows.md],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Watermark
          Positioned(
            bottom: -30,
            right: -30,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.psychology, size: 200, color: SBIColors.navy),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Seal
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: SBIColors.navy, shape: BoxShape.circle,
                      border: Border.all(color: SBIColors.gold, width: 2.5)),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SBI\u2122', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                      Icon(Icons.psychology, size: 16, color: SBIColors.gold),
                    ],
                  )),
                ),
                const SizedBox(height: 12),
                Eyebrow('Spicy Behavioral Institute\u2122'),
                Text('Volume I · 2026 Edition',
                    style: GoogleFonts.cormorantGaramond(fontSize: 12, fontStyle: FontStyle.italic, color: SBIColors.stone400)),
                const SizedBox(height: 16),
                Container(height: 1.5, width: 80, color: SBIColors.gold),
                const SizedBox(height: 20),
                // Hero title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.playfairDisplay(fontSize: 30, fontWeight: FontWeight.w800, color: SBIColors.navy, height: 1.15),
                    children: [
                      const TextSpan(text: 'Positive\nAffirmation\n'),
                      TextSpan(text: '& Success\n',
                          style: GoogleFonts.playfairDisplay(fontSize: 30, fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, color: SBIColors.burgundy)),
                      const TextSpan(text: 'Cards.'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('Building Confidence · Respect · Independence',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(fontSize: 14, fontStyle: FontStyle.italic, color: SBIColors.stone500)),
                const SizedBox(height: 24),
                // Level tiles
                Row(
                  children: [
                    Expanded(child: _LevelTile(num: '01', label: 'Foundations')),
                    const SizedBox(width: 8),
                    Expanded(child: _LevelTile(num: '02', label: 'Workplace &\nCommunity')),
                    const SizedBox(width: 8),
                    Expanded(child: _LevelTile(num: '03', label: 'Independence &\nLeadership')),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Bottom ribbon
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: SBIColors.burgundy,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CARDS · WORKBOOK · POSTERS · CERTIFICATES',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w600,
                          letterSpacing: 0.16, color: SBIColors.ivory)),
                  Text('HOME · SCHOOL · CLINIC · COMMUNITY',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w600,
                          letterSpacing: 0.14, color: SBIColors.ivory.withValues(alpha: 0.7))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final String num;
  final String label;
  const _LevelTile({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SBIColors.ivoryWarm,
        borderRadius: BorderRadius.circular(SBIRadius.sm),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: SBIColors.navy, borderRadius: BorderRadius.circular(99)),
            child: Text('LEVEL $num',
                style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w700,
                    letterSpacing: 0.14, color: SBIColors.gold)),
          ),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: SBIColors.navy, height: 1.3)),
        ],
      ),
    );
  }
}

class _Spine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: SBIColors.burgundy,
        borderRadius: BorderRadius.circular(SBIRadius.sm),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Brain icon
          Icon(Icons.psychology, size: 22, color: SBIColors.gold.withValues(alpha: 0.9)),
          const SizedBox(width: 16),
          Container(width: 1.5, height: 30, color: SBIColors.gold.withValues(alpha: 0.4)),
          const SizedBox(width: 16),
          // Spine title
          Expanded(
            child: Text(
              'Positive Affirmation & Success Cards · Spicy Behavioral Institute\u2122 · Vol. I · L1 · L2 · L3',
              style: TextStyle(
                fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700,
                color: SBIColors.ivory, letterSpacing: 0.08,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1.5, height: 30, color: SBIColors.gold.withValues(alpha: 0.4)),
          const SizedBox(width: 16),
          Text('2026', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600,
              color: SBIColors.ivory.withValues(alpha: 0.7))),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _BackCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inside = [
      '60+ affirmation cards',
      'Matching workbook activities',
      'Morning Meeting slide deck',
      'Affirmation posters',
      'Ring & pocket cards',
      'Self-monitoring checklists',
      'Certificates of completion',
      'Caregiver discussion pages',
    ];

    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.7), width: 1.5),
        boxShadow: const [SBIShadows.md],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Watermark
          Positioned(
            top: -40,
            left: -40,
            child: Opacity(
              opacity: 0.05,
              child: Icon(Icons.psychology, size: 220, color: SBIColors.navy),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: SBIColors.navy, shape: BoxShape.circle,
                          border: Border.all(color: SBIColors.gold, width: 2)),
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('SBI\u2122', style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                          Icon(Icons.psychology, size: 12, color: SBIColors.gold),
                        ],
                      )),
                    ),
                    const SizedBox(width: 12),
                    Eyebrow('About this curriculum'),
                  ],
                ),
                const SizedBox(height: 14),
                Text('A complete affirmation & vocabulary system for transition-age learners.',
                    style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: SBIColors.navy, height: 1.3)),
                const SizedBox(height: 10),
                Text('Designed for older teens, young adults, and adults with developmental disabilities. Built by BCBAs, SLPs, and transition specialists.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: SBIColors.stone600, height: 1.5)),
                const SizedBox(height: 16),
                // Inside this binder panel
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SBIColors.ivoryWarm,
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INSIDE THIS BINDER',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                              letterSpacing: 0.18, color: SBIColors.burgundy)),
                      const SizedBox(height: 10),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 10,
                        childAspectRatio: 5,
                        children: inside.map((item) => Row(
                          children: [
                            Icon(Icons.check, size: 14, color: SBIColors.burgundy),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(item,
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: SBIColors.navy)),
                            ),
                          ],
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'LEVELS 1 · 2 · 3 · HOME · SCHOOL · CLINIC · VOCATIONAL · COMMUNITY',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w600,
                        letterSpacing: 0.14, color: SBIColors.stone400),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Bottom ribbon
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: SBIColors.burgundy,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SPICY BEHAVIORAL INSTITUTE\u2122 · VOCABULARY WORKBOOK',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w600,
                          letterSpacing: 0.14, color: SBIColors.ivory)),
                  Text('VOLUME I · EDITION 2026',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 8, color: SBIColors.ivory.withValues(alpha: 0.7),
                          letterSpacing: 0.12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
