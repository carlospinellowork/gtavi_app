import '../../../core/domain/content_metadata.dart';

class CharacterModel {
  final String id;
  final String name;
  final String nickname;
  final String role;
  final String description;
  final String imageUrl;
  final String? localImageAsset;
  final String nationality;
  final String age;
  final List<String> skills;
  final List<String> relatedMissionIds;
  final List<String> relatedLocationIds;
  final List<String> relatedVideoIds;
  final List<String> relatedGuideIds;
  final ContentMeta meta;
  final bool isFavorite;

  const CharacterModel({
    required this.id,
    required this.name,
    this.nickname = '',
    required this.role,
    required this.description,
    required this.imageUrl,
    this.localImageAsset,
    this.nationality = '',
    this.age = '',
    this.skills = const [],
    this.relatedMissionIds = const [],
    this.relatedLocationIds = const [],
    this.relatedVideoIds = const [],
    this.relatedGuideIds = const [],
    this.meta = const ContentMeta(status: ContentStatus.confirmed),
    this.isFavorite = false,
  });

  CharacterModel copyWith({
    String? id,
    String? name,
    String? nickname,
    String? role,
    String? description,
    String? imageUrl,
    String? localImageAsset,
    String? nationality,
    String? age,
    List<String>? skills,
    List<String>? relatedMissionIds,
    List<String>? relatedLocationIds,
    List<String>? relatedVideoIds,
    List<String>? relatedGuideIds,
    ContentMeta? meta,
    bool? isFavorite,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      role: role ?? this.role,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageAsset: localImageAsset ?? this.localImageAsset,
      nationality: nationality ?? this.nationality,
      age: age ?? this.age,
      skills: skills ?? this.skills,
      relatedMissionIds: relatedMissionIds ?? this.relatedMissionIds,
      relatedLocationIds: relatedLocationIds ?? this.relatedLocationIds,
      relatedVideoIds: relatedVideoIds ?? this.relatedVideoIds,
      relatedGuideIds: relatedGuideIds ?? this.relatedGuideIds,
      meta: meta ?? this.meta,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nickname': nickname,
        'role': role,
        'description': description,
        'imageUrl': imageUrl,
        'localImageAsset': localImageAsset,
        'nationality': nationality,
        'age': age,
        'skills': skills,
        'relatedMissionIds': relatedMissionIds,
        'relatedLocationIds': relatedLocationIds,
        'relatedVideoIds': relatedVideoIds,
        'relatedGuideIds': relatedGuideIds,
        'meta': meta.toJson(),
        'isFavorite': isFavorite,
      };

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String? ?? '',
      role: json['role'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      localImageAsset: json['localImageAsset'] as String?,
      nationality: json['nationality'] as String? ?? '',
      age: json['age'] as String? ?? '',
      skills: List<String>.from(json['skills'] as List? ?? []),
      relatedMissionIds: List<String>.from(json['relatedMissionIds'] as List? ?? []),
      relatedLocationIds: List<String>.from(json['relatedLocationIds'] as List? ?? []),
      relatedVideoIds: List<String>.from(json['relatedVideoIds'] as List? ?? []),
      relatedGuideIds: List<String>.from(json['relatedGuideIds'] as List? ?? []),
      meta: json['meta'] != null
          ? ContentMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : const ContentMeta(status: ContentStatus.confirmed),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
