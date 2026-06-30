import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/enhanced_card.dart';
import '../data/enhanced_cards_data.dart';
import '../theme/sbi_tokens.dart';

class FocusCardsScreen extends StatefulWidget {
  const FocusCardsScreen({super.key});

  @override
  State<FocusCardsScreen> createState() => _FocusCardsScreenState();
}

class _FocusCardsScreenState extends State<FocusCardsScreen> {
  bool _isPracticeMode = false;
  int _practiceIndex = 0;
  bool _practiceFront = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final focusCards = state.focusCards;

        if (_isPracticeMode && focusCards.isNotEmpty) {
          return _PracticeMode(
            cards: focusCards,
            state: state,
            index: _practiceIndex,
            isFront: _practiceFront,
            onNext: () => setState(() {
              _practiceIndex = (_practiceIndex + 1) % focusCards.length;
              _practiceFront = true;
            }),
            onPrev: () => setState(() {
              _practiceIndex = (_practiceIndex - 1 + focusCards.length) % focusCards.length;
              _practiceFront = true;
            }),
            onFlip: () => setState(() => _practiceFront = !_practiceFront),
            onExit: () => setState(() {
              _isPracticeMode = false;
              _practiceIndex = 0;
              _practiceFront = true;
            }),
          );
        }

        return Scaffold(
          backgroundColor: SBIColors.ivory,
          appBar: AppBar(
            backgroundColor: SBIColors.navy,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                const Icon(Icons.star_outlined, color: SBIColors.gold, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Focus Cards',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (focusCards.isNotEmpty)
                      Text(
                        '${focusCards.length} card${focusCards.length != 1 ? 's' : ''} saved',
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.65)),
                      ),
                  ],
                ),
              ],
            ),
            actions: [
              if (focusCards.isNotEmpty)
                TextButton.icon(
                  onPressed: () => setState(() {
                    _isPracticeMode = true;
                    _practiceIndex = 0;
                    _practiceFront = true;
                  }),
                  icon: const Icon(Icons.play_circle_outline, color: SBIColors.gold, size: 18),
                  label: const Text(
                    'Practice',
                    style: TextStyle(color: SBIColors.gold, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          body: focusCards.isEmpty
              ? _EmptyFocusState()
              : Column(
                  children: [
                    // ── Quick stats ──────────────────────────────────────
                    _FocusStatsBar(cards: focusCards, state: state),
                    // ── Card list ────────────────────────────────────────
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(SBISpacing.sp4),
                        itemCount: focusCards.length,
                        itemBuilder: (context, i) => _FocusCardTile(
                          card: focusCards[i],
                          state: state,
                          index: i,
                          onPracticeFrom: () => setState(() {
                            _practiceIndex = i;
                            _isPracticeMode = true;
                            _practiceFront = true;
                          }),
                        ),
                      ),
                    ),
                    // ── Practice CTA ─────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        SBISpacing.sp4,
                        0,
                        SBISpacing.sp4,
                        SBISpacing.sp4,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() {
                            _isPracticeMode = true;
                            _practiceIndex = 0;
                            _practiceFront = true;
                          }),
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text(
                            'Practice Focus Cards',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SBIColors.navy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(SBIRadius.md),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          // ── Browse to add ──────────────────────────────────────────────
          floatingActionButton: focusCards.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showAddCardSheet(context, state),
                  backgroundColor: SBIColors.gold,
                  foregroundColor: SBIColors.navy,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Cards', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
        );
      },
    );
  }

  void _showAddCardSheet(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddCardSheet(state: state),
    );
  }
}

