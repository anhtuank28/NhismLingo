import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final QuizQuestionModel question;
  final VoidCallback onCorrectAnswer;

  const MultipleChoiceWidget({
    super.key,
    required this.question,
    required this.onCorrectAnswer,
  });

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  int? _selectedIndex;
  bool _hasAnsweredCorrectly = false;
  late List<String> _shuffledOptions;

  @override
  void initState() {
    super.initState();
    // Tạo bản sao của mảng options và xáo trộn nó
    _shuffledOptions = List.from(widget.question.options ?? [])..shuffle();
  }

  void _handleSelect(int index) {
    if (_hasAnsweredCorrectly) return; // Nếu đã đúng rồi thì không cho bấm nữa

    setState(() {
      _selectedIndex = index;
    });

    final selectedOption = _shuffledOptions[index];
    if (selectedOption == widget.question.correctAnswer) {
      setState(() {
        _hasAnsweredCorrectly = true;
      });
      // Gọi callback để QuizPage hiển thị nút Next
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        // Icon trang trí nhỏ
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline_rounded, size: 48, color: AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: 32),
        
        // Câu hỏi
        Text(
          widget.question.questionText ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 40),
        
        // Danh sách 4 đáp án
        if (_shuffledOptions.isNotEmpty)
          ...List.generate(_shuffledOptions.length, (index) {
            final isSelected = _selectedIndex == index;
            final isCorrectAnswer = _shuffledOptions[index] == widget.question.correctAnswer;
            
            // Logic đổ màu
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
              // Nếu user vừa chọn sai, sau đó chọn lại đúng câu này
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
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: borderColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // STT (A, B, C, D)
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? borderColor : AppColors.borderGrey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Nội dung đáp án
                      Expanded(
                        child: Text(
                          _shuffledOptions[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      // Icon check/close nếu đang được chọn
                      if (isSelected)
                        Icon(
                          isCorrectAnswer ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: borderColor,
                          size: 28,
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
