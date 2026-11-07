import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gtavi_app/core/constants/app_constants.dart';
import 'package:gtavi_app/features/content/content_models.dart';
import 'package:gtavi_app/features/content/content_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final bundledRaw = File('assets/content/content.json').readAsStringSync();

  test('content.json embutido é válido e completo', () {
    final c = AppContent.fromJson(
      jsonDecode(bundledRaw) as Map<String, dynamic>,
    );
    expect(c.releaseDate, DateTime(2026, 11, 19));
    expect(c.news, isNotEmpty);
    expect(c.videos, isNotEmpty);
    expect(c.videos.every((v) => v.youtubeId.length == 11), isTrue);
    expect(c.characters, isNotEmpty);
    expect(c.checklistTotal, greaterThan(0));
    expect(c.version, greaterThan(2)); // gerado pelo robô (AAAAMMDDhhmm)
    // notícias da mais nova para a mais antiga
    for (var i = 1; i < c.news.length; i++) {
      expect(c.news[i - 1].date.isBefore(c.news[i].date), isFalse);
    }
    // ids do checklist únicos (progresso é salvo por id)
    final ids = [
      for (final g in c.checklist)
        for (final i in g.items) i.id,
    ];
    expect(ids.toSet().length, ids.length);
  });

  test(
    'cache mais novo vence o embutido; cache antigo ou quebrado é ignorado',
    () async {
      final bundledVersion = AppContent.fromJson(
        jsonDecode(bundledRaw) as Map<String, dynamic>,
      ).version;
      final newer = (jsonDecode(bundledRaw) as Map<String, dynamic>)
        ..['version'] = bundledVersion + 1;
      SharedPreferences.setMockInitialValues({
        AppConstants.keyContentCache: jsonEncode(newer),
      });
      var repo = ContentRepository(
        prefs: await SharedPreferences.getInstance(),
        loadBundled: () async => bundledRaw,
      );
      expect((await repo.loadLocal()).version, bundledVersion + 1);

      SharedPreferences.setMockInitialValues({
        AppConstants.keyContentCache: '{quebrado',
      });
      repo = ContentRepository(
        prefs: await SharedPreferences.getInstance(),
        loadBundled: () async => bundledRaw,
      );
      expect((await repo.loadLocal()).version, bundledVersion);
    },
  );
}
