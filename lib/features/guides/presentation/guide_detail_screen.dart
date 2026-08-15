import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_badge.dart';

final guideDetailProvider = FutureProvider.family<dynamic, String>((ref, id) async {
  final repo = ref.watch(guidesRepositoryProvider);
  return await repo.getGuideById(id);
});

class GuideDetailScreen extends ConsumerWidget {
  final String guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAsync = ref.watch(guideDetailProvider(guideId));
    final favoritesAsync = ref.watch(favoritesStateProvider);
    final isFav = favoritesAsync.value?.contains(guideId) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guia de Estratégia'),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isFav ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: () {
              ref.read(favoritesStateProvider.notifier).toggleFavorite(guideId);
            },
          ),
        ],
      ),
      body: guideAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
        data: (guide) {
          if (guide == null) {
            return const Center(child: Text('Guia não encontrado.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBadge(label: guide.category, color: AppColors.accent),
                          Text('Autor: ${guide.author}', style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(guide.title, style: AppTypography.titleLarge),
                      const SizedBox(height: 8),
                      Text(guide.summary, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Passo a Passo Detalhado', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                ...List.generate(guide.steps.length, (index) {
                  final step = guide.steps[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(step, style: AppTypography.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: isFav ? 'Remover dos Favoritos' : 'Salvar Guia nos Favoritos',
                  icon: isFav ? Icons.bookmark_remove_rounded : Icons.bookmark_add_rounded,
                  variant: isFav ? AppButtonVariant.outline : AppButtonVariant.primary,
                  isFullWidth: true,
                  onPressed: () {
                    ref.read(favoritesStateProvider.notifier).toggleFavorite(guideId);
                  },
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
