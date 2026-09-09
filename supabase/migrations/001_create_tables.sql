-- =====================================================
-- NhismLingo Database Schema
-- Sprint 1: Database Foundation
-- =====================================================

-- 1. BẢNG PROFILES (Hồ sơ người dùng)
-- Tự động tạo 1 dòng khi có user mới đăng ký
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL DEFAULT '',
  avatar_url TEXT DEFAULT '',
  level INT NOT NULL DEFAULT 1,
  total_xp INT NOT NULL DEFAULT 0,
  total_gems INT NOT NULL DEFAULT 0,
  streak_days INT NOT NULL DEFAULT 0,
  last_active_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Bật Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Ai cũng có thể XEM profiles (cho Leaderboard)
CREATE POLICY "Profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

-- Policy: User chỉ được SỬA profile của chính mình
CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Policy: User chỉ được INSERT profile của chính mình (cho trigger)
CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- =====================================================
-- 2. TRIGGER: Tự động tạo profile khi user mới đăng ký
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Gắn trigger vào bảng auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- 3. BẢNG COURSES (Khóa học)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  level TEXT NOT NULL DEFAULT 'A1', -- A1, A2, B1, B2, C1
  total_lessons INT NOT NULL DEFAULT 0,
  category TEXT NOT NULL DEFAULT 'speaking', -- speaking, vocabulary, grammar, listening
  rating NUMERIC(2,1) DEFAULT 0.0,
  review_count INT DEFAULT 0,
  is_published BOOLEAN DEFAULT true,
  display_order INT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;

-- Ai cũng có thể xem courses
CREATE POLICY "Courses are viewable by everyone"
  ON public.courses FOR SELECT
  USING (true);

-- =====================================================
-- 4. BẢNG LESSONS (Bài học trong khóa học)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  lesson_order INT NOT NULL DEFAULT 0,
  type TEXT NOT NULL DEFAULT 'new_concept', -- new_concept, review, treasure, test
  content_json JSONB DEFAULT '[]'::jsonb, -- Chứa danh sách câu hỏi (flashcard + multiple_choice)
  xp_reward INT NOT NULL DEFAULT 10,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;

-- Ai cũng có thể xem lessons
CREATE POLICY "Lessons are viewable by everyone"
  ON public.lessons FOR SELECT
  USING (true);

-- =====================================================
-- 5. BẢNG USER_PROGRESS (Tiến độ học của từng user)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'locked', -- locked, unlocked, in_progress, completed
  score INT DEFAULT 0, -- Điểm bài quiz (0-100)
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Mỗi user chỉ có 1 bản ghi cho mỗi lesson
  UNIQUE(user_id, lesson_id)
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

-- User chỉ xem được tiến độ của chính mình
CREATE POLICY "Users can view their own progress"
  ON public.user_progress FOR SELECT
  USING (auth.uid() = user_id);

-- User chỉ được tạo/sửa tiến độ của chính mình
CREATE POLICY "Users can insert their own progress"
  ON public.user_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress"
  ON public.user_progress FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- 6. INDEX để tăng tốc truy vấn
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_lessons_course_id ON public.lessons(course_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON public.user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_lesson_id ON public.user_progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_profiles_total_xp ON public.profiles(total_xp DESC); -- Cho Leaderboard
