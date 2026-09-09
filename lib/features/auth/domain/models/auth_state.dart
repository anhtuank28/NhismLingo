import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,        // Chưa load xong (Đang check session)
  loading,        // Đang xử lý đăng nhập/đăng ký
  unauthenticated, // Chưa login (Ở ngoài màn hình Welcome/Login)
  guest,          // Khách (Đang học thử)
  authenticated,  // Đã login thành công (Có thể dùng mọi tính năng)
}

class AppAuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AppAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AppAuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
