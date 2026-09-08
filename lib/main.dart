import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/router/app_router.dart';
import 'package:nhims_lingo/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:nhims_lingo/core/services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lctujuziarczovyiuiod.supabase.co',
    anonKey: 'sb_publishable_Ph5YLHnaafdSz8oLMXCvZA_tYTWDAc1',
  );
  
  // Khởi tạo Text-to-Speech Engine
  await TTSService.instance.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy ra bộ điều hướng (Router) từ Provider
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'NhismLingo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      // Bàn giao quyền điều hướng cho GoRouter
      routerConfig: router,
    );
  }
}
