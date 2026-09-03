import 'package:flutter/material.dart';

class MapEnvironmentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawSunrays(canvas, size);

    final int rows = (size.height / 200).ceil();

    for (int i = 0; i < rows; i++) {
      final double y = size.height - (i * 200) - 50;

      // 1. Vẽ Mây (Clouds)
      final cloudX = (i % 2 == 0) ? size.width * 0.8 : size.width * 0.15;
      _drawCloud(canvas, Offset(cloudX, y - 150));

      // 2. Vẽ Cây thông (Pine Trees) rải rác
      final treeX = (i % 2 == 0) ? size.width * 0.15 : size.width * 0.85;
      _drawPineTree(canvas, Offset(treeX, y));

      // 3. Vẽ Bụi cỏ & Hoa (Grass & Flowers)
      final grassX = (i % 3 == 0) ? size.width * 0.4 : ((i % 2 == 0) ? size.width * 0.8 : size.width * 0.2);
      _drawGrassAndFlowers(canvas, Offset(grassX, y + 80));

      // 4. Vẽ Đá cuội rêu (Mossy Stones)
      if (i % 2 != 0) {
        final stoneX = (i % 4 == 0) ? size.width * 0.7 : size.width * 0.3;
        _drawStone(canvas, Offset(stoneX, y + 150));
      }
    }
  }

  // --- VẼ ÁNH NẮNG (Sunrays) ---
  void _drawSunrays(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.0),
        ],
        center: const Alignment(-1.0, -1.0),
        radius: 2.0,
      ).createShader(rect);

    // Vẽ 3 tia nắng khổng lồ
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.4, size.height)
      ..lineTo(size.width * 0.6, size.height)
      ..close();
    
    final path2 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  // --- VẼ CÂY THÔNG (Pine Tree) ---
  void _drawPineTree(Canvas canvas, Offset bottomCenter) {
    // Thân cây
    final trunkPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(bottomCenter.dx, bottomCenter.dy - 10), width: 12, height: 20),
      trunkPaint,
    );

    // Tán lá (3 lớp tam giác)
    final leafPaint = Paint()..color = const Color(0xFF2E7D32); // Xanh rừng sâu
    final leafShadow = Paint()..color = const Color(0xFF1B5E20); // Bóng râm tán lá

    for (int i = 0; i < 3; i++) {
      final double width = 60.0 - (i * 12);
      final double yBase = bottomCenter.dy - 20 - (i * 20);
      
      final path = Path()
        ..moveTo(bottomCenter.dx, yBase - 30) // Đỉnh tam giác
        ..lineTo(bottomCenter.dx - width / 2, yBase) // Trái
        ..lineTo(bottomCenter.dx + width / 2, yBase) // Phải
        ..close();

      canvas.drawPath(path, leafPaint);
      
      // Đổ bóng một nửa tán lá bên phải
      final shadowPath = Path()
        ..moveTo(bottomCenter.dx, yBase - 30)
        ..lineTo(bottomCenter.dx, yBase)
        ..lineTo(bottomCenter.dx + width / 2, yBase)
        ..close();
      canvas.drawPath(shadowPath, leafShadow);
    }
  }

  // --- VẼ CỎ VÀ HOA (Grass & Flowers) ---
  void _drawGrassAndFlowers(Canvas canvas, Offset center) {
    final grassPaint = Paint()..color = const Color(0xFF81C784); // Cỏ non
    final petalPaint = Paint()..color = const Color(0xFFF48FB1); // Cánh hoa hồng
    final centerPaint = Paint()..color = const Color(0xFFFFD54F); // Nhụy vàng

    // Bụi cỏ 3 cụm
    canvas.drawCircle(center, 12, grassPaint);
    canvas.drawCircle(Offset(center.dx - 12, center.dy + 6), 8, grassPaint);
    canvas.drawCircle(Offset(center.dx + 12, center.dy + 6), 8, grassPaint);

    // Vẽ 1 bông hoa trên cỏ
    final flowerCenter = Offset(center.dx - 5, center.dy - 8);
    // 5 cánh hoa
    for (int i = 0; i < 5; i++) {
      final double angle = (i * 72) * 3.14159 / 180;
      final double px = flowerCenter.dx + 6 * (1.0 * DateTime.now().minute == 0 ? 1 : 1); // Mock math
      final dx = flowerCenter.dx + 6 * 1.0 * (angle > 1.5 && angle < 4.5 ? -1 : 1); // Đơn giản hóa
      // Để dễ, vẽ 4 cánh quanh nhụy
    }
    
    // Vẽ cánh hoa thủ công
    canvas.drawCircle(Offset(flowerCenter.dx, flowerCenter.dy - 5), 4, petalPaint);
    canvas.drawCircle(Offset(flowerCenter.dx, flowerCenter.dy + 5), 4, petalPaint);
    canvas.drawCircle(Offset(flowerCenter.dx - 5, flowerCenter.dy), 4, petalPaint);
    canvas.drawCircle(Offset(flowerCenter.dx + 5, flowerCenter.dy), 4, petalPaint);
    
    // Nhụy hoa
    canvas.drawCircle(flowerCenter, 4, centerPaint);
  }

  // --- VẼ MÂY (Clouds) ---
  void _drawCloud(Canvas canvas, Offset center) {
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final shadowPaint = Paint()..color = Colors.blueGrey.withOpacity(0.1);

    // Đổ bóng mây
    canvas.drawCircle(Offset(center.dx, center.dy + 4), 24, shadowPaint);
    canvas.drawCircle(Offset(center.dx - 20, center.dy + 14), 18, shadowPaint);
    canvas.drawCircle(Offset(center.dx + 20, center.dy + 14), 18, shadowPaint);

    // Mây trắng
    canvas.drawCircle(center, 24, cloudPaint);
    canvas.drawCircle(Offset(center.dx - 20, center.dy + 10), 18, cloudPaint);
    canvas.drawCircle(Offset(center.dx + 20, center.dy + 10), 18, cloudPaint);
    canvas.drawRect(
      Rect.fromLTRB(center.dx - 20, center.dy, center.dx + 20, center.dy + 28),
      cloudPaint,
    );
  }

  // --- VẼ ĐÁ CUỘI (Stones) ---
  void _drawStone(Canvas canvas, Offset center) {
    final stonePaint = Paint()..color = const Color(0xFF90A4AE);
    final mossPaint = Paint()..color = const Color(0xFF66BB6A);

    // Hòn đá
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 40, height: 20),
      stonePaint,
    );
    
    // Mảng rêu bám trên đá
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - 8, center.dy - 2), width: 15, height: 8),
      mossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
