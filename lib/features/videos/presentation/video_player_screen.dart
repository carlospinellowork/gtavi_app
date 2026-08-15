import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../domain/video_model.dart';

final videoDetailProvider = FutureProvider.family<VideoModel?, String>((ref, id) async {
  final repo = ref.watch(videosRepositoryProvider);
  return await repo.getVideoById(id);
});

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  bool isExpandedFullscreen = false;

  void _toggleFullscreen() {
    setState(() {
      isExpandedFullscreen = !isExpandedFullscreen;
    });

    if (isExpandedFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(videoDetailProvider(widget.videoId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isExpandedFullscreen
          ? null
          : AppBar(
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

          Widget playerWidget = Container(
            width: double.infinity,
            height: isExpandedFullscreen ? MediaQuery.of(context).size.height : 230,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: isExpandedFullscreen ? BorderRadius.zero : BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(100),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Thumbnail Background
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/gtavi_lucia_jason.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceLight),
                  ),
                ),
                // Dark Gradient
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(140),
                  ),
                ),
                // Play Icon & Video Title Overlay
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 42),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        video.title,
                        style: AppTypography.titleMedium.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                // Expand / Fullscreen Toggle Button
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.black.withAlpha(160)),
                    icon: Icon(
                      isExpandedFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: _toggleFullscreen,
                  ),
                ),
              ],
            ),
          );

          if (isExpandedFullscreen) {
            return playerWidget;
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: playerWidget,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppBadge(label: video.category, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('Duração: ${video.duration}', style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(video.title, style: AppTypography.titleLarge),
                      const SizedBox(height: AppSpacing.md),

                      // Channel Card (Flow Games, BRKsEDU, etc.)
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
                                  Row(
                                    children: [
                                      Text(video.channelName, style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 16),
                                    ],
                                  ),
                                  Text('Canal Oficial de Cobertura GTA VI', style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {},
                              child: const Text('Inscrever', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      Text('Vídeos Relacionados do GTA VI', style: AppTypography.titleLarge),
                      const SizedBox(height: AppSpacing.sm),

                      _buildRelatedTile(
                        context,
                        title: 'TUDO SOBRE GTA VI! Análise do Trailer e Gráficos',
                        channel: 'Flow Games',
                        duration: '45:20',
                      ),
                      const SizedBox(height: 10),
                      _buildRelatedTile(
                        context,
                        title: '25 Segredos e Detalhes Escondidos em Vice City',
                        channel: 'IGN Brasil',
                        duration: '12:05',
                      ),
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

  Widget _buildRelatedTile(BuildContext context, {required String title, required String channel, required String duration}) {
    return GlassCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('$channel • $duration', style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
