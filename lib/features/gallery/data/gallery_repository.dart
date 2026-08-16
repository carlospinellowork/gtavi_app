import '../domain/media_item_model.dart';
import '../../../core/domain/content_metadata.dart';

abstract class GalleryRepository {
  Future<List<MediaItemModel>> getMediaItems({String? category, MediaType? type, String? query});
  Future<MediaItemModel?> getMediaItemById(String id);
}

class MockGalleryRepository implements GalleryRepository {
  final List<MediaItemModel> _items = const [
    MediaItemModel(id: 'media_1', title: 'Vice Beach Sunrise', type: MediaType.screenshot,
      category: 'Locais', imageUrl: '', localImageAsset: 'assets/images/vice_city_beach.png',
      sourceName: 'Rockstar Games', tags: ['vice beach', 'praia', 'sunrise'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_2', title: 'Downtown Skyline', type: MediaType.screenshot,
      category: 'Locais', imageUrl: '', localImageAsset: 'assets/images/vice_city_downtown.png',
      sourceName: 'Rockstar Games', tags: ['downtown', 'skyline', 'noite'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_3', title: 'Lucia & Jason — Key Art', type: MediaType.artwork,
      category: 'Personagens', imageUrl: '', localImageAsset: 'assets/images/gtavi_lucia_jason.png',
      sourceName: 'Rockstar Games', tags: ['lucia', 'jason', 'artwork'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_4', title: 'Lucia Portrait', type: MediaType.artwork,
      category: 'Personagens', imageUrl: '', localImageAsset: 'assets/images/lucia_portrait.png',
      sourceName: 'Rockstar Games', tags: ['lucia', 'retrato'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_5', title: 'Jason Portrait', type: MediaType.artwork,
      category: 'Personagens', imageUrl: '', localImageAsset: 'assets/images/jason_portrait.png',
      sourceName: 'Rockstar Games', tags: ['jason', 'retrato'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_6', title: 'Vice City Supercars', type: MediaType.screenshot,
      category: 'Veículos', imageUrl: '', localImageAsset: 'assets/images/vice_city_cars.png',
      sourceName: 'Rockstar Games', tags: ['carros', 'superesportivos'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_7', title: 'Vice City Skyline Wallpaper', type: MediaType.wallpaper,
      category: 'Locais', imageUrl: '', localImageAsset: 'assets/images/splash_vice_city.png',
      sourceName: 'Rockstar Games', tags: ['wallpaper', 'skyline'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_8', title: 'Mapa 3D de Vice City', type: MediaType.artwork,
      category: 'Mapa', imageUrl: '', localImageAsset: 'assets/images/gtavi_map_3d.png',
      sourceName: 'Comunidade GTA', tags: ['mapa', '3d', 'vice city'],
      meta: ContentMeta(status: ContentStatus.community)),
  ];

  @override
  Future<List<MediaItemModel>> getMediaItems({String? category, MediaType? type, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var list = _items;
    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((m) => m.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (type != null) {
      list = list.where((m) => m.type == type).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((m) => m.title.toLowerCase().contains(q) ||
          m.tags.any((t) => t.contains(q))).toList();
    }
    return list;
  }

  @override
  Future<MediaItemModel?> getMediaItemById(String id) async {
    try { return _items.firstWhere((m) => m.id == id); } catch (_) { return null; }
  }
}
