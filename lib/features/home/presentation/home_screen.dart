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
            // Top App Bar
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
                            color: AppColors.secondary,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.newspaper_rounded, color: AppColors.primary),
                          onPressed: () => context.push('/news'),
                        ),
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

            // High-Impact GTA VI Lucia & Jason Vice Neon Banner Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: InkWell(
                  onTap: () => context.push('/news'),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(140),
                          blurRadius: 22,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      child: Stack(
                        children: [
                          // Background Character Art
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/gtavi_lucia_jason.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
                            ),
                          ),
                          // Vice Gradient Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withAlpha(220),
                                    Colors.transparent,
                                    AppColors.background.withAlpha(240),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                            ),
                          ),
                          // Banner Content
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'AGENTE IA ATIVO • VICE CITY',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'LUCIA & JASON',
                                  style: AppTypography.displayMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 22,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Confira as últimas notícias, vazamentos e trailers do GTA VI',
                                  style: AppTypography.bodySmall.copyWith(color: Colors.white.withAlpha(230)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Search Bar Trigger
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
                      border: Border.all(color: AppColors.primary.withAlpha(80)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Text(
                          'O que você está procurando em Vice City?',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Shortcuts Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text('Atalhos Rápidos', style: AppTypography.titleLarge),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

            // Shortcuts Grid
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
                      icon: Icons.radio_rounded,
                      title: 'Rádio Vice',
                      color: AppColors.primary,
                      onTap: () => context.push('/radio'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.games_rounded,
                      title: 'Macetes/Cheats',
                      color: AppColors.secondary,
                      onTap: () => context.push('/cheats'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.attach_money_rounded,
                      title: 'Economia',
                      color: AppColors.gold,
                      onTap: () => context.push('/economy'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.chat_bubble_rounded,
                      title: 'IA Lucia/Jason',
                      color: Colors.cyanAccent,
                      onTap: () => context.push('/ai-chat'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.play_circle_fill_rounded,
                      title: 'Vídeos & Flow',
                      color: AppColors.secondary,
                      onTap: () => context.push('/videos'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.explore_rounded,
                      title: 'Mapa HD',
                      color: AppColors.gold,
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
                      icon: Icons.emoji_events_rounded,
                      title: 'Progresso',
                      color: AppColors.accent,
                      onTap: () => context.go('/progress'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Mais Procurados Section
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

            // Guias Populares Section
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

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Personagens Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Personagens Principais',
                onSeeAll: () => context.push('/ai-chat'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    _buildCharacterCard(
                      context,
                      name: 'LUCIA',
                      role: 'Protagonista • Estrategista',
                      imageAsset: 'assets/images/lucia_portrait.png',
                      color: AppColors.primary,
                    ),
                    _buildCharacterCard(
                      context,
                      name: 'JASON',
                      role: 'Protagonista • Motorista de Fuga',
                      imageAsset: 'assets/images/jason_portrait.png',
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Galeria Vice City
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text('Galeria de Vice City', style: AppTypography.titleLarge),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    _buildGalleryCard('assets/images/vice_city_beach.png', 'Vice Beach'),
                    _buildGalleryCard('assets/images/vice_city_downtown.png', 'Downtown'),
                    _buildGalleryCard('assets/images/vice_city_cars.png', 'Supercarros'),
                    _buildGalleryCard('assets/images/splash_vice_city.png', 'Skyline'),
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
              color: color.withAlpha(40),
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
              color: AppColors.primary.withAlpha(40),
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
                    AppBadge(label: category, color: AppColors.gold),
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

  Widget _buildCharacterCard(
    BuildContext context, {
    required String name,
    required String role,
    required String imageAsset,
    required Color color,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      child: GlassCard(
        onTap: () => context.push('/ai-chat'),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.surfaceLight,
                    child: const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 48),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(220),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryCard(String imageAsset, String label) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.surfaceLight),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withAlpha(200), Colors.transparent],
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
