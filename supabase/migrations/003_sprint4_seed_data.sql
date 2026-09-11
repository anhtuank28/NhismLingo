-- Xoá dữ liệu mẫu cũ
DELETE FROM user_progress;
DELETE FROM lessons;
DELETE FROM courses;

-- =========================================================================
-- KHÓA HỌC 1: TIẾNG ANH GIAO TIẾP CƠ BẢN
-- =========================================================================
INSERT INTO courses (id, title, description, image_url, level, total_lessons, category)
VALUES (
    '11111111-1111-1111-1111-111111111111', 
    'Tiếng Anh Giao Tiếp', 
    'Những câu chào hỏi và hội thoại cơ bản nhất cho người mới bắt đầu.', 
    'https://images.unsplash.com/photo-1577563908411-50cb98976fea?w=800&q=80', 
    'beginner', 
    2, 
    'giao_tiep'
);

-- Bài học 1: Chào hỏi cơ bản
INSERT INTO lessons (id, course_id, title, lesson_order, type, content_json)
VALUES (
    'a1111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    'Chào hỏi cơ bản',
    1,
    'vocabulary',
    '[
        {
            "id": "q1",
            "type": "flashcard",
            "word": "Hello",
            "word_class": "Thán từ",
            "phonetic": "/həˈləʊ/",
            "meaning": "Xin chào",
            "example_sentence": "Hello, how are you?",
            "highlight_word": "Hello"
        },
        {
            "id": "q1_2",
            "type": "flashcard",
            "word": "Goodbye",
            "word_class": "Thán từ",
            "phonetic": "/ɡʊdˈbaɪ/",
            "meaning": "Tạm biệt",
            "example_sentence": "Goodbye, see you tomorrow!",
            "highlight_word": "Goodbye"
        },
        {
            "id": "q1_3",
            "type": "flashcard",
            "word": "Thank you",
            "word_class": "Cụm từ",
            "phonetic": "/θæŋk juː/",
            "meaning": "Cảm ơn",
            "example_sentence": "Thank you very much.",
            "highlight_word": "Thank you"
        },
        {
            "id": "q2",
            "type": "listening",
            "word": "Nice to meet you",
            "options": ["Rất vui được gặp bạn", "Tạm biệt", "Xin chào buổi sáng", "Cảm ơn bạn"],
            "correct_answer": "Rất vui được gặp bạn"
        },
        {
            "id": "q3",
            "type": "multiple_choice",
            "question_text": "Từ nào sau đây có nghĩa là ''Tạm biệt''?",
            "options": ["Hello", "Goodbye", "Please", "Sorry"],
            "correct_answer": "Goodbye"
        },
        {
            "id": "q4",
            "type": "fill_in_the_blank",
            "question_text": "Good ___, everyone!___",
            "blanks": ["morning", "apple", "car", "book"],
            "correct_answer": "morning"
        },
        {
            "id": "q4_2",
            "type": "listening",
            "word": "Thank you",
            "options": ["Cảm ơn", "Tạm biệt", "Xin chào", "Xin lỗi"],
            "correct_answer": "Cảm ơn"
        },
        {
            "id": "q5",
            "type": "word_matching",
            "matching_pairs": {
                "Hello": "Xin chào",
                "Goodbye": "Tạm biệt",
                "Thank you": "Cảm ơn",
                "Sorry": "Xin lỗi"
            }
        }
    ]'::jsonb
);

