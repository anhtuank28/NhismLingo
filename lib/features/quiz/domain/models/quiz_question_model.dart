enum QuestionType {
  flashcard,
  // Tương lai sẽ thêm: multipleChoice, fillInTheBlank, etc.
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
  });
}
