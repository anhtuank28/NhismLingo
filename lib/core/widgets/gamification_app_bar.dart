import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/theme/app_typography.dart';
import 'package:nhims_lingo/core/providers/hearts_provider.dart';
import 'package:nhims_lingo/features/profile/presentation/providers/profile_provider.dart';

class GamificationAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final Color backgroundColor;

  const GamificationAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final hearts = ref.watch(heartsProvider);

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: title != null,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: _getTextColor()),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: _getTextColor(),
                letterSpacing: 0.5,
              ),
            )
          : null,
      actions: [
        // Hiển thị Streak, Gems và Hearts
        profileAsync.maybeWhen(
          data: (profile) {
            final streak = profile?.streakDays ?? 0;
            final gems = profile?.totalGems ?? 0;

            return Row(
              children: [
                // 1. Streak Badge
                _buildStatBadge(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AppColors.streakOrange,
                  value: streak.toString(),
                  textColor: _getTextColor(),
                  onTap: () => _showStreakDialog(context, streak),
                ),
                const SizedBox(width: 8),

                // 2. Gems Badge
                _buildStatBadge(
                  icon: Icons.diamond_rounded,
                  iconColor: AppColors.gemCyan,
                  value: gems.toString(),
                  textColor: _getTextColor(),
                  onTap: () => _showGemsDialog(context, gems),
                ),
                const SizedBox(width: 8),

                // 3. Hearts Badge
                _buildStatBadge(
                  icon: Icons.favorite_rounded,
                  iconColor: AppColors.heartRed,
                  value: hearts.toString(),
                  textColor: _getTextColor(),
                  onTap: () => _showHeartsDialog(context, ref, hearts),
                ),
                const SizedBox(width: 16),
              ],
            );
          },
          orElse: () => Row(
            children: [
              _buildStatBadge(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.heartRed,
                value: hearts.toString(),
                textColor: _getTextColor(),
                onTap: () => _showHeartsDialog(context, ref, hearts),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required Color iconColor,
    required String value,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: textColor.withValues(alpha: 0.08), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 5),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStreakDialog(BuildContext context, int streak) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, color: AppColors.streakOrange, size: 32),
            const SizedBox(width: 8),
            Text('Chuỗi $streak ngày!', style: AppTypography.heading2),
          ],
        ),
        content: Text(
          streak > 0
              ? 'Tuyệt vời! Bạn đang duy trì chuỗi học tập $streak ngày liên tiếp. Hãy học thêm bài hôm nay để giữ ngọn lửa bùng cháy nhé! 🔥'
              : 'Hãy bắt đầu học 1 bài hôm nay để thắp sáng chuỗi Streak đầu tiên nào! 🔥',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ĐÃ HIỂU', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  void _showGemsDialog(BuildContext context, int gems) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.diamond_rounded, color: AppColors.gemCyan, size: 32),
            const SizedBox(width: 8),
            Text('$gems Bảo thạch', style: AppTypography.heading2),
          ],
        ),
        content: Text(
          'Bảo thạch (Gems) được dùng để hồi máu trái tim hoặc mua vật phẩm đóng băng chuỗi (Streak Freeze). Cố gắng tích lũy thêm bằng cách hoàn thành các bài học nhé! 💎',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ĐÓNG', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  void _showHeartsDialog(BuildContext context, WidgetRef ref, int hearts) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: AppColors.heartRed, size: 32),
            const SizedBox(width: 8),
            Text('$hearts/5 Trái tim', style: AppTypography.heading2),
          ],
        ),
        content: Text(
          hearts == 5
              ? 'Bạn đang có đầy đủ 5/5 Trái tim! Hãy tự tin bắt đầu các bài học mới mà không sợ gián đoạn! ❤️'
              : 'Mỗi câu trả lời sai sẽ làm mất 1 trái tim. Bạn có muốn nạp đầy 5 trái tim ngay không?',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ĐÓNG', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          ),
          if (hearts < 5)
            ElevatedButton(
              onPressed: () {
                ref.read(heartsProvider.notifier).refillHearts();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.heartRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('HỒI PHỤC NGAY (FREE)', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }

  Color _getTextColor() {
    if (backgroundColor == AppColors.primaryBlue) {
      return Colors.white;
    }
    return AppColors.textPrimary;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
