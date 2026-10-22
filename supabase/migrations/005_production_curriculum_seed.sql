-- =========================================================================
-- NhismLingo: Production Standard Curriculum Seed (Khung Giáo Trình Chuẩn)
-- Phiên bản: 1.0 (CEFR Standard: A1 -> B1)
-- 3 Khóa học cốt lõi | 15 Bài học chuyên sâu | 120+ Câu hỏi thực tế 100%
-- =========================================================================

-- =========================================================================
-- 1. KHỞI TẠO CÁC KHÓA HỌC (COURSES)
-- =========================================================================

-- KHÓA 1: Tiếng Anh Giao Tiếp Thực Chiến (A1)
INSERT INTO public.courses (id, title, description, image_url, level, total_lessons, category, rating, review_count, is_published, display_order)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Tiếng Anh Giao Tiếp Thực Chiến',
  'Làm chủ các tình huống giao tiếp đời sống hàng ngày: chào hỏi, kết bạn, đặt lịch hẹn và gọi món tự nhiên như người bản xứ.',
  'https://images.unsplash.com/photo-1577563908411-50cb98976fea?w=800&q=80',
  'A1',
  5,
  'giao_tiep',
  4.9,
  340,
  true,
  1
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  image_url = EXCLUDED.image_url,
  level = EXCLUDED.level,
  total_lessons = EXCLUDED.total_lessons,
  category = EXCLUDED.category,
  rating = EXCLUDED.rating,
  review_count = EXCLUDED.review_count,
  is_published = EXCLUDED.is_published,
  display_order = EXCLUDED.display_order;

