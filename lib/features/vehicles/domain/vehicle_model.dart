class VehicleModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String location;
  final double speed;
  final double acceleration;
  final double braking;
  final double handling;
  final String imageUrl;
  final String description;
  final bool isFavorite;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.location,
    required this.speed,
    required this.acceleration,
    required this.braking,
    required this.handling,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  VehicleModel copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? location,
    double? speed,
    double? acceleration,
    double? braking,
    double? handling,
    String? imageUrl,
    String? description,
    bool? isFavorite,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      location: location ?? this.location,
      speed: speed ?? this.speed,
      acceleration: acceleration ?? this.acceleration,
      braking: braking ?? this.braking,
      handling: handling ?? this.handling,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'location': location,
        'speed': speed,
        'acceleration': acceleration,
        'braking': braking,
        'handling': handling,
        'imageUrl': imageUrl,
        'description': description,
        'isFavorite': isFavorite,
      };

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      speed: (json['speed'] as num).toDouble(),
      acceleration: (json['acceleration'] as num).toDouble(),
      braking: (json['braking'] as num).toDouble(),
      handling: (json['handling'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
