import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/widgets/gamification_app_bar.dart';
import 'package:nhims_lingo/features/courses/data/courses_provider.dart';
import 'package:nhims_lingo/features/courses/domain/models/course_model.dart';
import 'package:nhims_lingo/features/courses/presentation/widgets/course_list_item.dart';

class CoursesPage extends ConsumerStatefulWidget {
  const CoursesPage({super.key});

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const GamificationAppBar(
        backgroundColor: Color(0xFFF9F9F9),
      ),
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
                    const Icon(Icons.search_rounded, color: Color(0xFF1460D9), size: 20),
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
            _buildCategoryChips(coursesAsync),
            const SizedBox(height: 20),
            
            // 3. Danh sách Khoá học
            Expanded(
              child: coursesAsync.when(
                loading: () => _buildLoadingState(),
                error: (err, _) => _buildErrorState(err.toString()),
                data: (courses) {
                  final filtered = _selectedCategory == 'all'
                      ? courses
                      : courses.where((c) => c.category == _selectedCategory).toList();

                  if (filtered.isEmpty) return _buildEmptyState();

                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(coursesProvider.future),
                    color: AppColors.primaryBlue,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return CourseListItem(
                          course: filtered[index],
                          onTap: () {
                            // Navigate sang bản đồ bài học
                            context.push('/lessons/${filtered[index].id}');
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips(AsyncValue<List<CourseModel>> coursesAsync) {
    // Trích xuất unique categories từ danh sách courses
    final categories = coursesAsync.whenOrNull(
      data: (courses) {
        final cats = courses.map((c) => c.category).toSet().toList();
        cats.sort();
        return ['all', ...cats];
      },
    ) ?? ['all'];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          final label = cat == 'all' ? 'courses.categories.all'.tr() : _formatCategory(cat);
          
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1460D9) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: isSelected ? null : Border.all(color: const Color(0xFFEEEEEE), width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.white : const Color(0xFF444444),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Chuyển tên category từ DB (snake_case) thành dạng dễ đọc
  String _formatCategory(String raw) {
    // Thử dùng translation key trước
    final key = 'courses.categories.$raw';
    final translated = key.tr();
    if (translated != key) return translated;
    
    // Fallback: capitalize first letter
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shimmer ảnh
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 180, height: 14, decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 12),
                    Container(width: 120, height: 12, decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải khóa học',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(coursesProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
