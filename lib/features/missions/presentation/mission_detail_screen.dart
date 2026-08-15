import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_badge.dart';

final missionDetailProvider = FutureProvider.family<dynamic, String>((ref, id) async {
  final repo = ref.watch(missionsRepositoryProvider);
  return await repo.getMissionById(id);
});

class MissionDetailScreen extends ConsumerWidget {
  final String missionId;

  const MissionDetailScreen({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(missionDetailProvider(missionId));
    final favoritesAsync = ref.watch(favoritesStateProvider);
    final isFav = favoritesAsync.value?.contains(missionId) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalhes da Missão'),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isFav ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: () {
              ref.read(favoritesStateProvider.notifier).toggleFavorite(missionId);
            },
          ),
        ],
      ),
      body: missionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
        data: (mission) {
          if (mission == null) {
            return const Center(child: Text('Missão não encontrada.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  height: 180,
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
                        const Icon(Icons.flag_rounded, size: 70, color: AppColors.missions),
                        const SizedBox(height: 8),
                        Text(mission.title, style: AppTypography.titleLarge),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Main Info Card
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppBadge(label: mission.category, color: AppColors.missions),
                          const SizedBox(width: 8),
                          AppBadge(label: 'Dificuldade: ${mission.difficulty}', color: AppColors.accent),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(mission.title, style: AppTypography.displayMedium.copyWith(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(mission.description, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Rewards Card
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: AppColors.success, size: 22),
                          const SizedBox(width: 8),
                          Text('Recompensas & Bônus', style: AppTypography.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mission.rewardDescription,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Requirements Card
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.checklist_rounded, color: AppColors.secondary, size: 22),
                          const SizedBox(width: 8),
                          Text('Requisitos da Missão', style: AppTypography.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...mission.requirements.map<Widget>((req) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, color: AppColors.secondary, size: 16),
                              const SizedBox(width: 8),
                              Expanded(child: Text(req, style: AppTypography.bodyMedium)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Actions
                AppButton(
                  text: isFav ? 'Remover dos Favoritos' : 'Salvar nos Favoritos',
                  icon: isFav ? Icons.bookmark_remove_rounded : Icons.bookmark_add_rounded,
                  variant: isFav ? AppButtonVariant.outline : AppButtonVariant.primary,
                  isFullWidth: true,
                  onPressed: () {
                    ref.read(favoritesStateProvider.notifier).toggleFavorite(missionId);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  text: 'Ver Local no Mapa',
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
