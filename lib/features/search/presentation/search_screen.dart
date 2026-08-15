import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../domain/search_result_model.dart';

final globalSearchQueryProvider = StateProvider<String>((ref) => '');

final globalSearchResultsProvider = Provider<List<SearchResultModel>>((ref) {
  final query = ref.watch(globalSearchQueryProvider).trim().toLowerCase();

  final allItems = const [
    SearchResultModel(
      id: 'v1',
      title: 'Pegassi Ignus X',
      subtitle: 'Veículo • Superesportivo V12',
      type: SearchResultType.vehicle,
      routePath: '/vehicles/v1',
    ),
    SearchResultModel(
      id: 'v2',
      title: 'Grotti Cheetah Classic',
      subtitle: 'Veículo • Esportivo Vintage',
      type: SearchResultType.vehicle,
      routePath: '/vehicles/v2',
    ),
    SearchResultModel(
      id: 'm1',
      title: 'Boas-Vindas a Vice City',
      subtitle: 'Missão • História Principal',
      type: SearchResultType.mission,
      routePath: '/missions/m1',
    ),
    SearchResultModel(
      id: 'm2',
      title: 'O Grande Heist do Cassino Key',
      subtitle: 'Missão • Golpe do Cassino',
      type: SearchResultType.mission,
      routePath: '/missions/m2',
    ),
    SearchResultModel(
      id: 'g1',
      title: 'Como conseguir \$10.000.000 rapidamente',
      subtitle: 'Guia • Dicas de Dinheiro',
      type: SearchResultType.guide,
      routePath: '/guides/g1',
    ),
    SearchResultModel(
      id: 'g2',
      title: 'Guia Completo para os 100% de Conclusão',
      subtitle: 'Guia • Checklist Geral',
      type: SearchResultType.guide,
      routePath: '/guides/g2',
    ),
  ];

  if (query.isEmpty) {
    return allItems;
  }

  return allItems
      .where((item) =>
          item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query))
      .toList();
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(globalSearchQueryProvider);
    final results = ref.watch(globalSearchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (val) => ref.read(globalSearchQueryProvider.notifier).state = val,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'Pesquisar veículos, missões, guias...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
          ),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () => ref.read(globalSearchQueryProvider.notifier).state = '',
            ),
        ],
      ),
      body: results.isEmpty
          ? AppEmptyState(
              title: 'Nenhum resultado para "$query"',
              message: 'Tente termos como "Pegassi", "Heist", "100%" ou "Dinheiro".',
              icon: Icons.search_off_rounded,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];

                Color badgeColor = AppColors.primary;
                IconData icon = Icons.search_rounded;

                switch (item.type) {
                  case SearchResultType.vehicle:
                    badgeColor = AppColors.vehicles;
                    icon = Icons.directions_car_rounded;
                    break;
                  case SearchResultType.mission:
                    badgeColor = AppColors.missions;
                    icon = Icons.flag_rounded;
                    break;
                  case SearchResultType.guide:
                    badgeColor = AppColors.accent;
                    icon = Icons.menu_book_rounded;
                    break;
                  case SearchResultType.location:
                    badgeColor = AppColors.locations;
                    icon = Icons.place_rounded;
                    break;
                  case SearchResultType.collectible:
                    badgeColor = AppColors.collectibles;
                    icon = Icons.stars_rounded;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    onTap: () => context.push(item.routePath),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: badgeColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(icon, color: badgeColor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: AppTypography.titleMedium),
                              const SizedBox(height: 2),
                              Text(item.subtitle, style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
