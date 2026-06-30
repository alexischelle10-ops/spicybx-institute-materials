import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/enhanced_card.dart';
import '../data/enhanced_cards_data.dart';
import '../theme/sbi_tokens.dart';

class AdultModeScreen extends StatefulWidget {
  const AdultModeScreen({super.key});

  @override
  State<AdultModeScreen> createState() => _AdultModeScreenState();
}

class _AdultModeScreenState extends State<AdultModeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  SBICard? _expandedCard;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: SBIColors.ivory,
          appBar: AppBar(
            backgroundColor: SBIColors.burgundy,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(Icons.school_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  'Adult / Instructor Mode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: SBIColors.gold,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.60),
              tabs: const [
                Tab(text: 'Card Library'),
                Tab(text: 'Domain Overview'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabCtrl,
            children: [
              _CardLibraryTab(
                state: state,
                expandedCard: _expandedCard,
                onExpand: (card) => setState(() {
                  _expandedCard = _expandedCard?.id == card?.id ? null : card;
                }),
              ),
              const _DomainOverviewTab(),
            ],
          ),
        );
      },
    );
  }
}

// ─── Card Library Tab ─────────────────────────────────────────────────────────
class _CardLibraryTab extends StatelessWidget {
  final AppState state;
  final SBICard? expandedCard;
  final void Function(SBICard?) onExpand;

