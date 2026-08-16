import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class _ExploreCategory {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _ExploreCategory(this.label, this.icon, this.color, this.route);
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const _categories = [
    _ExploreCategory('Personagens', Icons.people_rounded, AppColors.primary, '/characters'),
    _ExploreCategory('Veículos', Icons.directions_car_rounded, AppColors.vehicles, '/vehicles'),
    _ExploreCategory('Locais', Icons.place_rounded, AppColors.locations, '/locations'),
    _ExploreCategory('Missões', Icons.flag_rounded, AppColors.missions, '/missions'),
    _ExploreCategory('Armas', Icons.gps_fixed_rounded, AppColors.secondary, '/weapons'),
    _ExploreCategory('Easter Eggs', Icons.visibility_rounded, AppColors.accent, '/easter-eggs'),
    _ExploreCategory('Guias', Icons.menu_book_rounded, AppColors.gold, '/guides'),
    _ExploreCategory('Galeria', Icons.photo_library_rounded, AppColors.primary, '/gallery'),
    _ExploreCategory('Vídeos', Icons.play_circle_fill_rounded, AppColors.secondary, '/videos'),
    _ExploreCategory('Notícias', Icons.newspaper_rounded, AppColors.locations, '/news'),
    _ExploreCategory('Rádio Vice', Icons.radio_rounded, AppColors.primary, '/radio'),
    _ExploreCategory('Macetes', Icons.games_rounded, AppColors.secondary, '/cheats'),
    _ExploreCategory('Economia', Icons.attach_money_rounded, AppColors.gold, '/economy'),
    _ExploreCategory('Mapa', Icons.map_rounded, AppColors.collectibles, '/map'),
    _ExploreCategory('Progresso', Icons.emoji_events_rounded, AppColors.accent, '/progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explorar', style: AppTypography.displayMedium),
                    const SizedBox(height: 4),
                    Text('Tudo sobre GTA VI em um só lugar',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
            // Search trigger
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: InkWell(
                  onTap: () => context.push('/search'),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.primary.withAlpha(60)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Text('O que você quer saber sobre GTA VI?',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            // Category Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = _categories[index];
                    return GlassCard(
                      onTap: () {
                        if (cat.route == '/map' || cat.route == '/progress' || cat.route == '/vehicles' || cat.route == '/missions') {
                          context.go(cat.route);
                        } else {
                          context.push(cat.route);
                        }
                      },
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: cat.color.withAlpha(40), shape: BoxShape.circle),
                            child: Icon(cat.icon, size: 24, color: cat.color),
                          ),
                          const SizedBox(height: 8),
                          Text(cat.label, style: AppTypography.labelLarge.copyWith(fontSize: 11),
                              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    );
                  },
                  childCount: _categories.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}
