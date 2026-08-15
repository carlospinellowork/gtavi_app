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
import '../domain/guide_model.dart';

final guideCategoryFilterProvider = StateProvider<String>((ref) => 'Todos');
final guideSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredGuidesProvider = FutureProvider<List<GuideModel>>((ref) async {
  final repo = ref.watch(guidesRepositoryProvider);
  final cat = ref.watch(guideCategoryFilterProvider);
  final query = ref.watch(guideSearchQueryProvider);
  return await repo.getGuides(category: cat, query: query);
});

class GuidesScreen extends ConsumerWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(filteredGuidesProvider);
    final selectedCategory = ref.watch(guideCategoryFilterProvider);

    final categories = ['Todos', 'Dinheiro', '100%', 'Colecionáveis', 'Iniciantes'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Guias & Estratégias', style: AppTypography.titleLarge),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            child: TextField(
              onChanged: (val) => ref.read(guideSearchQueryProvider.notifier).state = val,
              decoration: const InputDecoration(
                hintText: 'Buscar guias e dicas...',
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
                      ref.read(guideCategoryFilterProvider.notifier).state = cat;
                    },
                    selectedColor: AppColors.accent,
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
            child: guidesAsync.when(
              loading: () => const AppLoadingState(message: 'Carregando guias de Vice City...'),
              error: (err, _) => AppEmptyState(
                title: 'Erro ao carregar',
                message: err.toString(),
                icon: Icons.error_outline_rounded,
              ),
              data: (guides) {
                if (guides.isEmpty) {
                  return const AppEmptyState(
                    title: 'Nenhum guia encontrado',
                    message: 'Tente alterar os termos de busca.',
                    icon: Icons.menu_book_rounded,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: guides.length,
                  itemBuilder: (context, index) {
                    final guide = guides[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () => context.push('/guides/${guide.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppBadge(label: guide.category, color: AppColors.accent),
                                Text('Leitura ${guide.readTime}', style: AppTypography.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(guide.title, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Text(guide.summary, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
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
