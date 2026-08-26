import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mô hình dữ liệu tiến độ của người dùng
class UserProgress {
  final int streak;
  final int lessonsCompleted;
  final int totalXp;

  const UserProgress({
    this.streak = 0,
    this.lessonsCompleted = 0,
    this.totalXp = 0,
  });

  UserProgress copyWith({
    int? streak,
    int? lessonsCompleted,
    int? totalXp,
  }) {
    return UserProgress(
      streak: streak ?? this.streak,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      totalXp: totalXp ?? this.totalXp,
    );
  }
}

// Logic quản lý trạng thái tiến độ (Notifier)
class UserProgressNotifier extends StateNotifier<UserProgress> {
  UserProgressNotifier() 
    : super(const UserProgress(
        // Khởi tạo dữ liệu giả lập (Mock data) giống hệt thiết kế giao diện màn Profile
        streak: 14,
        lessonsCompleted: 42,
        totalXp: 2400,
      ));

  // Ví dụ hàm tăng XP (được gọi sau khi học xong bài)
  void addXp(int amount) {
    state = state.copyWith(totalXp: state.totalXp + amount);
  }

  // Ví dụ hàm hoàn thành bài học
  void completeLesson() {
    state = state.copyWith(lessonsCompleted: state.lessonsCompleted + 1);
  }
}

// Trạm phát sóng dữ liệu (Provider) để các màn hình lắng nghe
final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  return UserProgressNotifier();
});
