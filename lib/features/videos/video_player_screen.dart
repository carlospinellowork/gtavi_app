import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../app/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/share_service.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/links.dart';
import '../content/content_models.dart';

/// Toca o vídeo do YouTube dentro do app. Alguns vídeos bloqueiam a reprodução
/// embutida; "Abrir no YouTube" sempre funciona como alternativa.
class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String youtubeId;

  const VideoPlayerScreen({super.key, required this.youtubeId});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late final YoutubePlayerController _controller =
      YoutubePlayerController.fromVideoId(
        videoId: widget.youtubeId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
          enableCaption: false,
        ),
      );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videos =
        ref.watch(contentProvider).valueOrNull?.videos ?? const <VideoItem>[];
    final video = videos
        .where((v) => v.youtubeId == widget.youtubeId)
        .firstOrNull;
    final url = 'https://www.youtube.com/watch?v=${widget.youtubeId}';
    final others = videos
        .where((v) => v.youtubeId != widget.youtubeId)
        .take(10)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Vídeo')),
      body: ListView(
        children: [
          YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
          Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (video != null) ...[
                  Text(video.title, style: AppTypography.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    video.date == null
                        ? video.channel
                        : '${video.channel} · ${formatDate(video.date!)}',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => openLink(context, url),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text('Abrir no YouTube'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filledTonal(
                      tooltip: 'Compartilhar',
                      onPressed: () => shareText(
                        '${video?.title ?? 'Vídeo'}\n$url\n\nvia ${AppConstants.appName}',
                      ),
                      icon: const Icon(Icons.share_rounded),
                    ),
                  ],
                ),
                if (others.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Mais vídeos', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  for (final v in others) _OtherVideoTile(video: v),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherVideoTile extends StatelessWidget {
  final VideoItem video;

  const _OtherVideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushReplacement('/video/${video.youtubeId}'),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Image.network(
                video.thumbnailUrl,
                width: 128,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 128,
                  height: 72,
                  color: AppColors.surfaceLight,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(video.channel, style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
