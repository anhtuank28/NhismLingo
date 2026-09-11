import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nhims_lingo/core/services/supabase_service.dart';
import 'package:nhims_lingo/features/quiz/domain/models/leaderboard_user_model.dart';

/// Provider để lấy danh sách Leaderboard (Top 50 user theo total_xp)
final leaderboardProvider = FutureProvider.autoDispose<List<LeaderboardUser>>((ref) async {
  final service = SupabaseService.instance;
  final data = await service.getLeaderboard();
  
  return List.generate(data.length, (index) {
    return LeaderboardUser.fromJson(data[index], index + 1);
  });
});
