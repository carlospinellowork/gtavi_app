import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import '../core/constants/app_constants.dart';

class GtaViCompanionApp extends StatelessWidget {
  const GtaViCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
