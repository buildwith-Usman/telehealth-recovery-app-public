import 'package:flutter/material.dart';
import 'dart:async';

/// Enhanced AppText widget with better performance and features
class EnhancedAppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool selectable;
  final String? semanticsLabel;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const EnhancedAppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.selectable = false,
    this.semanticsLabel,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  // Pre-defined styles for consistency
  const EnhancedAppText.heading(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.color,
  })  : style = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        selectable = false,
        fontSize = 24,
        fontWeight = FontWeight.bold;

  const EnhancedAppText.subtitle(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.color,
  })  : style = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        selectable = false,
        fontSize = 18,
        fontWeight = FontWeight.w600;

  const EnhancedAppText.body(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.color,
  })  : style = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        selectable = false,
        fontSize = 14,
        fontWeight = FontWeight.normal;

  const EnhancedAppText.caption(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.color,
  })  : style = const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        selectable = false,
        fontSize = 12,
        fontWeight = FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = _buildEffectiveStyle(context);

    if (selectable) {
      return SelectableText(
        text,
        style: effectiveStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
    }

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }

  TextStyle _buildEffectiveStyle(BuildContext context) {
    final theme = Theme.of(context);
    var effectiveStyle =
        style ?? theme.textTheme.bodyMedium ?? const TextStyle();

    if (color != null) {
      effectiveStyle = effectiveStyle.copyWith(color: color);
    }
    if (fontSize != null) {
      effectiveStyle = effectiveStyle.copyWith(fontSize: fontSize);
    }
    if (fontWeight != null) {
      effectiveStyle = effectiveStyle.copyWith(fontWeight: fontWeight);
    }

    return effectiveStyle;
  }
}

/// Enhanced button with better state management
class EnhancedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const EnhancedButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.style,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !isEnabled || onPressed == null || isLoading;

    Widget buttonChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(title),
              ],
            ),
    );

    final effectiveStyle = style ??
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          minimumSize: Size(width ?? 0, height ?? 44),
        );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: effectiveStyle,
        child: buttonChild,
      ),
    );
  }
}

/// Enhanced input field with validation
class EnhancedTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final bool showValidationIcon;
  final Duration debounceDuration;

  const EnhancedTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.showValidationIcon = true,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  String? _errorText;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      _validateInput();
      widget.onChanged?.call(_controller.text);
    });
  }

  void _validateInput() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      setState(() {
        _errorText = error;
        _isValid = error == null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          onTap: widget.onTap,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            errorText: _errorText,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isValid
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) return widget.suffixIcon;

    if (widget.showValidationIcon && _controller.text.isNotEmpty) {
      return Icon(
        _isValid ? Icons.check_circle : Icons.error,
        color: _isValid ? Colors.green : Theme.of(context).colorScheme.error,
      );
    }

    return null;
  }
}
