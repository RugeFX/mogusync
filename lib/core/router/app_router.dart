import 'package:go_router/go_router.dart';

import '../../features/home/home_page.dart';
import '../../features/login/login_mode.dart';
import '../../features/login/login_page.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return LoginPage(
          mode: LoginMode.credentials,
          onCredentialsLogin: (_) => context.go(AppRoutes.home),
          onDiscordLogin: () => context.go(AppRoutes.home),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
