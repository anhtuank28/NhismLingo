import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/courses/data/mock_courses_data.dart';
import 'package:nhims_lingo/features/courses/presentation/widgets/category_chips.dart';
import 'package:nhims_lingo/features/courses/presentation/widgets/course_list_item.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _selectedCategory = 'courses.categories.all';

  List<CourseItem> get filteredCourses {
    if (_selectedCategory == 'courses.categories.all') {
      return mockCoursesList;
    }
    return mockCoursesList.where((course) => course.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final courses = filteredCourses;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Nền xám nhạt
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Search Bar
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF1460D9), size: 20), // Icon kính lúp xanh đậm
                    const SizedBox(width: 12),
                    Text(
                      'courses.search_hint'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 2. Bộ lọc danh mục (Category Chips)
            CategoryChips(
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 20),
            
            // 3. Danh sách Khoá học (List View)
            Expanded(
              child: courses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return CourseListItem(course: courses[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'courses.no_courses_found'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
