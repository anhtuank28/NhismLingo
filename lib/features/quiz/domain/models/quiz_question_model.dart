enum QuestionType {
  flashcard,
  multipleChoice,
  fillInTheBlank,
  listening,
  wordMatching,
}

class QuizQuestionModel {
  final String id;
  final QuestionType type;
  
  // Các field đặc thù cho Flashcard & Vocabulary
  final String word;
  final String wordClass; // Danh từ (NOUN), Động từ (VERB)...
  final String phonetic; // Phiên âm
  final String meaning; // Giải nghĩa
  final String exampleSentence; // Câu ví dụ
  final String highlightWord; // Từ cần in đậm trong câu ví dụ (thường là chính cái word)
  final String? imageUrl; // Ảnh minh họa (có thể null nếu dùng ảnh mặc định)

  // Các field đặc thù cho Multiple Choice / Listening
  final String? questionText;
  final List<String>? options;
  final String? correctAnswer; // Đổi từ Index sang String để UI tự do xáo trộn
  
  // Các field cho Fill in the Blank
  final List<String>? blanks; // Danh sách từ để điền vào chỗ trống
  
  // Các field cho Word Matching
  final Map<String, String>? matchingPairs; // VD: {'Apple': 'Quả táo', 'Cat': 'Con mèo'}
  
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
    this.blanks,
    this.matchingPairs,
  });

  /// Parse từ JSON (1 phần tử trong `content_json` của bảng `lessons`)
  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'flashcard';
    
    QuestionType parsedType;
    switch (typeStr) {
      case 'multiple_choice':
      case 'multipleChoice':
        parsedType = QuestionType.multipleChoice;
        break;
      case 'fill_in_the_blank':
      case 'fillInTheBlank':
        parsedType = QuestionType.fillInTheBlank;
        break;
      case 'listening':
        parsedType = QuestionType.listening;
        break;
      case 'word_matching':
      case 'wordMatching':
        parsedType = QuestionType.wordMatching;
        break;
      default:
        parsedType = QuestionType.flashcard;
    }

    return QuizQuestionModel(
      id: json['id'] as String? ?? '',
      type: parsedType,
      word: json['word'] as String? ?? '',
      wordClass: (json['word_class'] ?? json['wordClass']) as String? ?? '',
      phonetic: json['phonetic'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      exampleSentence: (json['example_sentence'] ?? json['exampleSentence']) as String? ?? '',
      highlightWord: (json['highlight_word'] ?? json['highlightWord']) as String? ?? '',
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      questionText: (json['question_text'] ?? json['questionText']) as String?,
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      correctAnswer: (json['correct_answer'] ?? json['correctAnswer']) as String?,
      blanks: (json['blanks'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      matchingPairs: (json['matching_pairs'] ?? json['matchingPairs']) != null 
          ? Map<String, String>.from(json['matching_pairs'] ?? json['matchingPairs']) 
          : null,
    );
  }
}
