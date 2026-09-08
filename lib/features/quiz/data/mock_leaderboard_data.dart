class LeaderboardUser {
  final String id;
  final int rank;
  final String name;
  final String avatarUrl;
  final int xp;
  final int lessons;
  final int? streakDays;
  final String? subtitle;
  final bool isCurrentUser;

  const LeaderboardUser({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.xp,
    required this.lessons,
    this.streakDays,
    this.subtitle,
    this.isCurrentUser = false,
  });
}

const mockLeaderboardUsers = [
  LeaderboardUser(
    id: 'u1',
    rank: 1,
    name: 'Linh (Bạn)',
    avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150&auto=format&fit=crop',
    xp: 1280,
    lessons: 42,
    isCurrentUser: true,
  ),
  LeaderboardUser(
    id: 'u2',
    rank: 2,
    name: 'Tuấn Minh',
    avatarUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=150&auto=format&fit=crop',
    xp: 1150,
    lessons: 38,
  ),
  LeaderboardUser(
    id: 'u3',
    rank: 3,
    name: 'Thu Hà',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150&auto=format&fit=crop',
    xp: 1020,
    lessons: 35,
  ),
  LeaderboardUser(
    id: 'u4',
    rank: 4,
    name: 'Hoàng Anh',
    avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=150&auto=format&fit=crop',
    xp: 940,
    lessons: 31,
    streakDays: 12,
    subtitle: 'Học 2 giờ trước',
  ),
  LeaderboardUser(
    id: 'u5',
    rank: 5,
    name: 'Mai Anh',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150&auto=format&fit=crop',
    xp: 860,
    lessons: 28,
    streakDays: 5,
    subtitle: 'Học 4 giờ trước',
  ),
  LeaderboardUser(
    id: 'u6',
    rank: 6,
    name: 'Quốc Bảo',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop',
    xp: 720,
    lessons: 24,
    streakDays: 3,
    subtitle: 'Hôm qua',
  ),
  LeaderboardUser(
    id: 'u7',
    rank: 7,
    name: 'Lan Phương',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150&auto=format&fit=crop',
    xp: 580,
    lessons: 19,
    subtitle: '2 ngày trước',
  ),
  LeaderboardUser(
    id: 'u8',
    rank: 8,
    name: 'Đức Huy',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150&auto=format&fit=crop',
    xp: 450,
    lessons: 15,
    subtitle: '3 ngày trước',
  ),
];
