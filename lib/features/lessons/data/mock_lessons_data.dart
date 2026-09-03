import '../domain/models/lesson_model.dart';

final List<LessonModel> mockLessons = [
  const LessonModel(id: 'l_1', title: 'Bài 1: Chào hỏi', type: LessonType.newConcept, status: LessonStatus.completed),
  const LessonModel(id: 'l_2', title: 'Bài 2: Số đếm', type: LessonType.newConcept, status: LessonStatus.completed),
  const LessonModel(id: 'l_3', title: 'Ôn tập 1', type: LessonType.review, status: LessonStatus.completed),
  const LessonModel(id: 'l_4', title: 'Phần thưởng', type: LessonType.treasure, status: LessonStatus.completed),
  const LessonModel(id: 'l_5', title: 'Bài 3: Gia đình', type: LessonType.newConcept, status: LessonStatus.current),
  const LessonModel(id: 'l_6', title: 'Bài 4: Màu sắc', type: LessonType.newConcept, status: LessonStatus.locked),
  const LessonModel(id: 'l_7', title: 'Ôn tập 2', type: LessonType.review, status: LessonStatus.locked),
  const LessonModel(id: 'l_8', title: 'Kiểm tra Unit 1', type: LessonType.test, status: LessonStatus.locked),
  const LessonModel(id: 'l_9', title: 'Bài 5: Đồ ăn', type: LessonType.newConcept, status: LessonStatus.locked),
  const LessonModel(id: 'l_10', title: 'Bài 6: Thức uống', type: LessonType.newConcept, status: LessonStatus.locked),
  const LessonModel(id: 'l_11', title: 'Phần thưởng', type: LessonType.treasure, status: LessonStatus.locked),
];
