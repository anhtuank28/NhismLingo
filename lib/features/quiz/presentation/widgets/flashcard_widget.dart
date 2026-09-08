import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';
import 'package:nhims_lingo/core/services/tts_service.dart';

class FlashcardWidget extends StatefulWidget {
  final QuizQuestionModel question;

  const FlashcardWidget({
    super.key,
    required this.question,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu chuyển sang từ mới (question mới) thì phải lật ngược lại về mặt trước
    if (oldWidget.question.id != widget.question.id && _isFlipped) {
      _isFlipped = false;
      _controller.reverse(from: 1.0); // Quay ngược lại thật nhanh
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          // Xác định xem đang ở mặt trước (angle < 90 độ) hay mặt sau (angle > 90 độ)
          final isFront = angle < pi / 2;
          
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Thêm phối cảnh 3D
              ..rotateY(angle), // Xoay quanh trục Y
            alignment: Alignment.center,
            child: isFront
                ? _buildFrontFace()
                : Transform(
                    // Lật ngược lại nội dung mặt sau để chữ không bị ngược gương
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _buildBackFace(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBaseCard({required List<Widget> children, required bool isFront}) {
    return Container(
      width: double.infinity,
      // Đặt một minHeight để khi lật card không bị giật do thay đổi kích thước đột ngột
      constraints: const BoxConstraints(minHeight: 400), 
      decoration: BoxDecoration(
        color: isFront ? Colors.white : const Color(0xFFF0F5FA), // Mặt sau có màu hơi xám xanh
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderGrey, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Sửa MainAxisSize.min để ôm trọn content
        children: children,
      ),
    );
  }

  Widget _buildFrontFace() {
    return _buildBaseCard(
      isFront: true,
      children: [
        const SizedBox(height: 40),
        // Word Class Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF58CC02).withOpacity(0.15),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            widget.question.wordClass,
            style: const TextStyle(
              color: AppColors.successGreen,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
        
        // Main Word
        Text(
          widget.question.word,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        // Phonetic and Audio
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.question.phonetic,
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.lightBlueBg,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryBlue),
                onPressed: () {
                  // Gọi Singleton TTSService để phát âm từ vựng tiếng Anh
                  TTSService.instance.speak(widget.question.word);
                },
              ),
            ),
          ],
        ),
        // Example Sentence (English part on front)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5FA), // Màu xanh xám nhạt như bản thiết kế
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildExampleSentence(),
        ),
        const SizedBox(height: 32),
        const Text(
          "Nhấn để xem nghĩa",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBackFace() {
    return _buildBaseCard(
      isFront: false,
      children: [
        const SizedBox(height: 40),
        // Meaning (Vietnamese)
        Text(
          widget.question.meaning,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28, // Chữ to hơn ở mặt sau
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900, 
          ),
        ),
        const SizedBox(height: 32),
        
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: widget.question.imageUrl != null
                ? Image.network(
                    widget.question.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.borderGrey,
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleSentence() {
    if (widget.question.highlightWord.isEmpty) {
      return Text(
        '"${widget.question.exampleSentence}"',
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: AppColors.textPrimary,
        ),
      );
    }

    final lowerSentence = widget.question.exampleSentence.toLowerCase();
    final lowerHighlight = widget.question.highlightWord.toLowerCase();
    
    final startIndex = lowerSentence.indexOf(lowerHighlight);
    
    if (startIndex == -1) {
       return Text(
        '"${widget.question.exampleSentence}"',
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: AppColors.textPrimary,
        ),
      );
    }

    final String beforeText = widget.question.exampleSentence.substring(0, startIndex);
    final String highlightText = widget.question.exampleSentence.substring(startIndex, startIndex + widget.question.highlightWord.length);
    final String afterText = widget.question.exampleSentence.substring(startIndex + widget.question.highlightWord.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        children: [
          TextSpan(text: '"$beforeText'),
          TextSpan(
            text: highlightText,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(text: '$afterText"'),
        ],
      ),
    );
  }
}
