import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/theme/app_typography.dart';

enum MascotMood { idle, happy, thinking, worried, celebrate, curious }

class NhismMascotWidget extends StatefulWidget {
  final MascotMood mood;
  final String? speechBubbleText;
  final double size;

  const NhismMascotWidget({
    super.key,
    this.mood = MascotMood.idle,
    this.speechBubbleText,
    this.size = 120,
  });

  @override
  State<NhismMascotWidget> createState() => _NhismMascotWidgetState();
}

class _NhismMascotWidgetState extends State<NhismMascotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Bong bóng hội thoại (Speech Bubble) nếu có
        if (widget.speechBubbleText != null && widget.speechBubbleText!.isNotEmpty) ...[
          _buildSpeechBubble(widget.speechBubbleText!),
          const SizedBox(height: 8),
        ],

        // 2. Bé Nhím Mascot với hiệu ứng nhún nhảy
        AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: child,
            );
          },
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Vòng hào quang sáng phía sau nếu đang ăn mừng
                if (widget.mood == MascotMood.celebrate || widget.mood == MascotMood.happy)
                  Container(
                    width: widget.size * 0.9,
                    height: widget.size * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.streakGlow.withValues(alpha: 0.3),
                    ),
                  ),

                // Thử load hoạt ảnh Rive hedgehog.riv, nếu lỗi fallback sang Vector vẽ tay
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const RiveAnimation.asset(
                    'assets/rive/hedgehog.riv',
                    fit: BoxFit.contain,
                    animations: ['idle'],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeechBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
