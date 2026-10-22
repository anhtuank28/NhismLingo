import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/core/widgets/skeleton_loading.dart';
import 'package:nhims_lingo/core/widgets/gamification_app_bar.dart';
import 'package:nhims_lingo/core/widgets/nhism_mascot_widget.dart';
import 'package:nhims_lingo/core/widgets/tactile_3d_button.dart';
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
        loading: () => _buildSkeletonLoading(context),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NhismMascotWidget(
                mood: lesson.status == LessonStatus.current ? MascotMood.happy : MascotMood.curious,
                speechBubbleText: lesson.status == LessonStatus.current
                    ? 'Bé Nhím sẵn sàng rồi! Vào việc thôi!'
                    : 'Ôn tập lại để nhớ thật lâu nha!',
                size: 90,
              ),
              const SizedBox(height: 12),
              Text(
                'Vượt ải này để nhận +${lesson.totalExp} XP và tích lũy đá quý nhé!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ĐỂ SAU', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            ),
            Tactile3DButton(
              text: 'CHIẾN LUÔN!',
              variant: TactileButtonVariant.primary,
              height: 46,
              borderRadius: 16,
              isFullWidth: false,
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/quiz/${lesson.id}?courseId=${courseId ?? ''}');
              },
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
              const NhismMascotWidget(
                mood: MascotMood.curious,
                speechBubbleText: 'Bạn ơi, chọn một khóa học để cùng phiêu lưu nhé!',
                size: 110,
              ),
              const SizedBox(height: 24),
              const Text(
                'Chọn một khóa học',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Hãy vào tab Khóa học và chọn một khóa để bắt đầu hành trình học tập!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              Tactile3DButton(
                text: 'XEM KHÓA HỌC',
                variant: TactileButtonVariant.primary,
                icon: Icons.explore_rounded,
                isFullWidth: false,
                onPressed: () => context.go('/courses'),
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
          const NhismMascotWidget(
            mood: MascotMood.worried,
            speechBubbleText: 'Chưa có bài học nào hết trơn!',
            size: 100,
          ),
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
            const NhismMascotWidget(
              mood: MascotMood.worried,
              speechBubbleText: 'Ôi mạng chập chờn quá bạn ơi!',
              size: 100,
            ),
            const SizedBox(height: 16),
            const Text('Lỗi tải bài học', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Tactile3DButton(
              text: 'Thử lại',
              icon: Icons.refresh_rounded,
              variant: TactileButtonVariant.primary,
              height: 46,
              borderRadius: 16,
              isFullWidth: false,
              onPressed: () => ref.invalidate(lessonsProvider(courseId!)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Align(
            alignment: Alignment(getAlignmentX(index), 0),
            child: const SkeletonLoading(width: 80, height: 80, borderRadius: 40),
          ),
        );
      },
    );
  }
}
