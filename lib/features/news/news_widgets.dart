import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/share_service.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/links.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/glass_card.dart';
import '../content/content_models.dart';

class NewsCard extends StatelessWidget {
  final NewsItem item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      onTap: item.url.isEmpty ? null : () => openLink(context, item.url),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.tag.isNotEmpty && item.tag != 'Notícia')
                AppBadge(label: item.tag, color: item.tag == 'Rumor' ? AppColors.warning : AppColors.primary),
              const Spacer(),
              Text(formatDate(item.date), style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(item.title, style: AppTypography.titleMedium),
          if (item.summary.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(item.summary, style: AppTypography.bodyMedium),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: Text('Fonte: ${item.source}', style: AppTypography.bodySmall)),
              IconButton(
                tooltip: 'Compartilhar',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.share_rounded, size: 18, color: AppColors.textMuted),
                onPressed: () => shareText('${item.title}\n${item.url}\n\nvia ${AppConstants.appName}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoItem video;
  final double? width;

  const VideoCard({super.key, required this.video, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GlassCard(
        padding: EdgeInsets.zero,
        onTap: () => context.push('/video/${video.youtubeId}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: AppColors.surfaceLight),
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xCC000000),
                        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: AppTypography.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    video.date == null ? video.channel : '${video.channel} · ${formatDate(video.date!)}',
                    style: AppTypography.bodySmall,
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
