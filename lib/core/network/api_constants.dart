class ApiConstants {
  ApiConstants._();

  /// Production Base URL for Bloom Backend
  static const String baseUrl = 'https://bloom.mindzed.tech';

  // Auth Endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String googleAuth = '/api/auth/google';
  static const String refreshToken = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // User Profile
  static const String userProfile = '/api/user/profile';

  // Sync Engine
  static const String syncPush = '/api/sync/push';
  static const String syncPull = '/api/sync/pull';

  // AI Insights & Clinical Doctor Summary
  static const String doctorSummary = '/api/ai/doctor-summary';

  // Support & Bug Reports
  static const String supportTicket = '/api/support/ticket';

  // Google Play & GDPR Compliance
  static const String userExport = '/api/user/export';
  static const String wipeTrackingData = '/api/user/wipe-tracking-data';
  static const String deleteAccount = '/api/user/account';

  // Health
  static const String healthCheck = '/healthz';
  static const String readyCheck = '/readyz';
}
