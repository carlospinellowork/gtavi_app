import '../domain/weapon_model.dart';
import '../../../core/domain/content_metadata.dart';

abstract class WeaponsRepository {
  Future<List<WeaponModel>> getWeapons({String? category, String? query});
  Future<WeaponModel?> getWeaponById(String id);
}

class MockWeaponsRepository implements WeaponsRepository {
  final List<WeaponModel> _weapons = const [
    WeaponModel(id: 'w1', name: 'Pistol 9mm', category: 'Pistola',
      description: 'Pistola semiautomática padrão. Confiável e precisa a curta distância.',
      imageUrl: '', damage: 0.35, accuracy: 0.70, fireRate: 0.50, range: 0.40, price: 500,
      locationHint: 'Disponível em qualquer Ammu-Nation',
      meta: ContentMeta(status: ContentStatus.confirmed)),
    WeaponModel(id: 'w2', name: 'Combat Shotgun', category: 'Escopeta',
      description: 'Escopeta de combate com alto poder de parada a curta distância.',
      imageUrl: '', damage: 0.85, accuracy: 0.40, fireRate: 0.30, range: 0.25, price: 3500,
      meta: ContentMeta(status: ContentStatus.confirmed)),
    WeaponModel(id: 'w3', name: 'AR-15 Tactical', category: 'Rifle',
      description: 'Rifle de assalto tático com mira holográfica e supressor opcional.',
      imageUrl: '', damage: 0.60, accuracy: 0.80, fireRate: 0.75, range: 0.70, price: 12000,
      relatedMissionIds: ['m2'],
      meta: ContentMeta(status: ContentStatus.reported, source: 'GTA Forums')),
    WeaponModel(id: 'w4', name: 'Sniper Rifle .50 Cal', category: 'Sniper',
      description: 'Rifle de precisão calibre .50 com alcance extremo e poder devastador.',
      imageUrl: '', damage: 0.95, accuracy: 0.95, fireRate: 0.15, range: 0.98, price: 25000,
      meta: ContentMeta(status: ContentStatus.reported)),
    WeaponModel(id: 'w5', name: 'Machete Vice', category: 'Corpo a corpo',
      description: 'Facão estilo caribenho. Arma icônica de Vice City.',
      imageUrl: '', damage: 0.50, accuracy: 1.0, fireRate: 0.60, range: 0.10, price: 200,
      meta: ContentMeta(status: ContentStatus.confirmed, source: 'Trailer Oficial')),
    WeaponModel(id: 'w6', name: 'RPG-7', category: 'Explosivo',
      description: 'Lançador de foguetes antitanque. Devastador contra veículos.',
      imageUrl: '', damage: 1.0, accuracy: 0.50, fireRate: 0.10, range: 0.60, price: 50000,
      meta: ContentMeta(status: ContentStatus.rumor)),
  ];

  @override
  Future<List<WeaponModel>> getWeapons({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var list = _weapons;
    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((w) => w.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((w) => w.name.toLowerCase().contains(q) || w.description.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Future<WeaponModel?> getWeaponById(String id) async {
    try { return _weapons.firstWhere((w) => w.id == id); } catch (_) { return null; }
  }
}