-- Bài học 2: Hỏi thăm sức khỏe
INSERT INTO lessons (id, course_id, title, lesson_order, type, content_json)
VALUES (
    'a1111111-1111-1111-1111-111111111112',
    '11111111-1111-1111-1111-111111111111',
    'Hỏi thăm sức khoẻ',
    2,
    'grammar',
    '[
        {
            "id": "q1",
            "type": "flashcard",
            "word": "Fine",
            "word_class": "Tính từ",
            "phonetic": "/faɪn/",
            "meaning": "Khỏe, tốt",
            "example_sentence": "I am fine, thank you.",
            "highlight_word": "fine"
        },
        {
            "id": "q2",
            "type": "listening",
            "word": "How are you today?",
            "options": ["Hôm nay bạn thế nào?", "Hôm nay là thứ mấy?", "Bạn đang làm gì?", "Tuyệt vời!"],
            "correct_answer": "Hôm nay bạn thế nào?"
        },
        {
            "id": "q3",
            "type": "fill_in_the_blank",
            "question_text": "I am ___, thanks!___",
            "blanks": ["fine", "bad", "apple", "running"],
            "correct_answer": "fine"
        },
        {
            "id": "q4",
            "type": "word_matching",
            "matching_pairs": {
                "How": "Thế nào",
                "You": "Bạn",
                "Today": "Hôm nay",
                "Fine": "Khỏe"
            }
        }
    ]'::jsonb
);

-- =========================================================================
-- KHÓA HỌC 2: TIẾNG ANH DU LỊCH
-- =========================================================================
INSERT INTO courses (id, title, description, image_url, level, total_lessons, category)
VALUES (
    '22222222-2222-2222-2222-222222222222', 
    'English for Travelers', 
    'Tự tin giao tiếp khi đi du lịch nước ngoài: sân bay, khách sạn, nhà hàng.', 
    'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80', 
    'intermediate', 
    1, 
    'du_lich'
);

INSERT INTO lessons (id, course_id, title, lesson_order, type, content_json)
VALUES (
    'b2222222-2222-2222-2222-222222222222',
    '22222222-2222-2222-2222-222222222222',
    'Tại sân bay',
    1,
    'vocabulary',
    '[
        {
            "id": "q1",
            "type": "flashcard",
            "word": "Passport",
            "word_class": "Danh từ",
            "phonetic": "/ˈpɑːspɔːt/",
            "meaning": "Hộ chiếu",
            "example_sentence": "Can I see your passport, please?",
            "highlight_word": "passport"
        },
        {
            "id": "q2",
            "type": "fill_in_the_blank",
            "question_text": "Where is your ___?___",
            "blanks": ["passport", "apple", "water", "cat"],
            "correct_answer": "passport"
        },
        {
            "id": "q3",
            "type": "word_matching",
            "matching_pairs": {
                "Flight": "Chuyến bay",
                "Ticket": "Vé máy bay",
                "Gate": "Cổng lên máy bay",
                "Luggage": "Hành lý"
            }
        }
    ]'::jsonb
);

-- =========================================================================
-- KHÓA HỌC 3: TIẾNG ANH CÔNG SỞ
-- =========================================================================
INSERT INTO courses (id, title, description, image_url, level, total_lessons, category)
VALUES (
    '33333333-3333-3333-3333-333333333333', 
    'Business English', 
    'Chinh phục môi trường công sở: viết email, phỏng vấn, thuyết trình.', 
    'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&q=80', 
    'advanced', 
    1, 
    'cong_so'
);

INSERT INTO lessons (id, course_id, title, lesson_order, type, content_json)
VALUES (
    'c3333333-3333-3333-3333-333333333333',
    '33333333-3333-3333-3333-333333333333',
    'Viết Email Chuyên Nghiệp',
    1,
    'grammar',
    '[
        {
            "id": "q1",
            "type": "flashcard",
            "word": "Attach",
            "word_class": "Động từ",
            "phonetic": "/əˈtætʃ/",
            "meaning": "Đính kèm",
            "example_sentence": "Please find the attached file.",
            "highlight_word": "attached"
        },
        {
            "id": "q2",
            "type": "fill_in_the_blank",
            "question_text": "I look forward to ___ from you.___",
            "blanks": ["hearing", "looking", "seeing", "talking"],
            "correct_answer": "hearing"
        },
        {
            "id": "q3",
            "type": "listening",
            "word": "Best regards",
            "options": ["Trân trọng", "Tạm biệt", "Cảm ơn", "Xin lỗi"],
            "correct_answer": "Trân trọng"
        }
    ]'::jsonb
);
