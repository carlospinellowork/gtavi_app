class PropertyModel {
  final String id;
  final String name;
  final String location;
  final int purchasePrice;
  final int incomePerHour;
  final String category;
  final String description;
  final bool isOwned;

  const PropertyModel({
    required this.id,
    required this.name,
    required this.location,
    required this.purchasePrice,
    required this.incomePerHour,
    required this.category,
    required this.description,
    this.isOwned = false,
  });
}
