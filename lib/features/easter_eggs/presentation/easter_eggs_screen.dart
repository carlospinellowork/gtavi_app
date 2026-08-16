import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/domain/content_metadata.dart';
import '../domain/easter_egg_model.dart';

final easterEggsListProvider = FutureProvider<List<EasterEggModel>>((ref) async {
  final repo = ref.watch(easterEggsRepositoryProvider);
  return await repo.getEasterEggs();
});

class EasterEggsScreen extends ConsumerWidget {
  const EasterEggsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eggsAsync = ref.watch(easterEggsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Easter Eggs & Segredos', style: AppTypography.titleLarge)),
      body: eggsAsync.when(
        loading: () => const AppLoadingState(message: 'Procurando segredos...'),
        error: (e, _) => AppEmptyState(title: 'Erro', message: e.toString(), icon: Icons.error_outline_rounded),
        data: (eggs) {
          if (eggs.isEmpty) {
            return const AppEmptyState(title: 'Nenhum easter egg', message: 'Ainda sem dados.', icon: Icons.visibility_rounded);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: eggs.length,
            itemBuilder: (context, index) {
              final e = eggs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      AppBadge(label: e.category, color: AppColors.accent),
                      const SizedBox(width: 8),
                      AppBadge(label: '${e.meta.status.emoji} ${e.meta.status.label}', color: _statusColor(e.meta.status)),
                    ]),
                    const SizedBox(height: 10),
                    Text(e.title, style: AppTypography.titleMedium),
                    const SizedBox(height: 6),
                    Text(e.description, style: AppTypography.bodyMedium.copyWith(height: 1.5)),
                    if (e.hint.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.gold.withAlpha(60)),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.lightbulb_rounded, color: AppColors.gold, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e.hint, style: AppTypography.bodySmall.copyWith(color: AppColors.gold))),
                        ]),
                      ),
                    ],
                    if (e.meta.source != null) ...[
                      const SizedBox(height: 8),
                      Text('Fonte: ${e.meta.source}', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ]),
                ),
              );
            },
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
