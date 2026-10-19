import 'package:flutter_test/flutter_test.dart';
import 'package:nhims_lingo/features/courses/domain/models/course_model.dart';
import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';

void main() {
  group('CourseModel Unit Tests', () {
    test('CourseModel.fromJson parses fields correctly', () {
      final json = {
        'id': 'course-123',
        'title': 'Tiếng Anh Giao Tiếp',
        'description': 'Khóa học giao tiếp cơ bản',
        'image_url': 'https://example.com/image.png',
        'level': 'A1',
        'total_lessons': 10,
        'category': 'speaking',
        'rating': 4.8,
        'review_count': 120,
        'display_order': 1,
      };

      final course = CourseModel.fromJson(json, progress: 0.5);

      expect(course.id, 'course-123');
      expect(course.title, 'Tiếng Anh Giao Tiếp');
      expect(course.level, 'A1');
      expect(course.totalLessons, 10);
      expect(course.category, 'speaking');
      expect(course.rating, 4.8);
      expect(course.progress, 0.5);
    });

    test('CourseModel copyWith updates progress accurately', () {
      const course = CourseModel(
        id: '1',
        title: 'Title',
        imageUrl: '',
        level: 'A1',
        totalLessons: 5,
        category: 'grammar',
        progress: 0.0,
      );

      final updated = course.copyWith(progress: 0.8);
      expect(updated.progress, 0.8);
      expect(updated.title, 'Title');
    });
  });

  group('QuizQuestionModel Unit Tests', () {
    test('QuizQuestionModel parses flashcard type properly', () {
      final json = {
        'id': 'q-1',
        'type': 'flashcard',
        'word': 'Bespoke',
        'word_class': 'ADJECTIVE',
        'phonetic': '/bɪˈspoʊk/',
        'meaning': 'Được đặt làm riêng',
        'example_sentence': 'He wore a bespoke suit.',
        'highlight_word': 'bespoke',
      };

      final question = QuizQuestionModel.fromJson(json);

      expect(question.id, 'q-1');
      expect(question.type, QuestionType.flashcard);
      expect(question.word, 'Bespoke');
      expect(question.wordClass, 'ADJECTIVE');
      expect(question.meaning, 'Được đặt làm riêng');
    });

    test('QuizQuestionModel parses multiple choice question', () {
      final json = {
        'id': 'q-2',
        'type': 'multiple_choice',
        'question_text': 'What does "abundant" mean?',
        'options': ['Hiếm có', 'Dồi dào', 'Nghèo nàn', 'Bất ngờ'],
        'correct_answer': 'Dồi dào',
      };

      final question = QuizQuestionModel.fromJson(json);

      expect(question.type, QuestionType.multipleChoice);
      expect(question.questionText, 'What does "abundant" mean?');
      expect(question.options?.length, 4);
      expect(question.correctAnswer, 'Dồi dào');
    });

    test('QuizQuestionModel parses word matching question', () {
      final json = {
        'id': 'q-3',
        'type': 'word_matching',
        'matching_pairs': {
          'Hello': 'Xin chào',
          'Goodbye': 'Tạm biệt',
        },
      };

      final question = QuizQuestionModel.fromJson(json);

      expect(question.type, QuestionType.wordMatching);
      expect(question.matchingPairs?['Hello'], 'Xin chào');
      expect(question.matchingPairs?['Goodbye'], 'Tạm biệt');
    });
  });
}
