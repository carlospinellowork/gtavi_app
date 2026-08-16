import '../domain/easter_egg_model.dart';
import '../../../core/domain/content_metadata.dart';

abstract class EasterEggsRepository {
  Future<List<EasterEggModel>> getEasterEggs({String? query});
  Future<EasterEggModel?> getEasterEggById(String id);
}

class MockEasterEggsRepository implements EasterEggsRepository {
  final List<EasterEggModel> _eggs = const [
    EasterEggModel(id: 'ee1', title: 'O Farol Fantasma de Key East',
      description: 'Um farol abandonado que emite uma luz pulsante vermelha às 3:00 AM.',
      hint: 'Vá até Key East entre 02:50 e 03:10 do horário do jogo.',
      category: 'Sobrenatural', locationHint: 'Key East, costa leste',
      relatedLocationIds: ['loc_ocean_drive'],
      meta: ContentMeta(status: ContentStatus.community, source: 'Dataminers do GTA Forums')),
    EasterEggModel(id: 'ee2', title: 'UFO nos Pântanos',
      description: 'Um OVNI pode ser avistado sobrevoando os Everglades durante noites de lua cheia.',
      hint: 'Noite de lua cheia, olhe para o céu nos Everglades entre 01:00 e 02:00.',
      category: 'Sobrenatural', locationHint: 'Everglades, área central',
      relatedLocationIds: ['loc_everglades'],
      meta: ContentMeta(status: ContentStatus.community, source: 'Reddit r/GTA6')),
    EasterEggModel(id: 'ee3', title: 'Referência ao Vice City Original',
      description: 'Uma placa na Ocean Drive diz "Tommy Vercetti Way" — referência ao GTA Vice City de 2002.',
      hint: 'Procure na esquina entre Ocean Drive e Starfish Boulevard.',
      category: 'Referência',
      meta: ContentMeta(status: ContentStatus.reported, source: 'IGN')),
    EasterEggModel(id: 'ee4', title: 'Tubarão Megalodonte',
      description: 'Um tubarão gigante pode ser visto nas profundezas do oceano perto de Keys Vice.',
      hint: 'Mergulhe nas águas profundas ao sul de Keys Vice.',
      category: 'Criatura',
      meta: ContentMeta(status: ContentStatus.rumor)),
    EasterEggModel(id: 'ee5', title: 'CJ no Poster de "Wanted"',
      description: 'Um poster de "Procurado" em Little Haiti mostra um rosto que se parece com CJ do GTA San Andreas.',
      hint: 'Procure nos muros de Little Haiti.',
      category: 'Referência', relatedLocationIds: ['loc_little_haiti'],
      meta: ContentMeta(status: ContentStatus.rumor, source: 'Twitter leaker')),
  ];

  @override
  Future<List<EasterEggModel>> getEasterEggs({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      return _eggs.where((e) => e.title.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q)).toList();
    }
    return _eggs;
  }

  @override
  Future<EasterEggModel?> getEasterEggById(String id) async {
    try { return _eggs.firstWhere((e) => e.id == id); } catch (_) { return null; }
  }
}
