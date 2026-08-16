import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Seus Favoritos', style: AppTypography.titleLarge),
      ),
      body: favoritesAsync.when(
        loading: () => const AppLoadingState(message: 'Carregando itens salvos...'),
        error: (err, _) => AppEmptyState(
          title: 'Erro ao carregar',
          message: err.toString(),
          icon: Icons.error_outline_rounded,
        ),
        data: (favIds) {
          if (favIds.isEmpty) {
            return AppEmptyState(
              title: 'Sua lista de favoritos está vazia',
              message: 'Navegue pelo aplicativo para favoritar veículos, missões, personagens, armas e guias.',
              icon: Icons.bookmark_outline_rounded,
              actionText: 'Explorar GTA VI',
              onAction: () => context.go('/explore'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: favIds.length,
            itemBuilder: (context, index) {
              final id = favIds[index];

              String title = 'Item Favorito #$id';
              String category = 'Geral';
              Color catColor = AppColors.primary;
              IconData icon = Icons.bookmark_rounded;
              String routePath = '/explore';

              if (id.startsWith('char_')) {
                category = 'Personagem';
                catColor = AppColors.primary;
                icon = Icons.person_rounded;
                if (id == 'char_lucia') title = 'Lucia Caminos';
                if (id == 'char_jason') title = 'Jason Duval';
                if (id == 'char_marco') title = 'Marco "El Tigre"';
                routePath = '/characters/$id';
              } else if (id.startsWith('loc_')) {
                category = 'Local';
                catColor = AppColors.locations;
                icon = Icons.place_rounded;
                if (id == 'loc_ocean_drive') title = 'Ocean Drive';
                if (id == 'loc_downtown') title = 'Downtown Vice City';
                routePath = '/locations';
              } else if (id.startsWith('w')) {
                category = 'Arma';
                catColor = AppColors.secondary;
                icon = Icons.gps_fixed_rounded;
                if (id == 'w1') title = 'Pistol 9mm';
                if (id == 'w2') title = 'Combat Shotgun';
                routePath = '/weapons';
              } else if (id.startsWith('ee')) {
                category = 'Easter Egg';
                catColor = AppColors.accent;
                icon = Icons.visibility_rounded;
                routePath = '/easter-eggs';
              } else if (id.startsWith('v')) {
                category = 'Veículo';
                catColor = AppColors.vehicles;
                icon = Icons.directions_car_rounded;
                if (id == 'v1') title = 'Pegassi Ignus X';
                if (id == 'v2') title = 'Grotti Cheetah Classic';
                routePath = '/vehicles/$id';
              } else if (id.startsWith('m')) {
                category = 'Missão';
                catColor = AppColors.missions;
                icon = Icons.flag_rounded;
                if (id == 'm1') title = 'Boas-Vindas a Vice City';
                if (id == 'm2') title = 'O Grande Heist do Cassino Key';
                routePath = '/missions/$id';
              } else if (id.startsWith('g')) {
                category = 'Guia';
                catColor = AppColors.gold;
                icon = Icons.menu_book_rounded;
                if (id == 'g1') title = 'Como conseguir \$10.000.000 rapidamente';
                routePath = '/guides/$id';
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  onTap: () => context.push(routePath),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: catColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Icon(icon, color: catColor, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBadge(label: category, color: catColor),
                            const SizedBox(height: 4),
                            Text(title, style: AppTypography.titleMedium),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_remove_rounded, color: AppColors.error),
                        onPressed: () {
                          ref.read(favoritesStateProvider.notifier).toggleFavorite(id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
