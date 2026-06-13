import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/app_tokens.dart';

class MogusyncTextField extends StatelessWidget {
  const MogusyncTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.focusNode,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText(
          label,
          style: TextStyler()
              .fontFamily(AppTypography.family)
              .fontSize(AppTypography.bodyMd.fontSize!)
              .fontWeight(AppTypography.bodyMd.fontWeight!)
              .height(1.1)
              .color(colorScheme.onSurface),
        ),
        const SizedBox(height: AppCoreTokens.base),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          cursorColor: colorScheme.primary,
          style: AppTypography.bodyLg.copyWith(color: colorScheme.onSurface),
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surfaceBright,
            hintText: hint,
            hintStyle: AppTypography.bodyLg.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(icon, color: colorScheme.primary, size: 24),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 52,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppCoreTokens.gutter,
              vertical: AppCoreTokens.sm,
            ),
            enabledBorder: _border(colorScheme.primary, 2),
            focusedBorder: _border(colorScheme.primary, 2.5),
            errorBorder: _border(colorScheme.error, 2),
            focusedErrorBorder: _border(colorScheme.error, 2.5),
            errorStyle: AppTypography.labelSm.copyWith(
              color: colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppCoreTokens.dflt),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
