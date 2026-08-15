import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../domain/news_model.dart';

final newsCategoryFilterProvider = StateProvider<String>((ref) => 'Todas');
final newsSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredNewsProvider = FutureProvider<List<NewsModel>>((ref) async {
  final repo = ref.watch(newsRepositoryProvider);
  final cat = ref.watch(newsCategoryFilterProvider);
  final query = ref.watch(newsSearchQueryProvider);
  return await repo.getNews(category: cat, query: query);
});

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(filteredNewsProvider);
    final selectedCategory = ref.watch(newsCategoryFilterProvider);

    final categories = ['Todas', 'Trailer', 'Destaque', 'Vazamento', 'Tecnologia'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text('Notícias & Trailers', style: AppTypography.titleLarge),
                  ],
                ),
              ),
            ),

            // Striking GTA VI Neon Vice Hero Header (Lucia & Jason Vibe)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF7928CA), AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(120),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.sports_esports_rounded,
                          size: 180,
                          color: Colors.white.withAlpha(25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(120),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'LUCIA & JASON • VICE CITY',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'GTA VI CENTRAL',
                              style: AppTypography.displayLarge.copyWith(
                                color: Colors.white,
                                fontSize: 26,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Feed Oficial de Anúncios, Trailers e Rumores',
                              style: AppTypography.bodySmall.copyWith(color: Colors.white.withAlpha(220)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: TextField(
                  onChanged: (val) => ref.read(newsSearchQueryProvider.notifier).state = val,
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar notícias, trailers...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

            // Category Chips Horizontal Bar
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
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
                          ref.read(newsCategoryFilterProvider.notifier).state = cat;
                        },
                        selectedColor: AppColors.primary,
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
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // News Feed List
            newsAsync.when(
              loading: () => const SliverFillRemaining(
                child: AppLoadingState(message: 'Buscando atualizações de Vice City...'),
              ),
              error: (err, _) => SliverFillRemaining(
                child: AppEmptyState(
                  title: 'Erro ao carregar feed',
                  message: err.toString(),
                  icon: Icons.newspaper_rounded,
                ),
              ),
              data: (newsList) {
                if (newsList.isEmpty) {
                  return const SliverFillRemaining(
                    child: AppEmptyState(
                      title: 'Nenhuma notícia encontrada',
                      message: 'Tente alterar a busca ou filtro.',
                      icon: Icons.newspaper_rounded,
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final news = newsList[index];
                        final isTrailer = news.category == 'Trailer' || news.videoUrl != null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: GlassCard(
                            onTap: () => _showNewsDetailsModal(context, news),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary.withAlpha(40),
                                            AppColors.secondary.withAlpha(40),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          isTrailer ? Icons.play_circle_fill_rounded : Icons.article_rounded,
                                          size: 56,
                                          color: isTrailer ? AppColors.primary : AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: AppBadge(
                                        label: news.category,
                                        color: isTrailer ? AppColors.primary : AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  news.title,
                                  style: AppTypography.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  news.summary,
                                  style: AppTypography.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Fonte: ${news.source}',
                                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          isTrailer ? 'Assistir' : 'Ler mais',
                                          style: AppTypography.labelLarge.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: newsList.length,
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  void _showNewsDetailsModal(BuildContext context, NewsModel news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final isTrailer = news.videoUrl != null;

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBadge(
                    label: news.category,
                    color: isTrailer ? AppColors.primary : AppColors.secondary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(news.title, style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text('Fonte: ${news.source}', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: AppSpacing.md),
              Text(news.summary, style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTrailer ? AppColors.primary : AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Abrindo ${isTrailer ? "Trailer" : "Notícia"}: ${news.url}'),
                      ),
                    );
                  },
                  icon: Icon(isTrailer ? Icons.play_arrow_rounded : Icons.open_in_new_rounded, color: Colors.white),
                  label: Text(
                    isTrailer ? 'Assistir Trailer no YouTube' : 'Ler Matéria Completa',
                    style: AppTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }
}
