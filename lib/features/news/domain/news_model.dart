class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String fullContent;
  final String source;
  final String category;
  final DateTime publishedAt;
  final String url;
  final String imageUrl;
  final String? localImageAsset;
  final String? videoUrl;
  final bool isFeatured;

  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.source,
    required this.category,
    required this.publishedAt,
    required this.url,
    required this.imageUrl,
    this.localImageAsset,
    this.videoUrl,
    this.isFeatured = false,
  });
}
