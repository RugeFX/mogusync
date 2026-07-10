import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../auth/auth_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _minimumDuration = Duration(milliseconds: 1200);

  late final AnimationController _scaleController;
  late final Animation<double> _logoScale;
  Timer? _minimumTimer;
  bool _minimumElapsed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0.97,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 55,
      ),
    ]).animate(_scaleController);

    if (_shouldReduceMotion) {
      _scaleController.value = 1;
    } else {
      _scaleController.repeat(reverse: true);
    }

    _minimumTimer = Timer(_minimumDuration, () {
      if (!mounted) {
        return;
      }

      setState(() {
        _minimumElapsed = true;
      });
      _tryNavigate(ref.read(authControllerProvider));
    });
  }

  bool get _shouldReduceMotion {
    final dispatcher = SchedulerBinding.instance.platformDispatcher;
    return dispatcher.accessibilityFeatures.disableAnimations;
  }

  @override
  void dispose() {
    _minimumTimer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  void _tryNavigate(AuthState authState) {
    if (!_minimumElapsed || _navigated || authState.isLoading) {
      return;
    }

    _navigated = true;
    final destination = authState.isAuthenticated
        ? AppRoutes.queue
        : AppRoutes.login;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(destination);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    _tryNavigate(authState);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.65, 1],
            colors: [
              colorScheme.surfaceContainerHigh,
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Center(
                child: AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    );
                  },
                  child: const _LogoMark(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/brand/logo.svg', width: 220, height: 220);
  }
}
