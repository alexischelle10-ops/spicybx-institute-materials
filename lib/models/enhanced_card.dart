import 'package:flutter/material.dart';

// ─── Skill Levels ─────────────────────────────────────────────────────────────
enum SkillLevel {
  matchIt(1, 'Match It', 'Match the word to a picture or icon'),
  sayIt(2, 'Say It', 'Read or repeat the affirmation'),
  chooseIt(3, 'Choose It', 'Select the correct choice from a scenario'),
  showIt(4, 'Show It', 'Role-play or demonstrate the skill'),
  useIt(5, 'Use It', 'Use the skill in real life and reflect');

  final int number;
  final String label;
  final String description;
  const SkillLevel(this.number, this.label, this.description);
}

// ─── Progress Status ──────────────────────────────────────────────────────────
enum ProgressStatus {
  notStarted,
  practiced,
  needsHelp,
  canIdentify,
  canExplain,
  canDemonstrate,
  usedInRealLife,
}

extension ProgressStatusLabel on ProgressStatus {
  String get label {
    switch (this) {
      case ProgressStatus.notStarted: return 'Not Started';
      case ProgressStatus.practiced: return 'Practiced';
      case ProgressStatus.needsHelp: return 'Needs Help';
      case ProgressStatus.canIdentify: return 'Can Identify';
      case ProgressStatus.canExplain: return 'Can Explain';
      case ProgressStatus.canDemonstrate: return 'Can Demonstrate';
      case ProgressStatus.usedInRealLife: return 'Used in Real Life';
    }
  }

  IconData get icon {
    switch (this) {
      case ProgressStatus.notStarted: return Icons.radio_button_unchecked;
      case ProgressStatus.practiced: return Icons.cached;
      case ProgressStatus.needsHelp: return Icons.front_hand_outlined;
      case ProgressStatus.canIdentify: return Icons.visibility_outlined;
      case ProgressStatus.canExplain: return Icons.record_voice_over_outlined;
      case ProgressStatus.canDemonstrate: return Icons.emoji_people_outlined;
      case ProgressStatus.usedInRealLife: return Icons.star_outline;
    }
  }

  Color get color {
    switch (this) {
      case ProgressStatus.notStarted: return const Color(0xFF9E9E9E);
      case ProgressStatus.practiced: return const Color(0xFF1976D2);
      case ProgressStatus.needsHelp: return const Color(0xFFE65100);
      case ProgressStatus.canIdentify: return const Color(0xFF5B3A7A);
      case ProgressStatus.canExplain: return const Color(0xFF1F3E66);
      case ProgressStatus.canDemonstrate: return const Color(0xFF2F6B3B);
      case ProgressStatus.usedInRealLife: return const Color(0xFF9C7314);
    }
  }

  bool get isMastered => this == ProgressStatus.canDemonstrate || this == ProgressStatus.usedInRealLife;
}

// ─── Scenario Choice ─────────────────────────────────────────────────────────
class ScenarioChoice {
  final String text;
  final bool isCorrect;
  final String feedback;
  const ScenarioChoice({required this.text, required this.isCorrect, required this.feedback});
}

// ─── Scenario ────────────────────────────────────────────────────────────────
class Scenario {
  final String prompt;
  final List<ScenarioChoice> choices;
  const Scenario({required this.prompt, required this.choices});
}

// ─── Domain Info (enhanced) ───────────────────────────────────────────────────
class DomainInfo {
  final String key;
  final String label;
  final String description;
  final Color color;
  final Color soft;
  final String icon;

  const DomainInfo({
    required this.key,
    required this.label,
    required this.description,
    required this.color,
    required this.soft,
    required this.icon,
  });
}

// ─── Enhanced Card ────────────────────────────────────────────────────────────
class SBICard {
  final String id;
  final String domain;
  final String word;
  final String affirmation;
  final String icon;
  final String definition;
  final String practice;
  final String reflection;
  final String generalizationChallenge;
  final List<String> looksLike;
  final List<String> notLike;
  final List<String> teachItPrompts;
  final List<String> promptingSupports;
  final Scenario? scenario;
  final int level;
  final String? imageUrl;

  const SBICard({
    required this.id,
    required this.domain,
    required this.word,
    required this.affirmation,
    required this.icon,
    required this.definition,
    required this.practice,
    required this.reflection,
    required this.generalizationChallenge,
    required this.looksLike,
    required this.notLike,
    required this.teachItPrompts,
    required this.promptingSupports,
    this.scenario,
    required this.level,
    this.imageUrl,
  });

  String get readAloudText =>
      '$word. $affirmation. $definition';

  String get domainLabel {
    switch (domain) {
      case 'workplace': return 'Workplace Skills';
      case 'relationship': return 'Relationship Skills';
      case 'character': return 'Character Strengths';
      case 'daily': return 'Daily Life Skills';
      case 'communication': return 'Communication Skills';
      case 'social': return 'Social Understanding';
      case 'coping': return 'Coping & Stress Management';
      case 'selfadvocacy': return 'Self-Advocacy & Confidence';
      default: return domain;
    }
  }
}
