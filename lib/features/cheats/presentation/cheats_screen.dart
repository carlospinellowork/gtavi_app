import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../domain/cheat_model.dart';

final cheatCategoryFilterProvider = StateProvider<String>((ref) => 'Todos');
final cheatPlatformProvider = StateProvider<String>((ref) => 'PS5');
final cheatSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCheatsProvider = FutureProvider<List<CheatModel>>((ref) async {
  final repo = ref.watch(cheatsRepositoryProvider);
  final cat = ref.watch(cheatCategoryFilterProvider);
  final query = ref.watch(cheatSearchQueryProvider);
  return await repo.getCheats(category: cat, query: query);
});

class CheatsScreen extends ConsumerWidget {
  const CheatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cheatsAsync = ref.watch(filteredCheatsProvider);
    final selectedCat = ref.watch(cheatCategoryFilterProvider);
    final selectedPlatform = ref.watch(cheatPlatformProvider);

    final categories = ['Todos', 'Jogador', 'Polícia', 'Armas', 'Veículos', 'Habilidades'];
    final platforms = ['PS5', 'Xbox', 'PC'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Macetes & Cheats GTA VI'),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          // Platform Selector & Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => ref.read(cheatSearchQueryProvider.notifier).state = val,
                  decoration: const InputDecoration(
                    hintText: 'Buscar macete (vida, helicóptero, armas...)...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: platforms.map((plat) {
                    final isSelected = plat == selectedPlatform;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(plat, style: const TextStyle(fontWeight: FontWeight.bold)),
                        selected: isSelected,
                        onSelected: (_) {
                          ref.read(cheatPlatformProvider.notifier).state = plat;
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceLight,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Categories Horizontal List
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(cheatCategoryFilterProvider.notifier).state = cat;
                    },
                    selectedColor: AppColors.secondary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Cheats List
          Expanded(
            child: cheatsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(child: Text('Erro ao carregar macetes: $err')),
              data: (cheats) {
                if (cheats.isEmpty) {
                  return const Center(child: Text('Nenhum macete encontrado.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: cheats.length,
                  itemBuilder: (context, index) {
                    final cheat = cheats[index];
                    List<String> buttonSequence = [];

                    if (selectedPlatform == 'PS5') {
                      buttonSequence = cheat.ps5Code;
                    } else if (selectedPlatform == 'Xbox') {
                      buttonSequence = cheat.xboxCode;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(40),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(cheat.icon, color: AppColors.primary, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cheat.title, style: AppTypography.titleMedium),
                                      const SizedBox(height: 2),
                                      AppBadge(label: cheat.category, color: AppColors.gold),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(cheat.description, style: AppTypography.bodySmall),
                            const SizedBox(height: 12),

                            // Sequence Display
                            if (selectedPlatform == 'PC')
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(160),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.secondary.withAlpha(100)),
                                ),
                                child: Text(
                                  'CÓDIGO PC: ${cheat.pcCode}',
                                  style: AppTypography.titleMedium.copyWith(color: AppColors.secondary, letterSpacing: 2.0),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: buttonSequence.map((btn) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.primary.withAlpha(120)),
                                    ),
                                    child: Text(
                                      btn,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
