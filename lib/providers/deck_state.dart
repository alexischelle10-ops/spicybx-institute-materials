import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/affirmation_card.dart';
import '../data/cards_data.dart';

class DeckState extends ChangeNotifier {
  int? _filterLevel; // null = all
  String? _filterDomain; // null = all
  bool _isDense = false;
  bool _flippedAll = false;
  final Set<String> _flippedCards = {};

  int? get filterLevel => _filterLevel;
  String? get filterDomain => _filterDomain;
  bool get isDense => _isDense;
  bool get flippedAll => _flippedAll;
  Set<String> get flippedCards => _flippedCards;

  List<AffirmationCard> get filteredCards {
    return allCards.where((card) {
      if (_filterLevel != null && card.level != _filterLevel) return false;
      if (_filterDomain != null && card.domain != _filterDomain) return false;
      return true;
    }).toList();
  }

  Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final level = prefs.getInt('level');
      final domain = prefs.getString('domain');
      final dense = prefs.getBool('dense') ?? false;
      _filterLevel = level;
      _filterDomain = domain;
      _isDense = dense;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_filterLevel != null) {
        await prefs.setInt('level', _filterLevel!);
      } else {
        await prefs.remove('level');
      }
      if (_filterDomain != null) {
        await prefs.setString('domain', _filterDomain!);
      } else {
        await prefs.remove('domain');
      }
      await prefs.setBool('dense', _isDense);
    } catch (_) {}
  }

  void setLevel(int? level) {
    _filterLevel = level;
    _flippedCards.clear();
    _flippedAll = false;
    _saveToPrefs();
    notifyListeners();
  }

  void setDomain(String? domain) {
    _filterDomain = domain;
    _flippedCards.clear();
    _flippedAll = false;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleDense() {
    _isDense = !_isDense;
    _saveToPrefs();
    notifyListeners();
  }

  void flipCard(String cardId) {
    if (_flippedCards.contains(cardId)) {
      _flippedCards.remove(cardId);
    } else {
      _flippedCards.add(cardId);
    }
    _flippedAll = false;
    notifyListeners();
  }

  void flipAll() {
    if (_flippedAll) {
      _flippedCards.clear();
      _flippedAll = false;
    } else {
      _flippedCards.clear();
      for (final card in filteredCards) {
        _flippedCards.add(card.id);
      }
      _flippedAll = true;
    }
    notifyListeners();
  }

  bool isFlipped(String cardId) => _flippedCards.contains(cardId);
}
