import '../../../core/domain/content_metadata.dart';

enum MediaType { screenshot, artwork, wallpaper, photo }

extension MediaTypeExt on MediaType {
  String get label {
    switch (this) {
      case MediaType.screenshot: return 'Screenshot';
      case MediaType.artwork: return 'Artwork';
      case MediaType.wallpaper: return 'Wallpaper';
      case MediaType.photo: return 'Foto';
    }
  }
  static MediaType fromString(String v) =>
      MediaType.values.firstWhere((e) => e.name == v, orElse: () => MediaType.screenshot);
}

class MediaItemModel {
  final String id;
  final String title;
  final String description;
  final MediaType type;
  final String category;
  final String imageUrl;
  final String? thumbnailUrl;
  final String? localImageAsset;
  final String? sourceName;
  final String? sourceUrl;
  final List<String> tags;
  final ContentMeta meta;
  final bool isFavorite;

  const MediaItemModel({
    required this.id, required this.title, this.description = '',
    required this.type, required this.category, required this.imageUrl,
    this.thumbnailUrl, this.localImageAsset, this.sourceName, this.sourceUrl,
    this.tags = const [], this.meta = const ContentMeta(status: ContentStatus.confirmed),
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description, 'type': type.name,
    'category': category, 'imageUrl': imageUrl, 'thumbnailUrl': thumbnailUrl,
    'localImageAsset': localImageAsset, 'sourceName': sourceName,
    'sourceUrl': sourceUrl, 'tags': tags, 'meta': meta.toJson(), 'isFavorite': isFavorite,
  };

  factory MediaItemModel.fromJson(Map<String, dynamic> j) => MediaItemModel(
    id: j['id'] as String, title: j['title'] as String,
    description: j['description'] as String? ?? '',
    type: MediaTypeExt.fromString(j['type'] as String? ?? 'screenshot'),
    category: j['category'] as String, imageUrl: j['imageUrl'] as String,
    thumbnailUrl: j['thumbnailUrl'] as String?,
    localImageAsset: j['localImageAsset'] as String?,
    sourceName: j['sourceName'] as String?, sourceUrl: j['sourceUrl'] as String?,
    tags: List<String>.from(j['tags'] as List? ?? []),
    meta: j['meta'] != null ? ContentMeta.fromJson(j['meta'] as Map<String, dynamic>) : const ContentMeta(),
    isFavorite: j['isFavorite'] as bool? ?? false,
  );
}
