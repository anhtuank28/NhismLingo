import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nhims_lingo/core/services/supabase_service.dart';
import 'package:nhims_lingo/features/courses/domain/models/course_model.dart';

/// Provider lấy tất cả khóa học (đã publish) từ Supabase.
/// Tự động tính progress dựa trên user_progress.
final coursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final service = SupabaseService.instance;

  // 1. Lấy danh sách khóa học
  final coursesJson = await service.getCourses();

  // 2. Lấy tất cả user_progress (để tính % hoàn thành cho mỗi course)
  final userId = service.client.auth.currentUser?.id;
  Map<String, int> completedCountByCourse = {};

  if (userId != null) {
    final progressData = await service.client
        .from('user_progress')
        .select('course_id')
        .eq('user_id', userId)
        .eq('status', 'completed');

    for (final row in progressData) {
      final courseId = row['course_id'] as String;
      completedCountByCourse[courseId] = (completedCountByCourse[courseId] ?? 0) + 1;
    }
  }

  // 3. Map thành CourseModel với progress
  return coursesJson.map((json) {
    final courseId = json['id'] as String;
    final totalLessons = json['total_lessons'] as int? ?? 1;
    final completedCount = completedCountByCourse[courseId] ?? 0;
    final progress = totalLessons > 0 ? completedCount / totalLessons : 0.0;

    return CourseModel.fromJson(json, progress: progress.clamp(0.0, 1.0));
  }).toList();
});

/// Provider lấy danh sách categories unique từ Supabase courses.
final courseCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final courses = await ref.watch(coursesProvider.future);
  final categories = courses.map((c) => c.category).toSet().toList();
  categories.sort();
  return ['all', ...categories]; // "all" luôn đứng đầu
});
