import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nhims_lingo/core/services/supabase_service.dart';
import 'package:nhims_lingo/features/lessons/domain/models/lesson_model.dart';

/// Provider lấy danh sách bài học theo courseId từ Supabase,
/// kết hợp user_progress để xác định status (completed / current / locked).
final lessonsProvider = FutureProvider.family<List<LessonModel>, String>((ref, courseId) async {
  final service = SupabaseService.instance;

  // 1. Lấy tất cả bài học của khóa (sắp theo lesson_order)
  final lessonsJson = await service.getLessonsByCourse(courseId);

  // 2. Lấy user_progress cho khóa này
  final progressData = await service.getUserProgress(courseId);
  final completedLessonIds = progressData
      .where((p) => p['status'] == 'completed')
      .map((p) => p['lesson_id'] as String)
      .toSet();

  // 3. Tìm index của bài hiện tại (bài đầu tiên chưa hoàn thành)
  int currentIndex = lessonsJson.length; // Mặc định: tất cả đã hoàn thành
  for (int i = 0; i < lessonsJson.length; i++) {
    final lessonId = lessonsJson[i]['id'] as String;
    if (!completedLessonIds.contains(lessonId)) {
      currentIndex = i;
      break;
    }
  }

  // 4. Map thành LessonModel với status chính xác
  return List.generate(lessonsJson.length, (i) {
    return LessonModel.fromSupabaseWithProgress(
      lessonsJson[i],
      completedLessonIds: completedLessonIds,
      currentIndex: currentIndex,
      lessonIndex: i,
    );
  });
});

/// Provider lấy tên khóa học từ courseId (dùng cho AppBar)
final courseNameProvider = FutureProvider.family<String, String>((ref, courseId) async {
  final service = SupabaseService.instance;
  final courses = await service.getCourses();
  final course = courses.firstWhere(
    (c) => c['id'] == courseId,
    orElse: () => {'title': 'Khóa học'},
  );
  return course['title'] as String? ?? 'Khóa học';
});
