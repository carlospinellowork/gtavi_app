import 'package:flutter/material.dart';
import '../domain/cheat_model.dart';

abstract class CheatsRepository {
  Future<List<CheatModel>> getCheats({String? category, String? platform, String? query});
}

class MockCheatsRepository implements CheatsRepository {
  final List<CheatModel> _cheats = const [
    CheatModel(
      id: 'c_health',
      title: 'Vida e Colete Máximo',
      category: 'Jogador',
      description: 'Restaura a vida total e adiciona blindagem máxima ao personagem.',
      icon: Icons.favorite_rounded,
      ps5Code: ['O', 'L1', 'Δ', 'R2', 'X', '□', 'O', 'Direita', '□', 'L1', 'L1', 'L1'],
      xboxCode: ['B', 'LB', 'Y', 'RT', 'A', 'X', 'B', 'Direita', 'X', 'LB', 'LB', 'LB'],
      pcCode: 'TURTLE',
    ),
    CheatModel(
      id: 'c_wanted_down',
      title: 'Diminuir Nível de Procurado',
      category: 'Polícia',
      description: 'Remove uma estrela do nível de procurado pela polícia de Vice City.',
      icon: Icons.shield_rounded,
      ps5Code: ['R1', 'R1', 'O', 'R2', 'Direita', 'Esquerda', 'Direita', 'Esquerda', 'Direita', 'Esquerda'],
      xboxCode: ['RB', 'RB', 'B', 'RT', 'Direita', 'Esquerda', 'Direita', 'Esquerda', 'Direita', 'Esquerda'],
      pcCode: 'LAWYERUP',
    ),
    CheatModel(
      id: 'c_wanted_up',
      title: 'Aumentar Nível de Procurado',
      category: 'Polícia',
      description: 'Adiciona uma estrela de procurado para aumentar a adrenalina das perseguições.',
      icon: Icons.local_police_rounded,
      ps5Code: ['R1', 'R1', 'O', 'R2', 'Esquerda', 'Direita', 'Esquerda', 'Direita', 'Esquerda', 'Direita'],
      xboxCode: ['RB', 'RB', 'B', 'RT', 'Esquerda', 'Direita', 'Esquerda', 'Direita', 'Esquerda', 'Direita'],
      pcCode: 'FUGITIVE',
    ),
    CheatModel(
      id: 'c_weapons',
      title: 'Pacote de Armas Pesadas',
      category: 'Armas',
      description: 'Concede RPG, Fuzil de Precisão, Escopeta Automática e Granadas.',
      icon: Icons.sports_kabaddi_rounded,
      ps5Code: ['Δ', 'R2', 'Esquerda', 'L1', 'X', 'Direita', 'Δ', 'Baixo', '□', 'L1', 'L1', 'L1'],
      xboxCode: ['Y', 'RT', 'Esquerda', 'LB', 'A', 'Direita', 'Y', 'Baixo', 'X', 'LB', 'LB', 'LB'],
      pcCode: 'TOOLUP',
    ),
    CheatModel(
      id: 'c_comet',
      title: 'Gerar Carro Esportivo Pfister Comet',
      category: 'Veículos',
      description: 'Faz surgir instantaneamente um carro esportivo rápido ao seu lado.',
      icon: Icons.directions_car_rounded,
      ps5Code: ['R1', 'O', 'R2', 'Direita', 'L1', 'L2', 'X', 'X', '□', 'R1'],
      xboxCode: ['RB', 'B', 'RT', 'Direita', 'LB', 'LT', 'A', 'A', 'X', 'RB'],
      pcCode: 'COMET',
    ),
    CheatModel(
      id: 'c_buzzard',
      title: 'Gerar Helicóptero de Ataque Buzzard',
      category: 'Veículos',
      description: 'Invoca um helicóptero armado com metralhadoras e mísseis.',
      icon: Icons.airplanemode_active_rounded,
      ps5Code: ['O', 'O', 'L1', 'O', 'O', 'O', 'L1', 'L2', 'R1', 'Δ', 'O', 'Δ'],
      xboxCode: ['B', 'B', 'LB', 'B', 'B', 'B', 'LB', 'LT', 'RB', 'Y', 'B', 'Y'],
      pcCode: 'BUZZOFF',
    ),
    CheatModel(
      id: 'c_super_jump',
      title: 'Super Pulo Vice City',
      category: 'Habilidades',
      description: 'Permite saltar prédios e barreiras com força sobre-humana.',
      icon: Icons.height_rounded,
      ps5Code: ['Esquerda', 'Esquerda', 'Δ', 'Δ', 'Direita', 'Direita', 'Esquerda', 'Direita', '□', 'R1', 'R2'],
      xboxCode: ['Esquerda', 'Esquerda', 'Y', 'Y', 'Direita', 'Direita', 'Esquerda', 'Direita', 'X', 'RB', 'RT'],
      pcCode: 'HOPTOIT',
    ),
  ];

  @override
  Future<List<CheatModel>> getCheats({String? category, String? platform, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var list = _cheats;

    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((c) => c.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((c) => c.title.toLowerCase().contains(q) || c.description.toLowerCase().contains(q)).toList();
    }

    return list;
  }
}
