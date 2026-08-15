import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool isPlaying = false;
  double progress = 0.0;
  Timer? _playbackTimer;
  int currentSeconds = 0;
  int totalSeconds = 91;

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

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _playbackTimer?.cancel();
      _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (currentSeconds < totalSeconds) {
            currentSeconds++;
            progress = currentSeconds / totalSeconds;
          } else {
            isPlaying = false;
            currentSeconds = 0;
            progress = 0.0;
            timer.cancel();
          }
        });
      });
    } else {
      _playbackTimer?.cancel();
    }
  }

  Future<void> _openExternalStream(String youtubeVideoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$youtubeVideoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o stream no YouTube.')),
        );
      }
    }
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
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
            child: ClipRRect(
              borderRadius: isExpandedFullscreen ? BorderRadius.zero : BorderRadius.circular(AppSpacing.radiusMd),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Thumbnail Background
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/gtavi_lucia_jason.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: AppColors.surfaceLight),
                    ),
                  ),
                  // Dark Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      color: isPlaying ? Colors.black.withAlpha(80) : Colors.black.withAlpha(160),
                    ),
                  ),
                  // Play / Stream Toggle Layer
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _togglePlayPause,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!isPlaying)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withAlpha(180),
                                        blurRadius: 20,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(180),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.primary.withAlpha(100)),
                                  ),
                                  child: const Text(
                                    'Toque para iniciar o stream',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          else
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                                    SizedBox(width: 6),
                                    Text(
                                      'REPRODUZINDO STREAM',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Controls overlay at the bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withAlpha(220), Colors.transparent],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.secondary,
                            ),
                            child: Slider(
                              value: progress.clamp(0.0, 1.0),
                              onChanged: (val) {
                                setState(() {
                                  progress = val;
                                  currentSeconds = (val * totalSeconds).round();
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: _togglePlayPause,
                              ),
                              Text(
                                '${_formatDuration(currentSeconds)} / ${_formatDuration(totalSeconds)}',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 20),
                                tooltip: 'Abrir no YouTube',
                                onPressed: () => _openExternalStream(video.youtubeVideoId),
                              ),
                              IconButton(
                                icon: Icon(
                                  isExpandedFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: _toggleFullscreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                      label: const Text('Abrir Stream no YouTube', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

