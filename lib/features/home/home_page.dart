import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppCoreTokens.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'mogusync',
                style: AppTypography.headlineLg.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppCoreTokens.base),
              Text(
                'Home placeholder',
                style: AppTypography.bodyLg.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: AppCoreTokens.xl,
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Back to login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
