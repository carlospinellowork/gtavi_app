import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/shell/presentation/main_shell_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/vehicles/presentation/vehicles_screen.dart';
import '../../features/vehicles/presentation/vehicle_detail_screen.dart';
import '../../features/missions/presentation/missions_screen.dart';
import '../../features/missions/presentation/mission_detail_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/guides/presentation/guides_screen.dart';
import '../../features/guides/presentation/guide_detail_screen.dart';
import '../../features/news/presentation/news_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vehicles',
              builder: (context, state) => const VehiclesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/missions',
              builder: (context, state) => const MissionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/vehicles/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'v1';
        return VehicleDetailScreen(vehicleId: id);
      },
    ),
    GoRoute(
      path: '/missions/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'm1';
        return MissionDetailScreen(missionId: id);
      },
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/guides',
      builder: (context, state) => const GuidesScreen(),
    ),
    GoRoute(
      path: '/guides/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'g1';
        return GuideDetailScreen(guideId: id);
      },
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
  ],
);
