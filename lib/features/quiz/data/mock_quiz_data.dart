import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';

const List<QuizQuestionModel> mockQuizQuestions = [
  // 1. Flashcard 1
  QuizQuestionModel(
    id: 'q1',
    type: QuestionType.flashcard,
    word: 'Adventure',
    wordClass: 'NOUN',
    phonetic: '/ədˈvɛntʃər/',
    meaning: 'Chuyến phiêu lưu, sự mạo hiểm',
    exampleSentence: 'Her trip to the Amazon jungle was a true adventure.',
    highlightWord: 'adventure',
  ),
  // 2. Flashcard 2
  QuizQuestionModel(
    id: 'q2',
    type: QuestionType.flashcard,
    word: 'Journey',
    wordClass: 'NOUN',
    phonetic: '/ˈdʒɜːrni/',
    meaning: 'Cuộc hành trình, chặng đường',
    exampleSentence: 'Life is a journey, not a destination.',
    highlightWord: 'journey',
  ),
  // 3. Flashcard 3
  QuizQuestionModel(
    id: 'q3',
    type: QuestionType.flashcard,
    word: 'Explore',
    wordClass: 'VERB',
    phonetic: '/ɪkˈsplɔːr/',
    meaning: 'Khám phá, thăm dò',
    exampleSentence: 'We decided to explore the old city center.',
    highlightWord: 'explore',
  ),
  // 4. Flashcard 4
  QuizQuestionModel(
    id: 'q4',
    type: QuestionType.flashcard,
    word: 'Destination',
    wordClass: 'NOUN',
    phonetic: '/ˌdɛstɪˈneɪʃən/',
    meaning: 'Điểm đến, đích đến',
    exampleSentence: 'Paris is a popular tourist destination.',
    highlightWord: 'destination',
  ),
  // 5. Flashcard 5
  QuizQuestionModel(
    id: 'q5',
    type: QuestionType.flashcard,
    word: 'Discover',
    wordClass: 'VERB',
    phonetic: '/dɪˈskʌvər/',
    meaning: 'Phát hiện, tìm ra',
    exampleSentence: 'Scientists hope to discover a cure for the disease.',
    highlightWord: 'discover',
  ),
  
  // --- PHẦN 2: 5 CÂU TRẮC NGHIỆM ĐẢO LỘN ---
  // Câu 6: Kiểm tra từ số 4 (Destination)
  QuizQuestionModel(
    id: 'q1_test',
    type: QuestionType.multipleChoice,
    questionText: 'Đâu là nghĩa của từ "Destination"?',
    options: [
      'Cuộc hành trình',
      'Điểm đến, đích đến',
      'Thăm dò, khám phá',
      'Chuyến phiêu lưu'
    ],
    correctAnswer: 'Điểm đến, đích đến',
  ),
  // Câu 7: Kiểm tra từ số 1 (Adventure)
  QuizQuestionModel(
    id: 'q2_test',
    type: QuestionType.multipleChoice,
    questionText: 'Đâu là nghĩa của từ "Adventure"?',
    options: [
      'Cuộc hành trình',
      'Điểm đến, đích đến',
      'Phát hiện, tìm ra',
      'Chuyến phiêu lưu, sự mạo hiểm'
    ],
    correctAnswer: 'Chuyến phiêu lưu, sự mạo hiểm',
  ),
  // Câu 8: Kiểm tra từ số 5 (Discover)
  QuizQuestionModel(
    id: 'q3_test',
    type: QuestionType.multipleChoice,
    questionText: 'Đâu là nghĩa của từ "Discover"?',
    options: [
      'Khám phá, thăm dò',
      'Phát hiện, tìm ra',
      'Chuyến phiêu lưu, sự mạo hiểm',
      'Cuộc hành trình'
    ],
    correctAnswer: 'Phát hiện, tìm ra',
  ),
  // Câu 9: Kiểm tra từ số 2 (Journey)
  QuizQuestionModel(
    id: 'q4_test',
    type: QuestionType.multipleChoice,
    questionText: 'Đâu là nghĩa của từ "Journey"?',
    options: [
      'Cuộc hành trình, chặng đường',
      'Điểm đến, đích đến',
      'Khám phá, thăm dò',
      'Phát hiện, tìm ra'
    ],
    correctAnswer: 'Cuộc hành trình, chặng đường',
  ),
  // Câu 10: Kiểm tra từ số 3 (Explore)
  QuizQuestionModel(
    id: 'q5_test',
    type: QuestionType.multipleChoice,
    questionText: 'Đâu là nghĩa của từ "Explore"?',
    options: [
      'Cuộc hành trình, chặng đường',
      'Chuyến phiêu lưu, sự mạo hiểm',
      'Khám phá, thăm dò',
      'Điểm đến, đích đến'
    ],
    correctAnswer: 'Khám phá, thăm dò',
  ),
];
