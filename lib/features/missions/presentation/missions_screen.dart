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
import '../domain/mission_model.dart';

final missionCategoryFilterProvider = StateProvider<String>((ref) => 'Todas');
final missionSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredMissionsProvider = FutureProvider<List<MissionModel>>((ref) async {
  final repo = ref.watch(missionsRepositoryProvider);
  final cat = ref.watch(missionCategoryFilterProvider);
  final query = ref.watch(missionSearchQueryProvider);
  return await repo.getMissions(category: cat, query: query);
});

class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(filteredMissionsProvider);
    final selectedCategory = ref.watch(missionCategoryFilterProvider);
    final favoritesAsync = ref.watch(favoritesStateProvider);

    final categories = ['Todas', 'História', 'Golpes', 'Secundária', 'Desafios'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Missões & Heists', style: AppTypography.titleLarge),
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
              onChanged: (val) => ref.read(missionSearchQueryProvider.notifier).state = val,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome da missão...',
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
                      ref.read(missionCategoryFilterProvider.notifier).state = cat;
                    },
                    selectedColor: AppColors.missions,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: missionsAsync.when(
              loading: () => const AppLoadingState(message: 'Carregando missões de Vice City...'),
              error: (err, _) => AppEmptyState(
                title: 'Erro ao carregar',
                message: err.toString(),
                icon: Icons.error_outline_rounded,
              ),
              data: (missions) {
                if (missions.isEmpty) {
                  return const AppEmptyState(
                    title: 'Nenhuma missão encontrada',
                    message: 'Tente alterar os termos de busca.',
                    icon: Icons.flag_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: missions.length,
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    final isFav = favoritesAsync.value?.contains(mission.id) ?? false;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () => context.push('/missions/${mission.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    AppBadge(label: mission.category, color: AppColors.missions),
                                    const SizedBox(width: 8),
                                    AppBadge(label: mission.difficulty, color: AppColors.accent),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                    color: isFav ? AppColors.primary : AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    ref.read(favoritesStateProvider.notifier).toggleFavorite(mission.id);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(mission.title, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              mission.description,
                              style: AppTypography.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recompensa: \$${mission.rewardAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textMuted),
                              ],
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
