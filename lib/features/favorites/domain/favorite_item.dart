import '../../../core/domain/entity_type.dart';

/// Item favoritado com tipo e metadados mínimos para exibição.
class FavoriteItem {
  final String id;
  final EntityType type;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String routePath;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.routePath,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name, 'title': title, 'subtitle': subtitle,
    'imageUrl': imageUrl, 'routePath': routePath,
    'addedAt': addedAt.toIso8601String(),
  };

  factory FavoriteItem.fromJson(Map<String, dynamic> j) => FavoriteItem(
    id: j['id'] as String,
    type: EntityTypeExt.fromString(j['type'] as String? ?? 'guide'),
    title: j['title'] as String,
    subtitle: j['subtitle'] as String?,
    imageUrl: j['imageUrl'] as String?,
    routePath: j['routePath'] as String,
    addedAt: DateTime.tryParse(j['addedAt'] as String? ?? '') ?? DateTime.now(),
  );
}
