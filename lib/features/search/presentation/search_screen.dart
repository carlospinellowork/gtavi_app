import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/domain/entity_type.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../data/search_repository.dart';

final globalSearchQueryProvider = StateProvider<String>((ref) => '');

final globalSearchResultsProvider = FutureProvider<GroupedSearchResults>((ref) async {
  final query = ref.watch(globalSearchQueryProvider).trim();
  if (query.isEmpty) return const GroupedSearchResults({});
  final repo = ref.watch(searchRepositoryProvider);
  return await repo.search(query);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(globalSearchQueryProvider);
    final resultsAsync = ref.watch(globalSearchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: TextField(
          controller: _controller, autofocus: true,
          onChanged: (val) => ref.read(globalSearchQueryProvider.notifier).state = val,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'O que você quer saber sobre GTA VI?',
            border: InputBorder.none, enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none, fillColor: Colors.transparent,
          ),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () {
              _controller.clear();
              ref.read(globalSearchQueryProvider.notifier).state = '';
            }),
        ],
      ),
      body: query.isEmpty
          ? _buildSuggestions()
          : resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Erro: $e')),
              data: (grouped) {
                if (grouped.isEmpty) {
                  return AppEmptyState(
                    title: 'Nenhum resultado para "$query"',
                    message: 'Tente termos como "Lucia", "Pegassi", "armas", "mapa" ou "easter egg".',
                    icon: Icons.search_off_rounded,
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Text('${grouped.totalCount} resultados encontrados',
                        style: AppTypography.bodySmall),
                    const SizedBox(height: 12),
                    ...grouped.groups.entries.map((entry) {
                      final type = entry.key;
                      final items = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(children: [
                              Text(type.emoji, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(type.label.toUpperCase(),
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary, letterSpacing: 1.5)),
                            ]),
                          ),
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GlassCard(
                              onTap: () => context.push(item.routePath),
                              child: Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _typeColor(item.type).withAlpha(30),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  ),
                                  child: Icon(_typeIcon(item.type), color: _typeColor(item.type), size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: AppTypography.titleMedium),
                                    const SizedBox(height: 2),
                                    Text(item.subtitle, style: AppTypography.bodySmall),
                                  ],
                                )),
                                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                              ]),
                            ),
                          )),
                          const Divider(color: AppColors.surfaceBorder, height: 16),
                        ],
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSuggestions() {
    final suggestions = ['Lucia', 'Jason', 'carros', 'mapa', 'missões', 'armas', 'easter eggs', 'dinheiro', 'Vice City'];
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Sugestões', style: AppTypography.titleLarge),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: suggestions.map((s) => ActionChip(
          label: Text(s, style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.surfaceLight,
          side: BorderSide(color: AppColors.primary.withAlpha(60)),
          onPressed: () {
            _controller.text = s;
            ref.read(globalSearchQueryProvider.notifier).state = s;
          },
        )).toList()),
      ]),
    );
  }

  Color _typeColor(EntityType t) {
    switch (t) {
      case EntityType.character: return AppColors.primary;
      case EntityType.vehicle: return AppColors.vehicles;
      case EntityType.mission: return AppColors.missions;
      case EntityType.location: return AppColors.locations;
      case EntityType.weapon: return AppColors.secondary;
      case EntityType.guide: return AppColors.gold;
      case EntityType.easterEgg: return AppColors.accent;
      case EntityType.media: return AppColors.primary;
      default: return AppColors.textMuted;
    }
  }

  IconData _typeIcon(EntityType t) {
    switch (t) {
      case EntityType.character: return Icons.person_rounded;
      case EntityType.vehicle: return Icons.directions_car_rounded;
      case EntityType.mission: return Icons.flag_rounded;
      case EntityType.location: return Icons.place_rounded;
      case EntityType.weapon: return Icons.gps_fixed_rounded;
      case EntityType.guide: return Icons.menu_book_rounded;
      case EntityType.easterEgg: return Icons.visibility_rounded;
      case EntityType.media: return Icons.photo_library_rounded;
      default: return Icons.search_rounded;
    }
  }
}
