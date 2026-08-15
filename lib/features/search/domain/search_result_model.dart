enum SearchResultType { vehicle, mission, location, guide, collectible }

class SearchResultModel {
  final String id;
  final String title;
  final String subtitle;
  final SearchResultType type;
  final String routePath;

  const SearchResultModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.routePath,
  });
}
