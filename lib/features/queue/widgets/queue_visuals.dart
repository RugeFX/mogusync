import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../../core/theme/app_tokens.dart';

const queueCardRadius = AppCoreTokens.dflt;

String formatTrackDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class QueueCard extends StatelessWidget {
  const QueueCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppCoreTokens.gutter),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(queueCardRadius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.82),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class MockTrackThumbnail extends StatelessWidget {
  const MockTrackThumbnail({
    super.key,
    required this.seed,
    this.size = 52,
    this.borderRadius = AppCoreTokens.base,
  });

  final int seed;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final palette = _thumbnailPalettes[seed % _thumbnailPalettes.length];
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _MockThumbnailPainter(
            colors: palette,
            lineColor: colorScheme.primary.withValues(alpha: 0.64),
          ),
        ),
      ),
    );
  }
}

class TrackCoverImage extends StatelessWidget {
  const TrackCoverImage({
    super.key,
    required this.seed,
    this.imageUrl,
    this.size = 52,
    this.borderRadius = AppCoreTokens.base,
  });

  final int seed;
  final String? imageUrl;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return MockTrackThumbnail(
        seed: seed,
        size: size,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return MockTrackThumbnail(
            seed: seed,
            size: size,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

class RequesterAvatar extends StatelessWidget {
  const RequesterAvatar({super.key, required this.name, required this.seed});

  final String name;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final palette = _avatarPalettes[seed % _avatarPalettes.length];

    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette,
        ),
        border: Border.all(
          color: AppCoreTokens.white.withValues(alpha: 0.7),
          width: 1.4,
        ),
      ),
      child: Text(
        name.characters.first.toUpperCase(),
        style: AppTypography.labelSm.copyWith(
          color: AppCoreTokens.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SourceBadge extends StatelessWidget {
  const SourceBadge({super.key, required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = switch (source) {
      'spotify_metadata' => SimpleIcons.spotify,
      _ => SimpleIcons.youtube,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppCoreTokens.base,
        vertical: AppCoreTokens.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppCoreTokens.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 11, color: colorScheme.onSurface)],
      ),
    );
  }
}

class OnigiriWatermark extends StatelessWidget {
  const OnigiriWatermark({super.key, this.size = 44, this.opacity = 0.12});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SvgPicture.asset(
        'assets/brand/logo.svg',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

class OnigiriBadge extends StatelessWidget {
  const OnigiriBadge({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.18),
      ),
      child: SvgPicture.asset(
        'assets/brand/logo.svg',
        width: size * 0.62,
        height: size * 0.62,
        fit: BoxFit.contain,
      ),
    );
  }
}

class CatEarProgressBar extends StatelessWidget {
  const CatEarProgressBar({
    super.key,
    required this.progress,
    required this.leadingLabel,
    required this.trailingLabel,
  });

  final double progress;
  final String leadingLabel;
  final String trailingLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const thumbWidth = 30.0;
            final trackWidth = constraints.maxWidth;
            final thumbLeft =
                (trackWidth - thumbWidth) * clampedProgress.toDouble();

            return SizedBox(
              height: 34,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.68,
                        ),
                        borderRadius: BorderRadius.circular(AppCoreTokens.full),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    width: math.max(0, trackWidth * clampedProgress),
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(AppCoreTokens.full),
                      ),
                    ),
                  ),
                  Positioned(
                    left: thumbLeft,
                    child: CustomPaint(
                      size: const Size(thumbWidth, 30),
                      painter: _CatEarThumbPainter(colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leadingLabel,
              style: AppTypography.labelSm.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              trailingLabel,
              style: AppTypography.labelSm.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MockThumbnailPainter extends CustomPainter {
  const _MockThumbnailPainter({required this.colors, required this.lineColor});

  final List<Color> colors;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    final horizonPaint = Paint()
      ..color = AppCoreTokens.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height * 0.58),
      Offset(size.width, size.height * 0.45),
      horizonPaint,
    );

    final sunPaint = Paint()
      ..color = AppCoreTokens.secondary.withValues(alpha: 0.86);
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      size.shortestSide * 0.11,
      sunPaint,
    );

    final roadPaint = Paint()..color = Colors.black.withValues(alpha: 0.26);
    final road = Path()
      ..moveTo(size.width * 0.22, size.height)
      ..lineTo(size.width * 0.47, size.height * 0.55)
      ..lineTo(size.width * 0.58, size.height * 0.55)
      ..lineTo(size.width * 0.86, size.height)
      ..close();
    canvas.drawPath(road, roadPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    for (var index = 0; index < 4; index += 1) {
      final x = size.width * (0.16 + index * 0.22);
      canvas.drawLine(
        Offset(x, size.height * 0.12),
        Offset(x + size.width * 0.08, size.height * 0.72),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MockThumbnailPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.lineColor != lineColor;
  }
}

class _CatEarThumbPainter extends CustomPainter {
  const _CatEarThumbPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      size.shortestSide / 2,
      Paint()..color = color.withValues(alpha: 0.78),
    );
    canvas.drawCircle(
      center,
      size.shortestSide / 2 - 4,
      Paint()..color = color,
    );

    final dotPaint = Paint()
      ..color = AppCoreTokens.onSecondary.withValues(alpha: 0.7);
    for (final dx in [-5.0, 0.0, 5.0]) {
      canvas.drawCircle(center.translate(dx, 0), 1.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CatEarThumbPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

const _thumbnailPalettes = [
  [Color(0xFF432B78), Color(0xFFCE6BD4), Color(0xFF11122F)],
  [Color(0xFF2A284D), Color(0xFFCE9D68), Color(0xFF17101F)],
  [Color(0xFF182B48), Color(0xFFB76A85), Color(0xFF30192B)],
  [Color(0xFF392B55), Color(0xFF895C44), Color(0xFF120E1E)],
  [Color(0xFF27334E), Color(0xFF7784BF), Color(0xFF0F1026)],
  [Color(0xFF1C2856), Color(0xFF8E4C7D), Color(0xFF120B23)],
];

const _avatarPalettes = [
  [Color(0xFFE9C7F7), Color(0xFF7C65B6)],
  [Color(0xFFFFC2D3), Color(0xFF8B3B61)],
  [Color(0xFFE8D5B1), Color(0xFF825D45)],
  [Color(0xFFD9C4F0), Color(0xFF594677)],
  [Color(0xFFC6DCF5), Color(0xFF4B5C88)],
  [Color(0xFFF0DEE7), Color(0xFF766070)],
];
