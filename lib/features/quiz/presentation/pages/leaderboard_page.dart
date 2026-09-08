import 'package:flutter/material.dart';
import 'package:nhims_lingo/core/theme/app_colors.dart';
import 'package:nhims_lingo/features/quiz/data/mock_leaderboard_data.dart';

class LeaderboardPage extends StatefulWidget {
  final String? lessonTitle; // Dùng chung tham số cũ nếu có truyền từ Router
  const LeaderboardPage({super.key, this.lessonTitle});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _selectedTab = 0; // 0: Tuần này, 1: Tháng này, 2: Mọi lúc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC), // Màu nền hơi tím nhạt xám
      body: SafeArea(
        child: Column(
          children: [
            // 1. Thanh Tabs
            _buildTopTabs(),
            
            // Nội dung cuộn
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // 2. Bục vinh quang Top 3
                    _buildPodium(),
                    
                    const SizedBox(height: 16),
                    
                    // 3. Vị trí hiện tại
                    _buildCurrentUserStatus(),
                    
                    const SizedBox(height: 24),
                    
                    // 4. Danh sách xếp hạng
                    _buildLeaderboardList(),
                    
                    const SizedBox(height: 24),
                    
                    // 5. Khung Mời bạn bè (Chuyển xuống dưới cùng, không ghim)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildInviteSection(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildTopTabs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECEF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            _buildTabItem(0, 'Tuần này'),
            _buildTabItem(1, 'Tháng này'),
            _buildTabItem(2, 'Mọi lúc'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String text) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium() {
    final top1 = mockLeaderboardUsers.firstWhere((u) => u.rank == 1);
    final top2 = mockLeaderboardUsers.firstWhere((u) => u.rank == 2);
    final top3 = mockLeaderboardUsers.firstWhere((u) => u.rank == 3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TOP 2
          _buildPodiumItem(top2, 100, const Color(0xFFF0F0F0), false),
          // TOP 1
          _buildPodiumItem(top1, 140, const Color(0xFFD3DFFF), true),
          // TOP 3
          _buildPodiumItem(top3, 90, const Color(0xFFF0F0F0), false),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardUser user, double height, Color blockColor, bool isTop1) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Vương miện cho Top 1
        if (isTop1)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.workspace_premium_rounded, color: Color(0xFFFF9800), size: 32),
          ),
        
        // Avatar + Badge
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: isTop1 ? 72 : 60,
              height: isTop1 ? 72 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isTop1 ? const Color(0xFFFF9800) : Colors.transparent, width: 3),
                image: DecorationImage(
                  image: NetworkImage(user.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isTop1 ? const Color(0xFFFF9800) : const Color(0xFFB0BEC5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Row(
                  children: [
                    if (isTop1) const Icon(Icons.star, color: Colors.white, size: 10),
                    Text(
                      '#${user.rank}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Name & XP
        Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: isTop1 ? 14 : 12),
        ),
        Text(
          '${user.xp} XP',
          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryBlue, fontSize: 12),
        ),
        Text(
          '${user.lessons} bài',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green, fontSize: 10),
        ),
        const SizedBox(height: 8),
        
        // Khối bục (Block)
        Container(
          width: isTop1 ? 100 : 80,
          height: height,
          decoration: BoxDecoration(
            color: blockColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Center(
            child: Icon(
              isTop1 ? Icons.emoji_events_rounded : Icons.military_tech_rounded,
              color: isTop1 ? AppColors.primaryBlue : (user.rank == 2 ? Colors.grey : const Color(0xFFCD7F32)),
              size: isTop1 ? 32 : 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentUserStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5DEB7B), // Màu xanh lá sáng như thiết kế
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Số Rank Tròn
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF006B2B), // Xanh lá thẫm
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '1',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 12),
          
          // Chữ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Vị trí của bạn: #1',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF004D1E), fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Giữ hạng',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004D1E), fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '42 thử thách vượt qua • Hơn bạn bè...',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF004D1E), fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Icon Share
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share_rounded, color: Color(0xFF004D1E), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    final listUsers = mockLeaderboardUsers.where((u) => u.rank > 3).toList();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bảng xếp hạng theo bài học',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary),
              ),
              Text(
                '18 bạn bè tham gia',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // List Items
          ...listUsers.map((user) => _buildListItem(user)),
        ],
      ),
    );
  }

  Widget _buildListItem(LeaderboardUser user) {
    String btnText = 'Cổ vũ';
    IconData btnIcon = Icons.waving_hand_rounded;
    Color btnColor = const Color(0xFFFFF3E0);
    Color txtColor = const Color(0xFFF57C00);

    if (user.rank % 3 == 0) { // Giả vờ random nút
      btnText = 'Đua';
      btnIcon = Icons.sports_score_rounded;
      btnColor = const Color(0xFFECEFF1);
      txtColor = Colors.grey.shade800;
    } else if (user.rank == 8) {
      btnText = 'Nhắc';
      btnIcon = Icons.notifications_active_rounded;
      btnColor = const Color(0xFFE3F2FD);
      txtColor = AppColors.primaryBlue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 24,
            child: Text(
              '${user.rank}',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          
          // Avatar + Streak
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              if (user.streakDays != null && user.streakDays! > 0)
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 14),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 6),
                    if (user.streakDays != null)
                      Text(
                        '${user.streakDays} ngày streak',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.grey.shade500),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.lessons} bài • ${user.subtitle}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          
          // XP
          Text(
            '${user.xp} XP',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          
          // Button Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(btnIcon, color: txtColor, size: 12),
                const SizedBox(width: 4),
                Text(
                  btnText,
                  style: TextStyle(fontWeight: FontWeight.w800, color: txtColor, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thêm bạn, thêm động lực!',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Học chung tăng gấp 3 lần tỷ lệ hoàn thành mục tiêu. Nhận ngay +50 XP cho mỗi bạn bè gia nhập.',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A58CA), // Xanh dương đậm
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.person_add_rounded, size: 18),
                label: const Text('Mời bạn bè (+50 XP)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F3F4), // Xám nhạt
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.search_rounded, size: 18),
                label: const Text('Tìm qua mã ID / Danh bạ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
