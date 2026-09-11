import 'package:supabase_flutter/supabase_flutter.dart';

/// Service tập trung để giao tiếp với Supabase.
/// Tất cả các repository sẽ gọi qua đây thay vì truy cập trực tiếp SupabaseClient.
class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;

  SupabaseService._() {
    _client = Supabase.instance.client;
  }

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseClient get client => _client;

  // ========================================
  // PROFILES
  // ========================================

  /// Lấy profile của user đang đăng nhập
  Future<Map<String, dynamic>?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  /// Cập nhật profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from('profiles')
        .update({...data, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }

  /// Lấy top N người chơi cho Leaderboard (sắp theo XP giảm dần)
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 20}) async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, avatar_url, level, total_xp, streak_days')
        .order('total_xp', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  // ========================================
  // COURSES
  // ========================================

  /// Lấy tất cả khóa học (đã publish)
  Future<List<Map<String, dynamic>>> getCourses() async {
    final response = await _client
        .from('courses')
        .select()
        .eq('is_published', true)
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Lấy khóa học theo category
  Future<List<Map<String, dynamic>>> getCoursesByCategory(String category) async {
    final response = await _client
        .from('courses')
        .select()
        .eq('is_published', true)
        .eq('category', category)
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  // ========================================
  // LESSONS
  // ========================================

  /// Lấy tất cả bài học của 1 khóa (sắp theo thứ tự)
  Future<List<Map<String, dynamic>>> getLessonsByCourse(String courseId) async {
    final response = await _client
        .from('lessons')
        .select()
        .eq('course_id', courseId)
        .order('lesson_order', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Lấy nội dung (content_json) của 1 bài học
  Future<Map<String, dynamic>?> getLessonContent(String lessonId) async {
    final response = await _client
        .from('lessons')
        .select()
        .eq('id', lessonId)
        .maybeSingle();

    return response;
  }

  // ========================================
  // USER PROGRESS
  // ========================================

  /// Lấy tiến độ của user cho 1 khóa học
  Future<List<Map<String, dynamic>>> getUserProgress(String courseId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .eq('course_id', courseId);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Đánh dấu hoàn thành 1 bài học + cộng XP
  Future<void> completeLesson({
    required String courseId,
    required String lessonId,
    required int score,
    required int xpEarned,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    // 1. Upsert tiến độ bài học
    await _client.from('user_progress').upsert({
      'user_id': userId,
      'course_id': courseId,
      'lesson_id': lessonId,
      'status': 'completed',
      'score': score,
      'completed_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id, lesson_id');

    // 2. Cộng XP vào profile
    final profile = await getCurrentProfile();
    if (profile != null) {
      final currentXp = profile['total_xp'] as int? ?? 0;
      final currentStreak = profile['streak_days'] as int? ?? 0;
      final lastActive = profile['last_active_date'] as String?;

      // Tính streak
      int newStreak = currentStreak;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      if (lastActive == null) {
        newStreak = 1; // Học bài đầu tiên từ lúc tạo tài khoản
      } else if (lastActive != today) {
        final lastDate = DateTime.parse(lastActive);
        // Reset thời gian về 00:00:00 để so sánh số ngày chênh lệch chuẩn xác
        final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
        final todayOnly = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        final diff = todayOnly.difference(lastDateOnly).inDays;
        
        if (diff == 1) {
          newStreak = currentStreak + 1; // Liên tiếp
        } else if (diff > 1) {
          newStreak = 1; // Reset streak vì bỏ lỡ ngày
        }
      }

      // Tính level mới (mỗi 500 XP = 1 level)
      final newXp = currentXp + xpEarned;
      final newLevel = (newXp / 500).floor() + 1;

      await updateProfile({
        'total_xp': newXp,
        'level': newLevel,
        'streak_days': newStreak,
        'last_active_date': today,
      });
    }
  }
}
