import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
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
                  context.go('/home'); // Fallback nếu không có gì để pop
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
        // Hiển thị Streak và Gems
        profileAsync.maybeWhen(
          data: (profile) {
            if (profile == null) return const SizedBox.shrink();
            
            final streak = profile.streakDays;
            final gems = profile.totalGems;

            return Row(
              children: [
                _buildStatBadge(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: Colors.orange,
                  value: streak.toString(),
                  textColor: _getTextColor(),
                ),
                const SizedBox(width: 8),
                _buildStatBadge(
                  icon: Icons.diamond_rounded,
                  iconColor: Colors.blueAccent,
                  value: gems.toString(),
                  textColor: _getTextColor(),
                ),
                const SizedBox(width: 16),
              ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required Color iconColor,
    required String value,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTextColor() {
    // Nếu nền là primaryBlue thì chữ trắng, ngược lại chữ đậm
    if (backgroundColor == AppColors.primaryBlue) {
      return Colors.white;
    }
    return AppColors.textPrimary;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
