class LeaderboardUser {
  final String id;
  final String name;
  final String avatarUrl;
  final int xp;
  final int level;
  final int rank;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.xp,
    required this.level,
    required this.rank,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json, int rank) {
    return LeaderboardUser(
      id: json['id'] as String,
      name: json['full_name'] as String? ?? 'Người dùng Ẩn danh',
      avatarUrl: json['avatar_url'] as String? ?? '',
      xp: json['total_xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      rank: rank,
    );
  }
}
