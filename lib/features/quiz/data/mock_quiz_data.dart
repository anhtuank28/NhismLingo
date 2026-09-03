import 'package:nhims_lingo/features/quiz/domain/models/quiz_question_model.dart';

const List<QuizQuestionModel> mockQuizQuestions = [
  QuizQuestionModel(
    id: 'q1',
    type: QuestionType.flashcard,
    word: 'Adventure',
    wordClass: 'NOUN',
    phonetic: '/ədˈvɛntʃər/',
    meaning: 'Chuyến phiêu lưu, sự mạo hiểm',
    exampleSentence: 'Her trip to the Amazon jungle was a true adventure.',
    highlightWord: 'adventure',
    // imageUrl: null,
  ),
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
];
