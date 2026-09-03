enum QuestionType {
  flashcard,
  multipleChoice,
  // Tương lai sẽ thêm: fillInTheBlank, etc.
}

class QuizQuestionModel {
  final String id;
  final QuestionType type;
  
  // Các field đặc thù cho Flashcard
  final String word;
  final String wordClass; // Danh từ (NOUN), Động từ (VERB)...
  final String phonetic; // Phiên âm
  final String meaning; // Giải nghĩa
  final String exampleSentence; // Câu ví dụ
  final String highlightWord; // Từ cần in đậm trong câu ví dụ (thường là chính cái word)
  final String? imageUrl; // Ảnh minh họa (có thể null nếu dùng ảnh mặc định)

  // Các field đặc thù cho Multiple Choice
  final String? questionText;
  final List<String>? options;
  final String? correctAnswer; // Đổi từ Index sang String để UI tự do xáo trộn
  
  const QuizQuestionModel({
    required this.id,
    required this.type,
    this.word = '',
    this.wordClass = '',
    this.phonetic = '',
    this.meaning = '',
    this.exampleSentence = '',
    this.highlightWord = '',
    this.imageUrl,
    this.questionText,
    this.options,
    this.correctAnswer,
  });
}
