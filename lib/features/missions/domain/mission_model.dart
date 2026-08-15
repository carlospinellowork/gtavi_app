class MissionModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final double rewardAmount;
  final String rewardDescription;
  final String location;
  final List<String> requirements;
  final bool isCompleted;
  final bool isFavorite;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.rewardAmount,
    required this.rewardDescription,
    required this.location,
    required this.requirements,
    this.isCompleted = false,
    this.isFavorite = false,
  });

  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? difficulty,
    double? rewardAmount,
    String? rewardDescription,
    String? location,
    List<String>? requirements,
    bool? isCompleted,
    bool? isFavorite,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      location: location ?? this.location,
      requirements: requirements ?? this.requirements,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'difficulty': difficulty,
        'rewardAmount': rewardAmount,
        'rewardDescription': rewardDescription,
        'location': location,
        'requirements': requirements,
        'isCompleted': isCompleted,
        'isFavorite': isFavorite,
      };

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      rewardAmount: (json['rewardAmount'] as num).toDouble(),
      rewardDescription: json['rewardDescription'] as String,
      location: json['location'] as String,
      requirements: List<String>.from(json['requirements'] as List),
      isCompleted: json['isCompleted'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
