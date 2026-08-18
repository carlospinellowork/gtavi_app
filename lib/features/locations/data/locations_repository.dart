import '../domain/location_model.dart';
import '../../../core/domain/content_metadata.dart';
import '../../../core/constants/gtavi_real_media.dart';

abstract class LocationsRepository {
  Future<List<LocationModel>> getLocations({String? category, String? query});
  Future<LocationModel?> getLocationById(String id);
}

class MockLocationsRepository implements LocationsRepository {
  final List<LocationModel> _locations = const [
    LocationModel(
      id: 'loc_ocean_drive', name: 'Ocean Drive', district: 'Vice Beach',
      description: 'A icônica avenida à beira-mar com hotéis art deco, bares e clubs noturnos.',
      category: 'Praia', imageUrl: GtaViRealMedia.viceCityBeach,
      mapX: 0.68, mapY: 0.48, relatedMissionIds: ['m1'], relatedCharacterIds: ['char_lucia'],
      meta: ContentMeta(status: ContentStatus.confirmed, source: 'Trailer Oficial'),
    ),
    LocationModel(
      id: 'loc_downtown', name: 'Downtown Vice City', district: 'Downtown',
      description: 'Centro financeiro com arranha-céus, bancos e escritórios corporativos.',
      category: 'Urbano', imageUrl: GtaViRealMedia.viceCityAerial,
      mapX: 0.42, mapY: 0.32, relatedMissionIds: ['m2', 'm3'],
      relatedCharacterIds: ['char_lucia', 'char_diana'],
      meta: ContentMeta(status: ContentStatus.confirmed, source: 'Trailer Oficial'),
    ),
    LocationModel(
      id: 'loc_star_island', name: 'Star Island', district: 'Star Island',
      description: 'Ilha exclusiva com mansões de milionários, heliponto e cais para iates.',
      category: 'Residencial', imageUrl: '', mapX: 0.58, mapY: 0.38,
      relatedCharacterIds: ['char_marco'], relatedVehicleIds: ['v5'],
      meta: ContentMeta(status: ContentStatus.confirmed),
    ),
    LocationModel(
      id: 'loc_little_haiti', name: 'Little Haiti', district: 'Little Haiti',
      description: 'Bairro multicultural com garagens clandestinas e oficinas de customização.',
      category: 'Urbano', imageUrl: '', mapX: 0.35, mapY: 0.50,
      relatedVehicleIds: ['v3'], relatedCharacterIds: ['char_jason'],
      meta: ContentMeta(status: ContentStatus.confirmed),
    ),
    LocationModel(
      id: 'loc_everglades', name: 'Everglades / Leonard County', district: 'Leonard County',
      description: 'Pântanos extensos com jacarés, airboats e esconderijos remotos.',
      category: 'Rural', imageUrl: '', mapX: 0.20, mapY: 0.70,
      relatedVehicleIds: ['v4'], relatedCharacterIds: ['char_jason'],
      meta: ContentMeta(status: ContentStatus.confirmed, source: 'Trailer Oficial'),
    ),
    LocationModel(
      id: 'loc_airport', name: 'Escobar International Airport', district: 'Escobar',
      description: 'Aeroporto internacional com pistas para jatos e aviões de carga.',
      category: 'Transporte', imageUrl: '', mapX: 0.28, mapY: 0.82,
      meta: ContentMeta(status: ContentStatus.confirmed),
    ),
    LocationModel(
      id: 'loc_marina', name: 'Vice Beach Marina', district: 'Vice Marina',
      description: 'Marina principal com barcos esportivos, iates e jet skis.',
      category: 'Transporte', imageUrl: '', mapX: 0.40, mapY: 0.65,
      relatedVehicleIds: ['v6'],
      meta: ContentMeta(status: ContentStatus.confirmed),
    ),
  ];

  @override
  Future<List<LocationModel>> getLocations({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var list = _locations;
    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((l) => l.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((l) => l.name.toLowerCase().contains(q) || l.district.toLowerCase().contains(q) ||
          l.description.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Future<LocationModel?> getLocationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try { return _locations.firstWhere((l) => l.id == id); } catch (_) { return null; }
  }
}
