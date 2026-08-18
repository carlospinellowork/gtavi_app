import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/domain/content_metadata.dart';
import '../domain/location_model.dart';

final locationsCategoryProvider = StateProvider<String>((ref) => 'Todos');

final filteredLocationsProvider = FutureProvider<List<LocationModel>>((ref) async {
  final repo = ref.watch(locationsRepositoryProvider);
  final cat = ref.watch(locationsCategoryProvider);
  return await repo.getLocations(category: cat);
});

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locsAsync = ref.watch(filteredLocationsProvider);
    final selectedCat = ref.watch(locationsCategoryProvider);
    final categories = ['Todos', 'Praia', 'Urbano', 'Rural', 'Residencial', 'Transporte'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Locais', style: AppTypography.titleLarge)),
      body: Column(children: [
        SizedBox(height: 42, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat == selectedCat;
            return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
              label: Text(cat), selected: isSelected,
              onSelected: (_) => ref.read(locationsCategoryProvider.notifier).state = cat,
              selectedColor: AppColors.locations, backgroundColor: AppColors.surface,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.bold),
            ));
          },
        )),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: locsAsync.when(
          loading: () => const AppLoadingState(message: 'Carregando locais...'),
          error: (e, _) => AppEmptyState(title: 'Erro', message: e.toString(), icon: Icons.error_outline_rounded),
          data: (locations) {
            if (locations.isEmpty) {
              return const AppEmptyState(title: 'Nenhum local', message: 'Altere o filtro.', icon: Icons.place_rounded);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final l = locations[index];
                return Padding(padding: const EdgeInsets.only(bottom: 14), child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.radiusLg),
                        topRight: Radius.circular(AppSpacing.radiusLg),
                      ),
                      child: SizedBox(height: 140, width: double.infinity,
                        child: AppNetworkImage(url: l.imageUrl, placeholderIcon: Icons.place_rounded)),
                    ),
                    Padding(padding: const EdgeInsets.all(14), child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          AppBadge(label: l.category, color: AppColors.locations),
                          const SizedBox(width: 8),
                          AppBadge(label: '${l.meta.status.emoji} ${l.meta.status.label}', color: _statusColor(l.meta.status)),
                        ]),
                        const SizedBox(height: 8),
                        Text(l.name, style: AppTypography.titleMedium),
                        const SizedBox(height: 4),
                        Text(l.district, style: AppTypography.bodySmall),
                        const SizedBox(height: 6),
                        Text(l.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    )),
                  ]),
                ));
              },
            );
          },
        )),
      ]),
    );
  }

  Color _statusColor(ContentStatus s) {
    switch (s) {
      case ContentStatus.confirmed: return AppColors.success;
      case ContentStatus.community: return AppColors.info;
      case ContentStatus.reported: return AppColors.warning;
      case ContentStatus.rumor: return AppColors.error;
    }
  }
}
