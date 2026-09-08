import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/profile/data/mock_profile_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Nền gần như trắng tinh khiết
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              
              // --- AVATAR & INFO ---
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                  image: DecorationImage(
                    image: NetworkImage(mockFullProfile.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Name
              Text(
                mockFullProfile.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              // Level Badge (Pill)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                ),
                child: Text(
                  'Level ${mockFullProfile.level}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // --- MINIMALIST STATS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMinimalStatCard(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: const Color(0xFFFF8A65), // Pastel Orange
                      value: mockFullProfile.streakDays.toString(),
                      label: 'Streak',
                    ),
                    _buildMinimalStatCard(
                      icon: Icons.star_rounded,
                      iconColor: const Color(0xFFFFD54F), // Pastel Yellow
                      value: _formatNumber(mockFullProfile.totalXP),
                      label: 'XP',
                    ),
                    _buildMinimalStatCard(
                      icon: Icons.diamond_rounded,
                      iconColor: const Color(0xFF4FC3F7), // Pastel Blue
                      value: _formatNumber(mockFullProfile.totalGems),
                      label: 'Gems',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // --- ACHIEVEMENTS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      mockFullProfile.joinedDate,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Grid Achievements
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  shrinkWrap: true, // Để GridView nằm trong SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 cột
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.8, // Chiều cao nhỉnh hơn chiều rộng
                  ),
                  itemCount: mockFullProfile.achievements.length + 3, // Giả lập thêm vài ô trống
                  itemBuilder: (context, index) {
                    if (index < mockFullProfile.achievements.length) {
                      return _buildMinimalAchievement(mockFullProfile.achievements[index]);
                    } else {
                      // Ô trống (More)
                      return _buildEmptyAchievement();
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 60), // Spacing đáy
            ],
          ),
        ),
      ),
    );
  }

  // Thẻ thống kê tối giản
  Widget _buildMinimalStatCard({
    required IconData icon, 
    required Color iconColor, 
    required String value, 
    required String label
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // Bóng cực kỳ nhẹ
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Huy hiệu thành tựu tối giản (Hình tròn)
  Widget _buildMinimalAchievement(ProfileAchievement achievement) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: achievement.isCompleted ? const Color(0xFF4FC3F7) : const Color(0xFFEEEEEE),
              width: 1.5,
            ),
            boxShadow: [
              if (achievement.isCompleted)
                BoxShadow(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              achievement.iconData,
              size: 32,
              color: achievement.isCompleted ? const Color(0xFF4FC3F7) : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          achievement.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  // Ô huy hiệu trống (Dấu +)
  Widget _buildEmptyAchievement() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
          ),
          child: const Icon(Icons.add, color: Color(0xFFCCCCCC), size: 28),
        ),
        const SizedBox(height: 12),
        const Text(
          'More',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFBBBBBB),
          ),
        ),
      ],
    );
  }

  // Hàm fomat số lượng XP
  String _formatNumber(int number) {
    if (number > 999) {
      return '${(number / 1000).toStringAsFixed(1)}K'; // 4500 -> 4.5K
    }
    return number.toString();
  }
}
