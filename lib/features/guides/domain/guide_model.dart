class GuideModel {
  final String id;
  final String title;
  final String summary;
  final String category;
  final String readTime;
  final String author;
  final List<String> steps;
  final bool isPopular;
  final bool isFavorite;

  const GuideModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.readTime,
    required this.author,
    required this.steps,
    this.isPopular = false,
    this.isFavorite = false,
  });

  GuideModel copyWith({
    String? id,
    String? title,
    String? summary,
    String? category,
    String? readTime,
    String? author,
    List<String>? steps,
    bool? isPopular,
    bool? isFavorite,
  }) {
    return GuideModel(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      readTime: readTime ?? this.readTime,
      author: author ?? this.author,
      steps: steps ?? this.steps,
      isPopular: isPopular ?? this.isPopular,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
