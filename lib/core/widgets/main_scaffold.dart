import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  // Xử lý sự kiện khi người dùng bấm vào một tab
  void _onItemTapped(int index, BuildContext context) {
    // goBranch giúp chuyển tab mà không làm mất trạng thái (state) hiện tại của tab đó
    navigationShell.goBranch(
      index,
      // Hỗ trợ hành vi bấm lại vào tab đang mở để quay về trang gốc của tab đó
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Lõi của Scaffold chính là nội dung của tab hiện tại do GoRouter truyền vào
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed, // Đảm bảo các icon không bị nhúc nhích khi bấm
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'bottom_nav.home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_outlined),
              activeIcon: const Icon(Icons.menu_book),
              label: 'bottom_nav.courses'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.play_circle_outline),
              activeIcon: const Icon(Icons.play_circle),
              label: 'bottom_nav.lessons'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.leaderboard_outlined),
              activeIcon: const Icon(Icons.leaderboard),
              label: 'bottom_nav.leaderboard'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'bottom_nav.profile'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
