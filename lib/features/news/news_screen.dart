import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/content_builder.dart';
import '../content/content_models.dart';
import 'news_widgets.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notícias'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [Tab(text: 'Notícias'), Tab(text: 'Vídeos')],
          ),
        ),
        body: ContentBuilder(
          builder: (context, content) => TabBarView(
            children: [
              RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => ref.read(contentProvider.notifier).refresh(),
                child: _NewsList(news: content.news),
              ),
              ListView.separated(
                padding: AppSpacing.paddingMd,
                itemCount: content.videos.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => VideoCard(video: content.videos[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lista com filtro por etiqueta (Lançamento, Trailer, Rumor...).
class _NewsList extends StatefulWidget {
  final List<NewsItem> news;

  const _NewsList({required this.news});

  @override
  State<_NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<_NewsList> {
  String? _tag;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final n in widget.news) {
      if (n.tag.isNotEmpty) counts[n.tag] = (counts[n.tag] ?? 0) + 1;
    }
    final tags = counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    final visible = _tag == null ? widget.news : widget.news.where((n) => n.tag == _tag).toList();

    return ListView(
      padding: AppSpacing.paddingMd,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final t in <String?>[null, ...tags])
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(t ?? 'Todas'),
                    selected: _tag == t,
                    onSelected: (_) => setState(() => _tag = t),
                    selectedColor: AppColors.primary.withAlpha(60),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: _tag == t ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: _tag == t ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: const BorderSide(color: AppColors.surfaceBorder),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (visible.isEmpty)
          const AppEmptyState(title: 'Sem notícias', message: 'Volte mais tarde.')
        else
          for (final n in visible) NewsCard(item: n),
      ],
    );
  }
}
