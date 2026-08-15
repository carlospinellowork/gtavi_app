class ProgressCategoryItem {
  final String id;
  final String name;
  final String category;
  final bool isCompleted;

  const ProgressCategoryItem({
    required this.id,
    required this.name,
    required this.category,
    this.isCompleted = false,
  });

  ProgressCategoryItem copyWith({
    String? id,
    String? name,
    String? category,
    bool? isCompleted,
  }) {
    return ProgressCategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ProgressModel {
  final double overallPercentage;
  final double missionsPercentage;
  final double collectiblesPercentage;
  final double vehiclesPercentage;
  final double easterEggsPercentage;
  final List<ProgressCategoryItem> items;

  const ProgressModel({
    required this.overallPercentage,
    required this.missionsPercentage,
    required this.collectiblesPercentage,
    required this.vehiclesPercentage,
    required this.easterEggsPercentage,
    required this.items,
  });
}
