import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/data/mock_quiz_data.dart';
import 'package:nhims_lingo/features/quiz/presentation/widgets/flashcard_widget.dart';

class QuizPage extends StatefulWidget {
  final String lessonTitle;

  const QuizPage({
    super.key,
    required this.lessonTitle,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  final int _totalQuestions = mockQuizQuestions.length;

  void _nextQuestion() {
    if (_currentIndex < _totalQuestions - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Hoàn thành bài học
      _showCompletionDialog();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Tuyệt vời!', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.successGreen, fontSize: 24)),
          content: const Text(
            'Bạn đã hoàn thành bài học xuất sắc! +10 XP',
            style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.of(context).pop(); // Quay lại bản đồ
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
              ),
              child: const Text('TIẾP TỤC', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = mockQuizQuestions[_currentIndex];
    final double progress = (_currentIndex + 1) / _totalQuestions;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Màu nền sáng nhẹ
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lesson Detail',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          // Giả lập avatar góc phải
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.borderGrey,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.lessonTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_currentIndex + 1} / $_totalQuestions Words',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.borderGrey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 12,
                        width: (MediaQuery.of(context).size.width - 48) * progress, // Fix layout
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content Area (Flashcard)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FlashcardWidget(question: currentQuestion),
              ),
            ),
            
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1)),
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    TextButton.icon(
                      onPressed: _previousQuestion,
                      icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
                      label: const Text(
                        'Previous',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 100), // Placeholder to balance row
                  
                  const Spacer(),
                  
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0, // Flat design cho button này
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentIndex == _totalQuestions - 1 ? 'Finish' : 'Next Word',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
