import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_network_image.dart';
import '../domain/video_model.dart';

final videoDetailProvider = FutureProvider.family<VideoModel?, String>((ref, id) async {
  final repo = ref.watch(videosRepositoryProvider);
  return await repo.getVideoById(id);
});

/// Toca o vídeo real do YouTube embutido no app. Se o embed falhar (algumas
/// poucas plataformas/vídeos bloqueiam reprodução embutida), "Abrir no
/// YouTube" abaixo do player sempre funciona como alternativa.
class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  String? _loadedYoutubeId;

  void _ensureController(String youtubeVideoId) {
    if (_loadedYoutubeId == youtubeVideoId && _controller != null) return;
    _controller?.close();
    _loadedYoutubeId = youtubeVideoId;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        enableCaption: false,
      ),
    );
  }

  Future<void> _openExternalStream(String youtubeVideoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$youtubeVideoId');
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir: $url')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(videoDetailProvider(widget.videoId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Player de Vídeo'),
        backgroundColor: AppColors.surface,
      ),
      body: videoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Erro ao carregar vídeo: $err')),
        data: (video) {
          if (video == null) {
            return const Center(child: Text('Vídeo não encontrado.'));
          }

          _ensureController(video.youtubeVideoId);
          final favoritesAsync = ref.watch(favoritesStateProvider);
          final isFav = favoritesAsync.value?.contains(video.id) ?? false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: YoutubePlayer(controller: _controller!),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Abrir no YouTube', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => _openExternalStream(video.youtubeVideoId),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppBadge(label: video.category, color: AppColors.primary),
                          if (video.duration.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text('Duração: ${video.duration}', style: AppTypography.bodySmall),
                          ],
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isFav ? AppColors.primary : AppColors.textMuted,
                            ),
                            onPressed: () {
                              ref.read(favoritesStateProvider.notifier).toggleFavorite(video.id);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(video.title, style: AppTypography.titleLarge),
                      const SizedBox(height: AppSpacing.md),

                      // Channel Card
                      GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(video.channelName.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(video.channelName, style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                                  Text('Canal do YouTube', style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () => _openExternalStream(video.youtubeVideoId),
                              child: const Text('Ver canal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      Text('Mais Vídeos sobre GTA VI', style: AppTypography.titleLarge),
                      const SizedBox(height: AppSpacing.sm),
                      _RelatedVideosList(currentVideoId: video.id),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final _relatedVideosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final repo = ref.watch(videosRepositoryProvider);
  return await repo.getVideos();
});

class _RelatedVideosList extends ConsumerWidget {
  final String currentVideoId;
  const _RelatedVideosList({required this.currentVideoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedAsync = ref.watch(_relatedVideosProvider);
    return relatedAsync.when(
      loading: () => const SizedBox(),
      error: (_, _) => const SizedBox(),
      data: (videos) {
        final related = videos.where((v) => v.id != currentVideoId).take(4).toList();
        return Column(
          children: related
              .map((v) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => context.pushReplacement('/videos/${v.id}'),
                      child: GlassCard(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AppNetworkImage(
                                url: v.thumbnailUrl,
                                width: 90,
                                height: 55,
                                placeholderIcon: Icons.smart_display_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v.title, style: AppTypography.titleMedium.copyWith(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(v.channelName, style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
