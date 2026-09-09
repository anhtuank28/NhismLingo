import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/home/data/mock_home_data.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/course_card.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/daily_goal_card.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/quick_action_buttons.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/up_next_card.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/animated_flame.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/home_background_painter.dart';
import 'package:nhims_lingo/features/profile/presentation/providers/profile_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy profile thật từ Supabase (nếu đã đăng nhập)
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Lớp nền trang trí cố định toàn màn hình
          Positioned.fill(
            child: CustomPaint(
              painter: HomeBackgroundPainter(),
            ),
          ),
          
          // Nội dung chính
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(profileAsync),
                const SizedBox(height: 24),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 1. Daily Goal ---
                      const Text(
                        'Daily Goal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const DailyGoalCard(),
                      const SizedBox(height: 32),
                      
                      // --- 2. Up Next ---
                      const Text(
                        'Up Next',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const UpNextCard(lesson: mockUpNext),
                      const SizedBox(height: 32),
                      
                      // --- 3. Recommended Courses Section ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerRight,
                            ),
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                
                // Horizontal List of Courses (Tràn viền màn hình)
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: mockRecommendedCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: mockRecommendedCourses[index]);
                    },
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // --- 4. Quick Actions ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: QuickActionButtons(),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildHeader(AsyncValue<ProfileData?> profileAsync) {
    // Lấy tên và streak thật, fallback về giá trị mặc định nếu chưa load xong
    final profile = profileAsync.valueOrNull;
    final streakCount = profile?.streakDays ?? mockUserProfile.streak;
    final avatarUrl = (profile != null && profile.avatarUrl.isNotEmpty) 
        ? profile.avatarUrl 
        : mockUserProfile.avatarUrl;
    final initial = (profile?.fullName.isNotEmpty == true) 
        ? profile!.fullName[0].toUpperCase() 
        : 'N';

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tiêu đề App
          const Text(
            'NhismLingo',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          
          // Cụm Thành tựu bên phải
          Row(
            children: [
              AnimatedFlame(streakCount: streakCount),
              const SizedBox(width: 12),
              // Avatar — Dùng ảnh thật nếu có, fallback về chữ cái đầu
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGrey, width: 1),
                  color: const Color(0xFFF5F5F5),
                ),
                child: avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
