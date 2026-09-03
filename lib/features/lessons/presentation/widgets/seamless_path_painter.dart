import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/lessons/domain/models/lesson_model.dart';

class SeamlessPathPainter extends CustomPainter {
  final List<Offset> points;
  final List<LessonStatus> statuses;

  SeamlessPathPainter({
    required this.points,
    required this.statuses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ từ dưới lên trên (phần tử 0 nằm ở dưới cùng)
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      
      // Đường đi tới bài tiếp theo sẽ phụ thuộc vào trạng thái bài đó
      final status = statuses[i + 1]; 
      
      // Đường được tô màu (đã mở) nếu ải tiếp theo là current hoặc completed
      bool isPathUnlocked = status == LessonStatus.completed || status == LessonStatus.current;

      final borderPaint = Paint()
        ..color = isPathUnlocked ? AppColors.successGreenShadow : AppColors.lockedGreyShadow
        ..strokeWidth = 44.0 // Đường đất dày
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final pathPaint = Paint()
        ..color = isPathUnlocked ? AppColors.successGreen : AppColors.lockedGrey
        ..strokeWidth = 34.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final Path path = Path();
      path.moveTo(start.dx, start.dy);

      // Thuật toán uốn éo (Bezier S-Curve) tiếp tuyến hoàn hảo
      final double distanceY = start.dy - end.dy;
      final double controlY = distanceY * 0.55; 
      
      path.cubicTo(
        start.dx, start.dy - controlY,
        end.dx, end.dy + controlY,
        end.dx, end.dy,
      );

      // Lớp đất tối (Viền ngoài)
      canvas.drawPath(path, borderPaint);
      
      // Lớp mặt sáng (Đường đi bên trong)
      canvas.drawPath(path, pathPaint);
      
      // (Optional) Nếu thích có thể vẽ thêm vạch đứt gạch giữa đường ở đây
    }
  }

  @override
  bool shouldRepaint(covariant SeamlessPathPainter oldDelegate) {
    return true; 
  }
}
