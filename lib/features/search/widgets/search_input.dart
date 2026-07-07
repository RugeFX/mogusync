import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFocused = _focusNode.hasFocus;

    return AnimatedContainer(
      height: 54,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppCoreTokens.full),
        border: Border.all(
          color: isFocused
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.92),
          width: isFocused ? 1.4 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppCoreTokens.gutter,
          right: AppCoreTokens.base,
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.search,
              size: 22,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppCoreTokens.sm),
            Expanded(
              child: Center(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  style: AppTypography.labelLg.copyWith(
                    color: colorScheme.onSurface,
                    letterSpacing: 0.4,
                  ),
                  cursorColor: colorScheme.primary,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search and add songs here...',
                    hintStyle: AppTypography.labelLg.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
