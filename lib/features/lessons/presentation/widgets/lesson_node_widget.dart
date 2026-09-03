import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Animation;
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/lessons/domain/models/lesson_model.dart';

class LessonNodeWidget extends StatelessWidget {
  final LessonModel lesson;
  final bool isLeft;
  final VoidCallback? onTap;

  const LessonNodeWidget({
    super.key,
    required this.lesson,
    this.isLeft = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: lesson.status != LessonStatus.locked ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 140,
        height: 200, // Đủ cao để chứa cả Mascot nhảy và Bóng
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. BÓNG ĐỔ TRÊN MẶT ĐẤT (Ground Shadow)
            Positioned(
              bottom: 45,
              child: Container(
                width: 80, 
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),

            // 2. VẬT THỂ CHÍNH (Mock 3D Object thay cho ảnh PNG)
            // Thay vì dùng Image.asset('apple.png'), ta dựng Widget 3D giả lập
            Positioned(
              bottom: 50,
              child: _buildMock3DObject(),
            ),

            // 3. MASCOT (Bé Nhím) NHẤP NHÔ
            if (lesson.status == LessonStatus.current)
              const Positioned(
                bottom: 110, // Đứng trên vật thể chính
                child: BouncingMascotMock(),
              ),

            // 4. BẢNG GỖ TÊN BÀI (Wooden Sign)
            Positioned(
              bottom: 0,
              child: _buildWoodenSign(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMock3DObject() {
    Color baseColor;
    Color topColor;
    IconData icon;

    switch (lesson.status) {
      case LessonStatus.completed:
        baseColor = const Color(0xFFC62828); // Đỏ sậm
        topColor = const Color(0xFFE53935); // Đỏ tươi (Mô phỏng quả Táo)
        icon = Icons.eco_rounded; // Lá táo
        break;
      case LessonStatus.current:
        baseColor = const Color(0xFF5D4037); // Nâu đậm
        topColor = const Color(0xFF8D6E63); // Nâu sáng (Mô phỏng Gốc cây)
        icon = Icons.star_rounded;
        break;
      case LessonStatus.locked:
        baseColor = const Color(0xFF757575); // Xám đậm
        topColor = const Color(0xFF9E9E9E); // Xám sáng (Mô phỏng Đá cuội rêu)
        icon = Icons.lock_rounded;
        break;
    }

    return Container(
      width: 80,
      height: 70,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: lesson.status == LessonStatus.current 
            ? [const BoxShadow(color: Colors.amber, blurRadius: 20, spreadRadius: 5)] // Glow effect
            : null,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                color: topColor,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
              ),
              child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWoodenSign() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD79F63), // Gỗ sáng
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8C5A2B), width: 3), // Gỗ đậm
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF8C5A2B), 
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        lesson.title,
        style: const TextStyle(
          fontWeight: FontWeight.w900, 
          color: Colors.white,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Widget Mô phỏng Bé Nhím nhấp nhô
class BouncingMascotMock extends StatefulWidget {
  const BouncingMascotMock({super.key});

  @override
  State<BouncingMascotMock> createState() => _BouncingMascotMockState();
}

class _BouncingMascotMockState extends State<BouncingMascotMock> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true); // Lặp đi lặp lại vô tận
    
    _animation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      // Hình nộm bé Nhím (Mascot)
      // Ý tưởng tuyệt vời từ bạn: Biến nền trắng thành một biểu tượng Định Vị (Map Pin)!
      child: SizedBox(
        width: 100,
        height: 120, // Tăng chiều cao để chứa mũi nhọn của Pin
        child: Center(
          child: PhysicalShape(
            clipper: MapPinClipper(),
            color: Colors.white,
            elevation: 8,
            shadowColor: Colors.black87,
            clipBehavior: Clip.antiAlias, // QUAN TRỌNG: Lệnh này sẽ chặt đứt những phần nền trắng thừa!
            child: SizedBox(
              width: 80,
              height: 100,
              child: Stack(
                children: [
                  // Nhím được đẩy nhẹ lên trên cho vừa với phần hình tròn của Pin
                  Positioned(
                    top: -5,
                    left: 0,
                    right: 0,
                    height: 85,
                    child: const RiveAnimation.asset(
                      'assets/rive/hedgehog.riv',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Clipper để tạo hình dáng Map Pin (Định vị) từ hình vuông ban đầu
class MapPinClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.width / 2;
    
    // Bắt đầu từ mũi nhọn dưới cùng
    path.moveTo(size.width / 2, size.height);
    
    // Vẽ đường cong lên mép trái của hình tròn
    path.quadraticBezierTo(0, size.height * 0.7, 0, radius);
    
    // Vẽ vòng tròn phía trên (từ trái qua phải)
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    
    // Vẽ đường cong từ mép phải xuống mũi nhọn
    path.quadraticBezierTo(size.width, size.height * 0.7, size.width / 2, size.height);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
