import '../domain/vehicle_model.dart';

abstract class VehiclesRepository {
  Future<List<VehicleModel>> getVehicles({String? category, String? query});
  Future<VehicleModel?> getVehicleById(String id);
}

class MockVehiclesRepository implements VehiclesRepository {
  final List<VehicleModel> _mockVehicles = const [
    VehicleModel(
      id: 'v1',
      name: 'Pegassi Ignus X',
      category: 'Super',
      price: 2450000,
      location: 'Vice City Downtown Showroom',
      speed: 0.95,
      acceleration: 0.90,
      braking: 0.82,
      handling: 0.88,
      imageUrl: 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?q=80&w=600',
      description: 'Superesportivo com tração integral e motor V12 com turbo híbrido, perfeito para alta velocidade no trecho costeiro de Vice City.',
    ),
    VehicleModel(
      id: 'v2',
      name: 'Grotti Cheetah Classic',
      category: 'Sports',
      price: 1850000,
      location: 'Ocean Drive Marina',
      speed: 0.88,
      acceleration: 0.85,
      braking: 0.78,
      handling: 0.90,
      imageUrl: 'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?q=80&w=600',
      description: 'Um ícone retro-futurista dos anos 80 reinventado para as ruas modernas de Vice City.',
    ),
    VehicleModel(
      id: 'v3',
      name: 'Vapid Dominator GTX',
      category: 'Muscle',
      price: 920000,
      location: 'Little Haiti Garage',
      speed: 0.82,
      acceleration: 0.88,
      braking: 0.70,
      handling: 0.75,
      imageUrl: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=600',
      description: 'Muscle car puro com ronco de motor V8 estrondoso e aceleração brutal em linha reta.',
    ),
    VehicleModel(
      id: 'v4',
      name: 'Karin Rebel Offroad 4x4',
      category: 'Off-Road',
      price: 650000,
      location: 'Grasmere Swamps',
      speed: 0.70,
      acceleration: 0.75,
      braking: 0.75,
      handling: 0.80,
      imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=600',
      description: 'Preparado para enfrentar o barro denso dos pântanos de Leonard County com tração 4x4 reforçada.',
    ),
    VehicleModel(
      id: 'v5',
      name: 'Maverick Deluxe Helicopter',
      category: 'Helicopter',
      price: 3200000,
      location: 'Vice City International Helipad',
      speed: 0.85,
      acceleration: 0.80,
      braking: 0.80,
      handling: 0.85,
      imageUrl: 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?q=80&w=600',
      description: 'Helicóptero executivo com alcance total sobre Vice City e Keys.',
    ),
    VehicleModel(
      id: 'v6',
      name: 'Pegassi Speeder Speedboat',
      category: 'Boat',
      price: 1100000,
      location: 'Starfish Island Docks',
      speed: 0.90,
      acceleration: 0.85,
      braking: 0.70,
      handling: 0.82,
      imageUrl: 'https://images.unsplash.com/photo-1567899378494-47b22a2ae96a?q=80&w=600',
      description: 'Lancha de altíssima performance para fugas aquáticas e corridas costeiras.',
    ),
  ];

  @override
  Future<List<VehicleModel>> getVehicles({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var list = _mockVehicles;

    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((v) => v.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((v) => v.name.toLowerCase().contains(q) || v.description.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<VehicleModel?> getVehicleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockVehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
}
