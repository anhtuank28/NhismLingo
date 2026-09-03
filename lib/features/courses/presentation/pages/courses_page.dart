import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Màn hình Khóa học (Courses)'),
      ),
    );
  }
}
