import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/shell/presentation/main_shell_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/explore/presentation/explore_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

import '../../features/characters/presentation/characters_screen.dart';
import '../../features/characters/presentation/character_detail_screen.dart';
import '../../features/locations/presentation/locations_screen.dart';
import '../../features/weapons/presentation/weapons_screen.dart';
import '../../features/gallery/presentation/gallery_screen.dart';
import '../../features/easter_eggs/presentation/easter_eggs_screen.dart';
import '../../features/vehicles/presentation/vehicles_screen.dart';
import '../../features/vehicles/presentation/vehicle_detail_screen.dart';
import '../../features/missions/presentation/missions_screen.dart';
import '../../features/missions/presentation/mission_detail_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/guides/presentation/guides_screen.dart';
import '../../features/guides/presentation/guide_detail_screen.dart';
import '../../features/news/presentation/news_screen.dart';
import '../../features/videos/presentation/videos_hub_screen.dart';
import '../../features/videos/presentation/video_player_screen.dart';
import '../../features/radio/presentation/radio_screen.dart';
import '../../features/cheats/presentation/cheats_screen.dart';
import '../../features/economy/presentation/economy_screen.dart';
import '../../features/ai_chat/presentation/ai_chat_screen.dart';

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
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
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
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Sub-rotas e telas independentes
    GoRoute(
      path: '/characters',
      builder: (context, state) => const CharactersScreen(),
    ),
    GoRoute(
      path: '/characters/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'char_lucia';
        return CharacterDetailScreen(characterId: id);
      },
    ),
    GoRoute(
      path: '/locations',
      builder: (context, state) => const LocationsScreen(),
    ),
    GoRoute(
      path: '/weapons',
      builder: (context, state) => const WeaponsScreen(),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const GalleryScreen(),
    ),
    GoRoute(
      path: '/easter-eggs',
      builder: (context, state) => const EasterEggsScreen(),
    ),
    GoRoute(
      path: '/vehicles',
      builder: (context, state) => const VehiclesScreen(),
    ),
    GoRoute(
      path: '/vehicles/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'v1';
        return VehicleDetailScreen(vehicleId: id);
      },
    ),
    GoRoute(
      path: '/missions',
      builder: (context, state) => const MissionsScreen(),
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
    GoRoute(
      path: '/videos',
      builder: (context, state) => const VideosHubScreen(),
    ),
    GoRoute(
      path: '/videos/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'v_trailer1';
        return VideoPlayerScreen(videoId: id);
      },
    ),
    GoRoute(
      path: '/radio',
      builder: (context, state) => const RadioScreen(),
    ),
    GoRoute(
      path: '/cheats',
      builder: (context, state) => const CheatsScreen(),
    ),
    GoRoute(
      path: '/economy',
      builder: (context, state) => const EconomyScreen(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AiChatScreen(),
    ),
  ],
);
