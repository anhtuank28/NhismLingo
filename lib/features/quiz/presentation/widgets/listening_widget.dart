import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';
import 'package:nhims_lingo/core/services/tts_service.dart';

class ListeningWidget extends StatefulWidget {
  final QuizQuestionModel question;
  final VoidCallback onCorrectAnswer;

  const ListeningWidget({
    super.key,
    required this.question,
    required this.onCorrectAnswer,
  });

  @override
  State<ListeningWidget> createState() => _ListeningWidgetState();
}

class _ListeningWidgetState extends State<ListeningWidget> {
  int? _selectedIndex;
  bool _hasAnsweredCorrectly = false;
  late List<String> _shuffledOptions;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _shuffledOptions = List.from(widget.question.options ?? [])..shuffle();
    // Tự động phát âm thanh khi mở câu hỏi
    _playAudio(normalSpeed: true);
  }

  Future<void> _playAudio({required bool normalSpeed}) async {
    setState(() => _isPlaying = true);
    // TODO: Bổ sung logic chỉnh speed trong TTSService sau nếu cần, tạm thời dùng mặc định
    await TTSService.instance.speak(widget.question.word);
    if (mounted) setState(() => _isPlaying = false);
  }

  void _handleSelect(int index) {
    if (_hasAnsweredCorrectly) return;

    setState(() {
      _selectedIndex = index;
    });

    final selectedOption = _shuffledOptions[index];
    if (selectedOption == widget.question.correctAnswer) {
      setState(() {
        _hasAnsweredCorrectly = true;
      });
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          "Nghe và chọn đáp án đúng",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 40),
        
        // Nút Phát Âm
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _playAudio(normalSpeed: true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: _isPlaying ? AppColors.primaryBlue : AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (_isPlaying)
                      BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  size: 64,
                  color: _isPlaying ? Colors.white : AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        
        // Các đáp án (Tương tự Multiple Choice)
        if (_shuffledOptions.isNotEmpty)
          ...List.generate(_shuffledOptions.length, (index) {
            final isSelected = _selectedIndex == index;
            final isCorrectAnswer = _shuffledOptions[index] == widget.question.correctAnswer;
            
            Color borderColor = AppColors.borderGrey;
            Color bgColor = Colors.white;
            Color textColor = AppColors.textPrimary;
            
            if (isSelected) {
              if (isCorrectAnswer) {
                borderColor = AppColors.successGreen;
                bgColor = AppColors.successGreen.withValues(alpha: 0.1);
                textColor = AppColors.successGreen;
              } else {
                borderColor = Colors.redAccent;
                bgColor = Colors.redAccent.withValues(alpha: 0.1);
                textColor = Colors.redAccent;
              }
            } else if (_hasAnsweredCorrectly && isCorrectAnswer) {
              borderColor = AppColors.successGreen;
              bgColor = AppColors.successGreen.withValues(alpha: 0.1);
              textColor = AppColors.successGreen;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () => _handleSelect(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: isSelected ? 2 : 1.5,
                    ),
                  ),
                  child: Text(
                    _shuffledOptions[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
