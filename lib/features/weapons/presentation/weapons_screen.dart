import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/stat_bar.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/domain/content_metadata.dart';
import '../domain/weapon_model.dart';

final weaponsCategoryProvider = StateProvider<String>((ref) => 'Todos');

final filteredWeaponsProvider = FutureProvider<List<WeaponModel>>((ref) async {
  final repo = ref.watch(weaponsRepositoryProvider);
  final cat = ref.watch(weaponsCategoryProvider);
  return await repo.getWeapons(category: cat);
});

class WeaponsScreen extends ConsumerWidget {
  const WeaponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weaponsAsync = ref.watch(filteredWeaponsProvider);
    final selectedCat = ref.watch(weaponsCategoryProvider);
    final categories = ['Todos', 'Pistola', 'Escopeta', 'Rifle', 'Sniper', 'Corpo a corpo', 'Explosivo'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Arsenal', style: AppTypography.titleLarge)),
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
              onSelected: (_) => ref.read(weaponsCategoryProvider.notifier).state = cat,
              selectedColor: AppColors.secondary, backgroundColor: AppColors.surface,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.bold),
            ));
          },
        )),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: weaponsAsync.when(
          loading: () => const AppLoadingState(message: 'Carregando arsenal...'),
          error: (e, _) => AppEmptyState(title: 'Erro', message: e.toString(), icon: Icons.error_outline_rounded),
          data: (weapons) {
            if (weapons.isEmpty) {
              return const AppEmptyState(title: 'Nenhuma arma', message: 'Altere o filtro.', icon: Icons.gps_fixed_rounded);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: weapons.length,
              itemBuilder: (context, index) {
                final w = weapons[index];
                return Padding(padding: const EdgeInsets.only(bottom: 14), child: GlassCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      AppBadge(label: w.category, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      AppBadge(label: '${w.meta.status.emoji} ${w.meta.status.label}', color: _statusColor(w.meta.status)),
                      const Spacer(),
                      if (w.price > 0) Text('\$${w.price}', style: AppTypography.titleMedium.copyWith(color: AppColors.gold)),
                    ]),
                    const SizedBox(height: 10),
                    Text(w.name, style: AppTypography.titleLarge),
                    const SizedBox(height: 6),
                    Text(w.description, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    StatBar(label: 'Dano', value: w.damage, barColor: Colors.redAccent),
                    const SizedBox(height: 8),
                    StatBar(label: 'Precisão', value: w.accuracy, barColor: AppColors.success),
                    const SizedBox(height: 8),
                    StatBar(label: 'Cadência', value: w.fireRate, barColor: AppColors.secondary),
                    const SizedBox(height: 8),
                    StatBar(label: 'Alcance', value: w.range, barColor: AppColors.info),
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
