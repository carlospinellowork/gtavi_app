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
import '../domain/video_model.dart';

final videoCategoryFilterProvider = StateProvider<String>((ref) => 'Todos');
final videoSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredVideosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final repo = ref.watch(videosRepositoryProvider);
  final cat = ref.watch(videoCategoryFilterProvider);
  final query = ref.watch(videoSearchQueryProvider);
  return await repo.getVideos(category: cat, query: query);
});

String _formatViews(int views) {
  if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
  if (views >= 1000) return '${(views / 1000).toStringAsFixed(0)}K';
  return views.toString();
}

class VideosHubScreen extends ConsumerWidget {
  const VideosHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(filteredVideosProvider);
    final selectedCategory = ref.watch(videoCategoryFilterProvider);

    final categories = ['Todos', 'Flow Games', 'Trailers', 'Análises'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Vídeos & Trailers GTA VI', style: AppTypography.titleLarge),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            child: TextField(
              onChanged: (val) => ref.read(videoSearchQueryProvider.notifier).state = val,
              decoration: const InputDecoration(
                hintText: 'Buscar vídeos do Flow Games, trailers...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
              ),
            ),
          ),
          SizedBox(
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
                      ref.read(videoCategoryFilterProvider.notifier).state = cat;
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
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: videosAsync.when(
              loading: () => const AppLoadingState(message: 'Carregando vídeos e análises...'),
              error: (err, _) => AppEmptyState(
                title: 'Erro ao carregar vídeos',
                message: err.toString(),
                icon: Icons.error_outline_rounded,
              ),
              data: (videos) {
                if (videos.isEmpty) {
                  return const AppEmptyState(
                    title: 'Nenhum vídeo encontrado',
                    message: 'Tente alterar a busca ou filtro.',
                    icon: Icons.video_library_rounded,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GlassCard(
                        onTap: () => context.push('/videos/${video.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    child: video.localThumbnailAsset != null
                                        ? Image.asset(
                                            video.localThumbnailAsset!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => Container(color: AppColors.surfaceLight),
                                          )
                                        : Image.asset(
                                            'assets/images/gtavi_lucia_jason.png',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => Container(color: AppColors.surfaceLight),
                                          ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                      color: Colors.black.withAlpha(80),
                                    ),
                                  ),
                                ),
                                const Positioned.fill(
                                  child: Center(
                                    child: Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 56),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(200),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      video.duration,
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: AppBadge(label: video.category, color: AppColors.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(video.title, style: AppTypography.titleMedium),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.primary,
                                  child: Text(video.channelName.substring(0, 1), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Text(video.channelName, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 14),
                                const Spacer(),
                                Text(
                                  '${_formatViews(video.viewsCount)} views',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                                ),
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
