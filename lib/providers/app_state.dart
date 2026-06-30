import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enhanced_card.dart';
import '../data/enhanced_cards_data.dart';

class AppState extends ChangeNotifier {
  // ── Auth ──────────────────────────────────────────────────────────────────
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;

  // ── Mode ──────────────────────────────────────────────────────────────────
  bool _isLearnerMode = true;
  bool get isLearnerMode => _isLearnerMode;

  void setLearnerMode(bool value) {
    _isLearnerMode = value;
    notifyListeners();
  }

  // ── Focus Cards ───────────────────────────────────────────────────────────
  final Set<String> _focusCardIds = {};
  Set<String> get focusCardIds => _focusCardIds;

  List<SBICard> get focusCards =>
      allEnhancedCards.where((c) => _focusCardIds.contains(c.id)).toList();

  bool isFocusCard(String id) => _focusCardIds.contains(id);

  void toggleFocusCard(String id) {
    if (_focusCardIds.contains(id)) {
      _focusCardIds.remove(id);
    } else {
      _focusCardIds.add(id);
    }
    _saveFocusCards();
    notifyListeners();
  }

  // ── Progress ──────────────────────────────────────────────────────────────
  final Map<String, ProgressStatus> _progress = {};

  ProgressStatus getProgress(String cardId) =>
      _progress[cardId] ?? ProgressStatus.notStarted;

  void setProgress(String cardId, ProgressStatus status) {
    _progress[cardId] = status;
    _saveProgress();
    notifyListeners();
  }

  int get totalPracticed =>
      _progress.values.where((s) => s != ProgressStatus.notStarted).length;

  int get totalMastered =>
      _progress.values.where((s) => s.isMastered).length;

  int get totalNeedsHelp =>
      _progress.values.where((s) => s == ProgressStatus.needsHelp).length;

  // ── Domain filter (for Adult Mode library) ────────────────────────────────
  String? _selectedDomain;
  String? get selectedDomain => _selectedDomain;

  void setDomain(String? domain) {
    _selectedDomain = domain;
    notifyListeners();
  }

  List<SBICard> get filteredCards {
    if (_selectedDomain == null) return allEnhancedCards;
    return allEnhancedCards.where((c) => c.domain == _selectedDomain).toList();
  }

  // ── Flipped cards ─────────────────────────────────────────────────────────
  final Set<String> _flippedCards = {};
  bool isFlipped(String id) => _flippedCards.contains(id);
  void flipCard(String id) {
    if (_flippedCards.contains(id)) {
      _flippedCards.remove(id);
    } else {
      _flippedCards.add(id);
    }
    notifyListeners();
  }

  // ── Today's card index for learner mode ───────────────────────────────────
  int _learnerCardIndex = 0;
  int get learnerCardIndex => _learnerCardIndex;

  SBICard get currentLearnerCard {
    final cards = focusCards.isNotEmpty ? focusCards : allEnhancedCards;
    return cards[_learnerCardIndex % cards.length];
  }

  void nextLearnerCard() {
    final cards = focusCards.isNotEmpty ? focusCards : allEnhancedCards;
    _learnerCardIndex = (_learnerCardIndex + 1) % cards.length;
    _learnerFlipped = false;
    notifyListeners();
  }

  void prevLearnerCard() {
    final cards = focusCards.isNotEmpty ? focusCards : allEnhancedCards;
    _learnerCardIndex = (_learnerCardIndex - 1 + cards.length) % cards.length;
    _learnerFlipped = false;
    notifyListeners();
  }

  bool _learnerFlipped = false;
  bool get learnerFlipped => _learnerFlipped;
  void flipLearnerCard() {
    _learnerFlipped = !_learnerFlipped;
    notifyListeners();
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Demo: accept any non-empty credentials
    if (email.isNotEmpty && password.length >= 4) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@').first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sbi_logged_in', true);
      await prefs.setString('sbi_email', email);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    SharedPreferences.getInstance().then((p) {
      p.remove('sbi_logged_in');
      p.remove('sbi_email');
    });
    notifyListeners();
  }

  // ── Persistence ───────────────────────────────────────────────────────────
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('sbi_logged_in') ?? false;
    _userEmail = prefs.getString('sbi_email') ?? '';
    _userName = _userEmail.isNotEmpty ? _userEmail.split('@').first : '';

    final focusIds = prefs.getStringList('sbi_focus_cards') ?? [];
    _focusCardIds.addAll(focusIds);

    final progressKeys = prefs.getStringList('sbi_progress_keys') ?? [];
    for (final key in progressKeys) {
      final idx = prefs.getInt('sbi_progress_$key');
      if (idx != null && idx < ProgressStatus.values.length) {
        _progress[key] = ProgressStatus.values[idx];
      }
    }

    _isLearnerMode = prefs.getBool('sbi_learner_mode') ?? true;
    notifyListeners();
  }

  Future<void> _saveFocusCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sbi_focus_cards', _focusCardIds.toList());
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = _progress.keys.toList();
    await prefs.setStringList('sbi_progress_keys', keys);
    for (final key in keys) {
      await prefs.setInt('sbi_progress_$key', _progress[key]!.index);
    }
  }
}
