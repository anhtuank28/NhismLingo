import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/lessons/data/mock_lessons_data.dart';
import 'package:nhims_lingo/features/lessons/presentation/widgets/lesson_node_widget.dart';
import 'package:nhims_lingo/features/lessons/domain/models/lesson_model.dart';
import 'package:nhims_lingo/features/lessons/presentation/widgets/seamless_path_painter.dart';
import 'package:nhims_lingo/features/lessons/presentation/widgets/map_environment_painter.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  double getAlignmentX(int index) {
    final pattern = index % 4;
    if (pattern == 0) return 0.0; // center
    if (pattern == 1) return -0.5; // left
    if (pattern == 2) return 0.0; // center
    return 0.5; // right
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vương quốc Ngôn ngữ',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 0.5),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double halfWidth = screenWidth / 2;
          
          const double nodeSpacing = 180.0;
          const double topPadding = 150.0;
          const double bottomPadding = 150.0;
          
          final int itemCount = mockLessons.length;
          final double totalHeight = (itemCount - 1) * nodeSpacing + topPadding + bottomPadding;
          
          // Tính toán trước tọa độ tâm (X, Y) của tất cả bài học
          List<Offset> points = [];
          List<LessonStatus> statuses = [];
          
          for (int i = 0; i < itemCount; i++) {
            // i = 0 là bài đầu tiên, đặt ở dưới cùng màn hình
            final double y = totalHeight - bottomPadding - (i * nodeSpacing);
            final double alignX = getAlignmentX(i);
            final double x = halfWidth + (alignX * halfWidth);
            
            points.add(Offset(x, y));
            statuses.add(mockLessons[i].status);
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
                  // Positioned bắt buộc phải là con trực tiếp của Stack
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
                  // THỦ THUẬT Y-SORT: Render ngược mảng để các node ở dưới cùng màn hình (gần Camera) 
                  // sẽ được vẽ đè lên các node ở phía trên (xa Camera).
                  ...List.generate(itemCount, (i) {
                    final point = points[i];
                    final lesson = mockLessons[i];
                    
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: point.dy - 120, // Đưa tâm của node khớp với point.dy
                      child: Align(
                        alignment: Alignment(getAlignmentX(i), 0),
                        child: LessonNodeWidget(
                          lesson: lesson,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                                  content: Text(
                                    lesson.status == LessonStatus.current 
                                        ? 'Bạn đã sẵn sàng vượt ải này chưa?'
                                        : 'Bạn muốn quay lại ôn tập ải này?',
                                    style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('ĐỂ SAU', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Đóng popup
                                        // TODO: Sprint 2 - Chuyển sang QuizPage thật
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('🦔 Bài "${lesson.title}" đang được xây dựng! Quay lại sớm nhé~'),
                                            backgroundColor: AppColors.primaryBlue,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                        );
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
                              }
                            );
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
      ),
    );
  }
}

