import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';

class MapMarkerData {
  final String id;
  final String title;
  final String category;
  final Offset position;
  final IconData icon;
  final Color color;

  const MapMarkerData({
    required this.id,
    required this.title,
    required this.category,
    required this.position,
    required this.icon,
    required this.color,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TransformationController _transformationController = TransformationController();
  String _selectedCategory = 'Todas';

  final List<String> _categories = const [
    'Todas',
    'Missões',
    'Veículos',
    'Lojas',
    'Armas',
    'Atividades',
    'Colecionáveis',
    'Locais Secretos',
  ];

  final List<MapMarkerData> _markers = const [
    MapMarkerData(
      id: 'm1',
      title: 'Boas-Vindas a Vice City',
      category: 'Missões',
      position: Offset(0.35, 0.45),
      icon: Icons.flag_rounded,
      color: AppColors.missions,
    ),
    MapMarkerData(
      id: 'v1',
      title: 'Showroom Pegassi',
      category: 'Veículos',
      position: Offset(0.60, 0.30),
      icon: Icons.directions_car_rounded,
      color: AppColors.vehicles,
    ),
    MapMarkerData(
      id: 'l1',
      title: 'Ammu-Nation Downtown',
      category: 'Armas',
      position: Offset(0.48, 0.52),
      icon: Icons.shield_rounded,
      color: AppColors.error,
    ),
    MapMarkerData(
      id: 'c1',
      title: 'Pacote Escondido #12',
      category: 'Colecionáveis',
      position: Offset(0.72, 0.65),
      icon: Icons.stars_rounded,
      color: AppColors.collectibles,
    ),
    MapMarkerData(
      id: 's1',
      title: 'Entrada da Caverna Submersa',
      category: 'Locais Secretos',
      position: Offset(0.20, 0.75),
      icon: Icons.visibility_off_rounded,
      color: AppColors.secondary,
    ),
  ];

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _showMarkerDetails(MapMarkerData marker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              const SizedBox(height: AppSpacing.sm),
              Text(marker.title, style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Marcador verificado no mapa de Vice City. Toque abaixo para abrir a página detalhada.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (marker.category == 'Veículos') {
                      context.push('/vehicles/v1');
                    } else if (marker.category == 'Missões') {
                      context.push('/missions/m1');
                    }
                  },
                  child: Text(
                    'Ver Detalhes do Ponto',
                    style: AppTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMarkers = _selectedCategory == 'Todas'
        ? _markers
        : _markers.where((m) => m.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.8,
                maxScale: 4.0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;

                    return Container(
                      width: width,
                      height: height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF020617)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: Size(width, height),
                            painter: MapGridPainter(),
                          ),
                          Positioned(
                            top: height * 0.2,
                            left: width * 0.1,
                            child: Container(
                              width: width * 0.8,
                              height: height * 0.6,
                              decoration: BoxDecoration(
                                color: AppColors.surface.withAlpha(180),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: AppColors.surfaceBorder, width: 2),
                              ),
                            ),
                          ),
                          ...filteredMarkers.map((marker) {
                            return Positioned(
                              left: marker.position.dx * width,
                              top: marker.position.dy * height,
                              child: GestureDetector(
                                onTap: () => _showMarkerDetails(marker),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: marker.color,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: marker.color.withAlpha(150),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(marker.icon, size: 18, color: Colors.white),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: Column(
                children: [
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mapa de Vice City', style: AppTypography.titleLarge),
                        Text(
                          '${filteredMarkers.length} pontos',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: AppSpacing.md,
              right: AppSpacing.md,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoom_reset',
                    onPressed: _resetZoom,
                    backgroundColor: AppColors.surface,
                    child: const Icon(Icons.center_focus_strong_rounded, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'my_location',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('GPS conectado a Vice City Downtown'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.my_location_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1F334155)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
