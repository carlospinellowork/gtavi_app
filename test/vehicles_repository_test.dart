import 'package:flutter_test/flutter_test.dart';
import 'package:gtavi_app/features/vehicles/data/vehicles_repository.dart';

void main() {
  group('MockVehiclesRepository', () {
    late MockVehiclesRepository repository;

    setUp(() {
      repository = MockVehiclesRepository();
    });

    test('retorna a lista completa de veículos quando nenhum filtro é passado', () async {
      final vehicles = await repository.getVehicles();
      expect(vehicles.length, equals(6));
    });

    test('filtra veículos por categoria Super', () async {
      final vehicles = await repository.getVehicles(category: 'Super');
      expect(vehicles.length, equals(1));
      expect(vehicles.first.name, equals('Pegassi Ignus X'));
    });

    test('filtra veículos por busca de texto', () async {
      final vehicles = await repository.getVehicles(query: 'Cheetah');
      expect(vehicles.length, equals(1));
      expect(vehicles.first.name, contains('Cheetah'));
    });

    test('retorna veículo específico por ID', () async {
      final vehicle = await repository.getVehicleById('v1');
      expect(vehicle, isNotNull);
      expect(vehicle?.id, equals('v1'));
      expect(vehicle?.name, equals('Pegassi Ignus X'));
    });
  });
}
