-- =====================================================
-- NhismLingo Migration 004: Lesson Completion & XP RPC
-- =====================================================

CREATE OR REPLACE FUNCTION public.complete_lesson_and_award_xp(
  p_course_id UUID,
  p_lesson_id UUID,
  p_score INT,
  p_xp_earned INT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id UUID;
  v_current_xp INT := 0;
  v_current_streak INT := 0;
  v_last_active DATE;
  v_new_streak INT := 1;
  v_today DATE := CURRENT_DATE;
  v_new_xp INT := 0;
  v_new_level INT := 1;
  v_result JSONB;
BEGIN
  -- Lấy user ID hiện tại từ auth context
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- 1. Upsert user_progress
  INSERT INTO public.user_progress (
    user_id,
    course_id,
    lesson_id,
    status,
    score,
    completed_at
  )
  VALUES (
    v_user_id,
    p_course_id,
    p_lesson_id,
    'completed',
    p_score,
    NOW()
  )
  ON CONFLICT (user_id, lesson_id)
  DO UPDATE SET
    status = 'completed',
    score = GREATEST(public.user_progress.score, EXCLUDED.score),
    completed_at = NOW();

  -- 2. Đọc profile hiện tại của user (với khoá FOR UPDATE để đảm bảo tính nguyên tử)
  SELECT
    COALESCE(total_xp, 0),
    COALESCE(streak_days, 0),
    last_active_date
  INTO
    v_current_xp,
    v_current_streak,
    v_last_active
  FROM public.profiles
  WHERE id = v_user_id
  FOR UPDATE;

  -- 3. Tính toán chuỗi Streak theo ngày trên Database Server
  IF v_last_active IS NULL THEN
    v_new_streak := 1;
  ELSIF v_last_active = v_today THEN
    v_new_streak := v_current_streak; -- Đã học hôm nay, giữ nguyên streak
  ELSIF v_last_active = v_today - 1 THEN
    v_new_streak := v_current_streak + 1; -- Ngày hôm qua vừa học -> tăng streak
  ELSE
    v_new_streak := 1; -- Bỏ lỡ hơn 1 ngày -> reset về 1
  END IF;

  -- 4. Tính XP và Level mới (mỗi 500 XP = 1 level)
  v_new_xp := v_current_xp + GREATEST(p_xp_earned, 0);
  v_new_level := FLOOR(v_new_xp / 500) + 1;

  -- 5. Cập nhật profiles
  UPDATE public.profiles
  SET
    total_xp = v_new_xp,
    level = v_new_level,
    streak_days = v_new_streak,
    last_active_date = v_today,
    updated_at = NOW()
  WHERE id = v_user_id;

  v_result := jsonb_build_object(
    'total_xp', v_new_xp,
    'level', v_new_level,
    'streak_days', v_new_streak
  );

  RETURN v_result;
END;
$$;
