import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Tông màu chủ đề Khu rừng của Nhím (Nâu, Vàng ấm, Xanh lá)
    final Color hedgehogBrown = const Color(0xFF8B5A2B).withValues(alpha: 0.05); // Nâu nhạt xỉu
    final Color leafGreen = const Color(0xFF6B8E23).withValues(alpha: 0.04);
    final Color autumnYellow = const Color(0xFFDAA520).withValues(alpha: 0.05);

    // 1. Vẽ những chiếc lá lơ lửng (Khối oval nhọn 2 đầu)
    _drawLeaf(canvas, Offset(size.width * 0.15, size.height * 0.15), 40, math.pi / 4, leafGreen);
    _drawLeaf(canvas, Offset(size.width * 0.85, size.height * 0.35), 30, -math.pi / 6, autumnYellow);
    _drawLeaf(canvas, Offset(size.width * 0.2, size.height * 0.7), 45, math.pi / 3, leafGreen);

    // 2. Vẽ dấu chân Nhím lon ton (Paw prints)
    _drawPaw(canvas, Offset(size.width * 0.7, size.height * 0.1), hedgehogBrown);
    _drawPaw(canvas, Offset(size.width * 0.75, size.height * 0.15), hedgehogBrown);
    _drawPaw(canvas, Offset(size.width * 0.8, size.height * 0.12), hedgehogBrown);
    
    _drawPaw(canvas, Offset(size.width * 0.1, size.height * 0.5), hedgehogBrown);
    _drawPaw(canvas, Offset(size.width * 0.15, size.height * 0.55), hedgehogBrown);

    // 3. Vẽ Bé Nhím đang cuộn tròn ngái ngủ ở góc phải dưới
    _drawSleepingHedgehog(canvas, Offset(size.width * 0.9, size.height * 0.8), 80, hedgehogBrown);
  }

  void _drawLeaf(Canvas canvas, Offset center, double length, double angle, Color color) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final path = Path();
    path.moveTo(-length / 2, 0);
    path.quadraticBezierTo(0, -length / 3, length / 2, 0);
    path.quadraticBezierTo(0, length / 3, -length / 2, 0);
    path.close();
    
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
    
    // Gân lá
    final linePaint = Paint()..color = color.withValues(alpha: 0.08)..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawLine(Offset(-length / 2, 0), Offset(length / 2, 0), linePaint);
    
    canvas.restore();
  }

  void _drawPaw(Canvas canvas, Offset center, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    
    // Đệm chính (Main pad)
    canvas.drawOval(Rect.fromCenter(center: center, width: 14, height: 10), paint);
    
    // 3 Ngón chân nhỏ (Toes)
    canvas.drawCircle(center + const Offset(-8, -10), 3.5, paint);
    canvas.drawCircle(center + const Offset(0, -12), 4, paint);
    canvas.drawCircle(center + const Offset(8, -10), 3.5, paint);
  }

  void _drawSleepingHedgehog(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    
    // Vẽ phần thân nhím (nửa hình tròn)
    final path = Path();
    path.moveTo(center.dx - radius, center.dy);
    path.arcToPoint(
      Offset(center.dx + radius, center.dy),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.close();
    canvas.drawPath(path, paint);

    // Vẽ các gai zigzag
    final spikePaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
      
    final spikePath = Path();
    spikePath.moveTo(center.dx - radius, center.dy);
    
    // Vẽ răng cưa dọc theo vòng cung
    int spikes = 10;
    for (int i = 1; i <= spikes; i++) {
      double t = i / spikes;
      double tPrev = (i - 0.5) / spikes;
      
      // Điểm nhô lên
      double angle1 = math.pi - (tPrev * math.pi);
      double outerRadius = radius * 1.2;
      double x1 = center.dx + math.cos(angle1) * outerRadius;
      double y1 = center.dy - math.sin(angle1) * outerRadius;
      
      // Điểm lõm xuống (trên vòng cung)
      double angle2 = math.pi - (t * math.pi);
      double x2 = center.dx + math.cos(angle2) * radius;
      double y2 = center.dy - math.sin(angle2) * radius;
      
      spikePath.lineTo(x1, y1);
      spikePath.lineTo(x2, y2);
    }
    canvas.drawPath(spikePath, spikePaint);
    
    // Vẽ cái mũi nhọn hoắt thò ra bên trái
    final nosePath = Path();
    nosePath.moveTo(center.dx - radius + 10, center.dy);
    nosePath.lineTo(center.dx - radius - 20, center.dy);
    nosePath.lineTo(center.dx - radius, center.dy - 20);
    nosePath.close();
    canvas.drawPath(nosePath, paint);
    
    // Vẽ chấm đen làm mũi
    final noseTipPaint = Paint()..color = const Color(0xFF6B4226).withValues(alpha: 0.1);
    canvas.drawCircle(Offset(center.dx - radius - 20, center.dy), 4, noseTipPaint);
    
    // Vẽ nhắm mắt ngủ (Một đường cong nhỏ)
    final eyePaint = Paint()
      ..color = const Color(0xFF6B4226).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
      
    final eyePath = Path();
    eyePath.moveTo(center.dx - radius + 5, center.dy - 10);
    eyePath.quadraticBezierTo(center.dx - radius + 15, center.dy - 5, center.dx - radius + 25, center.dy - 10);
    canvas.drawPath(eyePath, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
