import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/sbi_tokens.dart';

class LandingScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onPreview;

  const LandingScreen({super.key, required this.onLogin, required this.onPreview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBIColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LandingHeader(),
              _HeroSection(onLogin: onLogin, onPreview: onPreview),
              _FeaturesSection(),
              _DomainsSection(),
              _AccessNote(onLogin: onLogin, onPreview: onPreview),
              _LandingFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────
class _LandingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: SBIColors.gold.withValues(alpha: 0.3), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle,
                border: Border.all(color: SBIColors.gold, width: 2)),
            child: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SBI', style: const TextStyle(fontFamily: 'Inter', fontSize: 9,
                    fontWeight: FontWeight.w800, color: Colors.white)),
                Icon(Icons.psychology, size: 10, color: SBIColors.gold),
              ],
            )),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Spicy Behavioral Institute™',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 10,
                      fontWeight: FontWeight.w600, color: SBIColors.gold, letterSpacing: 0.12)),
              Text('SBI Success Cards™',
                  style: GoogleFonts.playfairDisplay(fontSize: 15,
                      fontWeight: FontWeight.w800, color: Colors.white)),
            ],
          )),
          _HeaderBadge('Member Access'),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final String label;
  const _HeaderBadge(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: SBIColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(SBIRadius.pill),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.4), width: 1)),
    child: Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10,
        fontWeight: FontWeight.w600, color: SBIColors.gold)),
  );
}

// ─── Hero ─────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onPreview;
  const _HeroSection({required this.onLogin, required this.onPreview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: SBIColors.burgundy,
                borderRadius: BorderRadius.circular(SBIRadius.pill)),
            child: Text('Premium Life-Skills Practice Tool',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 10,
                    fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.12)),
          ),
          const SizedBox(height: 16),
          Text('Interactive Life Skills\nPractice for\nReal-Life Success.',
              style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w800,
                  color: Colors.white, height: 1.15)),
          const SizedBox(height: 16),
          Text(
            'Behavioral vocabulary, affirmations, real-world scenarios, and printable practice cards for learners with ASD and Intellectual Disabilities.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14,
                color: Colors.white.withValues(alpha: 0.75), height: 1.6),
          ),
          const SizedBox(height: 32),
          // CTA buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onLogin,
              icon: const Icon(Icons.lock_open_outlined, size: 18),
              label: const Text('Log In to My Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SBIColors.gold,
                foregroundColor: SBIColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.pill)),
                textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPreview,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Preview Cards'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.pill)),
                textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text('Purchase in Resource Library →',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 13,
                      color: SBIColors.gold, fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: SBIColors.gold)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Features ─────────────────────────────────────────────────────────────────
class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.style_outlined, '60 behavioral vocabulary & affirmation cards'),
      (Icons.grid_view_outlined, '8 essential skill domains'),
      (Icons.person_outlined, 'Learner-friendly digital practice'),
      (Icons.volume_up_outlined, 'Read-aloud audio support'),
      (Icons.chat_bubble_outline, 'Scenario-based learning'),
      (Icons.print_outlined, 'Printable front/back card deck'),
      (Icons.school_outlined, 'Adult teaching prompts included'),
      (Icons.bar_chart_outlined, 'Progress tracking for each learner'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.gold.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WHAT\'S INCLUDED',
              style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 0.18, color: SBIColors.gold)),
          const SizedBox(height: 16),
          ...features.map((f) {
            final (icon, label) = f;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Icon(icon, size: 16, color: SBIColors.gold),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: TextStyle(fontFamily: 'Inter',
                    fontSize: 13, color: Colors.white.withValues(alpha: 0.85), height: 1.4))),
              ]),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Domains Preview ──────────────────────────────────────────────────────────
class _DomainsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final domains = [
      (const Color(0xFF1F3E66), 'Workplace Skills', Icons.work_outline),
      (const Color(0xFF5B3A7A), 'Relationship Skills', Icons.people_outline),
      (const Color(0xFF2F6B3B), 'Character Strengths', Icons.shield_outlined),
      (const Color(0xFF4A4A4A), 'Daily Life Skills', Icons.home_outlined),
      (const Color(0xFF2A6873), 'Communication Skills', Icons.chat_outlined),
      (const Color(0xFFA85822), 'Social Understanding', Icons.psychology_outlined),
      (const Color(0xFF6E0D25), 'Coping & Stress Mgmt', Icons.air_outlined),
      (const Color(0xFF9C7314), 'Self-Advocacy', Icons.star_outline),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('8 SKILL DOMAINS',
              style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 0.18, color: SBIColors.gold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.2,
            children: domains.map((d) {
              final (color, label, icon) = d;
              return Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(SBIRadius.sm),
                  border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
                ),
                child: Row(children: [
                  const SizedBox(width: 10),
                  Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(label, style: TextStyle(fontFamily: 'Inter',
                      fontSize: 10, fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9)), maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
                ]),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Access Note ──────────────────────────────────────────────────────────────
class _AccessNote extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onPreview;
  const _AccessNote({required this.onLogin, required this.onPreview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SBIColors.burgundy.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(SBIRadius.md),
        border: Border.all(color: SBIColors.burgundy.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.info_outline, color: SBIColors.gold, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('Member Access Required',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13,
                    fontWeight: FontWeight.w700, color: Colors.white))),
          ]),
          const SizedBox(height: 8),
          Text(
            'Access is available through the SBI Resource Library. Log in after purchase to begin using all features.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8), height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: onLogin,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.pill)),
              ),
              child: const Text('Log In', style: TextStyle(fontFamily: 'Inter',
                  fontSize: 12, fontWeight: FontWeight.w700)),
            )),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(
              onPressed: onPreview,
              style: ElevatedButton.styleFrom(
                backgroundColor: SBIColors.gold, foregroundColor: SBIColors.navy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.pill)),
              ),
              child: const Text('Preview Free', style: TextStyle(fontFamily: 'Inter',
                  fontSize: 12, fontWeight: FontWeight.w700)),
            )),
          ]),
        ],
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────
class _LandingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: SBIColors.gold.withValues(alpha: 0.2), width: 1)),
      ),
      child: Column(children: [
        Text('Spicy Behavioral Institute™',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                fontWeight: FontWeight.w700, color: SBIColors.gold)),
        const SizedBox(height: 4),
        Text('spicybehavioralinstitute.com',
            style: TextStyle(fontFamily: 'Inter', fontSize: 11,
                color: Colors.white.withValues(alpha: 0.5))),
        const SizedBox(height: 8),
        Text('Designed for learners with ASD, Intellectual Disabilities,\nand transition-age youth.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 10,
                color: Colors.white.withValues(alpha: 0.4), height: 1.5)),
      ]),
    );
  }
}
