import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class MogusyncTabBar extends StatelessWidget {
  const MogusyncTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _MogusyncTabItem(icon: Icons.queue_music_rounded, label: 'Queue'),
    _MogusyncTabItem(icon: Icons.search_rounded, label: 'Search'),
    _MogusyncTabItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppCoreTokens.marginMobile,
          0,
          AppCoreTokens.marginMobile,
          AppCoreTokens.base,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _items.length;

            return SizedBox(
              height: 88,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppCoreTokens.lg),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    top: -1,
                    left: itemWidth * currentIndex + itemWidth / 2 - 18,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: _TabPointer(color: colorScheme.primary),
                  ),
                  Row(
                    children: [
                      for (var index = 0; index < _items.length; index += 1)
                        Expanded(
                          child: _TabButton(
                            item: _items[index],
                            selected: currentIndex == index,
                            onTap: () => onTap(index),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _MogusyncTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = selected ? colorScheme.primary : colorScheme.onSurface;

    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        containedInkWell: false,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 32, color: foreground),
              const SizedBox(height: AppCoreTokens.xs),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelLg.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabPointer extends StatelessWidget {
  const _TabPointer({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 12),
      painter: _TabPointerPainter(color),
    );
  }
}

class _TabPointerPainter extends CustomPainter {
  const _TabPointerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _TabPointerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _MogusyncTabItem {
  const _MogusyncTabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
