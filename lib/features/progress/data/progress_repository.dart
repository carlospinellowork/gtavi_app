import '../../../core/storage/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/progress_model.dart';

abstract class ProgressRepository {
  Future<ProgressModel> getProgress();
  Future<void> toggleItemCompletion(String itemId);
}

class MockProgressRepository implements ProgressRepository {
  final StorageService _storageService;

  MockProgressRepository(this._storageService);

  final List<ProgressCategoryItem> _initialItems = const [
    ProgressCategoryItem(id: 'prog_m1', name: 'Missão Principais de História (35/35)', category: 'Missões', isCompleted: true),
    ProgressCategoryItem(id: 'prog_m2', name: 'Missões Secundárias e Golpes (25/25)', category: 'Missões', isCompleted: true),
    ProgressCategoryItem(id: 'prog_m3', name: 'Eventos Aleatórios em Vice City (14/15)', category: 'Missões', isCompleted: false),
    ProgressCategoryItem(id: 'prog_c1', name: 'Pacotes Escondidos em Vice City (50/50)', category: 'Colecionáveis', isCompleted: true),
    ProgressCategoryItem(id: 'prog_c2', name: 'Saltos Únicos de Dublê (25/30)', category: 'Colecionáveis', isCompleted: false),
    ProgressCategoryItem(id: 'prog_c3', name: 'Letreiros Em neon Encontrados (18/20)', category: 'Colecionáveis', isCompleted: false),
    ProgressCategoryItem(id: 'prog_v1', name: 'Garagem com 20 Veículos Raros', category: 'Veículos', isCompleted: true),
    ProgressCategoryItem(id: 'prog_v2', name: 'Exportação de Barcos & Helicópteros', category: 'Veículos', isCompleted: true),
    ProgressCategoryItem(id: 'prog_e1', name: 'Segredo do Farol Abandonado de Key East', category: 'Easter Eggs', isCompleted: false),
    ProgressCategoryItem(id: 'prog_e2', name: 'UFO nos Pântanos às 03:00 AM', category: 'Easter Eggs', isCompleted: true),
  ];

  @override
  Future<ProgressModel> getProgress() async {
    final completedIds = _storageService.getStringList(AppConstants.keyCompletedItems);
    
    final activeCompleted = completedIds.isEmpty
        ? _initialItems.where((i) => i.isCompleted).map((i) => i.id).toSet()
        : completedIds.toSet();

    final updatedItems = _initialItems.map((item) {
      return item.copyWith(isCompleted: activeCompleted.contains(item.id));
    }).toList();

    final missionsTotal = updatedItems.where((i) => i.category == 'Missões').length;
    final missionsDone = updatedItems.where((i) => i.category == 'Missões' && i.isCompleted).length;
    
    final colTotal = updatedItems.where((i) => i.category == 'Colecionáveis').length;
    final colDone = updatedItems.where((i) => i.category == 'Colecionáveis' && i.isCompleted).length;

    final vehTotal = updatedItems.where((i) => i.category == 'Veículos').length;
    final vehDone = updatedItems.where((i) => i.category == 'Veículos' && i.isCompleted).length;

    final eeTotal = updatedItems.where((i) => i.category == 'Easter Eggs').length;
    final eeDone = updatedItems.where((i) => i.category == 'Easter Eggs' && i.isCompleted).length;

    final totalCount = updatedItems.length;
    final doneCount = updatedItems.where((i) => i.isCompleted).length;

    return ProgressModel(
      overallPercentage: doneCount / totalCount,
      missionsPercentage: missionsTotal > 0 ? missionsDone / missionsTotal : 0.0,
      collectiblesPercentage: colTotal > 0 ? colDone / colTotal : 0.0,
      vehiclesPercentage: vehTotal > 0 ? vehDone / vehTotal : 0.0,
      easterEggsPercentage: eeTotal > 0 ? eeDone / eeTotal : 0.0,
      items: updatedItems,
    );
  }

  @override
  Future<void> toggleItemCompletion(String itemId) async {
    final completed = _storageService.getStringList(AppConstants.keyCompletedItems).toSet();
    if (completed.contains(itemId)) {
      completed.remove(itemId);
    } else {
      completed.add(itemId);
    }
    await _storageService.setStringList(AppConstants.keyCompletedItems, completed.toList());
  }
}
