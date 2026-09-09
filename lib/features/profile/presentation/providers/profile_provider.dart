import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nhims_lingo/core/services/supabase_service.dart';
import 'package:nhims_lingo/features/auth/presentation/providers/auth_provider.dart';
import 'package:nhims_lingo/features/auth/domain/models/auth_state.dart';

/// Dữ liệu profile đã parse từ Supabase
class ProfileData {
  final String fullName;
  final String avatarUrl;
  final int level;
  final int totalXp;
  final int totalGems;
  final int streakDays;
  final String joinedDate;

  const ProfileData({
    this.fullName = '',
    this.avatarUrl = '',
    this.level = 1,
    this.totalXp = 0,
    this.totalGems = 0,
    this.streakDays = 0,
    this.joinedDate = '',
  });
}

/// Provider lấy profile thật từ Supabase.
/// Tự động refresh khi trạng thái auth thay đổi.
final profileDataProvider = FutureProvider<ProfileData?>((ref) async {
  // Lắng nghe trạng thái auth - khi auth thay đổi, provider tự chạy lại
  final authState = ref.watch(authProvider);

  // Chỉ lấy data khi đã đăng nhập
  if (authState.status != AuthStatus.authenticated) return null;

  try {
    var data = await SupabaseService.instance.getCurrentProfile();
    
    // Nếu chưa có profile (user đăng ký trước khi có trigger) → Tự tạo
    if (data == null) {
      final user = SupabaseService.instance.client.auth.currentUser;
      if (user == null) return null;
      
      final fullName = user.userMetadata?['full_name'] ?? '';
      final avatarUrl = user.userMetadata?['avatar_url'] ?? '';
      
      // Tạo profile mới trên Supabase
      await SupabaseService.instance.client.from('profiles').insert({
        'id': user.id,
        'full_name': fullName,
        'avatar_url': avatarUrl,
      });
      
      // Lấy lại data vừa tạo
      data = await SupabaseService.instance.getCurrentProfile();
      if (data == null) return null;
    }

    // Parse ngày tham gia từ created_at
    String joinedDate = '';
    if (data['created_at'] != null) {
      final date = DateTime.parse(data['created_at']);
      final months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      joinedDate = 'Joined ${months[date.month]} ${date.year}';
    }

    return ProfileData(
      fullName: data['full_name'] ?? '',
      avatarUrl: data['avatar_url'] ?? '',
      level: data['level'] ?? 1,
      totalXp: data['total_xp'] ?? 0,
      totalGems: data['total_gems'] ?? 0,
      streakDays: data['streak_days'] ?? 0,
      joinedDate: joinedDate,
    );
  } catch (e) {
    return null;
  }
});
