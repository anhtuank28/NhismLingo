import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/widgets/primary_button.dart';
import 'package:nhims_lingo/features/onboarding/presentation/widgets/feature_tag.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Phần trên: Hình ảnh minh họa với viền cong và shadow
            Expanded(
              flex: 45, // Giảm ảnh một chút
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBg,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/welcome_bg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Nút chuyển đổi ngôn ngữ
                  Positioned(
                    top: 16,
                    right: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Nền trắng tinh khôi
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            final currentLocale = context.locale.languageCode;
                            if (currentLocale == 'en') {
                              context.setLocale(const Locale('vi'));
                            } else {
                              context.setLocale(const Locale('en'));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.language, size: 18, color: AppColors.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  context.locale.languageCode == 'en' ? 'EN / vi' : 'VI / en',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryBlue,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Phần dưới: Nội dung chữ và các nút bấm
            Expanded(
              flex: 55, // Tăng không gian cho text đa ngôn ngữ
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0), // Giảm lề để không gian rộng hơn
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cụm Tiêu đề, Mô tả và Thẻ (Tags)
                    Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'welcome.title_welcome'.tr(),
                            style: GoogleFonts.nunito(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'welcome.title_brand'.tr(),
                                style: GoogleFonts.nunito(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'welcome.subtitle'.tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24), // Giảm khoảng cách để chống tràn
                        // Thẻ (Tags) - Không dùng const nữa vì text tải động
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FeatureTag(icon: Icons.bolt_rounded, text: 'welcome.tag_fast_lessons'.tr()),
                            const SizedBox(width: 16),
                            FeatureTag(icon: Icons.chat_bubble_rounded, text: 'welcome.tag_real_speech'.tr()),
                          ],
                        ),
                      ],
                    ),

                    // Cụm Nút bấm
                    Column(
                      children: [
                        PrimaryButton(
                          text: 'welcome.btn_get_started'.tr(),
                          onPressed: () {
                            context.go('/home');
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryBlue,
                          ),
                          child: Text(
                            'welcome.btn_already_have_account'.tr(),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
