import '../../../core/domain/content_metadata.dart';

class EasterEggModel {
  final String id;
  final String title;
  final String description;
  final String hint;
  final String category;
  final String? imageUrl;
  final String? localImageAsset;
  final String? locationHint;
  final List<String> relatedLocationIds;
  final List<String> relatedVideoIds;
  final ContentMeta meta;
  final bool isFavorite;
  final bool isDiscovered;

  const EasterEggModel({
    required this.id, required this.title, required this.description,
    this.hint = '', this.category = 'Segredo', this.imageUrl, this.localImageAsset,
    this.locationHint, this.relatedLocationIds = const [],
    this.relatedVideoIds = const [],
    this.meta = const ContentMeta(status: ContentStatus.community),
    this.isFavorite = false, this.isDiscovered = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description, 'hint': hint,
    'category': category, 'imageUrl': imageUrl, 'localImageAsset': localImageAsset,
    'locationHint': locationHint, 'relatedLocationIds': relatedLocationIds,
    'relatedVideoIds': relatedVideoIds, 'meta': meta.toJson(),
    'isFavorite': isFavorite, 'isDiscovered': isDiscovered,
  };

  factory EasterEggModel.fromJson(Map<String, dynamic> j) => EasterEggModel(
    id: j['id'] as String, title: j['title'] as String,
    description: j['description'] as String, hint: j['hint'] as String? ?? '',
    category: j['category'] as String? ?? 'Segredo',
    imageUrl: j['imageUrl'] as String?, localImageAsset: j['localImageAsset'] as String?,
    locationHint: j['locationHint'] as String?,
    relatedLocationIds: List<String>.from(j['relatedLocationIds'] as List? ?? []),
    relatedVideoIds: List<String>.from(j['relatedVideoIds'] as List? ?? []),
    meta: j['meta'] != null ? ContentMeta.fromJson(j['meta'] as Map<String, dynamic>) : const ContentMeta(),
    isFavorite: j['isFavorite'] as bool? ?? false,
    isDiscovered: j['isDiscovered'] as bool? ?? false,
  );
}
