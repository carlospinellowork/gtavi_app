import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/content_builder.dart';
import '../../core/widgets/glass_card.dart';
import '../content/content_models.dart';
import '../news/news_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName, style: AppTypography.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Sobre',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.push('/sobre'),
          ),
        ],
      ),
      body: ContentBuilder(
        builder: (context, content) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(contentProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            children: [
              _Hero(content: content),
              const SizedBox(height: AppSpacing.md),
              _ChecklistCard(content: content),
              _SectionTitle('Últimas notícias', onSeeAll: () => context.go('/noticias')),
              Padding(
                padding: AppSpacing.paddingHorizontalMd,
                child: Column(children: [for (final n in content.news.take(3)) NewsCard(item: n)]),
              ),
              if (content.videos.isNotEmpty) ...[
                const _SectionTitle('Trailers'),
                SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: AppSpacing.paddingHorizontalMd,
                    itemCount: content.videos.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (_, i) => VideoCard(video: content.videos[i], width: 280),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, 0),
                child: Text(
                  '${AppConstants.disclaimer}\nConteúdo atualizado em ${formatDate(content.updatedAt)}.',
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final AppContent content;

  const _Hero({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.paddingHorizontalMd,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/hero_night.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.background.withAlpha(90), AppColors.background.withAlpha(230)],
                ),
              ),
            ),
          ),
          Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GTA 6 CHEGA EM', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary, letterSpacing: 2)),
                const SizedBox(height: AppSpacing.xs),
                Text(formatDate(content.releaseDate), style: AppTypography.displayMedium),
                const SizedBox(height: AppSpacing.md),
                Countdown(target: content.releaseDate),
                const SizedBox(height: AppSpacing.md),
                Text(content.platforms.join(' · '), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Contagem regressiva até [target]; depois da data mostra "Já disponível".
class Countdown extends StatefulWidget {
  final DateTime target;
  final DateTime Function() now;

  const Countdown({super.key, required this.target, this.now = DateTime.now});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.target.difference(widget.now());
    if (left.isNegative) {
      _timer?.cancel();
      return Text('Já disponível! Bom jogo.', style: AppTypography.titleLarge.copyWith(color: AppColors.success));
    }
    final parts = [
      (left.inDays, 'dias'),
      (left.inHours % 24, 'horas'),
      (left.inMinutes % 60, 'min'),
      (left.inSeconds % 60, 'seg'),
    ];
    return Row(
      children: [
        for (final (value, label) in parts)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface.withAlpha(200),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: [
                  Text(value.toString().padLeft(2, '0'),
                      style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                  Text(label, style: AppTypography.labelSmall),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ChecklistCard extends ConsumerWidget {
  final AppContent content;

  const _ChecklistCard({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = ref.watch(checklistProvider);
    final ids = {for (final g in content.checklist) for (final i in g.items) i.id};
    final total = ids.length;
    if (total == 0) return const SizedBox.shrink();
    final count = ids.where(done.contains).length;
    return GlassCard(
      margin: AppSpacing.paddingHorizontalMd,
      onTap: () => context.go('/checklist'),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: count / total,
              strokeWidth: 4,
              backgroundColor: AppColors.surfaceLight,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seu checklist', style: AppTypography.titleMedium),
                Text('$count de $total concluídos', style: AppTypography.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionTitle(this.title, {this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.sm, AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTypography.titleLarge)),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: const Text('Ver todas')),
        ],
      ),
    );
  }
}
