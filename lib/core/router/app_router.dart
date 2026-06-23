import 'package:go_router/go_router.dart';

import '../../features/library/library_page.dart';
import '../../features/login/login_mode.dart';
import '../../features/login/login_page.dart';
import '../../features/queue/queue_page.dart';
import '../../features/search/search_page.dart';
import '../../features/servers/servers_page.dart';
import '../../features/settings/settings_page.dart';
import '../navigation/app_shell.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return LoginPage(
          mode: LoginMode.credentials,
          onCredentialsLogin: (_) => context.go(AppRoutes.queue),
          onDiscordLogin: () => context.go(AppRoutes.queue),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      redirect: (context, state) => AppRoutes.queue,
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.queue,
              builder: (context, state) => const QueuePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.servers,
              builder: (context, state) => const ServersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.library,
              builder: (context, state) => const LibraryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
