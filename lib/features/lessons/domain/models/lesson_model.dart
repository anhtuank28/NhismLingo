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
  final String title;
  final LessonType type;
  final LessonStatus status;
  final int totalExp;

  const LessonModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.totalExp = 10,
  });
}
