import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/constants/gtavi_real_media.dart';

final mapCategoryFilterProvider = StateProvider<String>((ref) => 'Todos');
final mapSearchQueryProvider = StateProvider<String>((ref) => '');
final isSatelliteMapModeProvider = StateProvider<bool>((ref) => true);

class MapPoint {
  final String id;
  final String title;
  final String category;
  final Offset position; // 0.0 to 1.0
  final String description;
  final Color color;
  final String locationDistrict;

  const MapPoint({
    required this.id,
    required this.title,
    required this.category,
    required this.position,
    required this.description,
    required this.color,
    required this.locationDistrict,
  });
}

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final TransformationController _transformationController = TransformationController();
  MapPoint? _selectedPoint;

  final List<MapPoint> _points = const [
    MapPoint(
      id: 'p1',
      title: 'Ocean Drive Beach Club',
      category: 'Locais',
      position: Offset(0.68, 0.48),
      description: 'Clube exclusivo em Vice Beach, local principal de festas e missões com Lucia.',
      color: AppColors.primary,
      locationDistrict: 'Vice Beach',
    ),
    MapPoint(
      id: 'p2',
      title: 'Star Island Mansion',
      category: 'Propriedades',
      position: Offset(0.58, 0.38),
      description: 'Mansão de alto padrão em Star Island com heliponto e cais para iates.',
      color: AppColors.gold,
      locationDistrict: 'Star Island',
    ),
    MapPoint(
      id: 'p3',
      title: 'Downtown Central Bank',
      category: 'Golpes',
      position: Offset(0.42, 0.32),
      description: 'Cofre central de Vice City. Alvo principal do maior Golpe da história.',
      color: AppColors.secondary,
      locationDistrict: 'Downtown',
    ),
    MapPoint(
      id: 'p4',
      title: 'Escobar International Airport',
      category: 'Atividades',
      position: Offset(0.28, 0.82),
      description: 'Aeroporto internacional com pistas para jatos executivos e aviões de carga.',
      color: AppColors.accent,
      locationDistrict: 'Escobar International',
    ),
    MapPoint(
      id: 'p5',
      title: 'Vice Beach Marina',
      category: 'Veículos',
      position: Offset(0.40, 0.65),
      description: 'Marina principal de barcos esportivos, iates de luxo e jet skis.',
      color: AppColors.secondary,
      locationDistrict: 'Vice Marina',
    ),
    MapPoint(
      id: 'p6',
      title: 'Pacote Secreto Colecionável #01',
      category: 'Colecionáveis',
      position: Offset(0.72, 0.58),
      description: 'Estátua tiki secreta escondida nas pedras de Ocean Beach.',
      color: AppColors.gold,
      locationDistrict: 'Ocean Beach',
    ),
  ];

  void _zoomIn() {
    _transformationController.value = _transformationController.value.scaled(1.4, 1.4);
  }

  void _zoomOut() {
    _transformationController.value = _transformationController.value.scaled(0.7, 0.7);
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(mapCategoryFilterProvider);
    final query = ref.watch(mapSearchQueryProvider);
    final isSatellite = ref.watch(isSatelliteMapModeProvider);

    final categories = ['Todos', 'Locais', 'Golpes', 'Propriedades', 'Veículos', 'Colecionáveis'];

    final filteredPoints = _points.where((p) {
      final matchesCategory = selectedCategory == 'Todos' || p.category == selectedCategory;
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.locationDistrict.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Smooth Fluid Interactive Map Layer
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.8,
              maxScale: 4.0,
              boundaryMargin: const EdgeInsets.all(250),
              child: Center(
                child: Container(
                  width: 700,
                  height: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withAlpha(100), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(60),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Map Image
                        AppNetworkImage(
                          url: GtaViRealMedia.viceCityAerial,
                          width: 700,
                          height: 700,
                          color: isSatellite ? null : AppColors.primary.withAlpha(50),
                          colorBlendMode: isSatellite ? null : BlendMode.color,
                        ),

                        // High Visibility Map Pins
                        ...filteredPoints.map((point) {
                          final isSelected = _selectedPoint?.id == point.id;

                          return Positioned(
                            left: point.position.dx * 700 - 18,
                            top: point.position.dy * 700 - 18,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPoint = point;
                                });
                                _showPointBottomSheet(context, point);
                              },
                              child: AnimatedScale(
                                scale: isSelected ? 1.3 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: point.color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: point.color.withAlpha(180),
                                        blurRadius: 12,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
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

            // Top Header & Search Control Bar
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: Column(
                children: [
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => ref.read(mapSearchQueryProvider.notifier).state = val,
                            decoration: const InputDecoration(
                              hintText: 'Buscar local, distrito ou ponto no mapa...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSatellite ? Icons.satellite_alt_rounded : Icons.map_rounded,
                            color: AppColors.secondary,
                          ),
                          onPressed: () {
                            ref.read(isSatelliteMapModeProvider.notifier).state = !isSatellite;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

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
                            backgroundColor: AppColors.surface.withAlpha(230),
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

            // Right Map Zoom Controls (+ / - / Reset)
            Positioned(
              right: AppSpacing.md,
              bottom: 100,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'btn_zoom_in',
                    backgroundColor: AppColors.surface,
                    child: const Icon(Icons.add_rounded, color: AppColors.primary),
                    onPressed: _zoomIn,
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'btn_zoom_out',
                    backgroundColor: AppColors.surface,
                    child: const Icon(Icons.remove_rounded, color: AppColors.primary),
                    onPressed: _zoomOut,
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'btn_zoom_reset',
                    backgroundColor: AppColors.surface,
                    child: const Icon(Icons.center_focus_strong_rounded, color: AppColors.secondary),
                    onPressed: _resetZoom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPointBottomSheet(BuildContext context, MapPoint point) {
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
                  AppBadge(label: point.category, color: point.color),
                  Text('Distrito: ${point.locationDistrict}', style: AppTypography.bodySmall),
                ],
              ),
              const SizedBox(height: 10),
              Text(point.title, style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text(point.description, style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: point.color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rota traçada para ${point.title}')),
                    );
                  },
                  icon: const Icon(Icons.navigation_rounded, color: Colors.white),
                  label: const Text('Traçar Rota no Mapa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
