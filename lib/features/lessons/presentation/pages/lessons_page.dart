import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/widgets/gamification_app_bar.dart';
import 'package:nhims_lingo/features/lessons/data/lessons_provider.dart';
import 'package:nhims_lingo/features/lessons/domain/models/lesson_model.dart';
import 'package:nhims_lingo/features/lessons/presentation/widgets/lesson_node_widget.dart';
import 'package:nhims_lingo/features/lessons/presentation/widgets/seamless_path_painter.dart';
import 'package:nhims_lingo/features/lessons/presentation/widgets/map_environment_painter.dart';

class LessonsPage extends ConsumerWidget {
  /// Nếu courseId == null (mở từ Bottom Tab), hiển thị bản đồ mặc định.
  /// Nếu courseId != null (mở từ CoursesPage), load bài học theo khóa.
  final String? courseId;

  const LessonsPage({super.key, this.courseId});

  double getAlignmentX(int index) {
    final pattern = index % 4;
    if (pattern == 0) return 0.0; // center
    if (pattern == 1) return -0.5; // left
    if (pattern == 2) return 0.0; // center
    return 0.5; // right
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Nếu không có courseId, hiển thị thông báo hướng dẫn
    if (courseId == null || courseId!.isEmpty) {
      return _buildNoCourseSelected(context);
    }

    final lessonsAsync = ref.watch(lessonsProvider(courseId!));
    final courseNameAsync = ref.watch(courseNameProvider(courseId!));
    final courseName = courseNameAsync.valueOrNull ?? 'Bài học';

    return Scaffold(
      appBar: GamificationAppBar(
        title: courseName,
        backgroundColor: AppColors.primaryBlue,
        showBackButton: true,
      ),
      body: lessonsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (err, _) => _buildErrorState(context, ref, err.toString()),
        data: (lessons) {
          if (lessons.isEmpty) {
            return _buildEmptyLessons(context);
          }
          return _buildLessonMap(context, lessons);
        },
      ),
    );
  }

  Widget _buildLessonMap(BuildContext context, List<LessonModel> lessons) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double halfWidth = screenWidth / 2;
        
        const double nodeSpacing = 180.0;
        const double topPadding = 150.0;
        const double bottomPadding = 150.0;
        
        final int itemCount = lessons.length;
        final double totalHeight = (itemCount - 1) * nodeSpacing + topPadding + bottomPadding;
        
        // Tính toán trước tọa độ tâm (X, Y) của tất cả bài học
        List<Offset> points = [];
        List<LessonStatus> statuses = [];
        
        for (int i = 0; i < itemCount; i++) {
          final double y = totalHeight - bottomPadding - (i * nodeSpacing);
          final double alignX = getAlignmentX(i);
          final double x = halfWidth + (alignX * halfWidth);
          
          points.add(Offset(x, y));
          statuses.add(lessons[i].status);
        }
        
        return SingleChildScrollView(
          reverse: true, // Cuộn từ dưới lên trên
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: screenWidth,
            height: totalHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFDDF4FF), // Bầu trời
                  Color(0xFFFFFFFF), // Mặt đất
                ],
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // LỚP 1: Môi trường tĩnh (Cây, cỏ, mây, đá)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: MapEnvironmentPainter(),
                    ),
                  ),
                ),
                
                // LỚP 2: Con đường liền mạch xuyên suốt bản đồ
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: SeamlessPathPainter(
                        points: points,
                        statuses: statuses,
                      ),
                    ),
                  ),
                ),
                
                // LỚP 3: Các trạm bài học (Islands/Nodes 2.5D)
                ...List.generate(itemCount, (i) {
                  final point = points[i];
                  final lesson = lessons[i];
                  
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: point.dy - 120,
                    child: Align(
                      alignment: Alignment(getAlignmentX(i), 0),
                      child: LessonNodeWidget(
                        lesson: lesson,
                        onTap: () {
                          _showLessonDialog(context, lesson);
                        },
                      ),
                    ),
                  );
                }).reversed,
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLessonDialog(BuildContext context, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            lesson.title,
            style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          content: Text(
            lesson.status == LessonStatus.current
                ? 'Bạn đã sẵn sàng vượt ải này chưa?'
                : 'Bạn muốn quay lại ôn tập ải này?',
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ĐỂ SAU', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Đóng popup
                // Navigate sang QuizPage với lessonId + courseId
                context.push('/quiz/${lesson.id}?courseId=${courseId ?? ''}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
              ),
              child: const Text('CHIẾN LUÔN!', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoCourseSelected(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bài học',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 0.5),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu_book_rounded, size: 64, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 24),
              const Text(
                'Chọn một khóa học',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Hãy vào tab Khóa học và chọn một khóa để bắt đầu hành trình học tập! 🦔',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/courses'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text('XEM KHÓA HỌC', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyLessons(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty_rounded, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text(
            'Chưa có bài học nào',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Khóa học này đang được xây dựng nội dung',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('Lỗi tải bài học', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(lessonsProvider(courseId!)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
