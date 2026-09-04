import 'package:flutter/material.dart';

class AnimatedFlame extends StatefulWidget {
  final int streakCount;
  final Color color;
  
  const AnimatedFlame({
    super.key,
    required this.streakCount,
    this.color = const Color(0xFFFF9800), // Cam mặc định
  });

  @override
  State<AnimatedFlame> createState() => _AnimatedFlameState();
}

class _AnimatedFlameState extends State<AnimatedFlame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
    ]).animate(_controller);

    _glowAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: widget.color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: _glowAnimation.value / 4,
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: widget.color,
                    size: 20,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            '${widget.streakCount}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
