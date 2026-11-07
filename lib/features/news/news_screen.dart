import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/content_builder.dart';
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
                child: content.news.isEmpty
                    ? ListView(children: const [
                        SizedBox(height: 120),
                        AppEmptyState(title: 'Sem notícias', message: 'Volte mais tarde.'),
                      ])
                    : ListView(
                        padding: AppSpacing.paddingMd,
                        children: [for (final n in content.news) NewsCard(item: n)],
                      ),
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
