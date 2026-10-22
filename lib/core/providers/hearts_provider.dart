import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeartsNotifier extends StateNotifier<int> {
  static const int maxHearts = 5;

  HeartsNotifier() : super(maxHearts);

  /// Giảm 1 tim khi trả lời sai bài tập.
  /// Trả về true nếu còn tim, false nếu hết tim (Game Over / cần hồi phục).
  bool loseHeart() {
    if (state > 0) {
      state = state - 1;
    }
    return state > 0;
  }

  /// Hồi phục đầy 5 tim (bằng Gems hoặc sau thời gian chờ)
  void refillHearts() {
    state = maxHearts;
  }

  /// Thêm 1 tim (tối đa 5)
  void addHeart() {
    if (state < maxHearts) {
      state = state + 1;
    }
  }
}

final heartsProvider = StateNotifierProvider<HeartsNotifier, int>((ref) {
  return HeartsNotifier();
});
