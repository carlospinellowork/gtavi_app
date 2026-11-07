import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'features/monetization/monetization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  // Compras primeiro (para saber se a pessoa já removeu os anúncios), depois consentimento + anúncios.
  container.read(premiumProvider.notifier).init();
  container.read(adsProvider.notifier).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LeonidaHubApp(),
    ),
  );
}