// ─── Empty Focus State ────────────────────────────────────────────────────────
class _EmptyFocusState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SBISpacing.sp8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: SBIColors.gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.star_border, size: 44, color: SBIColors.gold),
              ),
            ),
            const SizedBox(height: SBISpacing.sp4),
            const Text(
              'No Focus Cards Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: SBIColors.navy,
                fontFamily: 'PlayfairDisplay',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SBISpacing.sp2),
            Text(
              'Add cards to your Focus set to create a personalized practice session for this learner.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: SBIColors.navy.withValues(alpha: 0.60),
                height: 1.6,
              ),
            ),
            const SizedBox(height: SBISpacing.sp6),
            Consumer<AppState>(
              builder: (context, state, _) => ElevatedButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => _AddCardSheet(state: state),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Focus Cards'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SBIColors.gold,
                  foregroundColor: SBIColors.navy,
                  padding: const EdgeInsets.symmetric(
                    horizontal: SBISpacing.sp6,
                    vertical: SBISpacing.sp3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SBIRadius.md),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SBISpacing.sp3),
            Text(
              'Tip: Tap ⭐ on any card in the Library or Learner Mode to add it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: SBIColors.navy.withValues(alpha: 0.45),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Focus Stats Bar ──────────────────────────────────────────────────────────
class _FocusStatsBar extends StatelessWidget {
  final List<SBICard> cards;
  final AppState state;

  const _FocusStatsBar({required this.cards, required this.state});

  @override
  Widget build(BuildContext context) {
    final mastered = cards
        .where((c) => state.getProgress(c.id).isMastered)
        .length;
    final needsHelp = cards
        .where((c) => state.getProgress(c.id) == ProgressStatus.needsHelp)
        .length;
    final practiced = cards
        .where((c) =>
            state.getProgress(c.id) != ProgressStatus.notStarted &&
            !state.getProgress(c.id).isMastered &&
            state.getProgress(c.id) != ProgressStatus.needsHelp)
        .length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SBISpacing.sp4,
        vertical: SBISpacing.sp3,
      ),
      color: SBIColors.navy.withValues(alpha: 0.04),
      child: Row(
        children: [
          Expanded(
            child: _FocusStat(
              label: 'Mastered',
              value: mastered,
              total: cards.length,
              color: const Color(0xFF2F6B3B),
            ),
          ),
          Expanded(
            child: _FocusStat(
              label: 'In Progress',
              value: practiced,
              total: cards.length,
              color: SBIColors.statusInfo,
            ),
          ),
          Expanded(
            child: _FocusStat(
              label: 'Needs Help',
              value: needsHelp,
              total: cards.length,
              color: const Color(0xFFB07D14),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusStat extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _FocusStat({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: SBIColors.navy.withValues(alpha: 0.55),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Focus Card Tile ──────────────────────────────────────────────────────────
class _FocusCardTile extends StatelessWidget {
  final SBICard card;
  final AppState state;
  final int index;
  final VoidCallback onPracticeFrom;

  const _FocusCardTile({
    required this.card,
    required this.state,
    required this.index,
    required this.onPracticeFrom,
  });

  @override
  Widget build(BuildContext context) {
    final domain = enhancedDomains[card.domain];
    final domainColor = domain?.color ?? SBIColors.navy;
    final progress = state.getProgress(card.id);

    return Container(
      margin: const EdgeInsets.only(bottom: SBISpacing.sp3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: domainColor.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(SBISpacing.sp3),
        child: Row(
          children: [
            // ── Number ──────────────────────────────────────────────────
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: domainColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: domainColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: SBISpacing.sp3),
            // ── Icon ────────────────────────────────────────────────────
            Text(card.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: SBISpacing.sp3),
            // ── Word + domain ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.word,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: SBIColors.navy,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        domain?.label ?? card.domain,
                        style: TextStyle(
                          fontSize: 11,
                          color: domainColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(progress.icon, size: 12, color: progress.color),
                      const SizedBox(width: 3),
                      Text(
                        progress.label,
                        style: TextStyle(fontSize: 11, color: progress.color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ── Actions ──────────────────────────────────────────────────
            Column(
              children: [
                IconButton(
                  onPressed: onPracticeFrom,
                  icon: const Icon(Icons.play_circle_outline),
                  color: domainColor,
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: 'Practice from here',
                ),
                IconButton(
                  onPressed: () => state.toggleFocusCard(card.id),
                  icon: const Icon(Icons.star),
                  color: SBIColors.gold,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: 'Remove from Focus',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Card Sheet ───────────────────────────────────────────────────────────
class _AddCardSheet extends StatefulWidget {
  final AppState state;

  const _AddCardSheet({required this.state});

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  String? _filterDomain;

  @override
  Widget build(BuildContext context) {
    final filtered = _filterDomain == null
        ? allEnhancedCards
        : allEnhancedCards.where((c) => c.domain == _filterDomain).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(SBIRadius.xl)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SBIColors.navy.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp4),
            child: Row(
              children: [
                const Text(
                  'Add Focus Cards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SBIColors.navy,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          // Domain Filter
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp4),
              children: [
                _DomainChip(
                  label: 'All',
                  isSelected: _filterDomain == null,
                  color: SBIColors.navy,
                  onTap: () => setState(() => _filterDomain = null),
                ),
                ...enhancedDomains.entries.map((e) => _DomainChip(
                  label: e.value.label,
                  isSelected: _filterDomain == e.key,
                  color: e.value.color,
                  onTap: () => setState(() => _filterDomain = e.key),
                )),
              ],
            ),
          ),
          const Divider(height: 1),
          // Card list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(SBISpacing.sp3),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final card = filtered[i];
                final domain = enhancedDomains[card.domain];
                final isFocus = widget.state.isFocusCard(card.id);
                return ListTile(
                  leading: Text(card.icon, style: const TextStyle(fontSize: 24)),
                  title: Text(
                    card.word,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: SBIColors.navy,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  subtitle: Text(
                    domain?.label ?? card.domain,
                    style: TextStyle(
                      fontSize: 12,
                      color: domain?.color ?? SBIColors.navy,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => setState(() => widget.state.toggleFocusCard(card.id)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFocus ? SBIColors.gold.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isFocus ? SBIColors.gold : SBIColors.navy.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFocus ? Icons.star : Icons.star_border,
                            size: 14,
                            color: isFocus ? SBIColors.gold : SBIColors.navy.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isFocus ? 'Remove' : 'Add',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isFocus ? SBIColors.gold : SBIColors.navy.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SBIRadius.sm),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DomainChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _DomainChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6, bottom: 4, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : SBIColors.navy.withValues(alpha: 0.25),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : SBIColors.navy.withValues(alpha: 0.65),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Practice Mode ────────────────────────────────────────────────────────────
class _PracticeMode extends StatefulWidget {
  final List<SBICard> cards;
  final AppState state;
  final int index;
  final bool isFront;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onFlip;
  final VoidCallback onExit;

  const _PracticeMode({
    required this.cards,
    required this.state,
    required this.index,
    required this.isFront,
    required this.onNext,
    required this.onPrev,
    required this.onFlip,
    required this.onExit,
  });

  @override
  State<_PracticeMode> createState() => _PracticeModeState();
}

class _PracticeModeState extends State<_PracticeMode>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Cubic(0.65, 0, 0.35, 1)),
    );
  }

  @override
  void didUpdateWidget(_PracticeMode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _ctrl.value = 0;
    } else if (!oldWidget.isFront && widget.isFront) {
      _ctrl.reverse();
    } else if (oldWidget.isFront && !widget.isFront) {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _markProgress(SBICard card, ProgressStatus status) {
    widget.state.setProgress(card.id, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked: ${status.label}'),
        backgroundColor: status.color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[widget.index % widget.cards.length];
    final domain = enhancedDomains[card.domain];
    final domainColor = domain?.color ?? SBIColors.navy;
    final progress = widget.state.getProgress(card.id);

    return Scaffold(
      backgroundColor: SBIColors.ivory,
      appBar: AppBar(
        backgroundColor: SBIColors.navy,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.star, color: SBIColors.gold, size: 18),
            const SizedBox(width: 8),
            const Text('Focus Practice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(
              '${widget.index + 1} / ${widget.cards.length}',
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.70)),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onExit,
          tooltip: 'Exit Practice',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SBISpacing.sp4),
              child: Column(
                children: [
                  // ── Progress bar ─────────────────────────────────────
                  LinearProgressIndicator(
                    value: (widget.index + 1) / widget.cards.length,
                    backgroundColor: SBIColors.navy.withValues(alpha: 0.10),
                    valueColor: AlwaysStoppedAnimation<Color>(domainColor),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  const SizedBox(height: SBISpacing.sp4),
                  // ── Card ─────────────────────────────────────────────
                  GestureDetector(
                    onTap: widget.onFlip,
                    child: AnimatedBuilder(
                      animation: _anim,
                      builder: (context, _) {
                        final angle = _anim.value * 3.14159;
                        final showFront = angle < 1.5708;
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: showFront
                              ? _PracticeFrontCard(card: card, domainColor: domainColor)
                              : Transform(
                                  transform: Matrix4.rotationY(3.14159),
                                  alignment: Alignment.center,
                                  child: _PracticeBackCard(card: card, domainColor: domainColor),
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: SBISpacing.sp4),
                  // ── Flip btn ──────────────────────────────────────────
                  OutlinedButton.icon(
                    onPressed: widget.onFlip,
                    icon: const Icon(Icons.flip_outlined, size: 18),
                    label: Text(widget.isFront ? 'Flip Card' : 'Show Front'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: domainColor,
                      side: BorderSide(color: domainColor.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SBIRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: SBISpacing.sp4),
                  // ── Progress Mark ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _MarkBtn(
                          icon: Icons.check_circle_outline,
                          label: 'I Can Do This',
                          color: const Color(0xFF2F6B3B),
                          isActive: progress.isMastered,
                          onTap: () => _markProgress(card, ProgressStatus.canDemonstrate),
                        ),
                      ),
                      const SizedBox(width: SBISpacing.sp2),
                      Expanded(
                        child: _MarkBtn(
                          icon: Icons.front_hand_outlined,
                          label: 'I Need Help',
                          color: const Color(0xFFB07D14),
                          isActive: progress == ProgressStatus.needsHelp,
                          onTap: () => _markProgress(card, ProgressStatus.needsHelp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ── Nav ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SBISpacing.sp4,
              vertical: SBISpacing.sp3,
            ),
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
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onPrev,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Prev'),
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
                const SizedBox(width: SBISpacing.sp3),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onNext,
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
          ),
        ],
      ),
    );
  }
}

class _PracticeFrontCard extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _PracticeFrontCard({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SBISpacing.sp6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.xl),
        border: Border.all(color: domainColor.withValues(alpha: 0.25)),
        boxShadow: [SBIShadows.sm],
      ),
      child: Column(
        children: [
          Text(card.icon, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: SBISpacing.sp3),
          Text(
            card.word,
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: SBIColors.navy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SBISpacing.sp3),
          Text(
            card.affirmation,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: SBIColors.navy,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SBISpacing.sp3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_outlined, size: 13, color: domainColor.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text('Tap to flip', style: TextStyle(fontSize: 12, color: domainColor.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    );
  }
}

class _PracticeBackCard extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _PracticeBackCard({required this.card, required this.domainColor});

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
          Text(
            card.definition,
            style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.90), height: 1.5),
          ),
          if (card.looksLike.isNotEmpty) ...[
            const SizedBox(height: SBISpacing.sp3),
            ...card.looksLike.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✓  ', style: TextStyle(color: SBIColors.gold.withValues(alpha: 0.80), fontSize: 14)),
                  Expanded(
                    child: Text(b, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85), height: 1.4)),
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

class _MarkBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _MarkBtn({
    required this.icon,
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
        duration: const Duration(milliseconds: 200),
        height: 60,
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(SBIRadius.lg),
          border: Border.all(color: isActive ? color : color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.white : color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : color,
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
