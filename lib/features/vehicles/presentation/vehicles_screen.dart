import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../domain/vehicle_model.dart';

final vehicleCategoryFilterProvider = StateProvider<String>((ref) => 'Todos');
final vehicleSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredVehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final repo = ref.watch(vehiclesRepositoryProvider);
  final cat = ref.watch(vehicleCategoryFilterProvider);
  final query = ref.watch(vehicleSearchQueryProvider);
  return await repo.getVehicles(category: cat, query: query);
});

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(filteredVehiclesProvider);
    final selectedCategory = ref.watch(vehicleCategoryFilterProvider);
    final favoritesAsync = ref.watch(favoritesStateProvider);

    final categories = ['Todos', 'Super', 'Sports', 'Muscle', 'Off-Road', 'Helicopter', 'Boat'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Catálogo de Veículos', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            onPressed: () => context.push('/favorites'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            child: TextField(
              onChanged: (val) => ref.read(vehicleSearchQueryProvider.notifier).state = val,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome, marca...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(vehicleCategoryFilterProvider.notifier).state = cat;
                    },
                    selectedColor: AppColors.vehicles,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: vehiclesAsync.when(
              loading: () => const AppLoadingState(message: 'Carregando veículos de Vice City...'),
              error: (err, _) => AppEmptyState(
                title: 'Erro ao carregar',
                message: err.toString(),
                icon: Icons.error_outline_rounded,
              ),
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return const AppEmptyState(
                    title: 'Nenhum veículo encontrado',
                    message: 'Tente alterar a busca ou a categoria.',
                    icon: Icons.no_photography_rounded,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    final isFav = favoritesAsync.value?.contains(vehicle.id) ?? false;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () => context.push('/vehicles/${vehicle.id}'),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: const Icon(Icons.directions_car_filled_rounded, size: 40, color: AppColors.vehicles),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppBadge(label: vehicle.category, color: AppColors.vehicles),
                                      IconButton(
                                        icon: Icon(
                                          isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                          color: isFav ? AppColors.primary : AppColors.textMuted,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          ref.read(favoritesStateProvider.notifier).toggleFavorite(vehicle.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(vehicle.name, style: AppTypography.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${vehicle.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
