import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/content_builder.dart';
import '../../core/widgets/glass_card.dart';
import '../content/content_models.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Guia'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [Tab(text: 'Essencial'), Tab(text: 'Personagens'), Tab(text: 'Lugares')],
          ),
        ),
        body: ContentBuilder(
          builder: (context, c) => TabBarView(
            children: [
              _FactsList(facts: c.facts),
              _CharactersList(characters: c.characters),
              _PlacesList(places: c.places),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactsList extends StatelessWidget {
  final List<FactItem> facts;

  const _FactsList({required this.facts});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingMd,
      children: [
        for (final f in facts)
          GlassCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.question, style: AppTypography.titleMedium.copyWith(color: AppColors.secondary)),
                const SizedBox(height: AppSpacing.xs),
                Text(f.answer, style: AppTypography.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}

class _CharactersList extends StatelessWidget {
  final List<CharacterItem> characters;

  const _CharactersList({required this.characters});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingMd,
      children: [
        for (final ch in characters)
          GlassCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withAlpha(40),
                  child: Text(ch.initials, style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(ch.name, style: AppTypography.titleMedium)),
                          const SizedBox(width: AppSpacing.sm),
                          AppBadge(
                            label: ch.role,
                            color: ch.role == 'Protagonista' ? AppColors.gold : AppColors.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(ch.description, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlacesList extends StatelessWidget {
  final List<PlaceItem> places;

  const _PlacesList({required this.places});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.paddingMd,
      itemCount: places.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) {
        final p = places[i];
        return GlassCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_rounded, color: AppColors.primaryGradientEnd),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(p.description, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
