import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/storage/storage_service.dart';
import '../core/network/api_client.dart';
import '../features/vehicles/data/vehicles_repository.dart';
import '../features/missions/data/missions_repository.dart';
import '../features/progress/data/progress_repository.dart';
import '../features/progress/domain/progress_model.dart';
import '../features/guides/data/guides_repository.dart';
import '../features/favorites/data/favorites_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences deve ser inicializado no main');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final secure = ref.watch(secureStorageProvider);
  return StorageService(prefs: prefs, secureStorage: secure);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final vehiclesRepositoryProvider = Provider<VehiclesRepository>((ref) {
  return MockVehiclesRepository();
});

final missionsRepositoryProvider = Provider<MissionsRepository>((ref) {
  return MockMissionsRepository();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return MockProgressRepository(storage);
});

final guidesRepositoryProvider = Provider<GuidesRepository>((ref) {
  return MockGuidesRepository();
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return MockFavoritesRepository(storage);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getFavoriteIds();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      await _repository.toggleFavorite(id);
      await loadFavorites();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final favoritesStateProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<String>>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repo);
});

class ProgressNotifier extends StateNotifier<AsyncValue<ProgressModel>> {
  final ProgressRepository _repository;

  ProgressNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProgress();
  }

  Future<void> loadProgress() async {
    state = const AsyncValue.loading();
    try {
      final progress = await _repository.getProgress();
      state = AsyncValue.data(progress);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleItem(String itemId) async {
    try {
      await _repository.toggleItemCompletion(itemId);
      await loadProgress();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final progressStateProvider = StateNotifierProvider<ProgressNotifier, AsyncValue<ProgressModel>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return ProgressNotifier(repo);
});