  const _CardLibraryTab({
    required this.state,
    required this.expandedCard,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final cards = state.filteredCards;

    return Column(
      children: [
        // ── Domain Filter ──────────────────────────────────────────────
        _DomainFilterBar(state: state),
        // ── Stats Bar ──────────────────────────────────────────────────
        _StatsBar(state: state),
        // ── Card List ──────────────────────────────────────────────────
        Expanded(
          child: cards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list_off, size: 48,
                          color: SBIColors.navy.withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      Text(
                        'No cards in this category',
                        style: TextStyle(color: SBIColors.navy.withValues(alpha: 0.5)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SBISpacing.sp4,
                    vertical: SBISpacing.sp3,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, i) => _AdultCardTile(
                    card: cards[i],
                    state: state,
                    isExpanded: expandedCard?.id == cards[i].id,
                    onTap: () => onExpand(cards[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

// ─── Domain Filter Bar ────────────────────────────────────────────────────────
class _DomainFilterBar extends StatelessWidget {
  final AppState state;

  const _DomainFilterBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final domains = ['All', ...enhancedDomains.keys];

    return Container(
      height: 48,
      color: SBIColors.burgundy.withValues(alpha: 0.06),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp4, vertical: 8),
        itemCount: domains.length,
        itemBuilder: (context, i) {
          final key = domains[i];
          final isAll = key == 'All';
          final isSelected = isAll
              ? state.selectedDomain == null
              : state.selectedDomain == key;
          final domainInfo = isAll ? null : enhancedDomains[key];
          final color = domainInfo?.color ?? SBIColors.burgundy;

          return GestureDetector(
            onTap: () => state.setDomain(isAll ? null : key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : SBIColors.navy.withValues(alpha: 0.25),
                ),
              ),
              child: Center(
                child: Text(
                  isAll ? 'All Cards' : (domainInfo?.label ?? key),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : SBIColors.navy.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Stats Bar ────────────────────────────────────────────────────────────────
class _StatsBar extends StatelessWidget {
  final AppState state;

  const _StatsBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SBISpacing.sp4,
        vertical: SBISpacing.sp2,
      ),
      color: SBIColors.stone100,
      child: Row(
        children: [
          _StatChip(
            label: '${state.totalPracticed} practiced',
            color: SBIColors.statusInfo,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: '${state.totalMastered} mastered',
            color: SBIColors.statusSuccess,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: '${state.totalNeedsHelp} needs help',
            color: SBIColors.statusWarn,
          ),
          const Spacer(),
          Text(
            '${state.filteredCards.length} cards',
            style: TextStyle(fontSize: 12, color: SBIColors.navy.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Adult Card Tile ──────────────────────────────────────────────────────────
class _AdultCardTile extends StatefulWidget {
  final SBICard card;
  final AppState state;
  final bool isExpanded;
  final VoidCallback onTap;

  const _AdultCardTile({
    required this.card,
    required this.state,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_AdultCardTile> createState() => _AdultCardTileState();
}

class _AdultCardTileState extends State<_AdultCardTile> {
  int _activeTab = 0; // 0=card, 1=teach, 2=scenario

  @override
  Widget build(BuildContext context) {
    final domain = enhancedDomains[widget.card.domain];
    final domainColor = domain?.color ?? SBIColors.navy;
    final progress = widget.state.getProgress(widget.card.id);
    final isFocus = widget.state.isFocusCard(widget.card.id);

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
      child: Column(
        children: [
          // ── Header row ────────────────────────────────────────────────
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(SBIRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(SBISpacing.sp3),
              child: Row(
                children: [
                  // ── Icon ──────────────────────────────────────────────
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: domainColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(SBIRadius.sm),
                    ),
                    child: Center(
                      child: Text(widget.card.icon, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: SBISpacing.sp3),
                  // ── Word + domain ──────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.card.word,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: SBIColors.navy,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          domain?.label ?? widget.card.domain,
                          style: TextStyle(
                            fontSize: 12,
                            color: domainColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Progress + focus + chevron ─────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(progress.icon, size: 14, color: progress.color),
                          const SizedBox(width: 4),
                          Icon(
                            isFocus ? Icons.star : Icons.star_border,
                            size: 14,
                            color: isFocus ? SBIColors.gold : SBIColors.navy.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: SBIColors.navy.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded content ──────────────────────────────────────────
          if (widget.isExpanded) ...[
            Divider(height: 1, color: domainColor.withValues(alpha: 0.15)),
            // Tab bar
            Container(
              color: SBIColors.stone50,
              child: Row(
                children: [
                  _InlineTab(label: 'Card Info', index: 0, active: _activeTab, onTap: (i) => setState(() => _activeTab = i)),
                  _InlineTab(label: 'Teach It', index: 1, active: _activeTab, onTap: (i) => setState(() => _activeTab = i)),
                  if (widget.card.scenario != null)
                    _InlineTab(label: 'Scenario', index: 2, active: _activeTab, onTap: (i) => setState(() => _activeTab = i)),
                ],
              ),
            ),
            Divider(height: 1, color: domainColor.withValues(alpha: 0.10)),
            Padding(
              padding: const EdgeInsets.all(SBISpacing.sp3),
              child: _activeTab == 0
                  ? _CardInfoPanel(card: widget.card, domainColor: domainColor)
                  : _activeTab == 1
                      ? _TeachItPanel(card: widget.card, domainColor: domainColor)
                      : widget.card.scenario != null
                          ? _ScenarioPanelAdult(scenario: widget.card.scenario!, domainColor: domainColor)
                          : const SizedBox.shrink(),
            ),
            // ── Progress + Focus actions ───────────────────────────────
            Divider(height: 1, color: domainColor.withValues(alpha: 0.10)),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SBISpacing.sp3,
                SBISpacing.sp2,
                SBISpacing.sp3,
                SBISpacing.sp3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MARK PROGRESS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: SBIColors.navy.withValues(alpha: 0.5),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ProgressStatus.values
                        .where((s) => s != ProgressStatus.notStarted)
                        .map((s) => _ProgressChipBtn(
                              status: s,
                              isActive: progress == s,
                              onTap: () => widget.state.setProgress(widget.card.id, s),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => widget.state.toggleFocusCard(widget.card.id),
                      icon: Icon(
                        isFocus ? Icons.star : Icons.star_border,
                        size: 16,
                        color: isFocus ? SBIColors.gold : SBIColors.navy,
                      ),
                      label: Text(
                        isFocus ? 'Remove from Focus Cards' : 'Add to Focus Cards',
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isFocus ? SBIColors.gold : SBIColors.navy,
                        side: BorderSide(
                          color: isFocus
                              ? SBIColors.gold.withValues(alpha: 0.5)
                              : SBIColors.navy.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SBIRadius.sm),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Inline Tab ───────────────────────────────────────────────────────────────
class _InlineTab extends StatelessWidget {
  final String label;
  final int index;
  final int active;
  final void Function(int) onTap;

  const _InlineTab({
    required this.label,
    required this.index,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == active;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? SBIColors.burgundy : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? SBIColors.burgundy : SBIColors.navy.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// ─── Card Info Panel ──────────────────────────────────────────────────────────
class _CardInfoPanel extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _CardInfoPanel({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Affirmation
        Container(
          padding: const EdgeInsets.all(SBISpacing.sp3),
          decoration: BoxDecoration(
            color: SBIColors.gold.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(SBIRadius.sm),
            border: Border.all(color: SBIColors.gold.withValues(alpha: 0.25)),
          ),
          child: Text(
            '"${card.affirmation}"',
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: SBIColors.navy,
            ),
          ),
        ),
        const SizedBox(height: SBISpacing.sp3),
        _InfoRow(title: 'Definition', content: card.definition, domainColor: domainColor),
        if (card.looksLike.isNotEmpty) ...[
          const SizedBox(height: SBISpacing.sp3),
          _BulletSection(
            title: 'Looks Like',
            bullets: card.looksLike,
            icon: Icons.check_circle_outline,
            color: const Color(0xFF2F6B3B),
          ),
        ],
        if (card.notLike.isNotEmpty) ...[
          const SizedBox(height: SBISpacing.sp3),
          _BulletSection(
            title: 'Not Like',
            bullets: card.notLike,
            icon: Icons.cancel_outlined,
            color: SBIColors.burgundy,
          ),
        ],
        const SizedBox(height: SBISpacing.sp3),
        _InfoRow(title: 'Real-Life Challenge', content: card.generalizationChallenge, domainColor: domainColor),
        const SizedBox(height: SBISpacing.sp2),
        _InfoRow(title: 'Reflection', content: card.reflection, domainColor: domainColor),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String content;
  final Color domainColor;

  const _InfoRow({required this.title, required this.content, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: domainColor,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 14, color: SBIColors.navy, height: 1.5),
        ),
      ],
    );
  }
}

class _BulletSection extends StatelessWidget {
  final String title;
  final List<String> bullets;
  final IconData icon;
  final Color color;

  const _BulletSection({
    required this.title,
    required this.bullets,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...bullets.map((b) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
              Expanded(
                child: Text(b, style: const TextStyle(fontSize: 14, color: SBIColors.navy, height: 1.4)),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

// ─── Teach It Panel ───────────────────────────────────────────────────────────
class _TeachItPanel extends StatelessWidget {
  final SBICard card;
  final Color domainColor;

  const _TeachItPanel({required this.card, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Teaching prompts ───────────────────────────────────────────
        _TeachSection(
          icon: Icons.record_voice_over_outlined,
          title: 'Teach It — Discussion Questions',
          domainColor: domainColor,
          bullets: card.teachItPrompts.isNotEmpty
              ? card.teachItPrompts
              : [
                  'What does ${card.word.toLowerCase()} mean?',
                  'When would you use this skill?',
                  'Show me what it looks like.',
                  'When is one time you used this skill?',
                ],
        ),
        const SizedBox(height: SBISpacing.sp3),
        // ── Prompting supports ─────────────────────────────────────────
        _TeachSection(
          icon: Icons.handshake_outlined,
          title: 'Prompting Supports',
          domainColor: domainColor,
          bullets: card.promptingSupports.isNotEmpty
              ? card.promptingSupports
              : [
                  'Model the response.',
                  'Offer two choices.',
                  'Use a visual cue.',
                  'Practice again with help.',
                  'Fade support when ready.',
                ],
        ),
        const SizedBox(height: SBISpacing.sp3),
        // ── Practice prompt ────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(SBISpacing.sp3),
          decoration: BoxDecoration(
            color: domainColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(SBIRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology_outlined, size: 14, color: domainColor),
                  const SizedBox(width: 6),
                  Text(
                    'PRACTICE PROMPT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: domainColor,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                card.practice,
                style: const TextStyle(fontSize: 14, color: SBIColors.navy, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: SBISpacing.sp3),
        // ── Generalization ─────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(SBISpacing.sp3),
          decoration: BoxDecoration(
            color: SBIColors.gold.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(SBIRadius.md),
            border: Border.all(color: SBIColors.gold.withValues(alpha: 0.30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_outline, size: 14, color: SBIColors.gold),
                  const SizedBox(width: 6),
                  Text(
                    'GENERALIZATION CHALLENGE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: SBIColors.gold.withValues(alpha: 0.9),
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                card.generalizationChallenge,
                style: const TextStyle(
                  fontSize: 14,
                  color: SBIColors.navy,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TeachSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color domainColor;
  final List<String> bullets;

  const _TeachSection({
    required this.icon,
    required this.title,
    required this.domainColor,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: domainColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: domainColor,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...bullets.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 8, top: 1),
                decoration: BoxDecoration(
                  color: domainColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${e.key + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: domainColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  e.value,
                  style: const TextStyle(fontSize: 14, color: SBIColors.navy, height: 1.4),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

// ─── Scenario Panel (Adult) ───────────────────────────────────────────────────
class _ScenarioPanelAdult extends StatefulWidget {
  final Scenario scenario;
  final Color domainColor;

  const _ScenarioPanelAdult({required this.scenario, required this.domainColor});

  @override
  State<_ScenarioPanelAdult> createState() => _ScenarioPanelAdultState();
}

class _ScenarioPanelAdultState extends State<_ScenarioPanelAdult> {
  int? _selected;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.scenario.prompt,
          style: const TextStyle(
            fontSize: 15,
            color: SBIColors.navy,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(widget.scenario.choices.length, (i) {
          final choice = widget.scenario.choices[i];
          final isSelected = _selected == i;
          final isCorrect = choice.isCorrect;
          Color borderColor = SBIColors.navy.withValues(alpha: 0.20);
          Color? bgColor;
          if (_submitted && isSelected) {
            bgColor = isCorrect
                ? const Color(0xFF2F6B3B).withValues(alpha: 0.12)
                : SBIColors.burgundy.withValues(alpha: 0.08);
            borderColor = isCorrect ? const Color(0xFF2F6B3B) : SBIColors.burgundy;
          } else if (!_submitted && isSelected) {
            bgColor = SBIColors.navy.withValues(alpha: 0.06);
            borderColor = SBIColors.navy;
          }
          return GestureDetector(
            onTap: () {
              if (!_submitted) setState(() => _selected = i);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor ?? SBIColors.ivory,
                borderRadius: BorderRadius.circular(SBIRadius.sm),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(
                    _submitted && isSelected
                        ? (isCorrect ? Icons.check_circle : Icons.cancel)
                        : (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                    size: 18,
                    color: _submitted && isSelected
                        ? (isCorrect ? const Color(0xFF2F6B3B) : SBIColors.burgundy)
                        : (isSelected ? SBIColors.navy : SBIColors.navy.withValues(alpha: 0.4)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(choice.text, style: const TextStyle(fontSize: 14, color: SBIColors.navy)),
                  ),
                  if (_submitted && isCorrect)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F6B3B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Correct',
                        style: TextStyle(fontSize: 11, color: Color(0xFF2F6B3B), fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        if (_submitted && _selected != null)
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.scenario.choices[_selected!].isCorrect
                  ? const Color(0xFF2F6B3B).withValues(alpha: 0.08)
                  : const Color(0xFFB07D14).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(SBIRadius.sm),
            ),
            child: Text(
              widget.scenario.choices[_selected!].feedback,
              style: TextStyle(
                fontSize: 14,
                color: widget.scenario.choices[_selected!].isCorrect
                    ? const Color(0xFF2F6B3B)
                    : const Color(0xFF8B5E0A),
                height: 1.4,
              ),
            ),
          ),
        Row(
          children: [
            if (!_submitted)
              Expanded(
                child: ElevatedButton(
                  onPressed: _selected != null
                      ? () => setState(() => _submitted = true)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SBIColors.burgundy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SBIRadius.sm),
                    ),
                  ),
                  child: const Text('Check Answer'),
                ),
              )
            else
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _selected = null;
                    _submitted = false;
                  }),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SBIColors.burgundy,
                    side: const BorderSide(color: SBIColors.burgundy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SBIRadius.sm),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Progress Chip Button ─────────────────────────────────────────────────────
class _ProgressChipBtn extends StatelessWidget {
  final ProgressStatus status;
  final bool isActive;
  final VoidCallback onTap;

  const _ProgressChipBtn({
    required this.status,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? status.color : status.color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: status.color.withValues(alpha: 0.40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 12, color: isActive ? Colors.white : status.color),
            const SizedBox(width: 4),
            Text(
              status.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : status.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Domain Overview Tab ──────────────────────────────────────────────────────
class _DomainOverviewTab extends StatelessWidget {
  const _DomainOverviewTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(SBISpacing.sp4),
      children: [
        Text(
          '8 Essential Domains',
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: SBIColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'SBI Success Cards™ covers the core skill areas '
          'needed for independence, employment, and community connection.',
          style: TextStyle(fontSize: 14, color: SBIColors.navy.withValues(alpha: 0.65), height: 1.5),
        ),
        const SizedBox(height: SBISpacing.sp4),
        ...enhancedDomains.values.map((d) => _DomainCard(domain: d)),
      ],
    );
  }
}

class _DomainCard extends StatelessWidget {
  final DomainInfo domain;

  const _DomainCard({required this.domain});

  @override
  Widget build(BuildContext context) {
    final cards = allEnhancedCards.where((c) => c.domain == domain.key).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: SBISpacing.sp3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: domain.color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: SBISpacing.sp4,
              vertical: SBISpacing.sp3,
            ),
            decoration: BoxDecoration(
              color: domain.color.withValues(alpha: 0.10),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SBIRadius.lg)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: domain.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      domain.label[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        domain.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: domain.color,
                        ),
                      ),
                      Text(
                        '${cards.length} card${cards.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: domain.color.withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Description + card list
          Padding(
            padding: const EdgeInsets.all(SBISpacing.sp3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  domain.description,
                  style: const TextStyle(fontSize: 13, color: SBIColors.navy, height: 1.5),
                ),
                if (cards.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: cards.map((c) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: domain.soft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${c.icon} ${c.word}',
                        style: TextStyle(
                          fontSize: 12,
                          color: domain.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
