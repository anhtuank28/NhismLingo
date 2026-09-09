import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  // Đăng ký tài khoản
  Future<AuthResponse> signUp({required String email, required String password, required String fullName}) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName}, // Lưu thêm tên người dùng
    );
  }

  // Đăng nhập
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Lấy User hiện tại (nếu có cache session)
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Lắng nghe sự thay đổi trạng thái đăng nhập (để tự động đổi màn hình)
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
