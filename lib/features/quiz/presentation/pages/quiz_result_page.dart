import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int xpEarned;
  final String courseId;
  final String lessonId;
  final String lessonTitle;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.xpEarned,
    required this.courseId,
    required this.lessonId,
    this.lessonTitle = '',
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _starsController;
  late AnimationController _xpController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _starsAnimation;
  late Animation<int> _xpCountAnimation;

  double get percentage => widget.totalQuestions > 0 ? widget.score / widget.totalQuestions : 0;

  @override
  void initState() {
    super.initState();

    // Animation 1: Vòng tròn điểm (0% → actual %)
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: percentage).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );

    // Animation 2: Ngôi sao (scale 0 → 1) 
    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _starsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.elasticOut),
    );

    // Animation 3: XP đếm lên (0 → xpEarned)
    _xpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _xpCountAnimation = IntTween(begin: 0, end: widget.xpEarned).animate(
      CurvedAnimation(parent: _xpController, curve: Curves.easeOut),
    );

    // Chạy animation theo chuỗi
    _scoreController.forward().then((_) {
      _starsController.forward();
      _xpController.forward();
    });
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _starsController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPerfect = percentage >= 1.0;
    final isGreat = percentage >= 0.8;
    final isGood = percentage >= 0.5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // ===== EMOJI + TIÊU ĐỀ =====
              Text(
                isPerfect ? '🎉' : isGreat ? '🌟' : isGood ? '👍' : '💪',
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              Text(
                isPerfect
                    ? 'Hoàn hảo!'
                    : isGreat
                        ? 'Xuất sắc!'
                        : isGood
                            ? 'Tốt lắm!'
                            : 'Cố gắng thêm!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              if (widget.lessonTitle.isNotEmpty)
                Text(
                  widget.lessonTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),

              const SizedBox(height: 40),

              // ===== VÒNG TRÒN ĐIỂM =====
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Vòng nền xám
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 14,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation(Color(0xFFE5E5E5)),
                          ),
                        ),
                        // Vòng progress (animation)
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: _scoreAnimation.value,
                            strokeWidth: 14,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(
                              isGreat ? AppColors.successGreen : isGood ? AppColors.warningYellow : Colors.redAccent,
                            ),
                          ),
                        ),
                        // Số điểm ở giữa
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(_scoreAnimation.value * widget.totalQuestions).round()}/${widget.totalQuestions}',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: isGreat ? AppColors.successGreen : isGood ? AppColors.warningYellow : Colors.redAccent,
                              ),
                            ),
                            Text(
                              'câu đúng',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ===== NGÔI SAO =====
              AnimatedBuilder(
                animation: _starsAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _starsAnimation.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isLit = (index == 0 && percentage >= 0.3) ||
                            (index == 1 && percentage >= 0.6) ||
                            (index == 2 && percentage >= 0.9);
                        final size = index == 1 ? 48.0 : 36.0; // Sao giữa to hơn
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            isLit ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: isLit ? AppColors.warningYellow : const Color(0xFFE5E5E5),
                            size: size,
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ===== XP EARNED =====
              AnimatedBuilder(
                animation: _xpCountAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.primaryBlue, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          '+${_xpCountAnimation.value} XP',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // ===== NÚT BẤM =====
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Quay về bản đồ bài học (pop quiz + quiz-result)
                    context.go('/lessons/${widget.courseId}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'TIẾP TỤC',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nút "Học lại"
              if (!isGreat)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      context.pushReplacement('/quiz/${widget.lessonId}?courseId=${widget.courseId}');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'HỌC LẠI',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
