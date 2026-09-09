-- =====================================================
-- NhismLingo Seed Data
-- Dữ liệu mẫu cho Courses & Lessons
-- =====================================================

-- KHÓA HỌC 1: Tiếng Anh Giao Tiếp Cơ Bản
INSERT INTO public.courses (id, title, description, image_url, level, total_lessons, category, rating, review_count, display_order)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-111111111111',
  'Tiếng Anh Giao Tiếp Cơ Bản',
  'Học các mẫu câu giao tiếp hàng ngày: chào hỏi, giới thiệu bản thân, hỏi đường.',
  'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=600&auto=format&fit=crop',
  'A1',
  5,
  'speaking',
  4.8,
  120,
  1
);

-- KHÓA HỌC 2: English for Travelers
INSERT INTO public.courses (id, title, description, image_url, level, total_lessons, category, rating, review_count, display_order)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-222222222222',
  'English for Travelers',
  'Tự tin giao tiếp khi đi du lịch nước ngoài: đặt phòng, gọi đồ ăn, hỏi đường.',
  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?q=80&w=600&auto=format&fit=crop',
  'A2',
  5,
  'speaking',
  4.7,
  89,
  2
);

-- KHÓA HỌC 3: Ngữ pháp Nền tảng
INSERT INTO public.courses (id, title, description, image_url, level, total_lessons, category, rating, review_count, display_order)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-333333333333',
  'Ngữ pháp Nền tảng',
  'Nắm vững các cấu trúc ngữ pháp cơ bản: thì hiện tại, quá khứ, tương lai.',
  'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=600&auto=format&fit=crop',
  'B1',
  5,
  'grammar',
  4.9,
  215,
  3
);

-- =====================================================
-- BÀI HỌC CHO KHÓA 1: Tiếng Anh Giao Tiếp Cơ Bản
-- =====================================================

-- Bài 1: Chào hỏi
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b1111111-0001-0001-0001-000000000001',
  'a1b2c3d4-e5f6-7890-abcd-111111111111',
  'Bài 1: Chào hỏi',
  1,
  'new_concept',
  15,
  '[
    {"type": "flashcard", "word": "Hello", "wordClass": "INTERJECTION", "phonetic": "/həˈloʊ/", "meaning": "Xin chào", "exampleSentence": "Hello, how are you?", "highlightWord": "Hello"},
    {"type": "flashcard", "word": "Goodbye", "wordClass": "INTERJECTION", "phonetic": "/ɡʊdˈbaɪ/", "meaning": "Tạm biệt", "exampleSentence": "Goodbye, see you tomorrow!", "highlightWord": "Goodbye"},
    {"type": "flashcard", "word": "Thank you", "wordClass": "PHRASE", "phonetic": "/θæŋk juː/", "meaning": "Cảm ơn", "exampleSentence": "Thank you for your help.", "highlightWord": "Thank you"},
    {"type": "flashcard", "word": "Please", "wordClass": "ADVERB", "phonetic": "/pliːz/", "meaning": "Làm ơn", "exampleSentence": "Please sit down.", "highlightWord": "Please"},
    {"type": "flashcard", "word": "Sorry", "wordClass": "ADJECTIVE", "phonetic": "/ˈsɒri/", "meaning": "Xin lỗi", "exampleSentence": "I am sorry for being late.", "highlightWord": "sorry"},
    {"type": "multipleChoice", "questionText": "\"Hello\" có nghĩa là gì?", "options": ["Tạm biệt", "Xin chào", "Cảm ơn", "Xin lỗi"], "correctAnswer": "Xin chào"},
    {"type": "multipleChoice", "questionText": "\"Goodbye\" có nghĩa là gì?", "options": ["Xin chào", "Làm ơn", "Tạm biệt", "Cảm ơn"], "correctAnswer": "Tạm biệt"},
    {"type": "multipleChoice", "questionText": "\"Thank you\" có nghĩa là gì?", "options": ["Xin lỗi", "Cảm ơn", "Xin chào", "Tạm biệt"], "correctAnswer": "Cảm ơn"},
    {"type": "multipleChoice", "questionText": "\"Please\" có nghĩa là gì?", "options": ["Cảm ơn", "Tạm biệt", "Xin lỗi", "Làm ơn"], "correctAnswer": "Làm ơn"},
    {"type": "multipleChoice", "questionText": "\"Sorry\" có nghĩa là gì?", "options": ["Làm ơn", "Xin chào", "Xin lỗi", "Cảm ơn"], "correctAnswer": "Xin lỗi"}
  ]'::jsonb
);

