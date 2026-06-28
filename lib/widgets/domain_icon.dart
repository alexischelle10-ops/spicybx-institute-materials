import 'package:flutter/material.dart';
import '../theme/sbi_tokens.dart';

/// Maps design icon names to Flutter Material Icons
IconData iconForName(String name) {
  const map = {
    'wind': Icons.air,
    'heart': Icons.favorite_outline,
    'hand': Icons.back_hand_outlined,
    'hourglass': Icons.hourglass_empty,
    'helping-hand': Icons.volunteer_activism_outlined,
    'shield-check': Icons.verified_outlined,
    'shield': Icons.shield_outlined,
    'list-checks': Icons.checklist_outlined,
    'repeat': Icons.repeat,
    'award': Icons.emoji_events_outlined,
    'ear': Icons.hearing_outlined,
    'thumbs-up': Icons.thumb_up_outlined,
    'star': Icons.star_outline,
    'move': Icons.open_with,
    'trash-2': Icons.delete_outline,
    'check': Icons.check_circle_outline,
    'users': Icons.group_outlined,
    'ban': Icons.block,
    'message-circle': Icons.chat_bubble_outline,
    'wrench': Icons.build_outlined,
    'message-square': Icons.comment_outlined,
    'target': Icons.my_location,
    'sparkles': Icons.auto_awesome,
    'book-open': Icons.menu_book_outlined,
    'sun': Icons.wb_sunny_outlined,
    'check-circle': Icons.check_circle_outlined,
    'badge-check': Icons.verified,
    'smile': Icons.sentiment_satisfied_outlined,
    'briefcase': Icons.work_outline,
    'mountain': Icons.terrain_outlined,
    'key-round': Icons.key_outlined,
    'lightbulb': Icons.lightbulb_outline,
    'git-branch': Icons.account_tree_outlined,
    'brain': Icons.psychology_outlined,
    'megaphone': Icons.campaign_outlined,
    'map-pin': Icons.place_outlined,
    'sprout': Icons.eco_outlined,
    'trending-up': Icons.trending_up,
    'rotate-ccw': Icons.replay,
    'sunrise': Icons.wb_twilight_outlined,
    'trophy': Icons.emoji_events_outlined,
    'medal': Icons.military_tech_outlined,
    'gift': Icons.card_giftcard_outlined,
    'compass': Icons.explore_outlined,
    'layers': Icons.layers_outlined,
    'presentation': Icons.present_to_all_outlined,
    'book': Icons.book_outlined,
    'image': Icons.image_outlined,
    'award2': Icons.workspace_premium_outlined,
    'bar-chart': Icons.bar_chart_outlined,
    'calendar': Icons.calendar_today_outlined,
    'home': Icons.home_outlined,
  };
  return map[name] ?? Icons.circle_outlined;
}

class DomainIconCircle extends StatelessWidget {
  final String iconName;
  final Color domainColor;
  final Color softColor;
  final double size;
  final double iconSize;

  const DomainIconCircle({
    super.key,
    required this.iconName,
    required this.domainColor,
    required this.softColor,
    this.size = 84,
    this.iconSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: softColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: domainColor,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Icon(
        iconForName(iconName),
        color: domainColor,
        size: iconSize,
      ),
    );
  }
}

/// Gold rule with diamond — the SBI signature divider
class GoldRule extends StatelessWidget {
  final double maxWidth;

  const GoldRule({super.key, this.maxWidth = 120});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: maxWidth / 2,
          height: 1.5,
          color: SBIColors.gold,
        ),
        const SizedBox(width: 8),
        Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 7,
            height: 7,
            color: SBIColors.gold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: maxWidth / 2,
          height: 1.5,
          color: SBIColors.gold,
        ),
      ],
    );
  }
}

/// Eyebrow label — uppercase, burgundy, wide tracking
class Eyebrow extends StatelessWidget {
  final String text;
  final Color? color;

  const Eyebrow(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.20,
        color: color ?? SBIColors.burgundy,
      ),
    );
  }
}

/// Level badge pill
class LevelBadge extends StatelessWidget {
  final int level;
  final Color domainColor;

  const LevelBadge({super.key, required this.level, required this.domainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: SBIColors.ivory,
        borderRadius: BorderRadius.circular(SBIRadius.pill),
      ),
      child: Text(
        'L$level',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.08,
          color: domainColor,
        ),
      ),
    );
  }
}
