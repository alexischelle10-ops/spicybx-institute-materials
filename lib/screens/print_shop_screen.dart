import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/sbi_tokens.dart';
import '../widgets/domain_icon.dart';

// ─── Purchase link — swap this URL when your Gumroad/Etsy/shop is live ───────
const String _shopUrl = 'https://spicybehavioralinstitute.com';

class PrintShopScreen extends StatelessWidget {
  const PrintShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBIColors.ivory,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PrintShopMasthead(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero pitch
                    _HeroBanner(),
                    const SizedBox(height: 24),
                    // What you get section
                    _WhatYouGetSection(),
                    const SizedBox(height: 24),
                    // The 3 deck packages
                    _SectionLabel('CHOOSE YOUR DECK'),
                    const SizedBox(height: 12),
                    _DeckCard(
                      level: '01',
                      title: 'Foundations Deck',
                      subtitle: 'Character · Regulation · Relationship',
                      description:
                          'Perfect starting point. 20 cards covering the core behavioral skills every learner needs first — self-control, kindness, honesty, listening, and more.',
                      cardCount: 20,
                      domainCount: 3,
                      price: '\$12',
                      color: const Color(0xFF2F6B3B),
                      features: [
                        'Character Strengths (7 cards)',
                        'Emotional Regulation (7 cards)',
                        'Relationship Skills (6 cards)',
                        'Front & back print-ready PDF',
                        'Standard card size: 3.5" × 5"',
                        'Cut guides included',
                      ],
                      isPopular: false,
                    ),
                    const SizedBox(height: 14),
                    _DeckCard(
                      level: '02',
                      title: 'Workplace & Community Deck',
                      subtitle: 'Workplace · Community · Safety',
                      description:
                          'Built for transition programs. 21 cards targeting the real-world skills learners need on the job, in the community, and staying safe.',
                      cardCount: 21,
                      domainCount: 3,
                      price: '\$12',
                      color: const Color(0xFF1F3E66),
                      features: [
                        'Workplace Skills (8 cards)',
                        'Community Skills (7 cards)',
                        'Safety Skills (6 cards)',
                        'Front & back print-ready PDF',
                        'Standard card size: 3.5" × 5"',
                        'Cut guides included',
                      ],
                      isPopular: true,
                    ),
                    const SizedBox(height: 14),
                    _DeckCard(
                      level: '03',
                      title: 'Leadership & Independence Deck',
                      subtitle: 'Leadership · Independent Living',
                      description:
                          'For learners ready to step up. 19 cards focused on leading others, self-advocacy, daily living, and managing life independently.',
                      cardCount: 19,
                      domainCount: 2,
                      price: '\$12',
                      color: const Color(0xFF9C7314),
                      features: [
                        'Leadership Skills (9 cards)',
                        'Independent Living (10 cards)',
                        'Front & back print-ready PDF',
                        'Standard card size: 3.5" × 5"',
                        'Cut guides included',
                      ],
                      isPopular: false,
                    ),
                    const SizedBox(height: 14),
                    // Complete bundle
                    _BundleCard(),
                    const SizedBox(height: 28),
                    // Print instructions
                    _PrintInstructionsSection(),
                    const SizedBox(height: 20),
                    // FAQ
                    _FAQSection(),
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

// ─── Masthead ────────────────────────────────────────────────────────────────

class _PrintShopMasthead extends StatelessWidget {
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
            decoration: BoxDecoration(
              color: SBIColors.navy,
              shape: BoxShape.circle,
              border: Border.all(color: SBIColors.gold, width: 1.5),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SBI\u2122',
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
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
                Text('Print Shop',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: SBIColors.navy)),
                Text('Print-ready card decks · Digital PDF download',
                    style: GoogleFonts.cormorantGaramond(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: SBIColors.stone500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: SBIColors.burgundy,
              borderRadius: BorderRadius.circular(SBIRadius.pill),
            ),
            child: Text('SHOP',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.14,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: SBIColors.navy,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        boxShadow: const [SBIShadows.md],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.print, color: SBIColors.gold, size: 18),
              const SizedBox(width: 8),
              Text('PRINT-READY CARD DECKS',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.18,
                      color: SBIColors.gold)),
            ],
          ),
          const SizedBox(height: 10),
          Text('Bring the cards\ninto the real world.',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2)),
          const SizedBox(height: 10),
          Text(
            'Download a professionally formatted PDF. Print front-to-back on any home printer or send to a print shop. Cut, laminate, and go.',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _HeroBadge(icon: Icons.picture_as_pdf_outlined, label: 'PDF Download'),
              const SizedBox(width: 10),
              _HeroBadge(icon: Icons.flip_outlined, label: 'Front & Back'),
              const SizedBox(width: 10),
              _HeroBadge(icon: Icons.cut_outlined, label: 'Cut Guides'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SBIRadius.pill),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: SBIColors.gold),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9))),
        ],
      ),
    );
  }
}

