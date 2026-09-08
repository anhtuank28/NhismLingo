import 'package:flutter/material.dart';

class ProfileAchievement {
  final String id;
  final String title;
  final IconData iconData;
  final double progress; // 0.0 to 1.0
  final bool isCompleted;

  const ProfileAchievement({
    required this.id,
    required this.title,
    required this.iconData,
    required this.progress,
    required this.isCompleted,
  });
}

class FullProfileData {
  final String name;
  final int level;
  final String joinedDate;
  final String avatarUrl;
  
  final int streakDays;
  final int totalXP;
  final int totalGems;

  final List<ProfileAchievement> achievements;

  const FullProfileData({
    required this.name,
    required this.level,
    required this.joinedDate,
    required this.avatarUrl,
    required this.streakDays,
    required this.totalXP,
    required this.totalGems,
    required this.achievements,
  });
}

const mockFullProfile = FullProfileData(
  name: 'Alex Chen',
  level: 15,
  joinedDate: 'Joined June 2023',
  avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
  streakDays: 12,
  totalXP: 4500,
  totalGems: 120,
  achievements: [
    ProfileAchievement(
      id: 'a1',
      title: 'Early Bird',
      iconData: Icons.wb_sunny_rounded,
      progress: 0.8,
      isCompleted: false,
    ),
    ProfileAchievement(
      id: 'a2',
      title: 'Polyglot Pro',
      iconData: Icons.public_rounded,
      progress: 0.4,
      isCompleted: false,
    ),
    ProfileAchievement(
      id: 'a3',
      title: 'Streak Master',
      iconData: Icons.local_fire_department_rounded,
      progress: 1.0,
      isCompleted: true,
    ),
  ],
);
