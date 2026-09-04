import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/home/data/mock_home_data.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/course_card.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/daily_goal_card.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/quick_action_buttons.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/up_next_card.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/animated_flame.dart';
import 'package:nhims_lingo/features/home/presentation/widgets/home_background_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Màu nền xám nhạt như mockup
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
                _buildHeader(),
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
                  height: 260, // Đã tăng chiều cao để tránh bị lỗi Overflow (thừa 18 pixels)
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
                
                const SizedBox(height: 40), // Padding cuối trang
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              AnimatedFlame(streakCount: mockUserProfile.streak),
              const SizedBox(width: 12),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGrey, width: 1),
                  image: DecorationImage(
                    image: NetworkImage(mockUserProfile.avatarUrl),
                    fit: BoxFit.cover,
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
