import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/widgets/content_builder.dart';
import '../../core/utils/links.dart';
import '../../core/widgets/glass_card.dart';
import '../monetization/monetization.dart';

class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = ref.watch(checklistProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: ContentBuilder(
        builder: (context, c) => ListView(
          padding: AppSpacing.paddingMd,
          children: [
            for (final g in c.checklist) ...[
              Builder(
                builder: (_) {
                  final count = g.items
                      .where((i) => done.contains(i.id))
                      .length;
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.sm,
                      top: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                g.title,
                                style: AppTypography.titleLarge,
                              ),
                            ),
                            Text(
                              '$count/${g.items.length}',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        if (g.description.isNotEmpty)
                          Text(g.description, style: AppTypography.bodySmall),
                        const SizedBox(height: AppSpacing.sm),
                        LinearProgressIndicator(
                          value: g.items.isEmpty ? 0 : count / g.items.length,
                          backgroundColor: AppColors.surfaceLight,
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                },
              ),
              GlassCard(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  children: [
                    for (final item in g.items)
                      CheckboxListTile(
                        value: done.contains(item.id),
                        onChanged: (_) => ref
                            .read(checklistProvider.notifier)
                            .toggle(item.id),
                        activeColor: AppColors.secondary,
                        checkColor: AppColors.background,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          item.title,
                          style: AppTypography.bodyLarge.copyWith(
                            decoration: done.contains(item.id)
                                ? TextDecoration.lineThrough
                                : null,
                            color: done.contains(item.id)
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: item.note.isEmpty && item.link.isEmpty
                            ? null
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.note.isNotEmpty)
                                    Text(
                                      item.note,
                                      style: AppTypography.bodySmall,
                                    ),
                                  if (item.link.isNotEmpty)
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: () => openLink(
                                        context,
                                        affiliateUrl(item.link),
                                      ),
                                      icon: const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 16,
                                      ),
                                      label: Text(
                                        item.linkLabel.isEmpty
                                            ? 'Ver na loja'
                                            : item.linkLabel,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                  ],
                ),
              ),
            ],
            GlassCard(
              borderColor: AppColors.glassBorder,
              child: Row(
                children: [
                  const Icon(Icons.update_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Depois do lançamento chegam aqui as listas de missões e colecionáveis. '
                      'Seu progresso fica salvo neste aparelho. Links de loja podem render '
                      'comissão ao app, sem custo a mais para você.',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
