import '../../../core/domain/content_metadata.dart';

class WeaponModel {
  final String id;
  final String name;
  final String category; // Pistola, Rifle, Shotgun, Explosivo, Corpo a corpo, etc.
  final String description;
  final String imageUrl;
  final String? localImageAsset;
  final double damage;
  final double accuracy;
  final double fireRate;
  final double range;
  final int price;
  final String? locationHint;
  final List<String> relatedMissionIds;
  final List<String> relatedLocationIds;
  final ContentMeta meta;
  final bool isFavorite;

  const WeaponModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    this.localImageAsset,
    required this.damage,
    required this.accuracy,
    required this.fireRate,
    required this.range,
    this.price = 0,
    this.locationHint,
    this.relatedMissionIds = const [],
    this.relatedLocationIds = const [],
    this.meta = const ContentMeta(status: ContentStatus.rumor),
    this.isFavorite = false,
  });

  WeaponModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imageUrl,
    String? localImageAsset,
    double? damage,
    double? accuracy,
    double? fireRate,
    double? range,
    int? price,
    String? locationHint,
    List<String>? relatedMissionIds,
    List<String>? relatedLocationIds,
    ContentMeta? meta,
    bool? isFavorite,
  }) {
    return WeaponModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageAsset: localImageAsset ?? this.localImageAsset,
      damage: damage ?? this.damage,
      accuracy: accuracy ?? this.accuracy,
      fireRate: fireRate ?? this.fireRate,
      range: range ?? this.range,
      price: price ?? this.price,
      locationHint: locationHint ?? this.locationHint,
      relatedMissionIds: relatedMissionIds ?? this.relatedMissionIds,
      relatedLocationIds: relatedLocationIds ?? this.relatedLocationIds,
      meta: meta ?? this.meta,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'localImageAsset': localImageAsset,
        'damage': damage,
        'accuracy': accuracy,
        'fireRate': fireRate,
        'range': range,
        'price': price,
        'locationHint': locationHint,
        'relatedMissionIds': relatedMissionIds,
        'relatedLocationIds': relatedLocationIds,
        'meta': meta.toJson(),
        'isFavorite': isFavorite,
      };

  factory WeaponModel.fromJson(Map<String, dynamic> json) {
    return WeaponModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      localImageAsset: json['localImageAsset'] as String?,
      damage: (json['damage'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      fireRate: (json['fireRate'] as num).toDouble(),
      range: (json['range'] as num).toDouble(),
      price: json['price'] as int? ?? 0,
      locationHint: json['locationHint'] as String?,
      relatedMissionIds: List<String>.from(json['relatedMissionIds'] as List? ?? []),
      relatedLocationIds: List<String>.from(json['relatedLocationIds'] as List? ?? []),
      meta: json['meta'] != null
          ? ContentMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : const ContentMeta(status: ContentStatus.rumor),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
