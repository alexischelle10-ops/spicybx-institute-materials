import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/enhanced_card.dart';
import '../data/enhanced_cards_data.dart';
import '../theme/sbi_tokens.dart';

class TodaysSkillScreen extends StatefulWidget {
  const TodaysSkillScreen({super.key});

  @override
  State<TodaysSkillScreen> createState() => _TodaysSkillScreenState();
}

class _TodaysSkillScreenState extends State<TodaysSkillScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  bool _isFront = true;
  bool _scenarioSubmitted = false;
  int? _scenarioSelected;

  late SBICard _todaysCard;

  @override
  void initState() {
    super.initState();
    _todaysCard = getTodaysCard();
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

  void _flip() {
    if (_isFront) {
      _flipCtrl.forward();
    } else {
      _flipCtrl.reverse();
    }
    setState(() {
      _isFront = !_isFront;
      _scenarioSelected = null;
      _scenarioSubmitted = false;
    });
  }

  void _markReflection(AppState state, ProgressStatus status) {
    state.setProgress(_todaysCard.id, status);
    final messages = {
      ProgressStatus.usedInRealLife: '🌟 Amazing! You used this skill in real life!',
      ProgressStatus.needsHelp: '💙 That is okay. Keep practicing — you are growing.',
      ProgressStatus.practiced: '✅ Noted. Keep practicing this skill.',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messages[status] ?? 'Progress saved.'),
        backgroundColor: status.color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final domain = enhancedDomains[_todaysCard.domain];
        final domainColor = domain?.color ?? SBIColors.navy;
        final progress = state.getProgress(_todaysCard.id);
        final isFocus = state.isFocusCard(_todaysCard.id);

        return Scaffold(
          backgroundColor: SBIColors.ivory,
          body: CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                backgroundColor: domainColor,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [domainColor, SBIColors.navy],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          SBISpacing.sp4,
                          SBISpacing.sp10,
                          SBISpacing.sp4,
                          SBISpacing.sp3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: SBIColors.gold.withValues(alpha: 0.20),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: SBIColors.gold.withValues(alpha: 0.50)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.wb_sunny_outlined, size: 13, color: SBIColors.gold),
                                      SizedBox(width: 4),
                                      Text(
                                        'TODAY\'S SKILL',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: SBIColors.gold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => state.toggleFocusCard(_todaysCard.id),
                                  icon: Icon(
                                    isFocus ? Icons.star : Icons.star_border,
                                    color: isFocus ? SBIColors.gold : Colors.white.withValues(alpha: 0.70),
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _todaysCard.word,
                              style: const TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Today\'s Skill: ${_todaysCard.word}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),

              // ── Body ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(SBISpacing.sp4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Domain Badge ───────────────────────────────
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: domainColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              domain?.label ?? _todaysCard.domain,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: domainColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: progress.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(progress.icon, size: 12, color: progress.color),
                                const SizedBox(width: 4),
                                Text(
                                  progress.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: progress.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SBISpacing.sp4),

                      // ── Card Flip ──────────────────────────────────
                      GestureDetector(
                        onTap: _flip,
                        child: AnimatedBuilder(
                          animation: _flipAnim,
                          builder: (context, _) {
                            final angle = _flipAnim.value * 3.14159;
                            final isFrontShowing = angle < 1.5708;
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isFrontShowing
                                  ? _TodayCardFront(card: _todaysCard, domainColor: domainColor)
                                  : Transform(
                                      transform: Matrix4.rotationY(3.14159),
                                      alignment: Alignment.center,
                                      child: _TodayCardBack(card: _todaysCard, domainColor: domainColor),
                                    ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),

                      // ── Flip button ────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _flip,
                          icon: const Icon(Icons.flip_outlined, size: 18),
                          label: Text(_isFront ? 'Flip Card — See Details' : 'Show Front'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: domainColor,
                            side: BorderSide(color: domainColor.withValues(alpha: 0.50)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(SBIRadius.md),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp5),

                      // ── Vocabulary ─────────────────────────────────
                      _TodaySection(
                        title: 'Vocabulary',
                        icon: Icons.menu_book_outlined,
                        domainColor: domainColor,
                        child: Text(
                          _todaysCard.definition,
                          style: const TextStyle(fontSize: 15, color: SBIColors.navy, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),

                      // ── Practice Prompt ────────────────────────────
                      _TodaySection(
                        title: 'Practice',
                        icon: Icons.psychology_outlined,
                        domainColor: domainColor,
                        child: Text(
                          _todaysCard.practice,
                          style: const TextStyle(fontSize: 15, color: SBIColors.navy, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),

                      // ── Scenario ───────────────────────────────────
                      if (_todaysCard.scenario != null)
                        _TodayScenario(
                          scenario: _todaysCard.scenario!,
                          domainColor: domainColor,
                          selected: _scenarioSelected,
                          submitted: _scenarioSubmitted,
                          onSelect: (i) {
                            if (!_scenarioSubmitted) setState(() => _scenarioSelected = i);
                          },
                          onSubmit: () => setState(() => _scenarioSubmitted = true),
                          onReset: () => setState(() {
                            _scenarioSelected = null;
                            _scenarioSubmitted = false;
                          }),
                        ),
                      const SizedBox(height: SBISpacing.sp3),

                      // ── Real-Life Challenge ────────────────────────
                      _TodaySection(
                        title: 'Real-Life Challenge',
                        icon: Icons.star_outline,
                        domainColor: SBIColors.gold,
                        highlight: true,
                        child: Text(
                          _todaysCard.generalizationChallenge,
                          style: const TextStyle(fontSize: 15, color: SBIColors.navy, height: 1.6, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),

                      // ── Reflection ─────────────────────────────────
                      _TodaySection(
                        title: 'Reflection',
                        icon: Icons.self_improvement,
                        domainColor: domainColor,
                        child: Text(
                          _todaysCard.reflection,
                          style: const TextStyle(fontSize: 15, color: SBIColors.navy, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp5),

                      // ── Reflection Buttons ─────────────────────────
                      const _ReflectionHeader(),
                      const SizedBox(height: SBISpacing.sp3),
                      Row(
                        children: [
                          Expanded(
                            child: _ReflectionBtn(
                              emoji: '🌟',
                              label: 'I Did It',
                              sublabel: 'Used in real life',
                              color: const Color(0xFF2F6B3B),
                              isActive: progress == ProgressStatus.usedInRealLife,
                              onTap: () => _markReflection(state, ProgressStatus.usedInRealLife),
                            ),
                          ),
                          const SizedBox(width: SBISpacing.sp2),
                          Expanded(
                            child: _ReflectionBtn(
                              emoji: '💙',
                              label: 'I Needed Help',
                              sublabel: 'Needed support',
                              color: const Color(0xFFB07D14),
                              isActive: progress == ProgressStatus.needsHelp,
                              onTap: () => _markReflection(state, ProgressStatus.needsHelp),
                            ),
                          ),
                          const SizedBox(width: SBISpacing.sp2),
                          Expanded(
                            child: _ReflectionBtn(
                              emoji: '📖',
                              label: 'Not Yet',
                              sublabel: 'Still learning',
                              color: const Color(0xFF1F3E66),
                              isActive: progress == ProgressStatus.practiced,
                              onTap: () => _markReflection(state, ProgressStatus.practiced),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SBISpacing.sp8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Today's Card Front ───────────────────────────────────────────────────────
class _TodayCardFront extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _TodayCardFront({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SBISpacing.sp5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.xl),
        border: Border.all(color: domainColor.withValues(alpha: 0.25)),
        boxShadow: [SBIShadows.sm],
      ),
      child: Column(
        children: [
          Text(card.icon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: SBISpacing.sp3),
          Text(
            card.word,
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: SBIColors.navy,
            ),
          ),
          const SizedBox(height: SBISpacing.sp3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: SBIColors.gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(SBIRadius.md),
              border: Border.all(color: SBIColors.gold.withValues(alpha: 0.30)),
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
          const SizedBox(height: SBISpacing.sp3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_outlined, size: 13, color: domainColor.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(
                'Tap to see details',
                style: TextStyle(fontSize: 12, color: domainColor.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Today's Card Back ────────────────────────────────────────────────────────
class _TodayCardBack extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _TodayCardBack({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SBISpacing.sp4),
      decoration: BoxDecoration(
        color: SBIColors.navy,
        borderRadius: BorderRadius.circular(SBIRadius.xl),
        boxShadow: [SBIShadows.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.word,
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: SBISpacing.sp3),
          if (card.looksLike.isNotEmpty) ...[
            Text(
              'LOOKS LIKE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: SBIColors.gold.withValues(alpha: 0.90),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            ...card.looksLike.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✓  ', style: TextStyle(color: SBIColors.gold.withValues(alpha: 0.80), fontSize: 14)),
                  Expanded(
                    child: Text(b, style: TextStyle(color: Colors.white.withValues(alpha: 0.90), fontSize: 14, height: 1.4)),
                  ),
                ],
              ),
            )),
          ],
          if (card.notLike.isNotEmpty) ...[
            const SizedBox(height: SBISpacing.sp3),
            Text(
              'NOT LIKE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: SBIColors.gold.withValues(alpha: 0.90),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            ...card.notLike.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✗  ', style: TextStyle(color: SBIColors.burgundy.withValues(alpha: 0.80), fontSize: 14)),
                  Expanded(
                    child: Text(b, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, height: 1.4)),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}

// ─── Today Section ────────────────────────────────────────────────────────────
class _TodaySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color domainColor;
  final Widget child;
  final bool highlight;

  const _TodaySection({
    required this.title,
    required this.icon,
    required this.domainColor,
    required this.child,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SBISpacing.sp4),
      decoration: BoxDecoration(
        color: highlight
            ? SBIColors.gold.withValues(alpha: 0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(
          color: highlight
              ? SBIColors.gold.withValues(alpha: 0.35)
              : SBIColors.navy.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: domainColor),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: domainColor,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// ─── Today Scenario ───────────────────────────────────────────────────────────
class _TodayScenario extends StatelessWidget {
  final Scenario scenario;
  final Color domainColor;
  final int? selected;
  final bool submitted;
  final void Function(int) onSelect;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  const _TodayScenario({
    required this.scenario,
    required this.domainColor,
    required this.selected,
    required this.submitted,
    required this.onSelect,
    required this.onSubmit,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SBISpacing.sp4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.navy.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz_outlined, size: 14, color: domainColor),
              const SizedBox(width: 6),
              Text(
                'SCENARIO PRACTICE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: domainColor,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            scenario.prompt,
            style: const TextStyle(
              fontSize: 15,
              color: SBIColors.navy,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(scenario.choices.length, (i) {
            final choice = scenario.choices[i];
            final isSelected = selected == i;
            Color borderColor = SBIColors.navy.withValues(alpha: 0.18);
            Color? bgColor;
            if (submitted && isSelected) {
              bgColor = choice.isCorrect
                  ? const Color(0xFF2F6B3B).withValues(alpha: 0.10)
                  : SBIColors.burgundy.withValues(alpha: 0.08);
              borderColor = choice.isCorrect ? const Color(0xFF2F6B3B) : SBIColors.burgundy;
            } else if (!submitted && isSelected) {
              bgColor = domainColor.withValues(alpha: 0.07);
              borderColor = domainColor;
            }
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor ?? SBIColors.stone50,
                  borderRadius: BorderRadius.circular(SBIRadius.sm),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      submitted && isSelected
                          ? (choice.isCorrect ? Icons.check_circle : Icons.cancel)
                          : (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                      size: 18,
                      color: submitted && isSelected
                          ? (choice.isCorrect ? const Color(0xFF2F6B3B) : SBIColors.burgundy)
                          : (isSelected ? domainColor : SBIColors.navy.withValues(alpha: 0.4)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(choice.text, style: const TextStyle(fontSize: 14, color: SBIColors.navy, height: 1.3)),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (submitted && selected != null)
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 12),
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
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: submitted
                ? OutlinedButton(
                    onPressed: onReset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: domainColor,
                      side: BorderSide(color: domainColor.withValues(alpha: 0.50)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Try Again'),
                  )
                : ElevatedButton(
                    onPressed: selected != null ? onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: domainColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Check My Answer'),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Reflection Header ────────────────────────────────────────────────────────
class _ReflectionHeader extends StatelessWidget {
  const _ReflectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How did today go?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: SBIColors.navy,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              Text(
                'Tap to record your experience with today\'s skill.',
                style: TextStyle(
                  fontSize: 13,
                  color: SBIColors.navy.withValues(alpha: 0.55),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Reflection Button ────────────────────────────────────────────────────────
class _ReflectionBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final String sublabel;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ReflectionBtn({
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: SBISpacing.sp3),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(SBIRadius.lg),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.35),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive ? [SBIShadows.sm] : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Colors.white.withValues(alpha: 0.80) : color.withValues(alpha: 0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
