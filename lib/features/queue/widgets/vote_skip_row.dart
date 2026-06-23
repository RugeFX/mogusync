import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';
import 'queue_visuals.dart';

class VoteSkipRow extends StatelessWidget {
  const VoteSkipRow({
    super.key,
    required this.votes,
    required this.voteTarget,
    required this.onVoteSkip,
    required this.onOpenDjTools,
    this.attached = false,
  });

  final int votes;
  final int voteTarget;
  final VoidCallback onVoteSkip;
  final VoidCallback onOpenDjTools;
  final bool attached;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (attached) {
      return _AttachedVoteSkipStrip(
        votes: votes,
        voteTarget: voteTarget,
        onVoteSkip: onVoteSkip,
        onOpenDjTools: onOpenDjTools,
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _QueueActionButton(
            label: 'Vote Skip',
            icon: LucideIcons.skipForward,
            onPressed: onVoteSkip,
            prominent: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.usersRound,
                  size: 26,
                  color: colorScheme.inversePrimary,
                ),
                const SizedBox(width: AppCoreTokens.base),
                Text('$votes/$voteTarget'),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppCoreTokens.sm),
        Expanded(
          flex: 2,
          child: _QueueActionButton(
            label: 'DJ Tools',
            icon: LucideIcons.slidersHorizontal,
            onPressed: onOpenDjTools,
          ),
        ),
      ],
    );
  }
}

class _AttachedVoteSkipStrip extends StatelessWidget {
  const _AttachedVoteSkipStrip({
    required this.votes,
    required this.voteTarget,
    required this.onVoteSkip,
    required this.onOpenDjTools,
  });

  final int votes;
  final int voteTarget;
  final VoidCallback onVoteSkip;
  final VoidCallback onOpenDjTools;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(queueCardRadius),
        bottomRight: Radius.circular(queueCardRadius),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.onPrimaryFixedVariant.withValues(alpha: 0.48),
          border: Border(
            top: BorderSide(color: colorScheme.primary.withValues(alpha: 0.42)),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 66),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppCoreTokens.gutter,
              vertical: AppCoreTokens.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PressableScale(
                    onTap: onVoteSkip,
                    borderRadius: BorderRadius.circular(AppCoreTokens.full),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppCoreTokens.base,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.skipForward,
                            size: 24,
                            color: colorScheme.primaryFixed,
                          ),
                          const SizedBox(width: AppCoreTokens.sm),
                          Expanded(
                            child: Text(
                              'Vote Skip',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMd.copyWith(
                                color: colorScheme.primaryFixed,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppCoreTokens.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppCoreTokens.sm,
                              vertical: AppCoreTokens.base,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(
                                AppCoreTokens.full,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.usersRound,
                                  size: 22,
                                  color: colorScheme.inversePrimary,
                                ),
                                const SizedBox(width: AppCoreTokens.xs),
                                Text(
                                  '$votes/$voteTarget',
                                  style: AppTypography.labelSm.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppCoreTokens.base),
                _AttachedDjToolsButton(onPressed: onOpenDjTools),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachedDjToolsButton extends StatelessWidget {
  const _AttachedDjToolsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _PressableScale(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppCoreTokens.full),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppCoreTokens.sm,
          vertical: AppCoreTokens.base,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppCoreTokens.full),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.24),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.slidersHorizontal,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppCoreTokens.xs),
            Text(
              'DJ',
              style: AppTypography.labelSm.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PressableScale extends StatefulWidget {
  const _PressableScale({
    required this.child,
    required this.onTap,
    required this.borderRadius,
  });

  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: _pressed ? 0.82 : 1,
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _QueueActionButton extends StatelessWidget {
  const _QueueActionButton({
    required this.label,
    required this.onPressed,
    this.prominent = false,
    this.icon,
    this.trailing,
  });

  final String label;
  final VoidCallback onPressed;
  final bool prominent;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = prominent
        ? colorScheme.primaryFixed
        : colorScheme.primary;

    return SizedBox(
      height: 62,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: prominent
              ? colorScheme.onPrimaryFixedVariant.withValues(alpha: 0.42)
              : colorScheme.surfaceContainer.withValues(alpha: 0.8),
          side: BorderSide(
            color: prominent
                ? colorScheme.primary.withValues(alpha: 0.58)
                : colorScheme.outlineVariant.withValues(alpha: 0.88),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppCoreTokens.sm),
          ),
          textStyle: AppTypography.bodyMd,
          padding: const EdgeInsets.symmetric(horizontal: AppCoreTokens.gutter),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) ...[
              Icon(icon, size: prominent ? 16 : 12),
              const SizedBox(width: AppCoreTokens.sm),
            ],
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppCoreTokens.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppCoreTokens.sm,
                  vertical: AppCoreTokens.base,
                ),
                decoration: BoxDecoration(
                  color: prominent
                      ? colorScheme.primaryFixed
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppCoreTokens.full),
                ),
                child: DefaultTextStyle.merge(
                  style: AppTypography.bodyMd.copyWith(
                    color: prominent
                        ? colorScheme.onPrimaryFixed
                        : colorScheme.onSurface,
                  ),
                  child: trailing!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
