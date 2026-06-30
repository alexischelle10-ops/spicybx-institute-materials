import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:affirmation_cards/main.dart';
import 'package:affirmation_cards/providers/deck_state.dart';
import 'package:affirmation_cards/providers/app_state.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DeckState()),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const SBISuccessCardsApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
