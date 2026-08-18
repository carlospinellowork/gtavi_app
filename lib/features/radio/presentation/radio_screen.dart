import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/radio_station_model.dart';
import 'radio_player_controller.dart';

final radioStationsProvider = FutureProvider<List<RadioStationModel>>((ref) async {
  final repo = ref.watch(radioRepositoryProvider);
  return await repo.getStations();
});

final radioGenreFilterProvider = StateProvider<String>((ref) => 'Todas');

class RadioScreen extends ConsumerWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(radioStationsProvider);
    final player = ref.watch(radioPlayerProvider);
    final genreFilter = ref.watch(radioGenreFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rádio Vice City'),
        backgroundColor: AppColors.surface,
      ),
      body: stationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Erro ao carregar rádios: $err')),
        data: (stations) {
          if (stations.isEmpty) {
            return const Center(child: Text('Nenhuma rádio disponível.'));
          }

          final displayStation = player.currentStation ?? stations.first;
          final genres = ['Todas', ...{for (final s in stations) s.genre}];
          final filteredStations = genreFilter == 'Todas'
              ? stations
              : stations.where((s) => s.genre == genreFilter).toList();

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NowPlayingCard(
                      station: displayStation,
                      player: player,
                      onPlayPause: () => ref.read(radioPlayerProvider.notifier).playStation(displayStation),
                      onNext: () => ref.read(radioPlayerProvider.notifier).nextStation(stations),
                      onPrevious: () => ref.read(radioPlayerProvider.notifier).previousStation(stations),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length,
                        itemBuilder: (context, index) {
                          final genre = genres[index];
                          final isSelected = genre == genreFilter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(genre),
                              selected: isSelected,
                              onSelected: (_) => ref.read(radioGenreFilterProvider.notifier).state = genre,
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.surfaceLight,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estações de Vice City', style: AppTypography.titleLarge),
                        Text('${filteredStations.length} estações ao vivo', style: AppTypography.bodySmall),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...filteredStations.map((station) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _StationTile(
                            station: station,
                            isCurrent: player.currentStation?.id == station.id,
                            isPlaying: player.isPlaying && player.currentStation?.id == station.id,
                            onTap: () => ref.read(radioPlayerProvider.notifier).playStation(station),
                          ),
                        )),
                  ],
                ),
              ),
              if (player.currentStation != null)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 14,
                  child: _MiniPlayerBar(
                    station: player.currentStation!,
                    isPlaying: player.isPlaying,
                    isLoading: player.isLoading,
                    onTogglePlay: () => ref.read(radioPlayerProvider.notifier).togglePlayPause(),
                    onNext: () => ref.read(radioPlayerProvider.notifier).nextStation(stations),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _NowPlayingCard extends StatelessWidget {
  final RadioStationModel station;
  final RadioPlayerState player;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _NowPlayingCard({
    required this.station,
    required this.player,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = player.currentStation?.id == station.id;
    final isPlaying = isActive && player.isPlaying;

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          gradient: LinearGradient(
            colors: [...station.gradientColors, AppColors.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: station.gradientColors.first.withAlpha(140),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    station.frequency,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: isPlaying ? AppColors.success : AppColors.textMuted,
                          shape: BoxShape.circle,
                          boxShadow: isPlaying ? [BoxShadow(color: AppColors.success, blurRadius: 6)] : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPlaying ? 'NO AR · ÁUDIO REAL' : 'PAUSADO',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A0B30),
                border: Border.all(color: Colors.white.withAlpha(130), width: 3),
                boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, 8))],
              ),
              child: Center(
                child: Container(
                  width: 42, height: 42,
                  decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                  child: Icon(station.icon, color: station.gradientColors.first, size: 22),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              station.name,
              style: AppTypography.displayMedium.copyWith(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            Text(
              station.genre,
              style: TextStyle(color: Colors.white.withAlpha(210), fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  final height = isPlaying ? 10.0 + ((i * 37 + 13) % 24) : 6.0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 5,
                    height: height,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: Colors.black.withAlpha(140), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Text('TOCANDO AGORA · STREAM REAL', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(station.currentTrack, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                  Text('${station.artist} · via ${station.streamSourceName}', style: TextStyle(color: Colors.white.withAlpha(190), fontSize: 11), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 26,
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white),
                  onPressed: onPrevious,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60, height: 60,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: player.isLoading && isActive
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                        )
                      : IconButton(
                          iconSize: 30,
                          icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: AppColors.primary),
                          onPressed: onPlayPause,
                        ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  iconSize: 26,
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
                  onPressed: onNext,
                ),
              ],
            ),
            if (player.error != null && isActive) ...[
              const SizedBox(height: 8),
              Text(player.error!, style: const TextStyle(color: Colors.white, fontSize: 11), textAlign: TextAlign.center),
            ],
          ],
        ),
      );
  }
}

class _StationTile extends StatelessWidget {
  final RadioStationModel station;
  final bool isCurrent;
  final bool isPlaying;
  final VoidCallback onTap;

  const _StationTile({
    required this.station,
    required this.isCurrent,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GlassCard(
          onTap: onTap,
          borderColor: isCurrent ? station.gradientColors.first.withAlpha(130) : AppColors.surfaceBorder,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const SizedBox(width: 6),
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: station.gradientColors),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: station.gradientColors.first.withAlpha(90), blurRadius: 10)],
                ),
                child: Icon(station.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(station.name, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: station.gradientColors.first.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(station.frequency, style: TextStyle(color: station.gradientColors.first, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('${station.genre} · via ${station.streamSourceName}', style: AppTypography.bodySmall),
                  ],
                ),
              ),
              Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isCurrent ? station.gradientColors.first : AppColors.textMuted,
              ),
            ],
          ),
        ),
        if (isCurrent)
          Positioned(
            left: 0,
            top: 10,
            bottom: 10,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: station.gradientColors.first,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
              ),
            ),
          ),
      ],
    );
  }
}

class _MiniPlayerBar extends StatelessWidget {
  final RadioStationModel station;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTogglePlay;
  final VoidCallback onNext;

  const _MiniPlayerBar({
    required this.station,
    required this.isPlaying,
    required this.isLoading,
    required this.onTogglePlay,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(235),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(gradient: LinearGradient(colors: station.gradientColors), shape: BoxShape.circle),
            child: Icon(station.icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${station.name} · ${station.currentTrack}', style: AppTypography.titleMedium.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(station.artist, style: AppTypography.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
            )
          else
            IconButton(
              icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded, color: AppColors.textPrimary, size: 26),
              onPressed: onTogglePlay,
            ),
          IconButton(
            icon: const Icon(Icons.skip_next_rounded, color: AppColors.textMuted, size: 22),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