// ─── What You Get ─────────────────────────────────────────────────────────────

class _WhatYouGetSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.style_outlined, 'Print-ready PDF', 'Formatted for standard 3.5" × 5" index cards or letter paper'),
      (Icons.flip_to_back_outlined, 'Front & back layout', 'Card fronts and backs aligned for duplex / double-sided printing'),
      (Icons.content_cut_outlined, 'Cut guides', 'Crop marks on every sheet so trimming is fast and accurate'),
      (Icons.water_drop_outlined, 'Lamination-ready', 'High-resolution artwork survives lamination without pixelating'),
      (Icons.image_outlined, 'Behavioral scene images', 'Every card back includes the domain "In Action" photo'),
      (Icons.download_done_outlined, 'Instant download', 'PDF delivered immediately after purchase — no shipping wait'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('EVERY DECK INCLUDES'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SBIColors.ivoryWarm,
            borderRadius: BorderRadius.circular(SBIRadius.md),
            border: Border.all(color: SBIColors.navyBorder, width: 1),
          ),
          child: Column(
            children: items.map((item) {
              final (icon, title, desc) = item;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: SBIColors.burgundy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(SBIRadius.sm),
                      ),
                      child: Icon(icon, size: 16, color: SBIColors.burgundy),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F1C2E))),
                          const SizedBox(height: 2),
                          Text(desc,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: SBIColors.stone500,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Deck Card ────────────────────────────────────────────────────────────────

class _DeckCard extends StatelessWidget {
  final String level;
  final String title;
  final String subtitle;
  final String description;
  final int cardCount;
  final int domainCount;
  final String price;
  final Color color;
  final List<String> features;
  final bool isPopular;

  const _DeckCard({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.cardCount,
    required this.domainCount,
    required this.price,
    required this.color,
    required this.features,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(
          color: isPopular ? SBIColors.gold : SBIColors.navyBorder,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular ? const [SBIShadows.md] : const [SBIShadows.xs],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header band
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: color,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(SBIRadius.pill),
                  ),
                  child: Text('LEVEL $level',
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.16,
                          color: Colors.white)),
                ),
                const Spacer(),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: SBIColors.gold,
                      borderRadius: BorderRadius.circular(SBIRadius.pill),
                    ),
                    child: Text('MOST POPULAR',
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.14,
                            color: Color(0xFF0F1C2E))),
                  ),
                if (!isPopular)
                  Row(
                    children: [
                      Icon(Icons.style_outlined, size: 13, color: Colors.white.withValues(alpha: 0.7)),
                      const SizedBox(width: 4),
                      Text('$cardCount cards',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.85))),
                    ],
                  ),
              ],
            ),
          ),
          // Gold bar
          Container(height: 3, color: SBIColors.gold),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: SBIColors.navy)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.08)),
                const SizedBox(height: 10),
                Text(description,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: SBIColors.stone600,
                        height: 1.5)),
                const SizedBox(height: 14),
                // Stats row
                Row(
                  children: [
                    _StatChip(label: '$cardCount Cards', icon: Icons.style_outlined),
                    const SizedBox(width: 8),
                    _StatChip(label: '$domainCount Domains', icon: Icons.grid_view_outlined),
                    const SizedBox(width: 8),
                    _StatChip(label: 'PDF', icon: Icons.picture_as_pdf_outlined),
                  ],
                ),
                const SizedBox(height: 14),
                // Features list
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 13, color: color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(f,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: SBIColors.navy,
                                    height: 1.3)),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),
                // Price + CTA row
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(price,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: SBIColors.navy)),
                        Text('one-time · instant PDF',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: SBIColors.stone500)),
                      ],
                    ),
                    const Spacer(),
                    _BuyButton(
                      label: 'Buy & Download',
                      color: color,
                      onTap: () => _launchShop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bundle Card ─────────────────────────────────────────────────────────────

class _BundleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SBIColors.navy, const Color(0xFF1A2F4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.gold, width: 2),
        boxShadow: const [SBIShadows.lg],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Watermark
          Positioned(
            bottom: -20,
            right: -20,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.psychology, size: 160, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: SBIColors.gold,
                        borderRadius: BorderRadius.circular(SBIRadius.pill),
                      ),
                      child: Text('BEST VALUE',
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.16,
                              color: Color(0xFF0F1C2E))),
                    ),
                    const Spacer(),
                    Text('COMPLETE BUNDLE',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.16,
                            color: SBIColors.gold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text('All 60 Cards\nComplete Deck Bundle',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2)),
                const SizedBox(height: 8),
                Text(
                  'Every card across all 8 domains — Foundations, Workplace, Community, Safety, Leadership, and Independent Living. The full SBI Success Cards system in one print-ready PDF.',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.5),
                ),
                const SizedBox(height: 16),
                // Domain chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    'Character', 'Workplace', 'Relationship',
                    'Community', 'Safety', 'Leadership',
                    'Regulation', 'Independence',
                  ].map((d) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(SBIRadius.pill),
                          border: Border.all(
                              color: SBIColors.gold.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Text(d,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.85))),
                      )).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$29',
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('\$36',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.4),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor:
                                          Colors.white.withValues(alpha: 0.4))),
                            ),
                          ],
                        ),
                        Text('Save \$7 · instant PDF download',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: SBIColors.gold.withValues(alpha: 0.85))),
                      ],
                    ),
                    const Spacer(),
                    _BuyButton(
                      label: 'Get Bundle',
                      color: SBIColors.gold,
                      textColor: SBIColors.navy,
                      onTap: () => _launchShop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Print Instructions ───────────────────────────────────────────────────────

class _PrintInstructionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      (Icons.download_outlined, 'Download', 'Click Buy & Download. Your PDF arrives instantly in your inbox and as a direct download.'),
      (Icons.print_outlined, 'Print', 'Open in any PDF viewer. Select "Duplex / Double-sided" and "Flip on short edge" for perfect front-to-back alignment.'),
      (Icons.content_cut_outlined, 'Cut', 'Use the crop marks on each sheet as a guide. A paper trimmer gives the cleanest edge.'),
      (Icons.water_drop_outlined, 'Laminate (optional)', 'Run through a thermal laminator for durable, wipe-clean cards. Great for classroom and clinic use.'),
      (Icons.auto_fix_high_outlined, 'Punch & Ring', 'Hole-punch the corner and add a binder ring for a portable flip deck learners can carry anywhere.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('HOW TO PRINT'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SBIColors.ivory,
            borderRadius: BorderRadius.circular(SBIRadius.md),
            border: Border.all(color: SBIColors.navyBorder, width: 1),
          ),
          child: Column(
            children: steps.asMap().entries.map((entry) {
              final idx = entry.key;
              final (icon, title, desc) = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step number circle
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: SBIColors.burgundy,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${idx + 1}',
                            style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, size: 14, color: SBIColors.burgundy),
                              const SizedBox(width: 6),
                              Text(title,
                                  style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F1C2E))),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(desc,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: SBIColors.stone500,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── FAQ ─────────────────────────────────────────────────────────────────────

class _FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final faqs = [
      ('What file format will I receive?',
          'A high-resolution PDF formatted for standard US letter paper (8.5" × 11"). Each sheet contains 2 cards (front on top, back on bottom) with crop marks.'),
      ('What paper should I use?',
          '65 lb cardstock gives the best feel. 32 lb heavy copy paper also works great and is lamination-friendly. Standard 20 lb paper works too.'),
      ('Can I print at a copy shop?',
          'Yes! Take the PDF to FedEx Office, Staples, or any local print shop. Request duplex printing on cardstock for best results.'),
      ('How many times can I print?',
          'Your purchase is for personal and professional classroom/clinic use. Print as many copies as you need for your own learners.'),
      ('Do the cards match the digital app?',
          'Yes — every card in the print deck matches exactly what you see in the SBI Success Cards digital app, including the behavioral scene images on the back.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('FREQUENTLY ASKED'),
        const SizedBox(height: 12),
        ...faqs.map((faq) {
          final (q, a) = faq;
          return _FAQTile(question: q, answer: a);
        }),
      ],
    );
  }
}

