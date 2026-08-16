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
import '../../../core/domain/content_metadata.dart';
import '../domain/character_model.dart';

final charactersListProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final repo = ref.watch(charactersRepositoryProvider);
  return await repo.getCharacters();
});

class CharactersScreen extends ConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charsAsync = ref.watch(charactersListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Personagens', style: AppTypography.titleLarge)),
      body: charsAsync.when(
        loading: () => const AppLoadingState(message: 'Carregando personagens...'),
        error: (e, _) => AppEmptyState(title: 'Erro', message: e.toString(), icon: Icons.error_outline_rounded),
        data: (characters) {
          if (characters.isEmpty) {
            return const AppEmptyState(title: 'Nenhum personagem', message: 'Ainda sem dados.', icon: Icons.people_rounded);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final c = characters[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GlassCard(
                  onTap: () => context.push('/characters/${c.id}'),
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSpacing.radiusLg),
                          bottomLeft: Radius.circular(AppSpacing.radiusLg),
                        ),
                        child: SizedBox(
                          width: 100, height: 120,
                          child: c.localImageAsset != null
                              ? Image.asset(c.localImageAsset!, fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => _placeholder(c))
                              : _placeholder(c),
                        ),
                      ),
                      // Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                AppBadge(label: c.meta.status.label, color: _statusColor(c.meta.status)),
                              ]),
                              const SizedBox(height: 6),
                              Text(c.name, style: AppTypography.titleMedium),
                              const SizedBox(height: 4),
                              Text(c.role, style: AppTypography.bodySmall),
                              if (c.nationality.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text('${c.nationality} • ${c.age}', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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

  Widget _placeholder(CharacterModel c) => Container(
    color: AppColors.surfaceLight,
    child: Center(child: Text(c.name.substring(0, 1), style: const TextStyle(color: AppColors.textMuted, fontSize: 32, fontWeight: FontWeight.bold))),
  );

  Color _statusColor(ContentStatus s) {
    switch (s) {
      case ContentStatus.confirmed: return AppColors.success;
      case ContentStatus.community: return AppColors.info;
      case ContentStatus.reported: return AppColors.warning;
      case ContentStatus.rumor: return AppColors.error;
    }
  }
}