-- KHÓA 2: Tiếng Anh Du Lịch & Khám Phá (A2)
INSERT INTO public.courses (id, title, description, image_url, level, total_lessons, category, rating, review_count, is_published, display_order)
VALUES (
  '22222222-2222-2222-2222-222222222222',
  'Tiếng Anh Du Lịch & Khám Phá',
  'Tự tin vi vu khắp thế giới: làm thủ tục sân bay, nhận phòng khách sạn, hỏi đường và mua sắm không ngại rào cản ngôn ngữ.',
  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
  'A2',
  5,
  'du_lich',
  4.8,
  215,
  true,
  2
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  image_url = EXCLUDED.image_url,
  level = EXCLUDED.level,
  total_lessons = EXCLUDED.total_lessons,
  category = EXCLUDED.category,
  rating = EXCLUDED.rating,
  review_count = EXCLUDED.review_count,
  is_published = EXCLUDED.is_published,
  display_order = EXCLUDED.display_order;

-- KHÓA 3: Tiếng Anh Công Sở & Thương Mại (B1)
INSERT INTO public.courses (id, title, description, image_url, level, total_lessons, category, rating, review_count, is_published, display_order)
VALUES (
  '33333333-3333-3333-3333-333333333333',
  'Tiếng Anh Công Sở & Thương Mại',
  'Bứt phá sự nghiệp trong môi trường quốc tế: viết email chuyên nghiệp, phỏng vấn, chủ trì cuộc họp và đàm phán hợp đồng thành công.',
  'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&q=80',
  'B1',
  5,
  'cong_so',
  4.9,
  420,
  true,
  3
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  image_url = EXCLUDED.image_url,
  level = EXCLUDED.level,
  total_lessons = EXCLUDED.total_lessons,
  category = EXCLUDED.category,
  rating = EXCLUDED.rating,
  review_count = EXCLUDED.review_count,
  is_published = EXCLUDED.is_published,
  display_order = EXCLUDED.display_order;


-- =========================================================================
-- 2. KHÓA 1: TIẾNG ANH GIAO TIẾP THỰC CHIẾN (5 BÀI HỌC)
-- =========================================================================

-- Bài 1: Chào hỏi, Phép lịch sự & Tự giới thiệu
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'a1111111-1111-1111-1111-100000000001',
  '11111111-1111-1111-1111-111111111111',
  'Chào hỏi & Tự giới thiệu',
  1,
  'new_concept',
  15,
  '[
    {
      "id": "c1_l1_q1",
      "type": "flashcard",
      "word": "Pleasure",
      "word_class": "Danh từ",
      "phonetic": "/ˈpleʒər/",
      "meaning": "Niềm vinh hạnh, niềm vui",
      "example_sentence": "It is a pleasure to meet you in person.",
      "highlight_word": "pleasure"
    },
    {
      "id": "c1_l1_q2",
      "type": "flashcard",
      "word": "Introduce",
      "word_class": "Động từ",
      "phonetic": "/ˌɪntrəˈdjuːs/",
      "meaning": "Giới thiệu, làm quen",
      "example_sentence": "Allow me to introduce myself to the team.",
      "highlight_word": "introduce"
    },
    {
      "id": "c1_l1_q3",
      "type": "flashcard",
      "word": "Appreciate",
      "word_class": "Động từ",
      "phonetic": "/əˈpriːʃieɪt/",
      "meaning": "Trân trọng, cảm kích",
      "example_sentence": "I really appreciate your kind hospitality.",
      "highlight_word": "appreciate"
    },
    {
      "id": "c1_l1_q4",
      "type": "multiple_choice",
      "question_text": "Khi lần đầu tiên gặp đối tác hoặc người mới quen, câu chào nào trang trọng và lịch thiệp nhất?",
      "options": ["It is a pleasure to meet you.", "Hey, what''s up?", "See you later, mate.", "I don''t know you."],
      "correct_answer": "It is a pleasure to meet you."
    },
    {
      "id": "c1_l1_q5",
      "type": "fill_in_the_blank",
      "question_text": "Allow me to ___ myself, my name is Alex.___ ",
      "blanks": ["introduce", "forget", "destroy", "dislike"],
      "correct_answer": "introduce"
    },
    {
      "id": "c1_l1_q6",
      "type": "listening",
      "word": "I really appreciate your help.",
      "options": ["Tôi thực sự cảm kích sự giúp đỡ của bạn.", "Tôi không cần bạn giúp đâu.", "Hãy giúp tôi hoàn thành việc này.", "Bạn có thể chỉ đường giúp tôi không?"],
      "correct_answer": "Tôi thực sự cảm kích sự giúp đỡ của bạn."
    },
    {
      "id": "c1_l1_q7",
      "type": "multiple_choice",
      "question_text": "Từ \"Appreciate\" có phiên âm IPA chuẩn xác là gì?",
      "options": ["/əˈpriːʃieɪt/", "/ˈæprɪkeɪt/", "/əˈpreɪʃət/", "/ˈæprəsaɪt/"],
      "correct_answer": "/əˈpriːʃieɪt/"
    },
    {
      "id": "c1_l1_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Pleasure": "Niềm vinh hạnh",
        "Introduce": "Giới thiệu",
        "Appreciate": "Trân trọng cảm kích",
        "Hospitality": "Lòng hiếu khách"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 2: Gia đình, Nghề nghiệp & Đời sống
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'a1111111-1111-1111-1111-100000000002',
  '11111111-1111-1111-1111-111111111111',
  'Gia đình & Nghề nghiệp',
  2,
  'new_concept',
  15,
  '[
    {
      "id": "c1_l2_q1",
      "type": "flashcard",
      "word": "Occupation",
      "word_class": "Danh từ",
      "phonetic": "/ˌɒkjuˈpeɪʃn/",
      "meaning": "Nghề nghiệp, công việc chính",
      "example_sentence": "Please state your current occupation on this form.",
      "highlight_word": "occupation"
    },
    {
      "id": "c1_l2_q2",
      "type": "flashcard",
      "word": "Sibling",
      "word_class": "Danh từ",
      "phonetic": "/ˈsɪblɪŋ/",
      "meaning": "Anh chị em ruột",
      "example_sentence": "Do you have any brothers, sisters, or other siblings?",
      "highlight_word": "siblings"
    },
    {
      "id": "c1_l2_q3",
      "type": "flashcard",
      "word": "Supportive",
      "word_class": "Tính từ",
      "phonetic": "/səˈpɔːtɪv/",
      "meaning": "Luôn ủng hộ, tương trợ",
      "example_sentence": "My family is very supportive of my career choices.",
      "highlight_word": "supportive"
    },
    {
      "id": "c1_l2_q4",
      "type": "multiple_choice",
      "question_text": "Từ nào sau đây mang nghĩa là \"Anh/Chị/Em ruột\" trong tiếng Anh?",
      "options": ["Sibling", "Colleague", "Neighbor", "Acquaintance"],
      "correct_answer": "Sibling"
    },
    {
      "id": "c1_l2_q5",
      "type": "fill_in_the_blank",
      "question_text": "What is your father''s current ___?___ ",
      "blanks": ["occupation", "weather", "traffic", "blanket"],
      "correct_answer": "occupation"
    },
    {
      "id": "c1_l2_q6",
      "type": "listening",
      "word": "My parents are always supportive.",
      "options": ["Bố mẹ tôi luôn luôn ủng hộ tôi.", "Bố mẹ tôi sống ở nông thôn.", "Gia đình tôi có ba người con.", "Tôi rất tự hào về anh trai tôi."],
      "correct_answer": "Bố mẹ tôi luôn luôn ủng hộ tôi."
    },
    {
      "id": "c1_l2_q7",
      "type": "multiple_choice",
      "question_text": "Cách hỏi nghề nghiệp của ai đó tự nhiên và lịch thiệp nhất là gì?",
      "options": ["What do you do for a living?", "Where is your cash?", "Why do you work?", "How much money do you have?"],
      "correct_answer": "What do you do for a living?"
    },
    {
      "id": "c1_l2_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Occupation": "Nghề nghiệp",
        "Sibling": "Anh chị em ruột",
        "Supportive": "Luôn ủng hộ",
        "Relative": "Họ hàng thân tộc"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 3: Thời gian, Lịch trình & Hẹn gặp
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'a1111111-1111-1111-1111-100000000003',
  '11111111-1111-1111-1111-111111111111',
  'Thời gian & Hẹn gặp',
  3,
  'new_concept',
  15,
  '[
    {
      "id": "c1_l3_q1",
      "type": "flashcard",
      "word": "Appointment",
      "word_class": "Danh từ",
      "phonetic": "/əˈpɔɪntmənt/",
      "meaning": "Cuộc hẹn, lịch hẹn chính thức",
      "example_sentence": "I have a scheduled appointment with the doctor at 3 PM.",
      "highlight_word": "appointment"
    },
    {
      "id": "c1_l3_q2",
      "type": "flashcard",
      "word": "Available",
      "word_class": "Tính từ",
      "phonetic": "/əˈveɪləbl/",
      "meaning": "Rảnh rỗi, có sẵn, sẵn sàng",
      "example_sentence": "Are you available for a quick chat this afternoon?",
      "highlight_word": "available"
    },
    {
      "id": "c1_l3_q3",
      "type": "flashcard",
      "word": "Postpone",
      "word_class": "Động từ",
      "phonetic": "/pəʊstˈpəʊn/",
      "meaning": "Trì hoãn, dời lại thời gian sau",
      "example_sentence": "Could we postpone our lunch until tomorrow?",
      "highlight_word": "postpone"
    },
    {
      "id": "c1_l3_q4",
      "type": "multiple_choice",
      "question_text": "Khi muốn hỏi ai đó có rảnh vào chiều nay không, mẫu câu nào chuẩn xác nhất?",
      "options": ["Are you available this afternoon?", "Do you have time for sleep?", "Is your clock working?", "Are you busy forever?"],
      "correct_answer": "Are you available this afternoon?"
    },
    {
      "id": "c1_l3_q5",
      "type": "fill_in_the_blank",
      "question_text": "Due to heavy rain, we have to ___ the outdoor gathering.___ ",
      "blanks": ["postpone", "welcome", "celebrate", "cook"],
      "correct_answer": "postpone"
    },
    {
      "id": "c1_l3_q6",
      "type": "listening",
      "word": "I have an appointment at three o''clock.",
      "options": ["Tôi có một cuộc hẹn lúc ba giờ đúng.", "Tôi sẽ tan làm lúc ba giờ chiều.", "Cuộc họp đã kết thúc từ ba giờ trước.", "Hãy gọi lại cho tôi sau ba giờ nhé."],
      "correct_answer": "Tôi có một cuộc hẹn lúc ba giờ đúng."
    },
    {
      "id": "c1_l3_q7",
      "type": "multiple_choice",
      "question_text": "Từ đồng nghĩa với \"Postpone\" (trì hoãn) trong tiếng Anh thông dụng là gì?",
      "options": ["Put off", "Give up", "Turn down", "Look for"],
      "correct_answer": "Put off"
    },
    {
      "id": "c1_l3_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Appointment": "Cuộc hẹn chính thức",
        "Available": "Rảnh rỗi có sẵn",
        "Postpone": "Dời lịch hoãn lại",
        "Punctual": "Đúng giờ chuẩn xác"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 4: Gọi món tại Nhà hàng & Quán Cà phê
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'a1111111-1111-1111-1111-100000000004',
  '11111111-1111-1111-1111-111111111111',
  'Gọi món & Nhà hàng',
  4,
  'review',
  20,
  '[
    {
      "id": "c1_l4_q1",
      "type": "flashcard",
      "word": "Recommend",
      "word_class": "Động từ",
      "phonetic": "/ˌrekəˈmend/",
      "meaning": "Gợi ý, tiến cử món ngon",
      "example_sentence": "What specialty dish do you recommend for dinner?",
      "highlight_word": "recommend"
    },
    {
      "id": "c1_l4_q2",
      "type": "flashcard",
      "word": "Allergic",
      "word_class": "Tính từ",
      "phonetic": "/əˈlɜːdʒɪk/",
      "meaning": "Bị dị ứng với thực phẩm/chất",
      "example_sentence": "I am allergic to seafood and peanuts.",
      "highlight_word": "allergic"
    },
    {
      "id": "c1_l4_q3",
      "type": "flashcard",
      "word": "Bill",
      "word_class": "Danh từ",
      "phonetic": "/bɪl/",
      "meaning": "Hóa đơn thanh toán bàn ăn",
      "example_sentence": "Excuse me, could we please have the bill?",
      "highlight_word": "bill"
    },
    {
      "id": "c1_l4_q4",
      "type": "multiple_choice",
      "question_text": "Khi muốn yêu cầu nhân viên phục vụ mang hóa đơn tính tiền, câu nào tự nhiên và đúng chuẩn nhất?",
      "options": ["Could we have the bill, please?", "I want to pay money now.", "Where is my cash desk?", "Give me the price quickly."],
      "correct_answer": "Could we have the bill, please?"
    },
    {
      "id": "c1_l4_q5",
      "type": "fill_in_the_blank",
      "question_text": "I cannot eat shrimp because I am ___ to shellfish.___ ",
      "blanks": ["allergic", "addicted", "hungry", "curious"],
      "correct_answer": "allergic"
    },
    {
      "id": "c1_l4_q6",
      "type": "listening",
      "word": "What do you recommend for dessert?",
      "options": ["Bạn gợi ý món tráng miệng nào ngon?", "Món tráng miệng này giá bao nhiêu?", "Bàn của chúng tôi đã gọi món chưa?", "Tôi muốn gọi thêm nước lọc."],
      "correct_answer": "Bạn gợi ý món tráng miệng nào ngon?"
    },
    {
      "id": "c1_l4_q7",
      "type": "multiple_choice",
      "question_text": "Trong tiếng Anh Mỹ (American English), từ nào thường được dùng thay thế cho \"the bill\"?",
      "options": ["The check", "The receipt", "The menu", "The ticket"],
      "correct_answer": "The check"
    },
    {
      "id": "c1_l4_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Recommend": "Gợi ý tiến cử",
        "Allergic": "Bị dị ứng",
        "Appetizer": "Món khai vị",
        "Beverage": "Đồ uống giải khát"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 5: Vượt ải Thử thách: Giao tiếp thường nhật
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'a1111111-1111-1111-1111-100000000005',
  '11111111-1111-1111-1111-111111111111',
  'Vượt ải: Giao tiếp thường nhật',
  5,
  'test',
  30,
  '[
    {
      "id": "c1_l5_q1",
      "type": "flashcard",
      "word": "Convenient",
      "word_class": "Tính từ",
      "phonetic": "/kənˈviːniənt/",
      "meaning": "Tiện lợi, thuận tiện thời gian",
      "example_sentence": "Is 10 AM convenient for you to meet?",
      "highlight_word": "convenient"
    },
    {
      "id": "c1_l5_q2",
      "type": "multiple_choice",
      "question_text": "Chọn câu trả lời phù hợp nhất khi được hỏi: \"How are you doing today?\"",
      "options": ["I''m doing great, thank you! How about you?", "I am twenty-five years old.", "I live in downtown.", "Yes, I am a software engineer."],
      "correct_answer": "I''m doing great, thank you! How about you?"
    },
    {
      "id": "c1_l5_q3",
      "type": "fill_in_the_blank",
      "question_text": "Let me know if Friday afternoon is ___ for our call.___ ",
      "blanks": ["convenient", "broken", "angry", "expensive"],
      "correct_answer": "convenient"
    },
    {
      "id": "c1_l5_q4",
      "type": "listening",
      "word": "It was wonderful speaking with you.",
      "options": ["Thật tuyệt vời khi được trò chuyện cùng bạn.", "Hôm nay thời tiết thật đẹp.", "Tôi không nghe rõ bạn nói gì.", "Chúng ta hãy nói chuyện vào ngày mai nhé."],
      "correct_answer": "Thật tuyệt vời khi được trò chuyện cùng bạn."
    },
    {
      "id": "c1_l5_q5",
      "type": "multiple_choice",
      "question_text": "Cụm từ \"Keep in touch\" trong giao tiếp có ý nghĩa là gì?",
      "options": ["Giữ liên lạc thường xuyên", "Chạm tay vào nhau", "Không gặp lại nữa", "Giữ bí mật tuyệt đối"],
      "correct_answer": "Giữ liên lạc thường xuyên"
    },
    {
      "id": "c1_l5_q6",
      "type": "word_matching",
      "matching_pairs": {
        "Convenient": "Thuận tiện tiện lợi",
        "Keep in touch": "Giữ liên lạc",
        "Pleased": "Rất vui lòng",
        "Take care": "Bảo trọng giữ gìn sức khỏe"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;


-- =========================================================================
-- 3. KHÓA 2: TIẾNG ANH DU LỊCH & KHÁM PHÁ (5 BÀI HỌC)
-- =========================================================================

-- Bài 1: Thủ tục Sân bay & Xuất nhập cảnh
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b2222222-2222-2222-2222-200000000001',
  '22222222-2222-2222-2222-222222222222',
  'Thủ tục Sân bay',
  1,
  'new_concept',
  15,
  '[
    {
      "id": "c2_l1_q1",
      "type": "flashcard",
      "word": "Boarding pass",
      "word_class": "Danh từ",
      "phonetic": "/ˈbɔːdɪŋ pɑːs/",
      "meaning": "Thẻ lên máy bay",
      "example_sentence": "Please have your passport and boarding pass ready for inspection.",
      "highlight_word": "boarding pass"
    },
    {
      "id": "c2_l1_q2",
      "type": "flashcard",
      "word": "Baggage claim",
      "word_class": "Danh từ",
      "phonetic": "/ˈbæɡɪdʒ kleɪm/",
      "meaning": "Khu vực nhận hành lý sau chuyến bay",
      "example_sentence": "Follow the yellow signs to reach the baggage claim area.",
      "highlight_word": "baggage claim"
    },
    {
      "id": "c2_l1_q3",
      "type": "flashcard",
      "word": "Departure",
      "word_class": "Danh từ",
      "phonetic": "/dɪˈpɑːtʃər/",
      "meaning": "Chuyến bay khởi hành, giờ cất cánh",
      "example_sentence": "Our flight departure has been delayed by forty minutes.",
      "highlight_word": "departure"
    },
    {
      "id": "c2_l1_q4",
      "type": "multiple_choice",
      "question_text": "Khi nhân viên hải quan hỏi: \"What is the purpose of your visit?\", bạn nên trả lời thế nào nếu đi du lịch?",
      "options": ["I am here on vacation for sightseeing.", "I don''t want to answer you.", "Where is my hotel bed?", "I will buy a new house."],
      "correct_answer": "I am here on vacation for sightseeing."
    },
    {
      "id": "c2_l1_q5",
      "type": "fill_in_the_blank",
      "question_text": "Passengers must show their ___ before entering the departure gate.___ ",
      "blanks": ["boarding pass", "receipt", "credit card", "sunglasses"],
      "correct_answer": "boarding pass"
    },
    {
      "id": "c2_l1_q6",
      "type": "listening",
      "word": "The flight is currently boarding at gate twelve.",
      "options": ["Chuyến bay hiện đang đón khách tại cổng số 12.", "Chuyến bay đã cất cánh từ cổng số 12.", "Hành lý sẽ được trả lại tại băng chuyền số 12.", "Hành khách cần đổi vé tại quầy số 12."],
      "correct_answer": "Chuyến bay hiện đang đón khách tại cổng số 12."
    },
    {
      "id": "c2_l1_q7",
      "type": "multiple_choice",
      "question_text": "Hành lý được phép xách tay lên khoang máy bay được gọi là gì?",
      "options": ["Carry-on baggage", "Checked baggage", "Lost luggage", "Cargo shipment"],
      "correct_answer": "Carry-on baggage"
    },
    {
      "id": "c2_l1_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Boarding pass": "Thẻ lên máy bay",
        "Baggage claim": "Khu nhận hành lý",
        "Departure": "Giờ khởi hành",
        "Customs": "Hải quan kiểm soát"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 2: Nhận phòng & Dịch vụ Khách sạn
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b2222222-2222-2222-2222-200000000002',
  '22222222-2222-2222-2222-222222222222',
  'Nhận phòng Khách sạn',
  2,
  'new_concept',
  15,
  '[
    {
      "id": "c2_l2_q1",
      "type": "flashcard",
      "word": "Reservation",
      "word_class": "Danh từ",
      "phonetic": "/ˌrezəˈveɪʃn/",
      "meaning": "Việc đặt chỗ trước, đơn đặt phòng",
      "example_sentence": "I have a room reservation under the name of Nguyen.",
      "highlight_word": "reservation"
    },
    {
      "id": "c2_l2_q2",
      "type": "flashcard",
      "word": "Amenity",
      "word_class": "Danh từ",
      "phonetic": "/əˈmiːnəti/",
      "meaning": "Tiện ích đi kèm (hồ bơi, wifi, phòng gym)",
      "example_sentence": "The hotel provides complimentary amenities including high-speed Wi-Fi.",
      "highlight_word": "amenities"
    },
    {
      "id": "c2_l2_q3",
      "type": "flashcard",
      "word": "Complimentary",
      "word_class": "Tính từ",
      "phonetic": "/ˌkɒmplɪˈmentri/",
      "meaning": "Miễn phí (do khách sạn phục vụ)",
      "example_sentence": "Enjoy your complimentary buffet breakfast on the third floor.",
      "highlight_word": "complimentary"
    },
    {
      "id": "c2_l2_q4",
      "type": "multiple_choice",
      "question_text": "Khi đến quầy lễ tân khách sạn để nhận phòng, bạn nên nói câu nào đầu tiên?",
      "options": ["Hi, I have a reservation under the name John.", "Where is my key right now?", "I want this hotel room immediately.", "Who are you?"],
      "correct_answer": "Hi, I have a reservation under the name John."
    },
    {
      "id": "c2_l2_q5",
      "type": "fill_in_the_blank",
      "question_text": "Bottled water in your mini-fridge is strictly ___ for hotel guests.___ ",
      "blanks": ["complimentary", "dangerous", "illegal", "noisy"],
      "correct_answer": "complimentary"
    },
    {
      "id": "c2_l2_q6",
      "type": "listening",
      "word": "What time is checkout tomorrow morning?",
      "options": ["Sáng mai mấy giờ phải trả phòng?", "Khách sạn mở cửa nhận phòng lúc mấy giờ?", "Bữa sáng ngày mai phục vụ từ mấy giờ?", "Xe đưa đón sân bay khởi hành lúc mấy giờ?"],
      "correct_answer": "Sáng mai mấy giờ phải trả phòng?"
    },
    {
      "id": "c2_l2_q7",
      "type": "multiple_choice",
      "question_text": "Cụm từ \"Wake-up call\" trong dịch vụ khách sạn có ý nghĩa gì?",
      "options": ["Cuộc gọi báo thức từ lễ tân", "Cuộc gọi khẩn cấp báo cháy", "Cuộc gọi đặt đồ ăn đêm", "Cuộc gọi hỏi thăm ý kiến"],
      "correct_answer": "Cuộc gọi báo thức từ lễ tân"
    },
    {
      "id": "c2_l2_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Reservation": "Đơn đặt phòng trước",
        "Complimentary": "Được miễn phí",
        "Housekeeping": "Bộ phận buồng phòng",
        "Front desk": "Quầy lễ tân đón tiếp"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 3: Hỏi đường & Phương tiện công cộng
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b2222222-2222-2222-2222-200000000003',
  '22222222-2222-2222-2222-222222222222',
  'Hỏi đường & Giao thông',
  3,
  'new_concept',
  15,
  '[
    {
      "id": "c2_l3_q1",
      "type": "flashcard",
      "word": "Direction",
      "word_class": "Danh từ",
      "phonetic": "/daɪˈrekʃn/",
      "meaning": "Phương hướng, chỉ đường",
      "example_sentence": "Could you please give me directions to the nearest subway station?",
      "highlight_word": "directions"
    },
    {
      "id": "c2_l3_q2",
      "type": "flashcard",
      "word": "Intersection",
      "word_class": "Danh từ",
      "phonetic": "/ˌɪntəˈsekʃn/",
      "meaning": "Ngã tư đường, giao lộ",
      "example_sentence": "Turn right at the next busy intersection.",
      "highlight_word": "intersection"
    },
    {
      "id": "c2_l3_q3",
      "type": "flashcard",
      "word": "Fare",
      "word_class": "Danh từ",
      "phonetic": "/feər/",
      "meaning": "Giá vé tàu, xe bus, cước taxi",
      "example_sentence": "How much is the standard bus fare to the city center?",
      "highlight_word": "fare"
    },
    {
      "id": "c2_l3_q4",
      "type": "multiple_choice",
      "question_text": "Khi đi lạc đường tại một thành phố lạ, câu hỏi mở lời lịch sự nhất là gì?",
      "options": ["Excuse me, could you tell me how to get to the museum?", "Where is the museum, tell me now!", "I don''t like this street.", "Why is this city so big?"],
      "correct_answer": "Excuse me, could you tell me how to get to the museum?"
    },
    {
      "id": "c2_l3_q5",
      "type": "fill_in_the_blank",
      "question_text": "Walk straight ahead for two blocks, then turn left at the ___ .___ ",
      "blanks": ["intersection", "airplane", "ocean", "pillow"],
      "correct_answer": "intersection"
    },
    {
      "id": "c2_l3_q6",
      "type": "listening",
      "word": "Is this train going toward Central Station?",
      "options": ["Chuyến tàu này có đi về ga Trung tâm không?", "Chuyến tàu này khởi hành từ ga Trung tâm à?", "Ga Trung tâm cách đây bao nhiêu km?", "Vé tàu đi ga Trung tâm giá bao nhiêu?"],
      "correct_answer": "Chuyến tàu này có đi về ga Trung tâm không?"
    },
    {
      "id": "c2_l3_q7",
      "type": "multiple_choice",
      "question_text": "Cụm từ \"Transfer to line 2\" trên bản đồ tàu điện ngầm có nghĩa là gì?",
      "options": ["Đổi sang tuyến tàu số 2", "Mua vé đi tuyến số 2", "Rời khỏi ga tàu số 2", "Chuyến tàu số 2 đã bị hủy"],
      "correct_answer": "Đổi sang tuyến tàu số 2"
    },
    {
      "id": "c2_l3_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Intersection": "Ngã tư giao lộ",
        "Direction": "Chỉ dẫn đường đi",
        "Subway": "Hệ thống tàu điện ngầm",
        "Bus stop": "Trạm dừng xe bus"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 4: Mua sắm, Thanh toán & Hoàn thuế
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b2222222-2222-2222-2222-200000000004',
  '22222222-2222-2222-2222-222222222222',
  'Mua sắm & Hoàn thuế',
  4,
  'review',
  20,
  '[
    {
      "id": "c2_l4_q1",
      "type": "flashcard",
      "word": "Tax-free",
      "word_class": "Tính từ",
      "phonetic": "/ˌtæks ˈfriː/",
      "meaning": "Miễn thuế, hoàn thuế du lịch",
      "example_sentence": "Is this boutique eligible for tax-free shopping for tourists?",
      "highlight_word": "tax-free"
    },
    {
      "id": "c2_l4_q2",
      "type": "flashcard",
      "word": "Receipt",
      "word_class": "Danh từ",
      "phonetic": "/rɪˈsiːt/",
      "meaning": "Biên lai, hóa đơn mua hàng",
      "example_sentence": "Always keep your original purchase receipt for customs verification.",
      "highlight_word": "receipt"
    },
    {
      "id": "c2_l4_q3",
      "type": "flashcard",
      "word": "Discount",
      "word_class": "Danh từ",
      "phonetic": "/ˈdɪskaʊnt/",
      "meaning": "Mức giảm giá, chiết khấu",
      "example_sentence": "Do you offer any special discounts if I buy two items?",
      "highlight_word": "discount"
    },
    {
      "id": "c2_l4_q4",
      "type": "multiple_choice",
      "question_text": "Từ \"Receipt\" có chữ \"p\" câm (silent p). Phiên âm chính xác là gì?",
      "options": ["/rɪˈsiːt/", "/rɪˈsiːpt/", "/ˈresɪpt/", "/reɪˈkeɪpt/"],
      "correct_answer": "/rɪˈsiːt/"
    },
    {
      "id": "c2_l4_q5",
      "type": "fill_in_the_blank",
      "question_text": "Do you accept credit card or only ___ cash?___ ",
      "blanks": ["cash", "water", "cloud", "paper"],
      "correct_answer": "cash"
    },
    {
      "id": "c2_l4_q6",
      "type": "listening",
      "word": "Could you provide a tax refund form for this purchase?",
      "options": ["Bạn có thể cung cấp biểu mẫu hoàn thuế cho món hàng này không?", "Món hàng này có được giảm giá không?", "Tôi có thể đổi sang kích cỡ khác không?", "Cửa hàng có chấp nhận thanh toán bằng thẻ không?"],
      "correct_answer": "Bạn có thể cung cấp biểu mẫu hoàn thuế cho món hàng này không?"
    },
    {
      "id": "c2_l4_q7",
      "type": "multiple_choice",
      "question_text": "Khi muốn thử một bộ quần áo trong cửa hàng thời trang, bạn sẽ hỏi nhân viên:",
      "options": ["Can I try this on in the fitting room?", "Give me this shirt now.", "Is this shirt for washing?", "I don''t like clothes."],
      "correct_answer": "Can I try this on in the fitting room?"
    },
    {
      "id": "c2_l4_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Receipt": "Biên lai mua sắm",
        "Tax-free": "Miễn thuế mua sắm",
        "Fitting room": "Phòng thử đồ",
        "Exchange": "Đổi trả hàng hóa"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 5: Vượt ải Thử thách: Xử lý sự cố du lịch
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'b2222222-2222-2222-2222-200000000005',
  '22222222-2222-2222-2222-222222222222',
  'Vượt ải: Sự cố Du lịch',
  5,
  'test',
  30,
  '[
    {
      "id": "c2_l5_q1",
      "type": "flashcard",
      "word": "Embassy",
      "word_class": "Danh từ",
      "phonetic": "/ˈembəsi/",
      "meaning": "Đại sứ quán",
      "example_sentence": "I lost my passport and urgently need to contact my country''s embassy.",
      "highlight_word": "embassy"
    },
    {
      "id": "c2_l5_q2",
      "type": "multiple_choice",
      "question_text": "Nếu bạn bị thất lạc hành lý tại sân bay, nơi đầu tiên bạn cần đến khai báo là gì?",
      "options": ["Lost and Found / Baggage Service Desk", "Duty Free Shop", "Fast Food Restaurant", "Boarding Gate"],
      "correct_answer": "Lost and Found / Baggage Service Desk"
    },
    {
      "id": "c2_l5_q3",
      "type": "fill_in_the_blank",
      "question_text": "Please call the police immediately, someone ___ my wallet!___ ",
      "blanks": ["stole", "helped", "cleaned", "painted"],
      "correct_answer": "stole"
    },
    {
      "id": "c2_l5_q4",
      "type": "listening",
      "word": "I have travel insurance covering medical emergencies.",
      "options": ["Tôi có bảo hiểm du lịch chi trả cho các trường hợp cấp cứu y tế.", "Tôi không có đủ tiền mặt để trả tiền viện phí.", "Tôi cần thuê một hướng dẫn viên du lịch.", "Chuyến bay của tôi bị hoãn do bão."],
      "correct_answer": "Tôi có bảo hiểm du lịch chi trả cho các trường hợp cấp cứu y tế."
    },
    {
      "id": "c2_l5_q5",
      "type": "multiple_choice",
      "question_text": "Khi gặp tình huống nguy cấp cần sự giúp đỡ lập tức trên phố, bạn nên kêu lớn:",
      "options": ["Help me, please!", "Good afternoon, sir.", "Excuse me for smiling.", "Have a nice holiday."],
      "correct_answer": "Help me, please!"
    },
    {
      "id": "c2_l5_q6",
      "type": "word_matching",
      "matching_pairs": {
        "Embassy": "Đại sứ quán",
        "Emergency": "Tình huống khẩn cấp",
        "Insurance": "Bảo hiểm du lịch",
        "Lost luggage": "Hành lý bị thất lạc"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;


-- =========================================================================
-- 4. KHÓA 3: TIẾNG ANH CÔNG SỞ & THƯƠNG MẠI (5 BÀI HỌC)
-- =========================================================================

-- Bài 1: Viết Email & Trao đổi Thư từ chuyên nghiệp
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'c3333333-3333-3333-3333-300000000001',
  '33333333-3333-3333-3333-333333333333',
  'Email Chuyên Nghiệp',
  1,
  'new_concept',
  20,
  '[
    {
      "id": "c3_l1_q1",
      "type": "flashcard",
      "word": "Inquire",
      "word_class": "Động từ",
      "phonetic": "/ɪnˈkwaɪər/",
      "meaning": "Thăm dò, hỏi thăm thông tin trang trọng",
      "example_sentence": "I am writing to inquire about the progress of our joint proposal.",
      "highlight_word": "inquire"
    },
    {
      "id": "c3_l1_q2",
      "type": "flashcard",
      "word": "Attachment",
      "word_class": "Danh từ",
      "phonetic": "/əˈtætʃmənt/",
      "meaning": "Tệp đính kèm trong thư điện tử",
      "example_sentence": "Please find the financial audit report in the attachment below.",
      "highlight_word": "attachment"
    },
    {
      "id": "c3_l1_q3",
      "type": "flashcard",
      "word": "Prompt",
      "word_class": "Tính từ",
      "phonetic": "/prɒmpt/",
      "meaning": "Nhanh chóng, kịp thời, không chậm trễ",
      "example_sentence": "Thank you for your prompt response to our request.",
      "highlight_word": "prompt"
    },
    {
      "id": "c3_l1_q4",
      "type": "multiple_choice",
      "question_text": "Cách kết thư trang trọng nhất khi gửi email công việc cho đối tác quốc tế là gì?",
      "options": ["Best regards,", "See ya later,", "Love and kisses,", "Bye bye,"],
      "correct_answer": "Best regards,"
    },
    {
      "id": "c3_l1_q5",
      "type": "fill_in_the_blank",
      "question_text": "I look forward to ___ from you soon regarding this partnership.___ ",
      "blanks": ["hearing", "screaming", "complaining", "escaping"],
      "correct_answer": "hearing"
    },
    {
      "id": "c3_l1_q6",
      "type": "listening",
      "word": "Please let me know if you have any questions or concerns.",
      "options": ["Xin vui lòng cho tôi biết nếu bạn có bất kỳ câu hỏi hoặc thắc mắc nào.", "Tôi sẽ gửi lại tài liệu cho bạn vào cuối tuần này.", "Dự án này cần được hoàn thành trước thứ Sáu tới.", "Cảm ơn bạn đã tham gia buổi phỏng vấn hôm nay."],
      "correct_answer": "Xin vui lòng cho tôi biết nếu bạn có bất kỳ câu hỏi hoặc thắc mắc nào."
    },
    {
      "id": "c3_l1_q7",
      "type": "multiple_choice",
      "question_text": "Cụm từ \"As per our discussion\" trong email công việc có nghĩa là gì?",
      "options": ["Như chúng ta đã trao đổi/thống nhất", "Mặc dù chúng ta không đồng ý", "Thay vì bàn bạc thêm", "Trước khi cuộc họp bắt đầu"],
      "correct_answer": "Như chúng ta đã trao đổi/thống nhất"
    },
    {
      "id": "c3_l1_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Inquire": "Thăm dò hỏi thông tin",
        "Attachment": "Tệp tin đính kèm",
        "Prompt": "Kịp thời nhanh chóng",
        "Clarify": "Làm rõ giải thích"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 2: Phỏng vấn Tuyển dụng & Thuyết trình Năng lực
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'c3333333-3333-3333-3333-300000000002',
  '33333333-3333-3333-3333-333333333333',
  'Phỏng Vấn & CV',
  2,
  'new_concept',
  20,
  '[
    {
      "id": "c3_l2_q1",
      "type": "flashcard",
      "word": "Applicant",
      "word_class": "Danh từ",
      "phonetic": "/ˈæplɪkənt/",
      "meaning": "Ứng viên ứng tuyển công việc",
      "example_sentence": "She was selected as the most promising applicant for the role.",
      "highlight_word": "applicant"
    },
    {
      "id": "c3_l2_q2",
      "type": "flashcard",
      "word": "Expertise",
      "word_class": "Danh từ",
      "phonetic": "/ˌekspɜːˈtiːz/",
      "meaning": "Chuyên môn sâu, năng lực chuyên ngành",
      "example_sentence": "He brings over ten years of technical expertise to our team.",
      "highlight_word": "expertise"
    },
    {
      "id": "c3_l2_q3",
      "type": "flashcard",
      "word": "Strength",
      "word_class": "Danh từ",
      "phonetic": "/streŋθ/",
      "meaning": "Thế mạnh nổi bật, điểm mạnh cá nhân",
      "example_sentence": "My greatest strength is solving complex analytical problems under pressure.",
      "highlight_word": "strength"
    },
    {
      "id": "c3_l2_q4",
      "type": "multiple_choice",
      "question_text": "Khi nhà tuyển dụng hỏi: \"Why should we hire you?\", câu trả lời thuyết phục nhất là:",
      "options": ["My track record and skills align closely with your company''s strategic goals.", "Because I really need money to pay my rent.", "I have no idea, you chose me for the interview.", "I want to try working here for fun."],
      "correct_answer": "My track record and skills align closely with your company''s strategic goals."
    },
    {
      "id": "c3_l2_q5",
      "type": "fill_in_the_blank",
      "question_text": "Her proven ___ in digital marketing helped grow online sales by 40%.___ ",
      "blanks": ["expertise", "laziness", "hesitation", "accident"],
      "correct_answer": "expertise"
    },
    {
      "id": "c3_l2_q6",
      "type": "listening",
      "word": "Could you walk me through your previous work experience?",
      "options": ["Bạn có thể tóm tắt kinh nghiệm làm việc trước đây của mình không?", "Tại sao bạn lại nghỉ việc ở công ty cũ?", "Mức lương kỳ vọng của bạn ở vị trí này là bao nhiêu?", "Bạn có sẵn sàng đi công tác nước ngoài không?"],
      "correct_answer": "Bạn có thể tóm tắt kinh nghiệm làm việc trước đây của mình không?"
    },
    {
      "id": "c3_l2_q7",
      "type": "multiple_choice",
      "question_text": "Từ nào đồng nghĩa với \"Resume\" trong tiếng Anh Anh (British English)?",
      "options": ["Curriculum Vitae (CV)", "Job Application Card", "Identity Card", "Recommendation Note"],
      "correct_answer": "Curriculum Vitae (CV)"
    },
    {
      "id": "c3_l2_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Applicant": "Ứng viên tìm việc",
        "Expertise": "Chuyên môn sâu",
        "Strength": "Điểm mạnh thế mạnh",
        "Probation": "Giai đoạn thử việc"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 3: Chủ trì & Đóng góp ý kiến trong Cuộc họp
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'c3333333-3333-3333-3333-300000000003',
  '33333333-3333-3333-3333-333333333333',
  'Họp & Thảo Luận',
  3,
  'new_concept',
  20,
  '[
    {
      "id": "c3_l3_q1",
      "type": "flashcard",
      "word": "Agenda",
      "word_class": "Danh từ",
      "phonetic": "/əˈdʒendə/",
      "meaning": "Chương trình nghị sự, nội dung cuộc họp",
      "example_sentence": "Let us take a quick look at the meeting agenda for today.",
      "highlight_word": "agenda"
    },
    {
      "id": "c3_l3_q2",
      "type": "flashcard",
      "word": "Consensus",
      "word_class": "Danh từ",
      "phonetic": "/kənˈsensəs/",
      "meaning": "Sự đồng thuận chung của tập thể",
      "example_sentence": "After intense deliberation, we finally reached a consensus.",
      "highlight_word": "consensus"
    },
    {
      "id": "c3_l3_q3",
      "type": "flashcard",
      "word": "Perspective",
      "word_class": "Danh từ",
      "phonetic": "/pəˈspektɪv/",
      "meaning": "Góc nhìn, quan điểm phân tích",
      "example_sentence": "From a financial perspective, this initiative offers substantial ROI.",
      "highlight_word": "perspective"
    },
    {
      "id": "c3_l3_q4",
      "type": "multiple_choice",
      "question_text": "Khi muốn ngắt lời người khác một cách văn minh trong cuộc họp để đóng góp ý kiến, câu nào chuẩn nhất?",
      "options": ["May I interject for a moment with a quick observation?", "Shut up, it''s my turn now.", "You are completely wrong, stop talking.", "Listen to me immediately."],
      "correct_answer": "May I interject for a moment with a quick observation?"
    },
    {
      "id": "c3_l3_q5",
      "type": "fill_in_the_blank",
      "question_text": "All board members reached a ___ regarding the quarterly budget allocation.___ ",
      "blanks": ["consensus", "disaster", "traffic", "midnight"],
      "correct_answer": "consensus"
    },
    {
      "id": "c3_l3_q6",
      "type": "listening",
      "word": "Let''s wrap up today''s discussion and assign action items.",
      "options": ["Hãy đúc kết cuộc thảo luận hôm nay và phân công các đầu việc cụ thể.", "Cuộc họp hôm nay bị hoãn lại vào tuần sau.", "Mọi người hãy chuẩn bị tài liệu cho buổi thảo luận.", "Tôi không đồng tình với kết quả thảo luận hôm nay."],
      "correct_answer": "Hãy đúc kết cuộc thảo luận hôm nay và phân công các đầu việc cụ thể."
    },
    {
      "id": "c3_l3_q7",
      "type": "multiple_choice",
      "question_text": "Thuật ngữ \"Action item\" trong biên bản cuộc họp có nghĩa là:",
      "options": ["Nhiệm vụ cụ thể cần hành động và hoàn thành", "Các trò chơi tương tác giải trí", "Vật phẩm lưu niệm của công ty", "Thời gian giải lao uống cà phê"],
      "correct_answer": "Nhiệm vụ cụ thể cần hành động và hoàn thành"
    },
    {
      "id": "c3_l3_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Agenda": "Chương trình nghị sự",
        "Consensus": "Sự đồng thuận chung",
        "Perspective": "Góc nhìn quan điểm",
        "Minutes": "Biên bản cuộc họp"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 4: Đàm phán Hợp đồng & Chăm sóc Đối tác
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'c3333333-3333-3333-3333-300000000004',
  '33333333-3333-3333-3333-333333333333',
  'Đàm Phán & Hợp Đồng',
  4,
  'review',
  25,
  '[
    {
      "id": "c3_l4_q1",
      "type": "flashcard",
      "word": "Negotiate",
      "word_class": "Động từ",
      "phonetic": "/nɪˈɡəʊʃieɪt/",
      "meaning": "Thương lượng, đàm phán hợp đồng",
      "example_sentence": "We are prepared to negotiate the contractual payment terms.",
      "highlight_word": "negotiate"
    },
    {
      "id": "c3_l4_q2",
      "type": "flashcard",
      "word": "Feasible",
      "word_class": "Tính từ",
      "phonetic": "/ˈfiːzəbl/",
      "meaning": "Khả thi, có thể thực hiện được",
      "example_sentence": "Given the tight timeframe, is this proposed milestone truly feasible?",
      "highlight_word": "feasible"
    },
    {
      "id": "c3_l4_q3",
      "type": "flashcard",
      "word": "Compromise",
      "word_class": "Danh từ",
      "phonetic": "/ˈkɒmprəmaɪz/",
      "meaning": "Sự thỏa hiệp mang lại lợi ích hai bên",
      "example_sentence": "Both parties reached a mutually beneficial compromise.",
      "highlight_word": "compromise"
    },
    {
      "id": "c3_l4_q4",
      "type": "multiple_choice",
      "question_text": "Cụm từ \"Win-win solution\" trong đàm phán thương mại biểu thị điều gì?",
      "options": ["Giải pháp mà cả hai bên cùng có lợi", "Một bên thắng hoàn toàn và một bên thua", "Không bên nào đạt được mục tiêu", "Cuộc đàm phán đổ vỡ"],
      "correct_answer": "Giải pháp mà cả hai bên cùng có lợi"
    },
    {
      "id": "c3_l4_q5",
      "type": "fill_in_the_blank",
      "question_text": "We need to ensure that this expansion timeline is commercially ___ for both sides.___ ",
      "blanks": ["feasible", "impossible", "careless", "frozen"],
      "correct_answer": "feasible"
    },
    {
      "id": "c3_l4_q6",
      "type": "listening",
      "word": "We are open to revising the terms to reach an agreement.",
      "options": ["Chúng tôi sẵn sàng sửa đổi các điều khoản để đạt được thỏa thuận.", "Chúng tôi kiên quyết giữ nguyên bản hợp đồng này.", "Hợp đồng này sẽ hết hạn vào cuối năm nay.", "Chúng tôi từ chối ký kết biên bản hợp tác này."],
      "correct_answer": "Chúng tôi sẵn sàng sửa đổi các điều khoản để đạt được thỏa thuận."
    },
    {
      "id": "c3_l4_q7",
      "type": "multiple_choice",
      "question_text": "Thuật ngữ \"Deadline\" trong quản lý dự án có nghĩa là:",
      "options": ["Hạn chót phải hoàn thành công việc", "Thời gian bắt đầu dự án", "Thời gian nghỉ phép hàng năm", "Danh sách các rủi ro nguy hiểm"],
      "correct_answer": "Hạn chót phải hoàn thành công việc"
    },
    {
      "id": "c3_l4_q8",
      "type": "word_matching",
      "matching_pairs": {
        "Negotiate": "Đàm phán thương lượng",
        "Feasible": "Khả thi thực tế",
        "Compromise": "Sự thỏa hiệp đôi bên",
        "Contract": "Hợp đồng kinh tế"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- Bài 5: Vượt ải Thử thách: Bản lĩnh Thương trường
INSERT INTO public.lessons (id, course_id, title, lesson_order, type, xp_reward, content_json)
VALUES (
  'c3333333-3333-3333-3333-300000000005',
  '33333333-3333-3333-3333-333333333333',
  'Vượt ải: Bản lĩnh Thương trường',
  5,
  'test',
  35,
  '[
    {
      "id": "c3_l5_q1",
      "type": "flashcard",
      "word": "Strategic",
      "word_class": "Tính từ",
      "phonetic": "/strəˈtiːdʒɪk/",
      "meaning": "Mang tính chiến lược, tầm nhìn dài hạn",
      "example_sentence": "Forming a strategic alliance will expand our footprint across Asia.",
      "highlight_word": "strategic"
    },
    {
      "id": "c3_l5_q2",
      "type": "multiple_choice",
      "question_text": "Cụm thành ngữ kinh doanh \"Touch base\" (VD: Let''s touch base next Monday) mang nghĩa là:",
      "options": ["Liên lạc lại để cập nhật tình hình", "Chạm tay vào căn cứ", "Ký kết hợp đồng ngay lập tức", "Hủy bỏ toàn bộ cuộc hẹn"],
      "correct_answer": "Liên lạc lại để cập nhật tình hình"
    },
    {
      "id": "c3_l5_q3",
      "type": "fill_in_the_blank",
      "question_text": "Investing in AI technology represents a key ___ milestone for our company.___ ",
      "blanks": ["strategic", "useless", "sleepy", "boring"],
      "correct_answer": "strategic"
    },
    {
      "id": "c3_l5_q4",
      "type": "listening",
      "word": "Let''s think outside the box to find an innovative solution.",
      "options": ["Hãy tư duy đột phá để tìm ra một giải pháp sáng tạo.", "Hãy mở chiếc hộp ra để xem tài liệu bên trong.", "Chúng ta nên làm theo phương pháp truyền thống cũ.", "Dự án này không có tính khả thi."],
      "correct_answer": "Hãy tư duy đột phá để tìm ra một giải pháp sáng tạo."
    },
    {
      "id": "c3_l5_q5",
      "type": "multiple_choice",
      "question_text": "Khi đối tác nói: \"We need to cut down operational overhead\", điều đó có nghĩa là:",
      "options": ["Cắt giảm chi phí vận hành chung", "Tuyển thêm 100 nhân viên mới", "Tăng thêm ngân sách quảng cáo", "Xây dựng thêm văn phòng mới"],
      "correct_answer": "Cắt giảm chi phí vận hành chung"
    },
    {
      "id": "c3_l5_q6",
      "type": "word_matching",
      "matching_pairs": {
        "Strategic": "Mang tầm chiến lược",
        "Milestone": "Cột mốc quan trọng",
        "Stakeholder": "Các bên liên quan",
        "Benchmark": "Tiêu chuẩn đối sánh"
      }
    }
  ]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  course_id = EXCLUDED.course_id,
  title = EXCLUDED.title,
  lesson_order = EXCLUDED.lesson_order,
  type = EXCLUDED.type,
  xp_reward = EXCLUDED.xp_reward,
  content_json = EXCLUDED.content_json;

-- =========================================================================
-- KẾT THÚC SEED DATA: 3 KHÓA HỌC & 15 BÀI HỌC HOÀN CHỈNH
-- =========================================================================
