import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nhims_lingo/core/widgets/main_scaffold.dart';
import 'package:nhims_lingo/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:nhims_lingo/features/home/presentation/pages/home_page.dart';
import 'package:nhims_lingo/features/courses/presentation/pages/courses_page.dart';
import 'package:nhims_lingo/features/lessons/presentation/pages/lessons_page.dart';
import 'package:nhims_lingo/features/quiz/presentation/pages/quiz_page.dart';
import 'package:nhims_lingo/features/profile/presentation/pages/profile_page.dart';

// Chìa khóa (Key) để quản lý Navigator gốc của toàn bộ ứng dụng
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// Khởi tạo Trạm kiểm soát Điều hướng (Router Provider)
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/', // Vị trí xuất phát luôn là trang Welcome
    routes: [
      // Tuyến đường độc lập: Welcome (Không có thanh Bottom Bar)
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomePage(),
      ),
      
      // Tuyến đường có vỏ bọc (Shell Route) cho 5 Tab chính
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Trả về MainScaffold, nhồi 5 tab vào bên trong
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Nhánh 1: Trang chủ
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Nhánh 2: Khóa học
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/courses',
                builder: (context, state) => const CoursesPage(),
              ),
            ],
          ),
          // Nhánh 3: Bài học
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lessons',
                builder: (context, state) => const LessonsPage(),
              ),
            ],
          ),
          // Nhánh 4: Luyện tập
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/quiz',
                builder: (context, state) => const QuizPage(lessonTitle: 'Ôn tập nhanh'),
              ),
            ],
          ),
          // Nhánh 5: Hồ sơ
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
