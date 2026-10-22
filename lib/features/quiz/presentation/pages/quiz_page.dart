import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/services/supabase_service.dart';
import 'package:nhims_lingo/core/services/audio_service.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';
import 'package:nhims_lingo/features/quiz/presentation/widgets/flashcard_widget.dart';
import 'package:nhims_lingo/features/quiz/presentation/widgets/multiple_choice_widget.dart';
import 'package:nhims_lingo/features/quiz/presentation/widgets/fill_in_blank_widget.dart';
import 'package:nhims_lingo/features/quiz/presentation/widgets/listening_widget.dart';
import 'package:nhims_lingo/features/quiz/presentation/widgets/word_matching_widget.dart';
import 'package:nhims_lingo/features/lessons/data/lessons_provider.dart';
import 'package:nhims_lingo/features/courses/data/courses_provider.dart';
import 'package:nhims_lingo/core/widgets/tactile_3d_button.dart';
import 'package:nhims_lingo/core/providers/hearts_provider.dart';
import 'package:nhims_lingo/core/theme/app_typography.dart';
import 'package:nhims_lingo/core/widgets/nhism_mascot_widget.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String lessonId;
  final String courseId;

  const QuizPage({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  List<QuizQuestionModel> _flashcards = [];
  List<QuizQuestionModel> _exercises = [];
  
  bool _isLearningPhase = true;
  int _currentIndex = 0;
  int _correctCount = 0;
  int _flashcardXp = 0;
  
  bool _isLoading = true;
  bool _canProceed = false;
  String? _errorMessage;
  String _lessonTitle = '';

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final service = SupabaseService.instance;
      final lessonData = await service.getLessonContent(widget.lessonId);

      if (lessonData == null) {
        setState(() {
          _errorMessage = 'Không tìm thấy bài học';
          _isLoading = false;
        });
        return;
      }

      _lessonTitle = lessonData['title'] as String? ?? '';
      final contentJson = lessonData['content_json'] as List<dynamic>?;

      if (contentJson == null || contentJson.isEmpty) {
        setState(() {
          _errorMessage = 'Bài học chưa có nội dung';
          _isLoading = false;
        });
        return;
      }

      final allQuestions = contentJson
          .map((q) => QuizQuestionModel.fromJson(q as Map<String, dynamic>))
          .toList();

      setState(() {
        _flashcards = allQuestions.where((q) => q.type == QuestionType.flashcard).toList();
        _exercises = allQuestions.where((q) => q.type != QuestionType.flashcard).toList();
        
        _isLearningPhase = _flashcards.isNotEmpty;
        _currentIndex = 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải bài học: $e';
        _isLoading = false;
      });
    }
  }

  void _onFlashcardFlipped() {
    if (!_canProceed) {
      setState(() => _canProceed = true);
    }
  }

  void _onCorrectAnswer() {
    setState(() {
      _correctCount++;
      _canProceed = true;
    });
  }

  void _onWrongAnswer() {
    final stillAlive = ref.read(heartsProvider.notifier).loseHeart();
    if (!stillAlive) {
      _showOutOfHeartsModal(context);
    }
  }

  void _showOutOfHeartsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.heart_broken_rounded, color: AppColors.heartRed, size: 36),
            SizedBox(width: 8),
            Text('Hết Trái tim rồi!', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.heartRed)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NhismMascotWidget(
              mood: MascotMood.worried,
              speechBubbleText: 'Đừng bỏ cuộc nha! Nạp tim để học tiếp nào!',
              size: 100,
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn đã dùng hết 5 Trái tim. Bạn có muốn nạp đầy 5 Trái tim miễn phí để tiếp tục làm bài không?',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/lessons/${widget.courseId}');
            },
            child: const Text('VỀ BẢN ĐỒ', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          ),
          Tactile3DButton(
            text: 'HỒI PHỤC NGAY (FREE)',
            variant: TactileButtonVariant.danger,
            height: 46,
            borderRadius: 16,
            isFullWidth: false,
            onPressed: () {
              ref.read(heartsProvider.notifier).refillHearts();
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _goNext() async {
    if (_isLearningPhase) {
      if (_currentIndex < _flashcards.length - 1) {
        setState(() {
          _currentIndex++;
          _canProceed = false;
          _flashcardXp += 5; // Thưởng 5 XP cho mỗi thẻ
        });
      } else {
        setState(() {
          _flashcardXp += 5; // Thưởng cho thẻ cuối cùng
        });
        
        if (_exercises.isEmpty) {
          await _finishLesson();
        } else {
          _showInterstitial();
        }
      }
    } else {
      if (_currentIndex < _exercises.length - 1) {
        setState(() {
          _currentIndex++;
          _canProceed = false;
        });
      } else {
        await _finishLesson();
      }
    }
  }

  void _showInterstitial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Hoàn thành học từ mới! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            NhismMascotWidget(
              mood: MascotMood.celebrate,
              speechBubbleText: 'Học từ mới xịn quá! Cùng chiến bài tập nào!',
              size: 90,
            ),
            SizedBox(height: 12),
            Text(
              'Bạn đã sẵn sàng để kiểm tra trí nhớ chưa?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Tactile3DButton(
            text: 'BẮT ĐẦU LÀM BÀI',
            variant: TactileButtonVariant.primary,
            height: 46,
            borderRadius: 16,
            isFullWidth: false,
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isLearningPhase = false;
                _currentIndex = 0;
                _canProceed = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _finishLesson() async {
    final totalExercises = _exercises.length;
    final score = totalExercises > 0 ? (_correctCount / totalExercises * 100).round() : 100;
    final exerciseXp = _correctCount * 10 + (_correctCount == totalExercises && totalExercises > 0 ? 20 : 0);
    final totalXpEarned = _flashcardXp + exerciseXp;

    try {
      await SupabaseService.instance.completeLesson(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        score: score,
        xpEarned: totalXpEarned,
      );
      
      ref.invalidate(lessonsProvider(widget.courseId));
      ref.invalidate(coursesProvider);
    } catch (_) {}

    AudioService.instance.playVictorySound();
    HapticFeedback.heavyImpact();

    if (mounted) {
      context.pushReplacement('/quiz-result', extra: {
        'score': _correctCount,
        'totalQuestions': totalExercises,
        'xpEarned': totalXpEarned,
        'courseId': widget.courseId,
        'lessonId': widget.lessonId,
        'lessonTitle': _lessonTitle,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryBlue),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Đang tải bài học...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 72, color: Colors.redAccent.withValues(alpha: 0.6)),
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text('Quay lại', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentList = _isLearningPhase ? _flashcards : _exercises;
    // Đảm bảo không bị lỗi nếu mảng rỗng
    if (currentList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Quay lại Trang chủ'),
          ),
        ),
      );
    }

    final question = currentList[_currentIndex];
    final progress = (_currentIndex + 1) / currentList.length;
    final hearts = ref.watch(heartsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER: Progress Bar + Close Button + Hearts =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showExitConfirmation(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 24),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            backgroundColor: const Color(0xFFE5E5E5),
                            valueColor: AlwaysStoppedAnimation(
                              progress >= 1.0 ? AppColors.successGreen : AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_currentIndex + 1}/${currentList.length}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Hearts Badge (❤️ 5)
                  GestureDetector(
                    onTap: () => _showHeartsRefillDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightHeartBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.heartRed.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_rounded, color: AppColors.heartRed, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '$hearts',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.heartRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Nhãn nhỏ chỉ ra đang ở Giai đoạn nào
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isLearningPhase ? 'HỌC TỪ MỚI' : 'BÀI TẬP KIỂM TRA',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryBlue,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            // ===== NỘI DUNG CÂU HỎI =====
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Builder(
                  builder: (context) {
                    final key = ValueKey(question.id);
                    switch (question.type) {
                      case QuestionType.flashcard:
                        return GestureDetector(
                          onTap: _onFlashcardFlipped,
                          child: FlashcardWidget(key: key, question: question),
                        );
                      case QuestionType.multipleChoice:
                        return MultipleChoiceWidget(
                          key: key,
                          question: question,
                          onCorrectAnswer: _onCorrectAnswer,
                          onWrongAnswer: _onWrongAnswer,
                        );
                      case QuestionType.fillInTheBlank:
                        return FillInBlankWidget(
                          key: key,
                          question: question,
                          onCorrectAnswer: _onCorrectAnswer,
                          onWrongAnswer: _onWrongAnswer,
                        );
                      case QuestionType.listening:
                        return ListeningWidget(
                          key: key,
                          question: question,
                          onCorrectAnswer: _onCorrectAnswer,
                          onWrongAnswer: _onWrongAnswer,
                        );
                      case QuestionType.wordMatching:
                        return WordMatchingWidget(
                          key: key,
                          question: question,
                          onCorrectAnswer: _onCorrectAnswer,
                          onWrongAnswer: _onWrongAnswer,
                        );
                    }
                  }
                ),
              ),
            ),

            // ===== NÚT TIẾP TỤC =====
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    final currentList = _isLearningPhase ? _flashcards : _exercises;
    final bool showButton = _isLearningPhase || _canProceed;
    final bool isLast = _currentIndex == currentList.length - 1;

    String buttonText = 'TIẾP TỤC';
    if (_isLearningPhase) {
      buttonText = isLast ? 'CHUYỂN SANG BÀI TẬP' : 'ĐÃ HIỂU, TIẾP TỤC';
    } else {
      buttonText = isLast ? 'XEM KẾT QUẢ' : 'TIẾP TỤC';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: showButton ? 100 : 0,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showButton ? 1.0 : 0.0,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
            Tactile3DButton(
              text: buttonText,
              variant: isLast ? TactileButtonVariant.success : TactileButtonVariant.primary,
              onPressed: showButton ? _goNext : null,
              height: 54,
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _showHeartsRefillDialog(BuildContext context) {
    final hearts = ref.read(heartsProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: AppColors.heartRed, size: 32),
            const SizedBox(width: 8),
            Text('$hearts/5 Trái tim', style: AppTypography.heading2),
          ],
        ),
        content: Text(
          hearts == 5
              ? 'Bạn đang có đủ 5 Trái tim! Mỗi khi trả lời sai sẽ bị mất 1 tim. Hãy cẩn thận nhé!'
              : 'Bạn còn $hearts tim. Khi hết tim, bạn sẽ phải bắt đầu lại bài học. Bạn có muốn nạp đầy 5 tim ngay bây giờ không?',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ĐÓNG', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          if (hearts < 5)
            ElevatedButton(
              onPressed: () {
                ref.read(heartsProvider.notifier).refillHearts();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.heartRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('HỒI PHỤC NGAY (FREE)', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }

  Future<void> _showExitConfirmation(BuildContext context) async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Thoát bài học?',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        content: const Text(
          'Tiến trình bài học sẽ không được lưu lại.',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ở LẠI', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('THOÁT', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      context.go('/lessons/${widget.courseId}');
    }
  }
}
