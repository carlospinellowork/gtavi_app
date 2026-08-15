import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';

final mapCategoryFilterProvider = StateProvider<String>((ref) => 'Todos');
final is3dMapModeProvider = StateProvider<bool>((ref) => true);

class MapMarkerData {
  final String id;
  final String title;
  final String category;
  final Offset position; // 0.0 to 1.0 relative
  final String description;
  final Color color;

  const MapMarkerData({
    required this.id,
    required this.title,
    required this.category,
    required this.position,
    required this.description,
    required this.color,
  });
}

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  final List<MapMarkerData> _markers = const [
    MapMarkerData(
      id: 'm1',
      title: 'Ocean Drive Beach Club',
      category: 'Locais',
      position: Offset(0.68, 0.48),
      description: 'Clube icônico de Vice Beach em frente ao mar, ponto focal de festas e missões de Lucia.',
      color: AppColors.primary,
    ),
    MapMarkerData(
      id: 'm2',
      title: 'Star Island Mansion',
      category: 'Propriedades',
      position: Offset(0.58, 0.38),
      description: 'Mansão de luxo em Star Island com heliponto privado e iate ancorado.',
      color: AppColors.gold,
    ),
    MapMarkerData(
      id: 'm3',
      title: 'Downtown Skyscraper Heist',
      category: 'Golpes',
      position: Offset(0.42, 0.32),
      description: 'Edifício comercial de alta segurança para a missão de assalto ao cofre central.',
      color: AppColors.secondary,
    ),
    MapMarkerData(
      id: 'm4',
      title: 'Escobar International Airport',
      category: 'Atividades',
      position: Offset(0.28, 0.82),
      description: 'Aeroporto internacional com pistas para aviões de carga, jatos e helicópteros.',
      color: AppColors.accent,
    ),
    MapMarkerData(
      id: 'm5',
      title: 'Vice Beach Marina',
      category: 'Veículos',
      position: Offset(0.40, 0.65),
      description: 'Marina com lanchas de alta velocidade, jet skis e compras de iates.',
      color: AppColors.secondary,
    ),
    MapMarkerData(
      id: 'm6',
      title: 'Pacote Secreto Colecionável #01',
      category: 'Colecionáveis',
      position: Offset(0.72, 0.58),
      description: 'Estátua tiki dourada escondida nas rochas costeiras de Ocean Beach.',
      color: AppColors.gold,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(mapCategoryFilterProvider);
    final is3d = ref.watch(is3dMapModeProvider);

    final categories = ['Todos', 'Locais', 'Golpes', 'Propriedades', 'Veículos', 'Colecionáveis'];

    final filteredMarkers = selectedCategory == 'Todos'
        ? _markers
        : _markers.where((m) => m.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // 3D Interactive Map Canvas Layer
            InteractiveViewer(
              minScale: 0.8,
              maxScale: 3.5,
              boundaryMargin: const EdgeInsets.all(300),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  transform: is3d
                      ? (Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateX(0.48)
                        ..rotateZ(-0.08))
                      : Matrix4.identity(),
                  transformAlignment: Alignment.center,
                  child: Container(
                    width: 700,
                    height: 700,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(is3d ? 150 : 60),
                          blurRadius: is3d ? 40 : 15,
                          spreadRadius: is3d ? 10 : 2,
                        ),
                        BoxShadow(
                          color: AppColors.secondary.withAlpha(is3d ? 120 : 40),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          // 3D Map Image Texture
                          Image.asset(
                            'assets/images/gtavi_map_3d.png',
                            width: 700,
                            height: 700,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: AppColors.surface,
                                child: const Center(
                                  child: Icon(Icons.map_rounded, size: 80, color: AppColors.primary),
                                ),
                              );
                            },
                          ),

                          // Rotating Radar Sonar Overlay
                          AnimatedBuilder(
                            animation: _radarController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _radarController.value * 2 * math.pi,
                                alignment: Alignment.center,
                                child: Container(
                                  width: 700,
                                  height: 700,
                                  decoration: BoxDecoration(
                                    gradient: SweepGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.secondary.withAlpha(40),
                                        AppColors.primary.withAlpha(80),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.7, 0.95, 1.0],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Interactive Map Markers
                          ...filteredMarkers.map((marker) {
                            return Positioned(
                              left: marker.position.dx * 700 - 20,
                              top: marker.position.dy * 700 - 20,
                              child: GestureDetector(
                                onTap: () => _showMarkerDetails(context, marker),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: marker.color,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: marker.color.withAlpha(200),
                                            blurRadius: 14,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                          begin: const Offset(1.0, 1.0),
                                          end: const Offset(1.2, 1.2),
                                          duration: 1000.ms,
                                        ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(200),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: marker.color, width: 1),
                                      ),
                                      child: Text(
                                        marker.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top HUD Overlay Controls
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: Column(
                children: [
                  // HUD Title Bar
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.explore_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VICE CITY MAPA 3D',
                                  style: AppTypography.titleLarge.copyWith(fontSize: 16),
                                ),
                                Text(
                                  is3d ? 'Modo Tático Perspectiva 3D' : 'Modo Satélite 2D Plano',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.secondary),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Toggle 2D / 3D Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: is3d ? AppColors.primary : AppColors.surfaceLight,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            ref.read(is3dMapModeProvider.notifier).state = !is3d;
                          },
                          icon: Icon(
                            is3d ? Icons.view_in_ar_rounded : Icons.map_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            is3d ? '3D ATIVO' : 'VISÃO 2D',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Category Chips Bar
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
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
                              ref.read(mapCategoryFilterProvider.notifier).state = cat;
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface.withAlpha(220),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkerDetails(BuildContext context, MapMarkerData marker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBadge(label: marker.category, color: marker.color),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(marker.title, style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text(marker.description, style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: marker.color,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rota traçada para ${marker.title}')),
                        );
                      },
                      icon: const Icon(Icons.navigation_rounded, color: Colors.white),
                      label: const Text('Traçar Rota', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }
}
