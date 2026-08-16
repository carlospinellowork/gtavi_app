import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/storage/storage_service.dart';
import '../core/network/api_client.dart';
import '../core/services/analytics_service.dart';
import '../features/vehicles/data/vehicles_repository.dart';
import '../features/missions/data/missions_repository.dart';
import '../features/progress/data/progress_repository.dart';
import '../features/progress/domain/progress_model.dart';
import '../features/guides/data/guides_repository.dart';
import '../features/news/data/news_repository.dart';
import '../features/favorites/data/favorites_repository.dart';
import '../features/videos/data/videos_repository.dart';
import '../features/radio/data/radio_repository.dart';
import '../features/cheats/data/cheats_repository.dart';
import '../features/economy/data/economy_repository.dart';
import '../features/characters/data/characters_repository.dart';
import '../features/locations/data/locations_repository.dart';
import '../features/weapons/data/weapons_repository.dart';
import '../features/gallery/data/gallery_repository.dart';
import '../features/easter_eggs/data/easter_eggs_repository.dart';
import '../features/search/data/search_repository.dart';

// ─── Core ───────────────────────────────────────────────────────────────
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

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return NoOpAnalyticsService();
});

// ─── Repositories ───────────────────────────────────────────────────────
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

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MockNewsRepository(apiClient: apiClient);
});

final videosRepositoryProvider = Provider<VideosRepository>((ref) {
  return MockVideosRepository();
});

final radioRepositoryProvider = Provider<RadioRepository>((ref) {
  return MockRadioRepository();
});

final cheatsRepositoryProvider = Provider<CheatsRepository>((ref) {
  return MockCheatsRepository();
});

final economyRepositoryProvider = Provider<EconomyRepository>((ref) {
  return MockEconomyRepository();
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return MockFavoritesRepository(storage);
});

// ─── NEW: Repositories adicionais ───────────────────────────────────────
final charactersRepositoryProvider = Provider<CharactersRepository>((ref) {
  return MockCharactersRepository();
});

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return MockLocationsRepository();
});

final weaponsRepositoryProvider = Provider<WeaponsRepository>((ref) {
  return MockWeaponsRepository();
});

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  return MockGalleryRepository();
});

final easterEggsRepositoryProvider = Provider<EasterEggsRepository>((ref) {
  return MockEasterEggsRepository();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    characters: ref.watch(charactersRepositoryProvider),
    vehicles: ref.watch(vehiclesRepositoryProvider),
    missions: ref.watch(missionsRepositoryProvider),
    locations: ref.watch(locationsRepositoryProvider),
    weapons: ref.watch(weaponsRepositoryProvider),
    guides: ref.watch(guidesRepositoryProvider),
    easterEggs: ref.watch(easterEggsRepositoryProvider),
    gallery: ref.watch(galleryRepositoryProvider),
  );
});

// ─── State Notifiers ────────────────────────────────────────────────────
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
