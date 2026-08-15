import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/stat_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_badge.dart';

final vehicleDetailProvider = FutureProvider.family<dynamic, String>((ref, id) async {
  final repo = ref.watch(vehiclesRepositoryProvider);
  return await repo.getVehicleById(id);
});

class VehicleDetailScreen extends ConsumerWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleDetailProvider(vehicleId));
    final favoritesAsync = ref.watch(favoritesStateProvider);
    final isFav = favoritesAsync.value?.contains(vehicleId) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalhes do Veículo'),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isFav ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: () {
              ref.read(favoritesStateProvider.notifier).toggleFavorite(vehicleId);
            },
          ),
        ],
      ),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('Veículo não encontrado.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Visual Banner Header
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.directions_car_filled_rounded, size: 80, color: AppColors.vehicles),
                        const SizedBox(height: 8),
                        Text(
                          vehicle.name,
                          style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Name & Price Header Card
                GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBadge(label: vehicle.category, color: AppColors.vehicles),
                          const SizedBox(height: 6),
                          Text(vehicle.name, style: AppTypography.displayMedium.copyWith(fontSize: 22)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Preço estimado', style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Text(
                            '\$${vehicle.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: AppTypography.titleLarge.copyWith(color: AppColors.accent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Vehicle Performance Meter Stats
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Desempenho & Estatísticas', style: AppTypography.titleLarge),
                      const SizedBox(height: AppSpacing.md),
                      StatBar(
                        label: 'Velocidade Máxima',
                        value: vehicle.speed,
                        barColor: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StatBar(
                        label: 'Aceleração',
                        value: vehicle.acceleration,
                        barColor: AppColors.secondary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StatBar(
                        label: 'Frenagem',
                        value: vehicle.braking,
                        barColor: AppColors.accent,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StatBar(
                        label: 'Manuseio / Curvas',
                        value: vehicle.handling,
                        barColor: AppColors.vehicles,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Description & Location Card
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Descrição do Veículo', style: AppTypography.titleMedium),
                      const SizedBox(height: 6),
                      Text(vehicle.description, style: AppTypography.bodyMedium),
                      const Divider(height: 24, color: AppColors.surfaceBorder),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Localização: ${vehicle.location}',
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Actions
                AppButton(
                  text: isFav ? 'Remover dos Favoritos' : 'Adicionar aos Favoritos',
                  icon: isFav ? Icons.bookmark_remove_rounded : Icons.bookmark_add_rounded,
                  variant: isFav ? AppButtonVariant.outline : AppButtonVariant.primary,
                  isFullWidth: true,
                  onPressed: () {
                    ref.read(favoritesStateProvider.notifier).toggleFavorite(vehicleId);
                  },
                ),

                const SizedBox(height: AppSpacing.sm),

                AppButton(
                  text: 'Ver Localização no Mapa',
                  icon: Icons.map_rounded,
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                  onPressed: () => context.go('/map'),
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
