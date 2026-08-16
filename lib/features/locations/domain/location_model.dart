import '../../../core/domain/content_metadata.dart';

class LocationModel {
  final String id;
  final String name;
  final String district;
  final String description;
  final String category; // Ex: Praia, Downtown, Subúrbio, Pântano, etc.
  final String imageUrl;
  final String? localImageAsset;
  final double? latitude;
  final double? longitude;
  final double? mapX; // 0.0 to 1.0 (posição no mapa custom)
  final double? mapY;
  final List<String> relatedMissionIds;
  final List<String> relatedCharacterIds;
  final List<String> relatedVehicleIds;
  final List<String> relatedVideoIds;
  final ContentMeta meta;
  final bool isFavorite;

  const LocationModel({
    required this.id,
    required this.name,
    required this.district,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.localImageAsset,
    this.latitude,
    this.longitude,
    this.mapX,
    this.mapY,
    this.relatedMissionIds = const [],
    this.relatedCharacterIds = const [],
    this.relatedVehicleIds = const [],
    this.relatedVideoIds = const [],
    this.meta = const ContentMeta(status: ContentStatus.confirmed),
    this.isFavorite = false,
  });

  LocationModel copyWith({
    String? id,
    String? name,
    String? district,
    String? description,
    String? category,
    String? imageUrl,
    String? localImageAsset,
    double? latitude,
    double? longitude,
    double? mapX,
    double? mapY,
    List<String>? relatedMissionIds,
    List<String>? relatedCharacterIds,
    List<String>? relatedVehicleIds,
    List<String>? relatedVideoIds,
    ContentMeta? meta,
    bool? isFavorite,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageAsset: localImageAsset ?? this.localImageAsset,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mapX: mapX ?? this.mapX,
      mapY: mapY ?? this.mapY,
      relatedMissionIds: relatedMissionIds ?? this.relatedMissionIds,
      relatedCharacterIds: relatedCharacterIds ?? this.relatedCharacterIds,
      relatedVehicleIds: relatedVehicleIds ?? this.relatedVehicleIds,
      relatedVideoIds: relatedVideoIds ?? this.relatedVideoIds,
      meta: meta ?? this.meta,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'district': district,
        'description': description,
        'category': category,
        'imageUrl': imageUrl,
        'localImageAsset': localImageAsset,
        'latitude': latitude,
        'longitude': longitude,
        'mapX': mapX,
        'mapY': mapY,
        'relatedMissionIds': relatedMissionIds,
        'relatedCharacterIds': relatedCharacterIds,
        'relatedVehicleIds': relatedVehicleIds,
        'relatedVideoIds': relatedVideoIds,
        'meta': meta.toJson(),
        'isFavorite': isFavorite,
      };

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      localImageAsset: json['localImageAsset'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      mapX: (json['mapX'] as num?)?.toDouble(),
      mapY: (json['mapY'] as num?)?.toDouble(),
      relatedMissionIds: List<String>.from(json['relatedMissionIds'] as List? ?? []),
      relatedCharacterIds: List<String>.from(json['relatedCharacterIds'] as List? ?? []),
      relatedVehicleIds: List<String>.from(json['relatedVehicleIds'] as List? ?? []),
      relatedVideoIds: List<String>.from(json['relatedVideoIds'] as List? ?? []),
      meta: json['meta'] != null
          ? ContentMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : const ContentMeta(status: ContentStatus.confirmed),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
