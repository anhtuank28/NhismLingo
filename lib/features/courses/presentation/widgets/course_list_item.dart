import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nhims_lingo/features/courses/domain/models/course_model.dart';

class CourseListItem extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const CourseListItem({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Phần Ảnh bìa & Tiêu đề đè lên ảnh
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh bìa
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: course.imageUrl.isNotEmpty
                        ? Image.network(
                            course.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                  
                  // Lớp gradient đen che phủ phía dưới ảnh để làm nổi chữ
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0x99000000), // Đen mờ 60% ở dưới
                        ],
                      ),
                    ),
                  ),
                  
                  // Tiêu đề khóa học (Góc dưới bên trái)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Badge Level (A1, A2, B2) ở góc trên bên phải
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00796B), // Xanh ngọc đậm (Teal)
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 2. Phần chi tiết thông tin
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Số bài học & Đánh giá
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cụm Bài học
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 6),
                          Text(
                            '${course.totalLessons} ${'courses.lessons_count'.tr()}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Cụm Đánh giá
                      if (course.rating > 0)
                        Row(
                          children: [
                            const Icon(Icons.star_border_rounded, size: 16, color: Color(0xFFB57C00)),
                            const SizedBox(width: 4),
                            Text(
                              '${course.rating} (${course.reviewCount})',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 3. Tiến độ & Nút bấm
                  if (course.progress > 0) 
                    _buildInProgressSection()
                  else 
                    _buildNotStartedSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, size: 48, color: Color(0xFFCCCCCC)),
      ),
    );
  }

  // Giao diện khi ĐÃ BẮT ĐẦU học (Tiến độ > 0)
  Widget _buildInProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chữ "Tiến độ của bạn" và %
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'courses.progress_label'.tr(),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(course.progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1460D9), // Xanh dương đậm
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Thanh Progress Bar
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E8EB), // Xám nền
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: course.progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF1460D9), // Xanh dương đậm
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Nút Tiếp tục học (To tràn ngang)
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1460D9), // Xanh dương đậm Vibrant
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'courses.btn_resume'.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Giao diện khi CHƯA BẮT ĐẦU học (Tiến độ = 0)
  Widget _buildNotStartedSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'courses.status_not_started'.tr(),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        // Nút Bắt đầu ngay (Xanh lợt, nằm bên phải)
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE1EDFF), // Xanh dương siêu nhạt
              foregroundColor: const Color(0xFF1460D9), // Chữ xanh dương đậm
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(
              'courses.btn_start_now'.tr(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
