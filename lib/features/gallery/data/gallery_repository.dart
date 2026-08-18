import '../domain/media_item_model.dart';
import '../../../core/domain/content_metadata.dart';
import '../../../core/constants/gtavi_real_media.dart';

abstract class GalleryRepository {
  Future<List<MediaItemModel>> getMediaItems({String? category, MediaType? type, String? query});
  Future<MediaItemModel?> getMediaItemById(String id);
}

class MockGalleryRepository implements GalleryRepository {
  final List<MediaItemModel> _items = const [
    MediaItemModel(id: 'media_1', title: 'Vice Beach Sunrise', type: MediaType.screenshot,
      category: 'Locais', imageUrl: GtaViRealMedia.viceCityBeach,
      sourceName: 'Rockstar Games', tags: ['vice beach', 'praia', 'sunrise'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_2', title: 'Downtown Skyline', type: MediaType.screenshot,
      category: 'Locais', imageUrl: GtaViRealMedia.viceCityAerial,
      sourceName: 'Rockstar Games', tags: ['downtown', 'skyline', 'noite'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_3', title: 'Lucia & Jason — Key Art', type: MediaType.artwork,
      category: 'Personagens', imageUrl: GtaViRealMedia.trailer2Thumbnail,
      sourceName: 'Rockstar Games', tags: ['lucia', 'jason', 'artwork'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_4', title: 'Lucia Portrait', type: MediaType.artwork,
      category: 'Personagens', imageUrl: GtaViRealMedia.luciaGym,
      sourceName: 'Rockstar Games', tags: ['lucia', 'retrato'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_5', title: 'Jason Portrait', type: MediaType.artwork,
      category: 'Personagens', imageUrl: GtaViRealMedia.jasonMotorcycle,
      sourceName: 'Rockstar Games', tags: ['jason', 'retrato'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_7', title: 'Vice City Skyline Wallpaper', type: MediaType.wallpaper,
      category: 'Locais', imageUrl: GtaViRealMedia.viceCitySign,
      sourceName: 'Rockstar Games', tags: ['wallpaper', 'skyline'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
    MediaItemModel(id: 'media_9', title: 'Lucia na Piscina — Vice City', type: MediaType.screenshot,
      category: 'Personagens', imageUrl: GtaViRealMedia.luciaPool,
      sourceName: 'Rockstar Games', tags: ['lucia', 'piscina', 'hotel'],
      meta: ContentMeta(status: ContentStatus.confirmed)),
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
