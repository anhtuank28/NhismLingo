enum LessonStatus {
  completed,
  current,
  locked,
}

enum LessonType {
  newConcept,
  review,
  test,
  treasure,
}

class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final LessonType type;
  final LessonStatus status;
  final int lessonOrder;
  final int totalExp;
  /// Nội dung câu hỏi dạng JSON (List<Map>), null nếu chưa load chi tiết
  final List<dynamic>? contentJson;

  const LessonModel({
    required this.id,
    this.courseId = '',
    required this.title,
    required this.type,
    required this.status,
    this.lessonOrder = 0,
    this.totalExp = 10,
    this.contentJson,
  });

  /// Parse từ JSON trả về bởi Supabase (bảng `lessons`)
  factory LessonModel.fromJson(Map<String, dynamic> json, {LessonStatus status = LessonStatus.locked}) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: _parseType(json['type'] as String?),
      status: status,
      lessonOrder: json['lesson_order'] as int? ?? 0,
      totalExp: json['xp_reward'] as int? ?? 10,
      contentJson: json['content_json'] as List<dynamic>?,
    );
  }

  /// Tạo LessonModel từ Supabase data + user_progress để xác định status
  /// [completedLessonIds]: Set các lesson_id đã hoàn thành
  /// [currentIndex]: index của bài hiện tại (bài đầu tiên chưa hoàn thành)
  /// [lessonIndex]: vị trí của bài này trong danh sách
  factory LessonModel.fromSupabaseWithProgress(
    Map<String, dynamic> json, {
    required Set<String> completedLessonIds,
    required int currentIndex,
    required int lessonIndex,
  }) {
    final id = json['id'] as String;
    LessonStatus status;
    
    if (completedLessonIds.contains(id)) {
      status = LessonStatus.completed;
    } else if (lessonIndex == currentIndex) {
      status = LessonStatus.current;
    } else {
      status = LessonStatus.locked;
    }

    return LessonModel.fromJson(json, status: status);
  }

  static LessonType _parseType(String? type) {
    switch (type) {
      case 'new_concept':
        return LessonType.newConcept;
      case 'review':
        return LessonType.review;
      case 'test':
        return LessonType.test;
      case 'treasure':
        return LessonType.treasure;
      default:
        return LessonType.newConcept;
    }
  }

  LessonModel copyWith({LessonStatus? status}) {
    return LessonModel(
      id: id,
      courseId: courseId,
      title: title,
      type: type,
      status: status ?? this.status,
      lessonOrder: lessonOrder,
      totalExp: totalExp,
      contentJson: contentJson,
    );
  }
}
