import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/features/home/presentation/pages/home_page.dart';
import 'package:nhims_lingo/features/onboarding/presentation/pages/welcome_page.dart';

// Khởi tạo Trạm kiểm soát Điều hướng (Router Provider)
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
