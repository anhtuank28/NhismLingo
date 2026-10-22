import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/widgets/tactile_3d_button.dart';
import 'package:nhims_lingo/features/home/data/mock_home_data.dart';

class UpNextCard extends StatelessWidget {
  final UpNextLesson lesson;
  final String? courseId;
  final VoidCallback? onContinue;

  const UpNextCard({
    super.key,
    required this.lesson,
    this.courseId,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Pill & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FA),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lesson.unitText,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F5FA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              )
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Title & Subtitle
          Text(
            lesson.title,
            style: const TextStyle(
              color: Color(0xFF111111), // Đen tuyền sắc nét
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.subtitle,
            style: const TextStyle(
              color: Color(0xFF666666), // Xám đậm rõ nét hơn
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Bottom Row: Progress & Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Bar
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5EA),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: lesson.progress,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(lesson.progress * 100).toInt()}% Complete',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              
              // Continue Button with 3D tactile feedback
              Tactile3DButton(
                text: 'Continue',
                icon: Icons.play_arrow_rounded,
                variant: TactileButtonVariant.primary,
                height: 44,
                borderRadius: 100,
                isFullWidth: false,
                onPressed: () {
                  if (onContinue != null) {
                    onContinue!();
                  } else if (courseId != null && courseId!.isNotEmpty) {
                    context.push('/lessons/$courseId');
                  } else {
                    context.go('/courses');
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
