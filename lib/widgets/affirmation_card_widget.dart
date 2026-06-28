import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/affirmation_card.dart';
import '../data/cards_data.dart';
import '../theme/sbi_tokens.dart';
import 'domain_icon.dart';

class AffirmationCardWidget extends StatefulWidget {
  final AffirmationCard card;
  final bool isFlipped;
  final bool isDense;
  final VoidCallback onFlip;

  const AffirmationCardWidget({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.isDense,
    required this.onFlip,
  });

  @override
  State<AffirmationCardWidget> createState() => _AffirmationCardWidgetState();
}

class _AffirmationCardWidgetState extends State<AffirmationCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.65, 0, 0.35, 1),
      ),
    );
    if (widget.isFlipped) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(AffirmationCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final domain = domains[widget.card.domain]!;

    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final isFrontVisible = angle < (math.pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0007)
              ..rotateY(angle),
            child: isFrontVisible
                ? _CardFront(card: widget.card, domain: domain)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _CardBack(
                      card: widget.card,
                      domain: domain,
                      isDense: widget.isDense,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  final AffirmationCard card;
  final DomainInfo domain;

  const _CardFront({required this.card, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        boxShadow: const [SBIShadows.sm],
        border: Border.all(color: SBIColors.navyBorder, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Domain band
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: domain.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  domain.label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.18,
                    color: Colors.white,
                  ),
                ),
                LevelBadge(level: card.level, domainColor: domain.color),
              ],
            ),
          ),
          // Gold separator
          Container(height: 4, color: SBIColors.gold),
          // Card body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Column(
                children: [
                  // Icon circle
                  DomainIconCircle(
                    iconName: card.icon,
                    domainColor: domain.color,
                    softColor: domain.soft,
                    size: 72,
                    iconSize: 32,
                  ),
                  const SizedBox(height: 12),
                  // Word headline
                  Text(
                    card.word,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: SBIColors.navy,
                      letterSpacing: -0.02,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const GoldRule(maxWidth: 80),
                  const SizedBox(height: 10),
                  // Affirmation
                  Text(
                    '"${card.affirmation}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: SBIColors.burgundy,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: SBIColors.navyBorder, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CARD · ${card.id}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.12,
                    color: SBIColors.stone500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'FLIP',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.18,
                        color: SBIColors.burgundy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.refresh, size: 11, color: SBIColors.burgundy),
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

/// Narrow behavioral scene strip (~88px tall) shown on card back between
/// the definition and the Looks Like / Not Like panels.
class _DomainSceneImage extends StatelessWidget {
  final String? imageUrl;
  final Color domainColor;

  const _DomainSceneImage({required this.imageUrl, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(SBIRadius.sm),
      child: Stack(
        children: [
          // Scene photo
          SizedBox(
            height: 88,
            width: double.infinity,
            child: Image.network(
              imageUrl!,
              height: 88,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 88,
                  color: domainColor.withValues(alpha: 0.08),
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: domainColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stack) => Container(
                height: 88,
                color: domainColor.withValues(alpha: 0.08),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 24,
                    color: domainColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          // Subtle domain-color gradient overlay at bottom for text legibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 32,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    domainColor.withValues(alpha: 0.0),
                    domainColor.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ),
          // "IN ACTION" label bottom-left
          Positioned(
            left: 8,
            bottom: 5,
            child: Text(
              'IN ACTION',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 7,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.18,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final AffirmationCard card;
  final DomainInfo domain;
  final bool isDense;

  const _CardBack({
    required this.card,
    required this.domain,
    required this.isDense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        boxShadow: const [SBIShadows.sm],
        border: Border.all(color: SBIColors.navyBorder, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Domain band
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: domain.color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  domain.label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.18,
                    color: Colors.white,
                  ),
                ),
                LevelBadge(level: card.level, domainColor: domain.color),
              ],
            ),
          ),
          Container(height: 4, color: SBIColors.gold),
          // Back body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.word,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: SBIColors.burgundy,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: SBIColors.ivoryWarm,
                          borderRadius: BorderRadius.circular(SBIRadius.xs),
                          border: Border.all(color: SBIColors.stone200),
                        ),
                        child: Text(
                          'DEFINITION',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.15,
                            color: SBIColors.stone500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Definition
                  Text(
                    card.definition,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      height: 1.5,
                      color: SBIColors.navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Behavioral scene image — visual anchor for the operational definition
                  _DomainSceneImage(
                    imageUrl: domainImages[card.domain],
                    domainColor: domain.color,
                  ),
                  const SizedBox(height: 8),
                  // Looks like / Not like
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4EE),
                            borderRadius: BorderRadius.circular(SBIRadius.sm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOOKS LIKE',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.15,
                                  color: SBIColors.statusSuccess,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...card.looksLike.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '✓ ',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: SBIColors.statusSuccess,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 9.5,
                                          color: SBIColors.stone600,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9EEF0),
                            borderRadius: BorderRadius.circular(SBIRadius.sm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NOT LIKE',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.15,
                                  color: SBIColors.burgundy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...card.notLike.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '✕ ',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: SBIColors.burgundy,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 9.5,
                                          color: SBIColors.stone600,
                                          height: 1.3,
                                        ),
                                      ),
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
                  const SizedBox(height: 8),
                  // Practice today callout
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    decoration: BoxDecoration(
                      color: SBIColors.goldAction,
                      borderRadius: BorderRadius.circular(SBIRadius.sm),
                      border: Border(
                        left: BorderSide(color: SBIColors.gold, width: 3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRACTICE TODAY',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.15,
                            color: SBIColors.burgundy,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          card.practice,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5,
                            color: SBIColors.navy,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDense) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      decoration: BoxDecoration(
                        color: SBIColors.navy.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(SBIRadius.sm),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REFLECTION',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.15,
                              color: SBIColors.stone500,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            card.reflection,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: SBIColors.navy,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: SBIColors.navyBorder, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spicy Behavioral Institute\u2122',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8,
                    color: SBIColors.stone400,
                  ),
                ),
                Text(
                  'LEVEL ${card.level}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: SBIColors.burgundy,
                    letterSpacing: 0.12,
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
