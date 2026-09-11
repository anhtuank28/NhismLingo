/// Model đại diện cho 1 khóa học, ánh xạ từ bảng `courses` trên Supabase.
class CourseModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String level; // A1, A2, B1, B2, C1
  final int totalLessons;
  final String category; // speaking, vocabulary, grammar
  final double rating;
  final int reviewCount;
  final int displayOrder;

  /// Progress tính được từ `user_progress` (không nằm trong bảng `courses`)
  final double progress;

  const CourseModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.imageUrl,
    required this.level,
    required this.totalLessons,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.displayOrder = 0,
    this.progress = 0.0,
  });

  /// Parse từ JSON trả về bởi Supabase
  factory CourseModel.fromJson(Map<String, dynamic> json, {double progress = 0.0}) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      level: json['level'] as String? ?? 'A1',
      totalLessons: json['total_lessons'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      displayOrder: json['display_order'] as int? ?? 0,
      progress: progress,
    );
  }

  CourseModel copyWith({double? progress}) {
    return CourseModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      level: level,
      totalLessons: totalLessons,
      category: category,
      rating: rating,
      reviewCount: reviewCount,
      displayOrder: displayOrder,
      progress: progress ?? this.progress,
    );
  }
}
