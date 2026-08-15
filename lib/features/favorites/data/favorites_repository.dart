import '../../../core/storage/storage_service.dart';
import '../../../core/constants/app_constants.dart';

abstract class FavoritesRepository {
  Future<List<String>> getFavoriteIds();
  Future<bool> isFavorite(String id);
  Future<void> toggleFavorite(String id);
}

class MockFavoritesRepository implements FavoritesRepository {
  final StorageService _storageService;

  MockFavoritesRepository(this._storageService);

  @override
  Future<List<String>> getFavoriteIds() async {
    final list = _storageService.getStringList(AppConstants.keyFavorites);
    if (list.isEmpty) {
      return ['v1', 'm2', 'g1'];
    }
    return list;
  }

  @override
  Future<bool> isFavorite(String id) async {
    final ids = await getFavoriteIds();
    return ids.contains(id);
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final ids = (await getFavoriteIds()).toSet();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await _storageService.setStringList(AppConstants.keyFavorites, ids.toList());
  }
}
