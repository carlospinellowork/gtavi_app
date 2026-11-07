import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtavi_app/app/app.dart';
import 'package:gtavi_app/app/providers.dart';
import 'package:gtavi_app/features/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('abre no Início com a contagem regressiva', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const LeonidaHubApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Checklist'), findsOneWidget);
  });

  testWidgets('contagem mostra dias que faltam e vira "Já disponível"', (
    tester,
  ) async {
    final target = DateTime(2026, 11, 19);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Countdown(target: target, now: () => DateTime(2026, 11, 7, 12)),
        ),
      ),
    );
    expect(find.text('11'), findsOneWidget); // 11 dias e 12 horas
    expect(find.text('dias'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Countdown(target: target, now: () => DateTime(2026, 11, 20)),
        ),
      ),
    );
    expect(find.textContaining('Já disponível'), findsOneWidget);
  });
}
