import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/enhanced_card.dart';
import '../data/enhanced_cards_data.dart';
import '../theme/sbi_tokens.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final total = allEnhancedCards.length;
        final practiced = state.totalPracticed;
        final mastered = state.totalMastered;
        final needsHelp = state.totalNeedsHelp;
        final focusCount = state.focusCards.length;

        return Scaffold(
          backgroundColor: SBIColors.ivory,
          body: CustomScrollView(
            slivers: [
              // ── AppBar ────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: SBIColors.navy,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [SBIColors.navy, Color(0xFF1B2C45)],
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
                            const Text(
                              'Progress Tracker',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Track skill development across all cards',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: const Text(
                    'Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(SBISpacing.sp4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Summary Cards ──────────────────────────────────
                      _SummaryGrid(
                        total: total,
                        practiced: practiced,
                        mastered: mastered,
                        needsHelp: needsHelp,
                        focusCount: focusCount,
                      ),
                      const SizedBox(height: SBISpacing.sp5),

                      // ── Overall Progress Bar ───────────────────────────
                      _OverallProgressBar(
                        practiced: practiced,
                        mastered: mastered,
                        total: total,
                      ),
                      const SizedBox(height: SBISpacing.sp5),

                      // ── Domain Breakdown ───────────────────────────────
                      const Text(
                        'By Domain',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SBIColors.navy,
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),
                      ...enhancedDomains.values.map(
                        (d) => _DomainProgressRow(domain: d, state: state),
                      ),
                      const SizedBox(height: SBISpacing.sp5),

                      // ── Card-by-Card Status ────────────────────────────
                      const Text(
                        'All Cards',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: SBIColors.navy,
                        ),
                      ),
                      const SizedBox(height: SBISpacing.sp3),
                      ...allEnhancedCards.map(
                        (card) => _CardProgressRow(card: card, state: state),
                      ),
                      const SizedBox(height: SBISpacing.sp8),

                      // ── Reset button ───────────────────────────────────
                      if (practiced > 0)
                        Center(
                          child: TextButton.icon(
                            onPressed: () => _confirmReset(context, state),
                            icon: Icon(Icons.refresh, size: 16, color: SBIColors.navy.withValues(alpha: 0.4)),
                            label: Text(
                              'Clear All Progress',
                              style: TextStyle(
                                fontSize: 13,
                                color: SBIColors.navy.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: SBISpacing.sp4),
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

  void _confirmReset(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.lg)),
        title: const Text(
          'Clear All Progress?',
          style: TextStyle(fontFamily: 'PlayfairDisplay', color: SBIColors.navy),
        ),
        content: Text(
          'This will remove all progress records for all cards. Focus cards will remain saved.',
          style: TextStyle(color: SBIColors.navy.withValues(alpha: 0.70), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Reset all progress
              for (final card in allEnhancedCards) {
                state.setProgress(card.id, ProgressStatus.notStarted);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All progress cleared.'),
                  backgroundColor: SBIColors.navy,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SBIColors.burgundy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SBIRadius.md)),
            ),
            child: const Text('Clear Progress'),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Grid ─────────────────────────────────────────────────────────────
class _SummaryGrid extends StatelessWidget {
  final int total;
  final int practiced;
  final int mastered;
  final int needsHelp;
  final int focusCount;

  const _SummaryGrid({
    required this.total,
    required this.practiced,
    required this.mastered,
    required this.needsHelp,
    required this.focusCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: SBISpacing.sp3,
      mainAxisSpacing: SBISpacing.sp3,
      childAspectRatio: 1.6,
      children: [
        _SummaryCard(
          value: '$practiced',
          label: 'Cards Practiced',
          sublabel: 'of $total total',
          icon: Icons.cached,
          color: SBIColors.statusInfo,
        ),
        _SummaryCard(
          value: '$mastered',
          label: 'Cards Mastered',
          sublabel: '${mastered == 0 ? 0 : ((mastered / total) * 100).round()}% complete',
          icon: Icons.star_outline,
          color: SBIColors.statusSuccess,
        ),
        _SummaryCard(
          value: '$needsHelp',
          label: 'Needs Support',
          sublabel: 'focus on these',
          icon: Icons.front_hand_outlined,
          color: SBIColors.statusWarn,
        ),
        _SummaryCard(
          value: '$focusCount',
          label: 'Focus Cards',
          sublabel: 'saved for practice',
          icon: Icons.star,
          color: SBIColors.gold,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SBISpacing.sp3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SBIColors.navy,
            ),
          ),
          Text(
            sublabel,
            style: TextStyle(
              fontSize: 11,
              color: SBIColors.navy.withValues(alpha: 0.50),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Overall Progress Bar ──────────────────────────────────────────────────────
class _OverallProgressBar extends StatelessWidget {
  final int practiced;
  final int mastered;
  final int total;

  const _OverallProgressBar({
    required this.practiced,
    required this.mastered,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final masteredPct = total > 0 ? mastered / total : 0.0;
    final practicedPct = total > 0 ? practiced / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(SBISpacing.sp4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.lg),
        border: Border.all(color: SBIColors.navy.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: SBIColors.navy.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Overall Progress',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: SBIColors.navy),
              ),
              const Spacer(),
              Text(
                '${(masteredPct * 100).round()}% mastered',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SBIColors.statusSuccess,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Practiced bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Practiced',
                    style: TextStyle(fontSize: 12, color: SBIColors.navy.withValues(alpha: 0.55)),
                  ),
                  Text(
                    '$practiced / $total',
                    style: TextStyle(fontSize: 12, color: SBIColors.statusInfo, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: practicedPct,
                  backgroundColor: SBIColors.statusInfo.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(SBIColors.statusInfo),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mastered bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mastered',
                    style: TextStyle(fontSize: 12, color: SBIColors.navy.withValues(alpha: 0.55)),
                  ),
                  Text(
                    '$mastered / $total',
                    style: TextStyle(
                      fontSize: 12,
                      color: SBIColors.statusSuccess,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: masteredPct,
                  backgroundColor: SBIColors.statusSuccess.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(SBIColors.statusSuccess),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Domain Progress Row ──────────────────────────────────────────────────────
class _DomainProgressRow extends StatelessWidget {
  final DomainInfo domain;
  final AppState state;

  const _DomainProgressRow({required this.domain, required this.state});

  @override
  Widget build(BuildContext context) {
    final cards = allEnhancedCards.where((c) => c.domain == domain.key).toList();
    final total = cards.length;
    final mastered = cards.where((c) => state.getProgress(c.id).isMastered).length;
    final practiced = cards.where((c) => state.getProgress(c.id) != ProgressStatus.notStarted).length;
    final pct = total > 0 ? mastered / total : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: SBISpacing.sp2),
      padding: const EdgeInsets.symmetric(
        horizontal: SBISpacing.sp3,
        vertical: SBISpacing.sp3,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.md),
        border: Border.all(color: domain.color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: domain.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                domain.label[0],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: domain.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: SBISpacing.sp3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        domain.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: SBIColors.navy,
                        ),
                      ),
                    ),
                    Text(
                      '$practiced/$total practiced · $mastered mastered',
                      style: TextStyle(
                        fontSize: 11,
                        color: SBIColors.navy.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: domain.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(domain.color),
                    minHeight: 6,
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

// ─── Card Progress Row ────────────────────────────────────────────────────────
class _CardProgressRow extends StatelessWidget {
  final SBICard card;
  final AppState state;

  const _CardProgressRow({required this.card, required this.state});

  @override
  Widget build(BuildContext context) {
    final domain = enhancedDomains[card.domain];
    final domainColor = domain?.color ?? SBIColors.navy;
    final progress = state.getProgress(card.id);
    final isFocus = state.isFocusCard(card.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: SBISpacing.sp3, vertical: SBISpacing.sp2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SBIRadius.sm),
        border: Border.all(color: SBIColors.navy.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Text(card.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: SBISpacing.sp3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      card.word,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SBIColors.navy,
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                    if (isFocus) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.star, size: 12, color: SBIColors.gold),
                    ],
                  ],
                ),
                Text(
                  domain?.label ?? card.domain,
                  style: TextStyle(fontSize: 11, color: domainColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: progress.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(progress.icon, size: 11, color: progress.color),
                const SizedBox(width: 4),
                Text(
                  progress.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: progress.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Quick mark buttons
          GestureDetector(
            onTap: () => state.setProgress(
              card.id,
              progress.isMastered ? ProgressStatus.notStarted : ProgressStatus.canDemonstrate,
            ),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: progress.isMastered
                    ? SBIColors.statusSuccess.withValues(alpha: 0.15)
                    : SBIColors.statusSuccess.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: SBIColors.statusSuccess.withValues(alpha: 0.35),
                ),
              ),
              child: Icon(
                Icons.check,
                size: 14,
                color: SBIColors.statusSuccess,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
