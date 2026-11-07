import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../features/content/content_models.dart';
import 'app_empty_state.dart';
import 'app_loading_state.dart';

/// Lê o conteúdo e cuida de carregando/erro, para as telas só desenharem os dados.
class ContentBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, AppContent content) builder;

  const ContentBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(contentProvider).when(
          data: (c) => builder(context, c),
          loading: () => const AppLoadingState(),
          error: (_, _) => AppEmptyState(
            title: 'Não deu para carregar',
            message: 'Tente de novo em instantes.',
            icon: Icons.wifi_off_rounded,
            actionText: 'Tentar de novo',
            onAction: () => ref.invalidate(contentProvider),
          ),
        );
  }
}
