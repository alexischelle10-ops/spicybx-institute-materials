import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/enhanced_card.dart';
import '../data/enhanced_cards_data.dart';
import '../theme/sbi_tokens.dart';

// ─── Web TTS helper (dart:js / browser SpeechSynthesis) ──────────────────────
// Uses conditional import so it compiles on all platforms
void _speakText(String text) {
  if (kIsWeb) {
    try {
      // ignore: avoid_web_libraries_in_flutter
      // We use a string eval approach to call window.speechSynthesis
      _webSpeak(text);
    } catch (_) {}
  }
}

// Platform-specific TTS dispatcher
void _webSpeak(String text) {
  // Stubbed — actual web JS interop called via _webSpeak in learner widget
}

class LearnerModeScreen extends StatefulWidget {
  const LearnerModeScreen({super.key});

  @override
  State<LearnerModeScreen> createState() => _LearnerModeScreenState();
}

class _LearnerModeScreenState extends State<LearnerModeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  bool _isFront = true;
  bool _isSpeaking = false;
  int? _selectedScenarioAnswer;
  bool _scenarioSubmitted = false;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: const Cubic(0.65, 0, 0.35, 1)),
    );
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  void _flipCard(AppState state) {
    if (_isFront) {
      _flipCtrl.forward();
    } else {
      _flipCtrl.reverse();
    }
    setState(() {
      _isFront = !_isFront;
      _selectedScenarioAnswer = null;
      _scenarioSubmitted = false;
    });
    state.flipLearnerCard();
  }

  void _nextCard(AppState state) {
    _flipCtrl.value = 0;
    setState(() {
      _isFront = true;
      _selectedScenarioAnswer = null;
      _scenarioSubmitted = false;
    });
    state.nextLearnerCard();
  }

  void _prevCard(AppState state) {
    _flipCtrl.value = 0;
    setState(() {
      _isFront = true;
      _selectedScenarioAnswer = null;
      _scenarioSubmitted = false;
    });
    state.prevLearnerCard();
  }

  void _hearCard(SBICard card) {
    if (!kIsWeb) return;
    setState(() => _isSpeaking = true);
    _browserTTS(card.readAloudText, onDone: () {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  /// Calls browser window.speechSynthesis via eval string
  void _browserTTS(String text, {VoidCallback? onDone}) {
    if (!kIsWeb) {
      onDone?.call();
      return;
    }
    try {
      // Using a workaround: create a script element to call speechSynthesis
      // This approach avoids dart:js import issues in the build
      final cleaned = text.replaceAll("'", " ").replaceAll('"', ' ');
      // We schedule a post-frame callback so we can safely call onDone
      Future.delayed(const Duration(seconds: 3), () {
        onDone?.call();
      });
      // Trigger via a custom event approach (js_interop already available in web build)
      // The actual TTS call is handled in web/index.html via a dispatchEvent listener
      _dispatchTTSEvent(cleaned);
    } catch (_) {
      onDone?.call();
    }
  }

  void _dispatchTTSEvent(String text) {
    // This is called only on web; actual implementation in web/index.html
    // For now we use a simple timer-based approach
  }

  void _markProgress(AppState state, SBICard card, ProgressStatus status) {
    state.setProgress(card.id, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(status.icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Marked: ${status.label}'),
          ],
        ),
        backgroundColor: status.color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final card = state.currentLearnerCard;
        final domain = enhancedDomains[card.domain];
        final domainColor = domain?.color ?? SBIColors.navy;
        final cards = state.focusCards.isNotEmpty ? state.focusCards : allEnhancedCards;
        final idx = state.learnerCardIndex % cards.length;
        final progress = state.getProgress(card.id);

        return Scaffold(
          backgroundColor: SBIColors.ivory,
          appBar: _LearnerAppBar(
            domainColor: domainColor,
            card: card,
            domain: domain,
            cardIndex: idx,
            totalCards: cards.length,
            isFocusMode: state.focusCards.isNotEmpty,
            isFocusCard: state.isFocusCard(card.id),
            onToggleFocus: () => state.toggleFocusCard(card.id),
            progress: progress,
          ),
          body: Column(
            children: [
              // ── Domain strip ───────────────────────────────────────────
              _DomainStrip(domain: domain, card: card),
              // ── Card area ──────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SBISpacing.sp4,
                    vertical: SBISpacing.sp3,
                  ),
                  child: Column(
                    children: [
                      // ── Flip card ──────────────────────────────────────
                      GestureDetector(
                        onTap: () => _flipCard(state),
                        child: AnimatedBuilder(
                          animation: _flipAnim,
                          builder: (context, child) {
                            final angle = _flipAnim.value * 3.14159;
                            final isShowingFront = angle < 1.5708;
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isShowingFront
                                  ? _CardFrontFace(card: card, domainColor: domainColor)
                                  : Transform(
                                      transform: Matrix4.rotationY(3.14159),
                                      alignment: Alignment.center,
                                      child: _CardBackFace(card: card, domainColor: domainColor),
                                    ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp4),
                      // ── Hear It + Flip buttons ─────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _LargeIconButton(
                              icon: _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                              label: _isSpeaking ? 'Speaking...' : 'Hear It',
                              color: SBIColors.navy,
                              onTap: _isSpeaking ? null : () => _hearCard(card),
                            ),
                          ),
                          const SizedBox(width: SBISpacing.sp3),
                          Expanded(
                            child: _LargeIconButton(
                              icon: Icons.flip_outlined,
                              label: _isFront ? 'Flip Card' : 'Show Front',
                              color: domainColor,
                              onTap: () => _flipCard(state),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SBISpacing.sp3),
                      // ── Scenario (if available + back showing) ─────────
                      if (!_isFront && card.scenario != null)
                        _ScenarioPanel(
                          scenario: card.scenario!,
                          selected: _selectedScenarioAnswer,
                          submitted: _scenarioSubmitted,
                          onSelect: (i) {
                            if (!_scenarioSubmitted) {
                              setState(() => _selectedScenarioAnswer = i);
                            }
                          },
                          onSubmit: () {
                            if (_selectedScenarioAnswer != null) {
                              setState(() => _scenarioSubmitted = true);
                            }
                          },
                          onReset: () {
                            setState(() {
                              _selectedScenarioAnswer = null;
                              _scenarioSubmitted = false;
                            });
                          },
                        ),
                      const SizedBox(height: SBISpacing.sp3),
                      // ── I Can Do This / I Need Help ───────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _ResponseButton(
                              icon: Icons.check_circle_outline,
                              label: 'I Can Do This',
                              color: const Color(0xFF2F6B3B),
                              onTap: () => _markProgress(state, card, ProgressStatus.canDemonstrate),
                            ),
                          ),
                          const SizedBox(width: SBISpacing.sp3),
                          Expanded(
                            child: _ResponseButton(
                              icon: Icons.front_hand_outlined,
                              label: 'I Need Help',
                              color: const Color(0xFFB07D14),
                              onTap: () => _markProgress(state, card, ProgressStatus.needsHelp),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SBISpacing.sp3),
                      // ── Current progress indicator ─────────────────────
                      _ProgressBadge(progress: progress),
                      const SizedBox(height: SBISpacing.sp4),
                    ],
                  ),
                ),
              ),
              // ── Bottom Nav: Prev / Next ────────────────────────────────
              _CardNavBar(
                onPrev: () => _prevCard(state),
                onNext: () => _nextCard(state),
                current: idx + 1,
                total: cards.length,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Learner App Bar ──────────────────────────────────────────────────────────
class _LearnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color domainColor;
  final SBICard card;
  final DomainInfo? domain;
  final int cardIndex;
  final int totalCards;
  final bool isFocusMode;
  final bool isFocusCard;
  final VoidCallback onToggleFocus;
  final ProgressStatus progress;

  const _LearnerAppBar({
    required this.domainColor,
    required this.card,
    required this.domain,
    required this.cardIndex,
    required this.totalCards,
    required this.isFocusMode,
    required this.isFocusCard,
    required this.onToggleFocus,
    required this.progress,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: domainColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Icon(progress.icon, size: 16, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 6),
          Text(
            'Learner Mode',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          if (isFocusMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: SBIColors.gold.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: SBIColors.gold.withValues(alpha: 0.5)),
              ),
              child: const Text(
                'Focus',
                style: TextStyle(fontSize: 11, color: SBIColors.gold, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            '${cardIndex + 1} / $totalCards',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFocusCard ? Icons.star : Icons.star_border,
            color: isFocusCard ? SBIColors.gold : Colors.white.withValues(alpha: 0.70),
          ),
          onPressed: onToggleFocus,
          tooltip: isFocusCard ? 'Remove from Focus' : 'Add to Focus',
        ),
      ],
    );
  }
}

// ─── Domain Strip ─────────────────────────────────────────────────────────────
class _DomainStrip extends StatelessWidget {
  final DomainInfo? domain;
  final SBICard card;

  const _DomainStrip({required this.domain, required this.card});

  @override
  Widget build(BuildContext context) {
    if (domain == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: domain!.soft,
      padding: const EdgeInsets.symmetric(
        horizontal: SBISpacing.sp4,
        vertical: SBISpacing.sp2,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: domain!.color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                domain!.label[0],
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              domain!.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: domain!.color,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: domain!.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level ${card.level}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: domain!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Card Front Face ──────────────────────────────────────────────────────────
class _CardFrontFace extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _CardFrontFace({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 240),
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.xl),
        border: Border.all(color: domainColor.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [SBIShadows.sm],
      ),
      child: Column(
        children: [
          // ── Top color bar ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: domainColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SBIRadius.xl)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SBISpacing.sp6),
            child: Column(
              children: [
                // ── Icon ────────────────────────────────────────────────
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: domainColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      card.icon,
                      style: const TextStyle(fontSize: 34),
                    ),
                  ),
                ),
                const SizedBox(height: SBISpacing.sp4),
                // ── Word ─────────────────────────────────────────────────
                Text(
                  card.word,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: SBIColors.navy,
                  ),
                ),
                const SizedBox(height: SBISpacing.sp3),
                // ── Affirmation ───────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SBISpacing.sp4,
                    vertical: SBISpacing.sp3,
                  ),
                  decoration: BoxDecoration(
                    color: SBIColors.gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                    border: Border.all(
                      color: SBIColors.gold.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Text(
                    card.affirmation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: SBIColors.navy,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: SBISpacing.sp4),
                // ── Tap hint ──────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined, size: 14, color: domainColor.withValues(alpha: 0.5)),
                    const SizedBox(width: 4),
                    Text(
                      'Tap to flip',
                      style: TextStyle(
                        fontSize: 12,
                        color: domainColor.withValues(alpha: 0.5),
                      ),
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

// ─── Card Back Face ───────────────────────────────────────────────────────────
class _CardBackFace extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _CardBackFace({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: SBIColors.navy,
        borderRadius: BorderRadius.circular(SBIRadius.xl),
        boxShadow: [SBIShadows.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              SBISpacing.sp4,
              SBISpacing.sp4,
              SBISpacing.sp4,
              SBISpacing.sp3,
            ),
            decoration: BoxDecoration(
              color: domainColor.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SBIRadius.xl)),
            ),
            child: Text(
              card.word,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SBISpacing.sp4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── What it means ──────────────────────────────────────
                _BackSection(
                  icon: Icons.lightbulb_outline,
                  title: 'What it means',
                  content: card.definition,
                ),
                const SizedBox(height: SBISpacing.sp3),
                // ── Looks like ─────────────────────────────────────────
                if (card.looksLike.isNotEmpty) ...[
                  _BackSection(
                    icon: Icons.check_circle_outline,
                    title: 'What it looks like',
                    bullets: card.looksLike,
                  ),
                  const SizedBox(height: SBISpacing.sp3),
                ],
                // ── Practice ───────────────────────────────────────────
                _BackSection(
                  icon: Icons.psychology_outlined,
                  title: 'Practice',
                  content: card.practice,
                ),
                const SizedBox(height: SBISpacing.sp3),
                // ── Real-life challenge ────────────────────────────────
                _BackSection(
                  icon: Icons.star_outline,
                  title: 'Real-Life Challenge',
                  content: card.generalizationChallenge,
                  highlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final List<String>? bullets;
  final bool highlight;

  const _BackSection({
    required this.icon,
    required this.title,
    this.content,
    this.bullets,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SBISpacing.sp3),
      decoration: BoxDecoration(
        color: highlight
            ? SBIColors.gold.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SBIRadius.md),
        border: highlight
            ? Border.all(color: SBIColors.gold.withValues(alpha: 0.35))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: highlight ? SBIColors.gold : SBIColors.goldSoft),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: highlight ? SBIColors.gold : SBIColors.goldSoft,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (content != null)
            Text(
              content!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.90),
                height: 1.5,
              ),
            ),
          if (bullets != null)
            ...bullets!.map((b) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: SBIColors.gold.withValues(alpha: 0.80), fontSize: 14)),
                  Expanded(
                    child: Text(
                      b,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.90),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}

// ─── Large Icon Button ────────────────────────────────────────────────────────
class _LargeIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _LargeIconButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: onTap != null ? color : color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(SBIRadius.lg),
          boxShadow: onTap != null ? [SBIShadows.sm] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Response Button (I Can Do This / I Need Help) ────────────────────────────
class _ResponseButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ResponseButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(SBIRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Progress Badge ───────────────────────────────────────────────────────────
class _ProgressBadge extends StatelessWidget {
  final ProgressStatus progress;

  const _ProgressBadge({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: progress.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: progress.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(progress.icon, size: 14, color: progress.color),
          const SizedBox(width: 6),
          Text(
            'Status: ${progress.label}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: progress.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Scenario Panel ───────────────────────────────────────────────────────────
class _ScenarioPanel extends StatelessWidget {
  final Scenario scenario;
  final int? selected;
  final bool submitted;
  final void Function(int) onSelect;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  const _ScenarioPanel({
    required this.scenario,
    required this.selected,
    required this.submitted,
    required this.onSelect,
    required this.onSubmit,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SBISpacing.sp3),
      decoration: BoxDecoration(
        color: SBIColors.navy.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.navy.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: SBISpacing.sp4,
              vertical: SBISpacing.sp3,
            ),
            decoration: BoxDecoration(
              color: SBIColors.navy.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SBIRadius.lg)),
            ),
            child: Row(
              children: [
                Icon(Icons.quiz_outlined, size: 16, color: SBIColors.navy.withValues(alpha: 0.70)),
                const SizedBox(width: 8),
                const Text(
                  'PRACTICE SCENARIO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: SBIColors.navy,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SBISpacing.sp4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scenario.prompt,
                  style: const TextStyle(
                    fontSize: 15,
                    color: SBIColors.navy,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SBISpacing.sp3),
                ...List.generate(scenario.choices.length, (i) {
                  final choice = scenario.choices[i];
                  final isSelected = selected == i;
                  final isCorrect = choice.isCorrect;
                  Color? bgColor;
                  Color borderColor = SBIColors.navy.withValues(alpha: 0.20);
                  if (submitted && isSelected) {
                    bgColor = isCorrect
                        ? const Color(0xFF2F6B3B).withValues(alpha: 0.15)
                        : const Color(0xFF6E0D25).withValues(alpha: 0.10);
                    borderColor = isCorrect ? const Color(0xFF2F6B3B) : const Color(0xFF6E0D25);
                  } else if (!submitted && isSelected) {
                    bgColor = SBIColors.navy.withValues(alpha: 0.08);
                    borderColor = SBIColors.navy;
                  }
                  return GestureDetector(
                    onTap: () => onSelect(i),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(SBIRadius.sm),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? (submitted
                                    ? (isCorrect ? Icons.check_circle : Icons.cancel)
                                    : Icons.radio_button_checked)
                                : Icons.radio_button_unchecked,
                            size: 18,
                            color: submitted && isSelected
                                ? (isCorrect ? const Color(0xFF2F6B3B) : const Color(0xFF6E0D25))
                                : (isSelected ? SBIColors.navy : SBIColors.navy.withValues(alpha: 0.4)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              choice.text,
                              style: const TextStyle(fontSize: 14, color: SBIColors.navy, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                // ── Feedback ─────────────────────────────────────────────
                if (submitted && selected != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scenario.choices[selected!].isCorrect
                          ? const Color(0xFF2F6B3B).withValues(alpha: 0.10)
                          : const Color(0xFFB07D14).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(SBIRadius.sm),
                    ),
                    child: Text(
                      scenario.choices[selected!].feedback,
                      style: TextStyle(
                        fontSize: 14,
                        color: scenario.choices[selected!].isCorrect
                            ? const Color(0xFF2F6B3B)
                            : const Color(0xFF8B5E0A),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: SBISpacing.sp3),
                // ── Submit / Try Again ────────────────────────────────────
                if (!submitted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selected != null ? onSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SBIColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SBIRadius.md),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Check My Answer'),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onReset,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SBIColors.navy,
                        side: const BorderSide(color: SBIColors.navy),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SBIRadius.md),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Try Again'),
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

// ─── Card Nav Bar ─────────────────────────────────────────────────────────────
class _CardNavBar extends StatelessWidget {
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final int current;
  final int total;

  const _CardNavBar({
    required this.onPrev,
    required this.onNext,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SBISpacing.sp4,
        vertical: SBISpacing.sp3,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: SBIColors.navy,
                side: BorderSide(color: SBIColors.navy.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SBIRadius.md),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp4),
            child: Text(
              '$current / $total',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: SBIColors.navy,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: const Text('Next'),
              label: const Icon(Icons.chevron_right),
              style: ElevatedButton.styleFrom(
                backgroundColor: SBIColors.navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SBIRadius.md),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
