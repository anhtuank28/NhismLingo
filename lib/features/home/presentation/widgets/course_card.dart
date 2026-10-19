import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/home/data/mock_home_data.dart';

import 'package:nhims_lingo/features/courses/domain/models/course_model.dart';

class CourseCard extends StatelessWidget {
  final RecommendedCourse? course;
  final CourseModel? courseModel;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    this.course,
    this.courseModel,
    this.onTap,
  }) : assert(course != null || courseModel != null, 'Either course or courseModel must be provided');

  @override
  Widget build(BuildContext context) {
    final title = courseModel?.title ?? course?.title ?? '';
    final subtitle = courseModel?.description ?? course?.subtitle ?? '';
    final imageUrl = (courseModel?.imageUrl.isNotEmpty ?? false)
        ? courseModel!.imageUrl
        : (course?.imageUrl ?? '');
    final badgeText = courseModel?.level ?? course?.badgeText ?? 'A1';
    final lessonCountText = courseModel != null
        ? '${courseModel!.totalLessons} bài học'
        : (course?.lessonCount ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 220, // Rộng hơn một chút để chứa ảnh đẹp
      margin: const EdgeInsets.only(right: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nửa trên: Hình ảnh & Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 110,
                          color: const Color(0xFFE5EDF6),
                          child: const Icon(Icons.school_rounded, color: AppColors.primaryBlue, size: 36),
                        ),
                      )
                    : Container(
                        height: 110,
                        color: const Color(0xFFE5EDF6),
                        child: const Icon(Icons.school_rounded, color: AppColors.primaryBlue, size: 36),
                      ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
            ],
          ),
          
          // Nửa dưới: Thông tin
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222), // Tăng độ đậm nét
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666), // Xám đậm và rõ nét hơn
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  lessonCountText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}
