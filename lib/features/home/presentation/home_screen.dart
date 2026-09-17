import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/constants/gtavi_real_media.dart';
import '../../characters/domain/character_model.dart';
import '../../vehicles/domain/vehicle_model.dart';
import '../../guides/domain/guide_model.dart';
import '../../gallery/domain/media_item_model.dart';

final homeCharactersProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final repo = ref.watch(charactersRepositoryProvider);
  return await repo.getCharacters();
});

final homeVehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final repo = ref.watch(vehiclesRepositoryProvider);
  return await repo.getVehicles();
});

final homeGuidesProvider = FutureProvider<List<GuideModel>>((ref) async {
  final repo = ref.watch(guidesRepositoryProvider);
  return await repo.getGuides();
});

final homeGalleryProvider = FutureProvider<List<MediaItemModel>>((ref) async {
  final repo = ref.watch(galleryRepositoryProvider);
  return await repo.getMediaItems();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charsAsync = ref.watch(homeCharactersProvider);
    final vehsAsync = ref.watch(homeVehiclesProvider);
    final guidesAsync = ref.watch(homeGuidesProvider);
    final galleryAsync = ref.watch(homeGalleryProvider);

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
                          'CENTRAL HUB',
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

            // High-Impact GTA VI Banner Header
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
                          Positioned.fill(
                            child: AppNetworkImage(url: GtaViRealMedia.extendedLookThumbnail),
                          ),
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
                                        width: 6, height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'AGENTE IA ATIVO • VICE CITY',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'LUCIA & JASON',
                                  style: AppTypography.displayMedium.copyWith(
                                    color: Colors.white, fontSize: 22, height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Confira as últimas notícias, vazamentos e trailers de GTA VI',
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

            // Countdown para o lançamento oficial
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _buildCountdownCard(),
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
                          'O que você quer saber sobre GTA VI?',
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
                      icon: Icons.people_rounded,
                      title: 'Personagens',
                      color: AppColors.primary,
                      onTap: () => context.push('/characters'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.photo_library_rounded,
                      title: 'Galeria',
                      color: AppColors.secondary,
                      onTap: () => context.push('/gallery'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.place_rounded,
                      title: 'Locais',
                      color: AppColors.locations,
                      onTap: () => context.push('/locations'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.gps_fixed_rounded,
                      title: 'Arsenal',
                      color: AppColors.secondary,
                      onTap: () => context.push('/weapons'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.visibility_rounded,
                      title: 'Easter Eggs',
                      color: AppColors.accent,
                      onTap: () => context.push('/easter-eggs'),
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
                      icon: Icons.radio_rounded,
                      title: 'Rádio Vice',
                      color: AppColors.primary,
                      onTap: () => context.push('/radio'),
                    ),
                    _buildShortcutCard(
                      context,
                      icon: Icons.games_rounded,
                      title: 'Macetes',
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
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Mais Procurados (Veículos) Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Veículos em Destaque',
                onSeeAll: () => context.push('/vehicles'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 170,
                child: vehsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, st) => const SizedBox(),
                  data: (vehicles) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final v = vehicles[index];
                      return _buildPopularCard(
                        context,
                        id: v.id,
                        title: v.name,
                        subtitle: '\$${v.price.toStringAsFixed(0)} • ${v.category}',
                        badge: v.category,
                        badgeColor: AppColors.vehicles,
                        onTap: () => context.push('/vehicles/${v.id}'),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Personagens Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Personagens Principais',
                onSeeAll: () => context.push('/characters'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: charsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, st) => const SizedBox(),
                  data: (characters) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final c = characters[index];
                      return _buildCharacterCard(
                        context,
                        id: c.id,
                        name: c.name.toUpperCase(),
                        role: c.role,
                        imageUrl: c.imageUrl,
                        color: index.isEven ? AppColors.primary : AppColors.secondary,
                      );
                    },
                  ),
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
                child: guidesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, st) => const SizedBox(),
                  data: (guides) => Column(
                    children: guides.take(3).map((g) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildGuideTile(
                        context,
                        title: g.title,
                        category: g.category,
                        time: g.readTime,
                        onTap: () => context.push('/guides/${g.id}'),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Galeria Vice City Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Galeria de Vice City',
                onSeeAll: () => context.push('/gallery'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: galleryAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, st) => const SizedBox(),
                  data: (mediaItems) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: mediaItems.length,
                    itemBuilder: (context, index) {
                      final item = mediaItems[index];
                      return _buildGalleryCard(
                        item.imageUrl,
                        item.title,
                        onTap: () => context.push('/gallery'),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCard() {
    final daysLeft = GtaViRealMedia.releaseDate.difference(DateTime.now()).inDays;

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_available_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  daysLeft > 0 ? 'Faltam $daysLeft dias para o lançamento' : 'GTA VI já foi lançado!',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: 2),
                Text('19 de novembro de 2026 • PS5 e Xbox Series X|S', style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
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
            style: AppTypography.labelLarge.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    required String id,
    required String name,
    required String role,
    required String? imageUrl,
    required Color color,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      child: GlassCard(
        onTap: () => context.push('/characters/$id'),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Stack(
            children: [
              Positioned.fill(
                child: AppNetworkImage(url: imageUrl, placeholderIcon: Icons.person_rounded),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildGalleryCard(String? imageUrl, String label, {required VoidCallback onTap}) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Stack(
            children: [
              Positioned.fill(
                child: AppNetworkImage(url: imageUrl, placeholderIcon: Icons.image_rounded),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
