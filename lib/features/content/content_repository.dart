import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import 'content_models.dart';

/// Conteúdo do app em três camadas:
/// 1. cópia salva da última versão remota (abre na hora, funciona offline);
/// 2. arquivo embutido no app (primeira abertura ou sem internet);
/// 3. arquivo remoto (atualiza notícias, guias e checklist sem nova versão na loja).
class ContentRepository {
  final SharedPreferences prefs;
  final Dio dio;
  final Future<String> Function() loadBundled;

  ContentRepository({
    required this.prefs,
    Dio? dio,
    Future<String> Function()? loadBundled,
  })  : dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              responseType: ResponseType.plain,
            )),
        loadBundled = loadBundled ?? (() => rootBundle.loadString('assets/content/content.json'));

  /// Melhor conteúdo disponível sem rede: o mais novo entre cache e embutido.
  Future<AppContent> loadLocal() async {
    final bundled = AppContent.fromJson(jsonDecode(await loadBundled()) as Map<String, dynamic>);
    final cached = _parse(prefs.getString(AppConstants.keyContentCache));
    if (cached != null && cached.version >= bundled.version) return cached;
    return bundled;
  }

  /// Busca o arquivo remoto. Devolve null se falhar ou se não for mais novo que [current].
  Future<AppContent?> fetchRemote(AppContent current) async {
    try {
      final res = await dio.get<String>(AppConstants.contentUrl);
      final raw = res.data;
      final remote = _parse(raw);
      if (remote == null || remote.version < current.version) return null;
      await prefs.setString(AppConstants.keyContentCache, raw!);
      return remote;
    } catch (_) {
      return null;
    }
  }

  AppContent? _parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return AppContent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
