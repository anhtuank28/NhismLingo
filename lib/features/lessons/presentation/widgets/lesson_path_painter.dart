import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class LessonPathPainter extends CustomPainter {
  final double currentX;
  final double nextX;
  final bool isCompleted;

  LessonPathPainter({
    required this.currentX,
    required this.nextX,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Viền ngoài tối màu (Shadow/Border)
    final borderPaint = Paint()
      ..color = isCompleted ? AppColors.successGreenShadow : AppColors.lockedGreyShadow
      ..strokeWidth = 40.0 // Cực kỳ dày
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 2. Lõi sáng màu (Đường đi chính)
    final pathPaint = Paint()
      ..color = isCompleted ? AppColors.successGreen : AppColors.lockedGrey
      ..strokeWidth = 32.0 // Lõi nhỏ hơn viền
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double width = size.width;
    final double height = size.height;
    final double halfWidth = width / 2;

    final double startX = halfWidth + (currentX * halfWidth);
    final double endX = halfWidth + (nextX * halfWidth);

    // Xuất phát từ tâm nút hiện tại
    final Offset start = Offset(startX, height / 2);
    // Đi tới tâm nút tiếp theo
    final Offset end = Offset(endX, -height / 2);

    final Path path = Path();
    path.moveTo(start.dx, start.dy);

    // Sử dụng thuật toán tiếp tuyến vuông góc (Vertical tangents)
    // Kéo mạnh điểm điều khiển (Control points) theo trục dọc để đường cong uốn mềm mại
    final double controlPointY1 = start.dy - height * 0.6; 
    final double controlPointY2 = end.dy + height * 0.6; 

    path.cubicTo(
      start.dx, controlPointY1,
      end.dx, controlPointY2,
      end.dx, end.dy,
    );

    // Vẽ viền ngoài
    canvas.drawPath(path, borderPaint);
    // Vẽ lõi trong
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant LessonPathPainter oldDelegate) {
    return oldDelegate.currentX != currentX ||
        oldDelegate.nextX != nextX ||
        oldDelegate.isCompleted != isCompleted;
  }
}
