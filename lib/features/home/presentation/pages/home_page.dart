import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Đây là Trang chủ tạm thời.\nLuồng điều hướng GoRouter đã hoạt động!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
