import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';

class FillInBlankWidget extends StatefulWidget {
  final QuizQuestionModel question;
  final VoidCallback onCorrectAnswer;

  const FillInBlankWidget({
    super.key,
    required this.question,
    required this.onCorrectAnswer,
  });

  @override
  State<FillInBlankWidget> createState() => _FillInBlankWidgetState();
}

class _FillInBlankWidgetState extends State<FillInBlankWidget> {
  String? _selectedBlank;
  bool _hasAnsweredCorrectly = false;
  late List<String> _shuffledBlanks;

  @override
  void initState() {
    super.initState();
    _shuffledBlanks = List.from(widget.question.blanks ?? [])..shuffle();
  }

  void _handleSelect(String option) {
    if (_hasAnsweredCorrectly) return;

    setState(() {
      _selectedBlank = option;
    });

    if (option == widget.question.correctAnswer) {
      setState(() {
        _hasAnsweredCorrectly = true;
      });
      widget.onCorrectAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tách câu hỏi thành các phần dựa trên '___'
    final textParts = (widget.question.questionText ?? '').split('___');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit_note_rounded, size: 48, color: AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: 40),
        
        // Hiển thị câu hỏi với chỗ trống
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (textParts.isNotEmpty)
              Text(
                textParts.first,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedBlank != null ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: _selectedBlank != null ? AppColors.primaryBlue : AppColors.borderGrey,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _selectedBlank ?? '       ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _hasAnsweredCorrectly 
                      ? AppColors.successGreen 
                      : (_selectedBlank != null && _selectedBlank != widget.question.correctAnswer ? Colors.redAccent : AppColors.primaryBlue),
                ),
              ),
            ),
            if (textParts.length > 1)
              Text(
                textParts[1],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
          ],
        ),
        const SizedBox(height: 60),
        
        // Các từ gợi ý
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _shuffledBlanks.map((option) {
            final isSelected = _selectedBlank == option;
            
            return GestureDetector(
              onTap: () => _handleSelect(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.borderGrey.withValues(alpha: 0.5) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderGrey,
                    width: 2,
                  ),
                  boxShadow: isSelected 
                      ? null 
                      : const [BoxShadow(color: Color(0x0C000000), blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.transparent : AppColors.textPrimary, // Ẩn chữ nếu đã chọn để tạo hiệu ứng "bốc từ"
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
