import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    _MogusyncTabItem(icon: LucideIcons.listMusic, label: 'Queue'),
    _MogusyncTabItem(icon: LucideIcons.search, label: 'Search'),
    _MogusyncTabItem(icon: LucideIcons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(
      context,
    ).bottom.clamp(0.0, AppCoreTokens.md);
    const contentHeight = 80.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / _items.length;

        return SizedBox(
          height: contentHeight + bottomInset,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppCoreTokens.md),
                      topRight: Radius.circular(AppCoreTokens.md),
                    ),
                    border: Border(
                      top: BorderSide(color: colorScheme.outlineVariant),
                      right: BorderSide(color: colorScheme.outlineVariant),
                      left: BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                top: 1,
                left: itemWidth * currentIndex + itemWidth / 2 - 10,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: _TabPointer(color: colorScheme.primary),
              ),
              SizedBox(
                height: contentHeight,
                child: Row(
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabButton extends StatefulWidget {
  const _TabButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _MogusyncTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 130);
    final foreground = widget.selected
        ? colorScheme.primary
        : colorScheme.onSurface;
    final scale = _pressed ? 0.94 : 1.0;

    return Semantics(
      label: widget.item.label,
      selected: widget.selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: _handleTap,
        child: SizedBox.expand(
          child: AnimatedScale(
            scale: scale,
            duration: duration,
            curve: Curves.easeOutCubic,
            child: Column(
              spacing: AppCoreTokens.xs,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.item.icon, size: 24, color: foreground),
                Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLg.copyWith(color: foreground),
                ),
              ],
            ),
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
    return SvgPicture.asset(
      'assets/miscellaneous/navigation-pointer.svg',
      width: 20,
      height: 5,
      colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
    );
  }
}

class _MogusyncTabItem {
  const _MogusyncTabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
