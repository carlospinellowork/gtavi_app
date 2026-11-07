import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../features/content/content_models.dart';
import '../features/content/content_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences deve ser inicializado no main');
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository(prefs: ref.watch(sharedPreferencesProvider));
});

/// Conteúdo: mostra o local na hora e troca pelo remoto quando chegar.
class ContentNotifier extends AsyncNotifier<AppContent> {
  @override
  Future<AppContent> build() async {
    final repo = ref.watch(contentRepositoryProvider);
    final local = await repo.loadLocal();
    Future.microtask(() => refresh(current: local));
    return local;
  }

  Future<void> refresh({AppContent? current}) async {
    final base = current ?? state.valueOrNull;
    if (base == null) return;
    final remote = await ref.read(contentRepositoryProvider).fetchRemote(base);
    if (remote != null) state = AsyncData(remote);
  }
}

final contentProvider = AsyncNotifierProvider<ContentNotifier, AppContent>(ContentNotifier.new);

/// Itens marcados no checklist (ids), salvos no aparelho.
class ChecklistNotifier extends Notifier<Set<String>> {
  late SharedPreferences _prefs;

  @override
  Set<String> build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return (_prefs.getStringList(AppConstants.keyChecklistDone) ?? const []).toSet();
  }

  void toggle(String id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
    _prefs.setStringList(AppConstants.keyChecklistDone, next.toList());
  }
}

final checklistProvider = NotifierProvider<ChecklistNotifier, Set<String>>(ChecklistNotifier.new);
