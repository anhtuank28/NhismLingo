import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';

class WordMatchingWidget extends StatefulWidget {
  final QuizQuestionModel question;
  final VoidCallback onCorrectAnswer;

  const WordMatchingWidget({
    super.key,
    required this.question,
    required this.onCorrectAnswer,
  });

  @override
  State<WordMatchingWidget> createState() => _WordMatchingWidgetState();
}

class _WordMatchingWidgetState extends State<WordMatchingWidget> {
  late List<String> _shuffledItems;
  final Set<String> _matchedItems = {};
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  void _initItems() {
    final pairs = widget.question.matchingPairs ?? {};
    final List<String> allItems = [];
    allItems.addAll(pairs.keys);
    allItems.addAll(pairs.values);
    allItems.shuffle();
    _shuffledItems = allItems;
  }

  bool _isMatch(String item1, String item2) {
    final pairs = widget.question.matchingPairs ?? {};
    // Kiểm tra xem item1 có phải key và item2 có phải value không, hoặc ngược lại
    if (pairs[item1] == item2) return true;
    if (pairs[item2] == item1) return true;
    return false;
  }

  void _handleTap(String item) async {
    if (_matchedItems.contains(item)) return; // Đã match rồi thì không bấm được nữa

    if (_selectedItem == null) {
      // Chọn item đầu tiên
      setState(() {
        _selectedItem = item;
      });
    } else {
      // Nếu bấm lại chính item đó thì bỏ chọn
      if (_selectedItem == item) {
        setState(() {
          _selectedItem = null;
        });
        return;
      }

      // Chọn item thứ 2 và kiểm tra
      final firstItem = _selectedItem!;
      final secondItem = item;
      
      if (_isMatch(firstItem, secondItem)) {
        // Đúng -> Thêm vào danh sách matched
        setState(() {
          _matchedItems.add(firstItem);
          _matchedItems.add(secondItem);
          _selectedItem = null;
        });

        // Kiểm tra chiến thắng
        if (_matchedItems.length == _shuffledItems.length) {
          widget.onCorrectAnswer();
        }
      } else {
        // Sai -> Tạm thời gán để hiện màu đỏ, sau 500ms bỏ chọn
        // TODO: Hiệu ứng rung hoặc màu đỏ (hiện tại tạm thời clear _selectedItem luôn)
        setState(() {
          _selectedItem = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          "Ghép các cặp từ có nghĩa giống nhau",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 40),
        
        // Lưới các thẻ từ
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Tắt cuộn nếu ít từ
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _shuffledItems.length,
          itemBuilder: (context, index) {
            final item = _shuffledItems[index];
            final isMatched = _matchedItems.contains(item);
            final isSelected = _selectedItem == item;

            if (isMatched) {
              // Thẻ đã ghép thành công (ẩn đi hoặc mờ đi)
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.borderGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }

            return GestureDetector(
              onTap: () => _handleTap(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : AppColors.borderGrey,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: isSelected 
                    ? null 
                    : const [BoxShadow(color: Color(0x0C000000), blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
