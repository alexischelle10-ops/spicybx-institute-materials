import 'package:flutter/material.dart';

class DomainInfo {
  final String key;
  final String label;
  final Color color;
  final Color soft;
  final String icon;

  const DomainInfo({
    required this.key,
    required this.label,
    required this.color,
    required this.soft,
    required this.icon,
  });
}

class AffirmationCard {
  final String id;
  final int level;
  final String domain;
  final String word;
  final String affirmation;
  final String icon;
  final String definition;
  final List<String> looksLike;
  final List<String> notLike;
  final String practice;
  final String reflection;

  const AffirmationCard({
    required this.id,
    required this.level,
    required this.domain,
    required this.word,
    required this.affirmation,
    required this.icon,
    required this.definition,
    required this.looksLike,
    required this.notLike,
    required this.practice,
    required this.reflection,
  });
}
