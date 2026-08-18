import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gtavi_app/app/app.dart';
import 'package:gtavi_app/app/providers.dart';

void main() {
  testWidgets('GtaViCompanionApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const GtaViCompanionApp(),
      ),
    );

    // Splash/home agora carregam imagens reais via rede (AppNetworkImage);
    // runAsync deixa esse I/O real completar durante o teste em vez de travar
    // o pumpAndSettle esperando por um future que o clock falso não resolve.
    await tester.runAsync(() async {
      await tester.pump(const Duration(milliseconds: 2300));
      await tester.pumpAndSettle();
    });

    expect(find.text('GTA VI'), findsWidgets);
  });
}
