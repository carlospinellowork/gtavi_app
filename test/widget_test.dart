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

    // Splash/home agora carregam imagens reais via rede (AppNetworkImage).
    // Essas chamadas HTTP não respeitam o relógio falso do teste, então
    // NÃO usamos pumpAndSettle (ele esperaria a rede "assentar" e pode
    // travar/expirar em CI sem rede, ou demorar demais com rede lenta).
    // Em vez disso, avançamos o tempo falso o suficiente para a splash
    // (Future.delayed de 2800ms) navegar para /home e a tela assentar,
    // com pumps de duração fixa — sem esperar a imagem de rede terminar.
    await tester.pump(const Duration(milliseconds: 2900));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('GTA VI'), findsWidgets);
  });
}
