import '../domain/mission_model.dart';

abstract class MissionsRepository {
  Future<List<MissionModel>> getMissions({String? category, String? query});
  Future<MissionModel?> getMissionById(String id);
}

class MockMissionsRepository implements MissionsRepository {
  final List<MissionModel> _mockMissions = const [
    MissionModel(
      id: 'm1',
      title: 'Boas-Vindas a Vice City',
      description: 'Primeiro grande assalto da dupla nas ruas iluminadas por neon de Vice City. Escape da polícia usando a rota rápida pelo píer.',
      category: 'História',
      difficulty: 'Médio',
      rewardAmount: 50000,
      rewardDescription: '\$50.000 + Desbloqueio do esconderijo de Ocean Drive',
      location: 'Vice Port Marina',
      requirements: ['Completar introdução do prólogo', 'Adquirir veículo de fuga'],
    ),
    MissionModel(
      id: 'm2',
      title: 'O Grande Heist do Cassino Key',
      description: 'Invada o cofre principal do Diamond Key Casino com disfarce de equipe de manutenção e escape pelo helicóptero de resgate.',
      category: 'Golpes',
      difficulty: 'Difícil',
      rewardAmount: 2500000,
      rewardDescription: '\$2.500.000 + Roupa Tática Exclusiva',
      location: 'Keys Island Resort',
      requirements: ['Comprar o galpão de planejamento', 'Recrutar 3 especialistas'],
    ),
    MissionModel(
      id: 'm3',
      title: 'Corrida Noturna em Ocean Drive',
      description: 'Vença os pilotos mais rápidos de Vice City em uma corrida de circuito de 5 voltas à beira-mar.',
      category: 'Desafios',
      difficulty: 'Fácil',
      rewardAmount: 35000,
      rewardDescription: '\$35.000 + Pintura Neon Neon Pink',
      location: 'Ocean Drive Promenade',
      requirements: ['Possuir um veículo categoria Sports ou Super'],
    ),
    MissionModel(
      id: 'm4',
      title: 'Contrabando no Pântano',
      description: 'Recupere a carga preciosa caindo de paraquedas no pântano de Leonard e evite a patrulha ambiental armada.',
      category: 'Secundária',
      difficulty: 'Médio',
      rewardAmount: 85000,
      rewardDescription: '\$85.000 + Armamento pesado modificado',
      location: 'Leonard County Swamps',
      requirements: ['Desbloquear veículo Off-Road'],
    ),
  ];

  @override
  Future<List<MissionModel>> getMissions({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var list = _mockMissions;

    if (category != null && category.isNotEmpty && category != 'Todas') {
      list = list.where((m) => m.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((m) => m.title.toLowerCase().contains(q) || m.description.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<MissionModel?> getMissionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockMissions.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
