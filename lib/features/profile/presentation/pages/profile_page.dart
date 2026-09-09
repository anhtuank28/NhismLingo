import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/profile/presentation/providers/profile_provider.dart';
import 'package:nhims_lingo/features/auth/presentation/providers/auth_provider.dart';
import 'package:nhims_lingo/features/auth/domain/models/auth_state.dart';
import 'package:nhims_lingo/features/auth/presentation/widgets/login_required_widget.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kéo trạng thái đăng nhập
    final authState = ref.watch(authProvider);

    // Bức tường chặn Guest Mode
    if (authState.status == AuthStatus.guest || authState.status == AuthStatus.unauthenticated) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDFDFD),
        body: LoginRequiredWidget(
          title: 'Hồ sơ của bạn',
          description: 'Đăng nhập để xem hồ sơ cá nhân, lưu trữ tiến độ học tập và quản lý tài khoản.',
          icon: Icons.person_rounded,
        ),
      );
    }

    // Lấy dữ liệu profile thật từ Supabase
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
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
      body: profileAsync.when(
        // Đang tải
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        // Lỗi
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFE57373)),
              const SizedBox(height: 16),
              const Text('Không thể tải hồ sơ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(profileDataProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        // Đã có data
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Không tìm thấy hồ sơ'));
          }

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  
                  // --- AVATAR ---
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                      color: const Color(0xFFF5F5F5),
                    ),
                    child: profile.avatarUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              profile.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildDefaultAvatar(profile.fullName),
                            ),
                          )
                        : _buildDefaultAvatar(profile.fullName),
                  ),
                  const SizedBox(height: 16),
                  
                  // Name - Hiển thị tên thật từ Supabase
                  Text(
                    profile.fullName.isNotEmpty ? profile.fullName : 'Nhím Học Giỏi',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                    ),
                    child: Text(
                      'Level ${profile.level}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // --- STATS THẬT ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMinimalStatCard(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFFF8A65),
                          value: profile.streakDays.toString(),
                          label: 'Streak',
                        ),
                        _buildMinimalStatCard(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFFFD54F),
                          value: _formatNumber(profile.totalXp),
                          label: 'XP',
                        ),
                        _buildMinimalStatCard(
                          icon: Icons.diamond_rounded,
                          iconColor: const Color(0xFF4FC3F7),
                          value: _formatNumber(profile.totalGems),
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
                          profile.joinedDate,
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
                  
                  // Grid Achievements (giữ nguyên placeholder cho Sprint 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.8,
                      children: [
                        _buildAchievementItem(
                          icon: Icons.wb_sunny_rounded,
                          title: 'Early Bird',
                          isCompleted: profile.streakDays >= 7,
                        ),
                        _buildAchievementItem(
                          icon: Icons.public_rounded,
                          title: 'Polyglot Pro',
                          isCompleted: profile.totalXp >= 1000,
                        ),
                        _buildAchievementItem(
                          icon: Icons.local_fire_department_rounded,
                          title: 'Streak Master',
                          isCompleted: profile.streakDays >= 30,
                        ),
                        _buildEmptyAchievement(),
                        _buildEmptyAchievement(),
                        _buildEmptyAchievement(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // --- NÚT ĐĂNG XUẤT ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showLogoutDialog(context, ref),
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text('Đăng xuất'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE57373),
                          side: const BorderSide(color: Color(0xFFE57373), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Avatar mặc định (chữ cái đầu tên)
  Widget _buildDefaultAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '🦔';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryBlue,
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
              color: Colors.black.withOpacity(0.02),
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

  // Huy hiệu thành tựu (dựa trên dữ liệu thật)
  Widget _buildAchievementItem({
    required IconData icon,
    required String title,
    required bool isCompleted,
  }) {
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
              color: isCompleted ? const Color(0xFF4FC3F7) : const Color(0xFFEEEEEE),
              width: 1.5,
            ),
            boxShadow: [
              if (isCompleted)
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
              icon,
              size: 32,
              color: isCompleted ? const Color(0xFF4FC3F7) : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
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

  // Format số lượng XP
  String _formatNumber(int number) {
    if (number > 999) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Dialog xác nhận đăng xuất
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Đăng xuất',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất không?',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Đóng dialog trước
              ref.read(authProvider.notifier).signOut(); // Gọi đăng xuất
              context.go('/'); // Chuyển về màn hình Welcome
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
