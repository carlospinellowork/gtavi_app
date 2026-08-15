import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GTA VI',
                          style: AppTypography.displayMedium.copyWith(
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'COMPANION',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.bookmark_outline_rounded, color: AppColors.textPrimary),
                          onPressed: () => context.push('/favorites'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_outline_rounded, color: AppColors.textPrimary),
                          onPressed: () => context.push('/profile'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

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
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.textMuted),
                        const SizedBox(width: 12),
                        Text(
                          'O que você está procurando?',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text('Atalhos Rápidos', style: AppTypography.titleLarge),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    _buildShortcutCard(
                      context,
                      icon: Icons.map_rounded,
                      title: 'Mapa',
                      color: AppColors.locations,
                      onTap: () => context.go('/map'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.directions_car_rounded,
                      title: 'Veículos',
                      color: AppColors.vehicles,
                      onTap: () => context.go('/vehicles'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.flag_rounded,
                      title: 'Missões',
                      color: AppColors.missions,
                      onTap: () => context.go('/missions'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.place_rounded,
                      title: 'Locais',
                      color: AppColors.secondary,
                      onTap: () => context.go('/map'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.emoji_events_rounded,
                      title: 'Progresso',
                      color: AppColors.accent,
                      onTap: () => context.go('/progress'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.menu_book_rounded,
                      title: 'Guias',
                      color: AppColors.collectibles,
                      onTap: () => context.push('/guides'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Mais Procurados',
                onSeeAll: () => context.go('/vehicles'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 170,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    _buildPopularCard(
                      context,
                      id: 'v1',
                      title: 'Pegassi Ignus X',
                      subtitle: '\$2.450.000 • Super',
                      badge: 'População Alta',
                      badgeColor: AppColors.vehicles,
                      onTap: () => context.push('/vehicles/v1'),
                    ),
                    _buildPopularCard(
                      context,
                      id: 'v2',
                      title: 'Grotti Cheetah Classic',
                      subtitle: '\$1.850.000 • Sports',
                      badge: 'Ícone 80s',
                      badgeColor: AppColors.primary,
                      onTap: () => context.push('/vehicles/v2'),
                    ),
                    _buildPopularCard(
                      context,
                      id: 'v3',
                      title: 'Maverick Helicopter',
                      subtitle: '\$3.200.000 • Aéreo',
                      badge: 'Executivo',
                      badgeColor: AppColors.secondary,
                      onTap: () => context.push('/vehicles/v5'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Guias Populares',
                onSeeAll: () => context.push('/guides'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    _buildGuideTile(
                      context,
                      title: 'Como conseguir \$10.000.000 rapidamente',
                      category: 'Dinheiro',
                      time: '6 min',
                      onTap: () => context.push('/guides/g1'),
                    ),
                    const SizedBox(height: 10),
                    _buildGuideTile(
                      context,
                      title: 'Guia Completo para os 100% de Conclusão',
                      category: '100%',
                      time: '12 min',
                      onTap: () => context.push('/guides/g2'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.titleLarge),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'Ver todos',
              style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCard(
    BuildContext context, {
    required String id,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBadge(label: badge, color: badgeColor),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideTile(
    BuildContext context, {
    required String title,
    required String category,
    required String time,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    AppBadge(label: category, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Text('• $time de leitura', style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