class _FAQTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FAQTile({required this.question, required this.answer});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _open = !_open),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: SBIColors.ivory,
          borderRadius: BorderRadius.circular(SBIRadius.sm),
          border: Border.all(color: SBIColors.navyBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.question,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F1C2E))),
                  ),
                  Icon(
                    _open ? Icons.remove : Icons.add,
                    size: 16,
                    color: SBIColors.burgundy,
                  ),
                ],
              ),
            ),
            if (_open)
              Container(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Text(widget.answer,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: SBIColors.stone600,
                        height: 1.5)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.18,
            color: SBIColors.stone500));
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: SBIColors.ivoryWarm,
        borderRadius: BorderRadius.circular(SBIRadius.pill),
        border: Border.all(color: SBIColors.navyBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: SBIColors.stone500),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: SBIColors.navy)),
        ],
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;

  const _BuyButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(SBIRadius.pill),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_outlined,
                size: 14, color: textColor ?? Colors.white),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor ?? Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ─── Launch shop URL ──────────────────────────────────────────────────────────

void _launchShop(BuildContext context) {
  // Copy shop URL to clipboard and show snackbar
  Clipboard.setData(const ClipboardData(text: _shopUrl));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.open_in_new, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Visit $_shopUrl to purchase your print deck!',
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
            ),
          ),
        ],
      ),
      backgroundColor: SBIColors.burgundy,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SBIRadius.sm)),
      duration: const Duration(seconds: 4),
    ),
  );
}
