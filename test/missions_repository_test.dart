import 'package:flutter_test/flutter_test.dart';
import 'package:gtavi_app/features/missions/data/missions_repository.dart';

void main() {
  group('MockMissionsRepository', () {
    late MockMissionsRepository repository;

    setUp(() {
      repository = MockMissionsRepository();
    });

    test('retorna a lista completa de missões', () async {
      final missions = await repository.getMissions();
      expect(missions.length, equals(4));
    });

    test('filtra missões por categoria Golpe', () async {
      final missions = await repository.getMissions(category: 'Golpes');
      expect(missions.length, equals(1));
      expect(missions.first.title, contains('Cassino'));
    });

    test('retorna missão por id', () async {
      final mission = await repository.getMissionById('m1');
      expect(mission, isNotNull);
      expect(mission?.title, equals('Boas-Vindas a Vice City'));
    });
  });
}
