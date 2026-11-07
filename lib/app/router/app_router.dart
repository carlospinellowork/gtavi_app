import 'package:go_router/go_router.dart';

import '../../features/about/about_screen.dart';
import '../../features/checklist/checklist_screen.dart';
import '../../features/guide/guide_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/news/news_screen.dart';
import '../../features/shell/main_shell_screen.dart';
import '../../features/videos/video_player_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/inicio',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShellScreen(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/inicio', builder: (_, _) => const HomeScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/noticias', builder: (_, _) => const NewsScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/guia', builder: (_, _) => const GuideScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/checklist', builder: (_, _) => const ChecklistScreen())]),
      ],
    ),
    GoRoute(path: '/sobre', builder: (_, _) => const AboutScreen()),
    GoRoute(
      path: '/video/:id',
      builder: (_, state) => VideoPlayerScreen(youtubeId: state.pathParameters['id'] ?? ''),
    ),
  ],
);
