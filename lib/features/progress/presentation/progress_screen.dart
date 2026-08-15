import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/stat_bar.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Progresso 100%', style: AppTypography.titleLarge),
      ),
      body: progressAsync.when(
        loading: () => const AppLoadingState(message: 'Calculando seu progresso em Vice City...'),
        error: (err, _) => AppEmptyState(
          title: 'Erro ao carregar progresso',
          message: err.toString(),
          icon: Icons.error_outline_rounded,
        ),
        data: (progress) {
          final overallPercent = (progress.overallPercentage * 100).toInt();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall 100% Progress Dashboard Header Card
                GlassCard(
                  backgroundColor: AppColors.surface,
                  child: Row(
                    children: [
                      // Radial Progress Ring
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: progress.overallPercentage,
                              strokeWidth: 8,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                            Center(
                              child: Text(
                                '$overallPercent%',
                                style: AppTypography.displayMedium.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Progresso Geral', style: AppTypography.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              'Conclua todos os objetivos para alcançar os 100% lendários em Vice City.',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Category Breakdowns Card
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Divisão por Categoria', style: AppTypography.titleMedium),
                      const SizedBox(height: AppSpacing.md),
                      StatBar(
                        label: 'Missões Principais & Secundárias',
                        value: progress.missionsPercentage,
                        barColor: AppColors.missions,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StatBar(
                        label: 'Colecionáveis & Pacotes',
                        value: progress.collectiblesPercentage,
                        barColor: AppColors.collectibles,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StatBar(
                        label: 'Garagem & Veículos Raros',
                        value: progress.vehiclesPercentage,
                        barColor: AppColors.vehicles,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      StatBar(
                        label: 'Easter Eggs & Segredos',
                        value: progress.easterEggsPercentage,
                        barColor: AppColors.secondary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Checklist Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Checklist de Objetivos', style: AppTypography.titleLarge),
                    Text(
                      '${progress.items.where((i) => i.isCompleted).length}/${progress.items.length}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: progress.items.length,
                  itemBuilder: (context, index) {
                    final item = progress.items[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        onTap: () {
                          ref.read(progressStateProvider.notifier).toggleItem(item.id);
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isCompleted,
                              activeColor: AppColors.primary,
                              onChanged: (_) {
                                ref.read(progressStateProvider.notifier).toggleItem(item.id);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name,
                                style: AppTypography.bodyMedium.copyWith(
                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                  color: item.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
