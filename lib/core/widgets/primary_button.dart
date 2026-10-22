import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color shadowColor;
  final bool isLoading;
  final double height;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryBlue,
    this.shadowColor = AppColors.primaryBlueShadow,
    this.isLoading = false,
    this.height = 54,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;
  static const double _depth = 4.0;

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
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final faceColor = isEnabled ? widget.backgroundColor : const Color(0xFFE5E7EB);
    final shadowColor = isEnabled ? widget.shadowColor : const Color(0xFFD1D5DB);
    final textColor = isEnabled ? Colors.white : const Color(0xFF9CA3AF);

    final effectiveTopPadding = _isPressed ? _depth : 0.0;
    final effectiveBottomOffset = _isPressed ? 0.0 : _depth;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(top: effectiveTopPadding, bottom: _depth - effectiveTopPadding),
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: faceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
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
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: textColor, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text.toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
