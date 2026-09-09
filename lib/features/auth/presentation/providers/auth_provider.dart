import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nhims_lingo/features/auth/data/repositories/auth_repository.dart';
import 'package:nhims_lingo/features/auth/domain/models/auth_state.dart';

// Provider cung cấp AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});

// StateNotifier điều khiển trạng thái đăng nhập
class AuthNotifier extends StateNotifier<AppAuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AppAuthState()) {
    _initAuth();
  }

  // Khởi tạo và kiểm tra xem người dùng đã đăng nhập từ phiên trước chưa
  void _initAuth() {
    final user = _repository.getCurrentUser();
    if (user != null) {
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }

    // Lắng nghe sự thay đổi (VD: Hết hạn token, hoặc người dùng vừa login xong)
    _repository.authStateChanges.listen((data) {
      final session = data.session;
      if (session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: session.user);
      } else {
        // Nếu không có session, kiểm tra xem có đang ở chế độ Guest không
        if (state.status != AuthStatus.guest) {
          state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
        }
      }
    });
  }

  // Kích hoạt chế độ Học thử (Guest Mode)
  void loginAsGuest() {
    state = state.copyWith(status: AuthStatus.guest, user: null, errorMessage: null);
  }

  // Đăng nhập bằng Email/Password
  Future<void> signIn(String email, String password) async {
    try {
      // Reset lỗi cũ trước khi thử đăng nhập
      state = state.copyWith(status: AuthStatus.loading, clearError: true);
      await _repository.signIn(email: email, password: password);
      // Không cần set lại state ở đây vì listener authStateChanges sẽ tự động bắt được và cập nhật
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _parseErrorMessage(e.toString()),
      );
    }
  }

  // Đăng ký tài khoản
  Future<void> signUp(String email, String password, String fullName) async {
    try {
      // Reset lỗi cũ trước khi thử đăng ký
      state = state.copyWith(status: AuthStatus.loading, clearError: true);
      final response = await _repository.signUp(email: email, password: password, fullName: fullName);
      
      // Kiểm tra email trùng: Khi tắt Confirm Email, Supabase không trả lỗi
      // mà trả về response giả với identities rỗng nếu email đã tồn tại.
      final identities = response.user?.identities;
      if (identities == null || identities.isEmpty) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Ui, email này đã có chủ rồi! Bạn thử đăng nhập xem sao? 🦉',
        );
        return;
      }

      // Kiểm tra: Nếu Supabase bắt xác nhận email -> session sẽ null
      if (response.session == null) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Tuyệt vời! 🎉 Vui lòng check hộp thư để kích hoạt tài khoản nhé!',
        );
      }
      // Nếu session != null (Supabase không bắt xác nhận) -> listener tự bắt authenticated
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: _parseErrorMessage(e.toString()),
      );
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _repository.signOut();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  // Tiện ích dịch lỗi cho dễ hiểu theo phong cách App Học Tập / Game
  String _parseErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Oops! Sai email hoặc mật khẩu rồi. Cố nhớ lại xem nào! 🤔';
    } else if (error.contains('already registered')) {
      return 'Ui, email này đã có chủ rồi! Bạn thử đăng nhập xem sao? 🦉';
    } else if (error.contains('Password should be at least')) {
      return 'Mật khẩu hơi ngắn đó! Ít nhất 6 ký tự để bảo vệ tài khoản nhé! 🛡️';
    }
    return 'Có lỗi vũ trụ nào đó đã xảy ra! Bạn thử lại xíu nhé! 🛸';
  }
}

// Provider chính mà UI sẽ gọi tới
final authProvider = StateNotifierProvider<AuthNotifier, AppAuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
