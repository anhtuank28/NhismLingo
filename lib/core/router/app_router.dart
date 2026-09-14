import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nhims_lingo/core/widgets/main_scaffold.dart';
import 'package:nhims_lingo/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:nhims_lingo/features/home/presentation/pages/home_page.dart';
import 'package:nhims_lingo/features/courses/presentation/pages/courses_page.dart';
import 'package:nhims_lingo/features/lessons/presentation/pages/lessons_page.dart';
import 'package:nhims_lingo/features/quiz/presentation/pages/leaderboard_page.dart';
import 'package:nhims_lingo/features/quiz/presentation/pages/quiz_page.dart';
import 'package:nhims_lingo/features/quiz/presentation/pages/quiz_result_page.dart';
import 'package:nhims_lingo/features/profile/presentation/pages/profile_page.dart';
import 'package:nhims_lingo/features/auth/presentation/pages/login_page.dart';
import 'package:nhims_lingo/features/auth/presentation/pages/register_page.dart';
import 'package:nhims_lingo/features/auth/presentation/providers/auth_provider.dart';
import 'package:nhims_lingo/features/auth/domain/models/auth_state.dart';

// Chìa khóa (Key) để quản lý Navigator gốc
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

Page<dynamic> _fadeTransition(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

Page<dynamic> _slideTransition(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

/// Chuông báo thức (Listenable) cho GoRouter.
/// Khi trạng thái Auth thay đổi, nó sẽ rung chuông để GoRouter chạy lại hàm redirect.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    ref.listen<AppAuthState>(authProvider, (_, __) {
      notifyListeners(); // Rung chuông -> GoRouter chạy lại redirect
    });
  }
}

// Tạo chuông báo thức (chỉ tạo 1 lần duy nhất)
final _authChangeNotifierProvider = Provider<AuthChangeNotifier>((ref) {
  return AuthChangeNotifier(ref);
});

// Khởi tạo GoRouter (CHỈ TẠO 1 LẦN DUY NHẤT)
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(_authChangeNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier, // Gắn chuông báo thức vào GoRouter
    redirect: (context, state) {
      // Mỗi khi chuông rung, hàm này chạy lại để kiểm tra quyền truy cập
      final authState = ref.read(authProvider); // Dùng read() thay vì watch()!

      final isAuth = authState.status == AuthStatus.authenticated;
      final isGuest = authState.status == AuthStatus.guest;
      final isUnauth = authState.status == AuthStatus.unauthenticated;

      final currentPath = state.uri.path;
      final isGoingToAuthScreen = currentPath == '/' ||
          currentPath == '/login' ||
          currentPath == '/register';

      // Nếu chưa có trạng thái rõ ràng (đang check hoặc đang loading), đứng im
      if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) return null;

      // Đã Đăng nhập mà đang ở Welcome/Login/Register -> Đá vào Home
      if (isAuth && isGoingToAuthScreen) {
        return '/home';
      }

      // Là Khách mà đang ở Welcome -> Đá vào Home
      // CHO PHÉP Khách đi vào /login và /register
      if (isGuest && currentPath == '/') {
        return '/home';
      }

      // Chưa Đăng nhập và không phải Khách -> Đá ra Welcome
      if (isUnauth && !isGoingToAuthScreen) {
        return '/';
      }

      return null;
    },
    routes: [
      // Welcome (Không có Bottom Bar)
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _fadeTransition(context, state, const WelcomePage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadeTransition(context, state, const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _fadeTransition(context, state, const RegisterPage()),
      ),

      // ===== Routes Standalone (KHÔNG có Bottom Bar) =====
      
      // Bản đồ bài học theo khóa (từ Courses bấm vào)
      GoRoute(
        path: '/lessons/:courseId',
        pageBuilder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          return _slideTransition(context, state, LessonsPage(courseId: courseId));
        },
      ),

      // Quiz (làm bài)
      GoRoute(
        path: '/quiz/:lessonId',
        pageBuilder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          final courseId = state.uri.queryParameters['courseId'] ?? '';
          return _slideTransition(context, state, QuizPage(lessonId: lessonId, courseId: courseId));
        },
      ),

      // Kết quả Quiz
      GoRoute(
        path: '/quiz-result',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _fadeTransition(context, state, QuizResultPage(
            score: extra['score'] as int? ?? 0,
            totalQuestions: extra['totalQuestions'] as int? ?? 0,
            xpEarned: extra['xpEarned'] as int? ?? 0,
            courseId: extra['courseId'] as String? ?? '',
            lessonId: extra['lessonId'] as String? ?? '',
            lessonTitle: extra['lessonTitle'] as String? ?? '',
          ));
        },
      ),

      // 5 Tab chính (có Bottom Bar)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
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
          // Nhánh 3: Bài học (mặc định - hiển thị tất cả hoặc khóa đầu tiên)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lessons',
                builder: (context, state) => const LessonsPage(),
              ),
            ],
          ),
          // Nhánh 4: Bảng xếp hạng
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/quiz',
                builder: (context, state) => const LeaderboardPage(lessonTitle: 'Ôn tập nhanh'),
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
