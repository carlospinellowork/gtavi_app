import '../../../core/domain/entity_type.dart';
import '../../characters/data/characters_repository.dart';
import '../../vehicles/data/vehicles_repository.dart';
import '../../missions/data/missions_repository.dart';
import '../../locations/data/locations_repository.dart';
import '../../weapons/data/weapons_repository.dart';
import '../../guides/data/guides_repository.dart';
import '../../easter_eggs/data/easter_eggs_repository.dart';
import '../../gallery/data/gallery_repository.dart';

/// Resultado unificado de busca global.
class GlobalSearchResult {
  final String id;
  final String title;
  final String subtitle;
  final EntityType type;
  final String routePath;
  final String? imageUrl;

  const GlobalSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.routePath,
    this.imageUrl,
  });
}

/// Resultados agrupados por tipo.
class GroupedSearchResults {
  final Map<EntityType, List<GlobalSearchResult>> groups;
  int get totalCount => groups.values.fold(0, (s, l) => s + l.length);
  bool get isEmpty => totalCount == 0;

  const GroupedSearchResults(this.groups);
}

/// Repository que agrega busca de todos os repositories.
class SearchRepository {
  final CharactersRepository _characters;
  final VehiclesRepository _vehicles;
  final MissionsRepository _missions;
  final LocationsRepository _locations;
  final WeaponsRepository _weapons;
  final GuidesRepository _guides;
  final EasterEggsRepository _easterEggs;
  final GalleryRepository _gallery;

  SearchRepository({
    required CharactersRepository characters,
    required VehiclesRepository vehicles,
    required MissionsRepository missions,
    required LocationsRepository locations,
    required WeaponsRepository weapons,
    required GuidesRepository guides,
    required EasterEggsRepository easterEggs,
    required GalleryRepository gallery,
  })  : _characters = characters,
        _vehicles = vehicles,
        _missions = missions,
        _locations = locations,
        _weapons = weapons,
        _guides = guides,
        _easterEggs = easterEggs,
        _gallery = gallery;

  Future<GroupedSearchResults> search(String query) async {
    if (query.trim().isEmpty) return const GroupedSearchResults({});

    final results = <EntityType, List<GlobalSearchResult>>{};

    // Buscar em paralelo
    final futures = await Future.wait([
      _characters.getCharacters(query: query),
      _vehicles.getVehicles(query: query),
      _missions.getMissions(query: query),
      _locations.getLocations(query: query),
      _weapons.getWeapons(query: query),
      _guides.getGuides(query: query),
      _easterEggs.getEasterEggs(query: query),
      _gallery.getMediaItems(query: query),
    ]);

    // Characters
    final chars = futures[0] as List;
    if (chars.isNotEmpty) {
      results[EntityType.character] = chars.map((c) => GlobalSearchResult(
        id: c.id, title: c.name, subtitle: c.role,
        type: EntityType.character, routePath: '/characters/${c.id}',
        imageUrl: c.imageUrl,
      )).toList();
    }

    // Vehicles
    final vehs = futures[1] as List;
    if (vehs.isNotEmpty) {
      results[EntityType.vehicle] = vehs.map((v) => GlobalSearchResult(
        id: v.id, title: v.name, subtitle: '${v.category} • \$${v.price.toStringAsFixed(0)}',
        type: EntityType.vehicle, routePath: '/vehicles/${v.id}',
      )).toList();
    }

    // Missions
    final missions = futures[2] as List;
    if (missions.isNotEmpty) {
      results[EntityType.mission] = missions.map((m) => GlobalSearchResult(
        id: m.id, title: m.title, subtitle: '${m.category} • ${m.difficulty}',
        type: EntityType.mission, routePath: '/missions/${m.id}',
      )).toList();
    }

    // Locations
    final locs = futures[3] as List;
    if (locs.isNotEmpty) {
      results[EntityType.location] = locs.map((l) => GlobalSearchResult(
        id: l.id, title: l.name, subtitle: '${l.district} • ${l.category}',
        type: EntityType.location, routePath: '/locations',
        imageUrl: l.imageUrl,
      )).toList();
    }

    // Weapons
    final weaps = futures[4] as List;
    if (weaps.isNotEmpty) {
      results[EntityType.weapon] = weaps.map((w) => GlobalSearchResult(
        id: w.id, title: w.name, subtitle: w.category,
        type: EntityType.weapon, routePath: '/weapons',
      )).toList();
    }

    // Guides
    final guides = futures[5] as List;
    if (guides.isNotEmpty) {
      results[EntityType.guide] = guides.map((g) => GlobalSearchResult(
        id: g.id, title: g.title, subtitle: '${g.category} • ${g.readTime}',
        type: EntityType.guide, routePath: '/guides/${g.id}',
      )).toList();
    }

    // Easter Eggs
    final eggs = futures[6] as List;
    if (eggs.isNotEmpty) {
      results[EntityType.easterEgg] = eggs.map((e) => GlobalSearchResult(
        id: e.id, title: e.title, subtitle: e.category,
        type: EntityType.easterEgg, routePath: '/easter-eggs',
      )).toList();
    }

    // Gallery
    final media = futures[7] as List;
    if (media.isNotEmpty) {
      results[EntityType.media] = media.map((m) => GlobalSearchResult(
        id: m.id, title: m.title, subtitle: m.category,
        type: EntityType.media, routePath: '/gallery',
        imageUrl: m.imageUrl,
      )).toList();
    }

    return GroupedSearchResults(results);
  }
}
