import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Màn hình Hồ sơ (Profile)'),
      ),
    );
  }
}
