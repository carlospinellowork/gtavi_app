import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/radio_station_model.dart';

final radioStationsProvider = FutureProvider<List<RadioStationModel>>((ref) async {
  final repo = ref.watch(radioRepositoryProvider);
  return await repo.getStations();
});

class RadioScreen extends ConsumerStatefulWidget {
  const RadioScreen({super.key});

  @override
  ConsumerState<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends ConsumerState<RadioScreen> {
  RadioStationModel? selectedStation;
  bool isPlaying = false;
  double volume = 0.8;
  Timer? _equalizerTimer;
  List<double> eqHeights = [0.4, 0.7, 0.9, 0.5, 0.8, 0.3, 0.6];

  @override
  void dispose() {
    _equalizerTimer?.cancel();
    super.dispose();
  }

  void _togglePlay(RadioStationModel station) {
    setState(() {
      if (selectedStation?.id == station.id) {
        isPlaying = !isPlaying;
      } else {
        selectedStation = station;
        isPlaying = true;
      }
    });

    if (isPlaying) {
      _equalizerTimer?.cancel();
      _equalizerTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
        if (!mounted) return;
        setState(() {
          eqHeights = List.generate(7, (index) => 0.2 + (0.8 * (index * 0.3 + DateTime.now().millisecondsSinceEpoch / 200) % 1.0));
        });
      });
    } else {
      _equalizerTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(radioStationsProvider);

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

          selectedStation ??= stations.first;
          final current = selectedStation!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio Main Player Neon Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    gradient: LinearGradient(
                      colors: current.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: current.gradientColors.first.withAlpha(140),
                        blurRadius: 20,
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
                              current.frequency,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          Icon(current.icon, color: Colors.white, size: 28),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        current.name,
                        style: AppTypography.displayMedium.copyWith(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        current.genre,
                        style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Animated Equalizer Bars
                      SizedBox(
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            eqHeights.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 6,
                              height: isPlaying ? 36 * eqHeights[index] : 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Current Track Info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(140),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('TOCANDO AGORA', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
                            const SizedBox(height: 4),
                            Text(
                              current.currentTrack,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              current.artist,
                              style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Play/Pause Big Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 56,
                            icon: Icon(
                              isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => _togglePlay(current),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                Text('Estações de Vice City', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.sm),

                // Station List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final st = stations[index];
                    final isSelected = st.id == current.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlassCard(
                        onTap: () => _togglePlay(st),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: st.gradientColors),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(st.icon, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(st.name, style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withAlpha(40),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(st.frequency, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${st.genre} • ${st.currentTrack}', style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            Icon(
                              (isSelected && isPlaying) ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: isSelected ? AppColors.primary : AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