-- Bài 2: Số đếm
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b1111111-0001-0001-0001-000000000002',
  'a1b2c3d4-e5f6-7890-abcd-111111111111',
  'Bài 2: Số đếm',
  2,
  'new_concept',
  15,
  '[
    {"type": "flashcard", "word": "One", "wordClass": "NUMBER", "phonetic": "/wʌn/", "meaning": "Một", "exampleSentence": "I have one apple.", "highlightWord": "one"},
    {"type": "flashcard", "word": "Two", "wordClass": "NUMBER", "phonetic": "/tuː/", "meaning": "Hai", "exampleSentence": "There are two cats.", "highlightWord": "two"},
    {"type": "flashcard", "word": "Three", "wordClass": "NUMBER", "phonetic": "/θriː/", "meaning": "Ba", "exampleSentence": "She has three books.", "highlightWord": "three"},
    {"type": "flashcard", "word": "Ten", "wordClass": "NUMBER", "phonetic": "/tɛn/", "meaning": "Mười", "exampleSentence": "I can count to ten.", "highlightWord": "ten"},
    {"type": "flashcard", "word": "Hundred", "wordClass": "NUMBER", "phonetic": "/ˈhʌndrəd/", "meaning": "Một trăm", "exampleSentence": "There are one hundred students.", "highlightWord": "hundred"},
    {"type": "multipleChoice", "questionText": "\"Three\" có nghĩa là gì?", "options": ["Một", "Hai", "Ba", "Mười"], "correctAnswer": "Ba"},
    {"type": "multipleChoice", "questionText": "\"Ten\" có nghĩa là gì?", "options": ["Ba", "Mười", "Một trăm", "Hai"], "correctAnswer": "Mười"},
    {"type": "multipleChoice", "questionText": "\"Hundred\" có nghĩa là gì?", "options": ["Mười", "Một", "Hai", "Một trăm"], "correctAnswer": "Một trăm"},
    {"type": "multipleChoice", "questionText": "\"One\" có nghĩa là gì?", "options": ["Hai", "Một", "Ba", "Mười"], "correctAnswer": "Một"},
    {"type": "multipleChoice", "questionText": "\"Two\" có nghĩa là gì?", "options": ["Một", "Ba", "Hai", "Mười"], "correctAnswer": "Hai"}
  ]'::jsonb
);

-- Bài 3: Ôn tập 1
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b1111111-0001-0001-0001-000000000003',
  'a1b2c3d4-e5f6-7890-abcd-111111111111',
  'Ôn tập 1',
  3,
  'review',
  20,
  '[]'::jsonb
);

-- Bài 4: Gia đình
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b1111111-0001-0001-0001-000000000004',
  'a1b2c3d4-e5f6-7890-abcd-111111111111',
  'Bài 3: Gia đình',
  4,
  'new_concept',
  15,
  '[
    {"type": "flashcard", "word": "Mother", "wordClass": "NOUN", "phonetic": "/ˈmʌðər/", "meaning": "Mẹ", "exampleSentence": "My mother is a teacher.", "highlightWord": "mother"},
    {"type": "flashcard", "word": "Father", "wordClass": "NOUN", "phonetic": "/ˈfɑːðər/", "meaning": "Bố", "exampleSentence": "My father works in the hospital.", "highlightWord": "father"},
    {"type": "flashcard", "word": "Sister", "wordClass": "NOUN", "phonetic": "/ˈsɪstər/", "meaning": "Chị/Em gái", "exampleSentence": "I have a little sister.", "highlightWord": "sister"},
    {"type": "flashcard", "word": "Brother", "wordClass": "NOUN", "phonetic": "/ˈbrʌðər/", "meaning": "Anh/Em trai", "exampleSentence": "My brother is older than me.", "highlightWord": "brother"},
    {"type": "flashcard", "word": "Family", "wordClass": "NOUN", "phonetic": "/ˈfæməli/", "meaning": "Gia đình", "exampleSentence": "I love my family.", "highlightWord": "family"},
    {"type": "multipleChoice", "questionText": "\"Mother\" có nghĩa là gì?", "options": ["Bố", "Mẹ", "Chị gái", "Gia đình"], "correctAnswer": "Mẹ"},
    {"type": "multipleChoice", "questionText": "\"Brother\" có nghĩa là gì?", "options": ["Chị gái", "Mẹ", "Anh/Em trai", "Bố"], "correctAnswer": "Anh/Em trai"},
    {"type": "multipleChoice", "questionText": "\"Family\" có nghĩa là gì?", "options": ["Mẹ", "Gia đình", "Bố", "Chị gái"], "correctAnswer": "Gia đình"},
    {"type": "multipleChoice", "questionText": "\"Father\" có nghĩa là gì?", "options": ["Mẹ", "Anh trai", "Bố", "Gia đình"], "correctAnswer": "Bố"},
    {"type": "multipleChoice", "questionText": "\"Sister\" có nghĩa là gì?", "options": ["Anh trai", "Bố", "Gia đình", "Chị/Em gái"], "correctAnswer": "Chị/Em gái"}
  ]'::jsonb
);

-- Bài 5: Kiểm tra Unit 1
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b1111111-0001-0001-0001-000000000005',
  'a1b2c3d4-e5f6-7890-abcd-111111111111',
  'Kiểm tra Unit 1',
  5,
  'test',
  30,
  '[]'::jsonb
);
