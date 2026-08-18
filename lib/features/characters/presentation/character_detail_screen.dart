import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/domain/content_metadata.dart';
import '../../../core/widgets/app_network_image.dart';
import '../domain/character_model.dart';

final characterDetailProvider = FutureProvider.family<CharacterModel?, String>((ref, id) async {
  final repo = ref.watch(charactersRepositoryProvider);
  return await repo.getCharacterById(id);
});

class CharacterDetailScreen extends ConsumerWidget {
  final String characterId;
  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charAsync = ref.watch(characterDetailProvider(characterId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: charAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (character) {
          if (character == null) return const Center(child: Text('Personagem não encontrado.'));
          final c = character;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 300, pinned: true, backgroundColor: AppColors.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(fit: StackFit.expand, children: [
                    AppNetworkImage(url: c.imageUrl, placeholderIcon: Icons.person_rounded),
                    Container(decoration: BoxDecoration(gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.background.withAlpha(220), AppColors.background],
                      stops: const [0.3, 0.7, 1.0],
                    ))),
                  ]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      AppBadge(label: '${c.meta.status.emoji} ${c.meta.status.label}', color: _statusColor(c.meta.status)),
                      if (c.meta.source != null) ...[
                        const SizedBox(width: 8),
                        Text('Fonte: ${c.meta.source}', style: AppTypography.bodySmall),
                      ],
                    ]),
                    const SizedBox(height: 12),
                    Text(c.name, style: AppTypography.displayMedium),
                    const SizedBox(height: 4),
                    Text(c.role, style: AppTypography.bodyMedium.copyWith(color: AppColors.primary)),
                    if (c.nationality.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('${c.nationality} • ${c.age}', style: AppTypography.bodySmall),
                    ],
                    const SizedBox(height: 16),
                    Text(c.description, style: AppTypography.bodyMedium.copyWith(height: 1.6)),
                    if (c.skills.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Habilidades', style: AppTypography.titleLarge),
                      const SizedBox(height: 10),
                      Wrap(spacing: 8, runSpacing: 8, children: c.skills.map((s) =>
                        AppBadge(label: s, color: AppColors.secondary)).toList()),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
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
