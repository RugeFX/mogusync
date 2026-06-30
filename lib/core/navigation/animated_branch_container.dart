import 'package:flutter/material.dart';

class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  static const _duration = Duration(milliseconds: 200);
  static const _horizontalOffset = 0.04;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : _duration;

    return Stack(
      fit: StackFit.expand,
      children: [
        for (var index = 0; index < children.length; index += 1)
          _AnimatedBranch(
            active: index == currentIndex,
            offset: _inactiveOffset(index),
            duration: duration,
            child: children[index],
          ),
      ],
    );
  }

  Offset _inactiveOffset(int index) {
    return Offset(
      index < currentIndex ? -_horizontalOffset : _horizontalOffset,
      0,
    );
  }
}

class _AnimatedBranch extends StatelessWidget {
  const _AnimatedBranch({
    required this.active,
    required this.offset,
    required this.duration,
    required this.child,
  });

  final bool active;
  final Offset offset;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !active,
      child: ExcludeSemantics(
        excluding: !active,
        child: AnimatedOpacity(
          opacity: active ? 1 : 0,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: active ? Offset.zero : offset,
            duration: duration,
            curve: Curves.easeOutCubic,
            child: TickerMode(
              enabled: active,
              child: RepaintBoundary(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
