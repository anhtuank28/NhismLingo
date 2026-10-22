import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/theme/app_typography.dart';

enum TactileButtonVariant { primary, success, danger, warning, secondary }

class Tactile3DButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TactileButtonVariant variant;
  final IconData? icon;
  final IconData? leadingIcon;
  final bool isLoading;
  final double height;
  final double? width;
  final double borderRadius;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const Tactile3DButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = TactileButtonVariant.primary,
    this.icon,
    this.leadingIcon,
    this.isLoading = false,
    this.height = 54.0,
    this.width,
    this.borderRadius = 16.0,
    this.isFullWidth = true,
    this.padding,
    this.textStyle,
  });

  @override
  State<Tactile3DButton> createState() => _Tactile3DButtonState();
}

class _Tactile3DButtonState extends State<Tactile3DButton> {
  bool _isPressed = false;
  static const double _depth = 4.0; // Độ dày khối cơ học

  Color get _faceColor {
    if (widget.onPressed == null) return const Color(0xFFE5E7EB);
    switch (widget.variant) {
      case TactileButtonVariant.primary:
        return AppColors.primaryBlue;
      case TactileButtonVariant.success:
        return AppColors.successGreen;
      case TactileButtonVariant.danger:
        return AppColors.heartRed;
      case TactileButtonVariant.warning:
        return AppColors.streakOrange;
      case TactileButtonVariant.secondary:
        return Colors.white;
    }
  }

  Color get _shadowColor {
    if (widget.onPressed == null) return const Color(0xFFD1D5DB);
    switch (widget.variant) {
      case TactileButtonVariant.primary:
        return AppColors.primaryBlueShadow;
      case TactileButtonVariant.success:
        return AppColors.successGreenShadow;
      case TactileButtonVariant.danger:
        return AppColors.heartRedShadow;
      case TactileButtonVariant.warning:
        return AppColors.streakOrangeShadow;
      case TactileButtonVariant.secondary:
        return const Color(0xFFE0E0E0);
    }
  }

  Color get _textColor {
    if (widget.onPressed == null) return const Color(0xFF9CA3AF);
    if (widget.variant == TactileButtonVariant.secondary) return AppColors.textPrimary;
    return Colors.white;
  }

  IconData? get _effectiveIcon => widget.icon ?? widget.leadingIcon;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTopPadding = _isPressed ? _depth : 0.0;
    final effectiveBottomOffset = _isPressed ? 0.0 : _depth;
    final effectiveWidth = widget.width ?? (widget.isFullWidth ? double.infinity : null);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(top: effectiveTopPadding, bottom: _depth - effectiveTopPadding),
        child: Container(
          height: widget.height,
          width: effectiveWidth,
          padding: widget.padding ?? (widget.isFullWidth ? null : const EdgeInsets.symmetric(horizontal: 20)),
          decoration: BoxDecoration(
            color: _faceColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.variant == TactileButtonVariant.secondary
                ? Border.all(color: const Color(0xFFE5E7EB), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: _shadowColor,
                offset: Offset(0, effectiveBottomOffset),
                blurRadius: 0,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_effectiveIcon != null) ...[
                      Icon(_effectiveIcon, color: _textColor, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text.toUpperCase(),
                      style: (widget.textStyle ?? AppTypography.buttonLabel).copyWith(color: _textColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
