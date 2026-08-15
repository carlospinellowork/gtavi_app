import '../domain/guide_model.dart';

abstract class GuidesRepository {
  Future<List<GuideModel>> getGuides({String? category, String? query});
  Future<GuideModel?> getGuideById(String id);
}

class MockGuidesRepository implements GuidesRepository {
  final List<GuideModel> _mockGuides = const [
    GuideModel(
      id: 'g1',
      title: 'Como conseguir \$10.000.000 rapidamente no início do jogo',
      summary: 'Passo a passo definitivo para otimizar os investimentos imobiliários e negócios ilegais nas primeiras 10 horas de Vice City.',
      category: 'Dinheiro',
      readTime: '6 min',
      author: 'VicePro',
      isPopular: true,
      steps: [
        'Compre a garagem de desmanche de Little Haiti assim que desbloquear \$50.000.',
        'Roube e entregue os 5 carros de luxo da lista prioritária no porto.',
        'Invista o lucro inicial nos cassinos de Keys Island antes da missão "Grande Heist".',
        'Venda as ações no pico da missão de mercado.',
      ],
    ),
    GuideModel(
      id: 'g2',
      title: 'Guia Completo para os 100% de Conclusão',
      summary: 'Checklist completo cobrindo todas as missões de história, secundárias, coletáveis, saltos e propriedades.',
      category: '100%',
      readTime: '12 min',
      author: 'GTA Master',
      isPopular: true,
      steps: [
        'Complete as 35 missões principais de história.',
        'Encontre os 50 pacotes escondidos em Vice City.',
        'Realize os 30 saltos únicos de dublê com motos leves.',
        'Vença todas as 10 corridas urbanas e 5 marinhas.',
      ],
    ),
    GuideModel(
      id: 'g3',
      title: 'Mapa Secreto dos Pacotes Escondidos',
      summary: 'Localização exata de todos os 50 pacotes escondidos sob a água e nos telhados de Vice City.',
      category: 'Colecionáveis',
      readTime: '8 min',
      author: 'MapHunter',
      isPopular: false,
      steps: [
        'Pacotes 1 a 15: Submersos ao redor do Píer de Ocean Drive.',
        'Pacotes 16 a 30: Telhados do distrito comercial de Downtown Vice City.',
        'Pacotes 31 a 50: Pântanos de Leonard e ruínas da usina abandonada.',
      ],
    ),
  ];

  @override
  Future<List<GuideModel>> getGuides({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    var list = _mockGuides;

    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((g) => g.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((g) => g.title.toLowerCase().contains(q) || g.summary.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<GuideModel?> getGuideById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockGuides.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
