import '../domain/character_model.dart';
import '../../../core/domain/content_metadata.dart';

abstract class CharactersRepository {
  Future<List<CharacterModel>> getCharacters({String? query});
  Future<CharacterModel?> getCharacterById(String id);
}

class MockCharactersRepository implements CharactersRepository {
  final List<CharacterModel> _characters = const [
    CharacterModel(
      id: 'char_lucia', name: 'Lucia Caminos', nickname: 'Lu',
      role: 'Protagonista • Estrategista',
      description: 'Lucia é uma jovem latina criada em Leonida que se envolveu no submundo do crime de Vice City. '
          'Estrategista brilhante, ela planeja cada detalhe dos golpes com precisão cirúrgica. '
          'Especialista em hacking, persuasão e disfarces.',
      imageUrl: '', localImageAsset: 'assets/images/lucia_portrait.png',
      nationality: 'Americana-Latina', age: '28 anos',
      skills: ['Hacking', 'Persuasão', 'Disfarces', 'Planejamento', 'Direção defensiva'],
      relatedMissionIds: ['m1', 'm2', 'm3'], relatedLocationIds: ['loc_ocean_drive', 'loc_downtown'],
      relatedVideoIds: ['v_trailer1', 'v_guinas'], relatedGuideIds: ['g1'],
      meta: ContentMeta(status: ContentStatus.confirmed, source: 'Rockstar Games', sourceUrl: 'https://rockstargames.com/VI'),
    ),
    CharacterModel(
      id: 'char_jason', name: 'Jason Duval', nickname: 'Jay',
      role: 'Protagonista • Motorista de Fuga',
      description: 'Jason é um nativo da Flórida, criado em uma família desestruturada. '
          'Impulsivo e carismático, é o motorista de fuga e o homem de ação da dupla. '
          'Mestre em combate corpo a corpo, mecânica de veículos e pilotagem.',
      imageUrl: '', localImageAsset: 'assets/images/jason_portrait.png',
      nationality: 'Americano', age: '32 anos',
      skills: ['Combate corpo a corpo', 'Mecânica de veículos', 'Pilotagem', 'Armas de fogo', 'Intimidação'],
      relatedMissionIds: ['m1', 'm2', 'm4'], relatedLocationIds: ['loc_little_haiti', 'loc_everglades'],
      relatedVideoIds: ['v_trailer1', 'v_flow1'], relatedGuideIds: ['g2'],
      meta: ContentMeta(status: ContentStatus.confirmed, source: 'Rockstar Games'),
    ),
    CharacterModel(
      id: 'char_marco', name: 'Marco "El Tigre" Vasquez',
      role: 'Antagonista • Chefe do Cartel',
      description: 'Líder do cartel de drogas que controla os portos de Vice City. '
          'Elegante e brutal, Marco é o principal obstáculo de Lucia e Jason.',
      imageUrl: '', nationality: 'Colombiano', age: '45 anos',
      skills: ['Liderança', 'Negociação', 'Manipulação'],
      relatedMissionIds: ['m2', 'm5'], relatedLocationIds: ['loc_star_island'],
      meta: ContentMeta(status: ContentStatus.reported, source: 'GTA Forums'),
    ),
    CharacterModel(
      id: 'char_diana', name: 'Diana Chen',
      role: 'Aliada • Hacker & Informante',
      description: 'Gênio da tecnologia que fornece suporte técnico para os golpes da dupla. '
          'Opera de um apartamento secreto em Downtown Vice City.',
      imageUrl: '', nationality: 'Americana-Chinesa', age: '26 anos',
      skills: ['Hacking avançado', 'Vigilância', 'Criptografia'],
      relatedMissionIds: ['m2', 'm3'], relatedLocationIds: ['loc_downtown'],
      meta: ContentMeta(status: ContentStatus.rumor, source: 'Leaker desconhecido'),
    ),
  ];

  @override
  Future<List<CharacterModel>> getCharacters({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      return _characters.where((c) =>
          c.name.toLowerCase().contains(q) || c.role.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q)).toList();
    }
    return _characters;
  }

  @override
  Future<CharacterModel?> getCharacterById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try { return _characters.firstWhere((c) => c.id == id); } catch (_) { return null; }
  }
}
