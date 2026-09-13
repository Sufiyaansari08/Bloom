import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/security_storage_service.dart';

class PrivacySecurityState {
  final String lockType; // 'None', 'PIN', 'Password', 'Pattern'
  final String pin;
  final String password;
  final String pattern;
  final String autoLockTime;
  final bool isPrivacyBlurEnabled;
  final bool isDiscreteNotificationsEnabled;
  final bool isAiDataUsageEnabled;
  final bool isAnalyticsEnabled;
  final bool isPersonalizedRecommendationsEnabled;

  const PrivacySecurityState({
    this.lockType = 'None',
    this.pin = '1234',
    this.password = '',
    this.pattern = '0,1,2,5,8',
    this.autoLockTime = '5 minutes',
    this.isPrivacyBlurEnabled = true,
    this.isDiscreteNotificationsEnabled = true,
    this.isAiDataUsageEnabled = true,
    this.isAnalyticsEnabled = true,
    this.isPersonalizedRecommendationsEnabled = true,
  });

  bool get isLockActive => lockType != 'None';

  PrivacySecurityState copyWith({
    String? lockType,
    String? pin,
    String? password,
    String? pattern,
    String? autoLockTime,
    bool? isPrivacyBlurEnabled,
    bool? isDiscreteNotificationsEnabled,
    bool? isAiDataUsageEnabled,
    bool? isAnalyticsEnabled,
    bool? isPersonalizedRecommendationsEnabled,
  }) {
    return PrivacySecurityState(
      lockType: lockType ?? this.lockType,
      pin: pin ?? this.pin,
      password: password ?? this.password,
      pattern: pattern ?? this.pattern,
      autoLockTime: autoLockTime ?? this.autoLockTime,
      isPrivacyBlurEnabled: isPrivacyBlurEnabled ?? this.isPrivacyBlurEnabled,
      isDiscreteNotificationsEnabled:
          isDiscreteNotificationsEnabled ?? this.isDiscreteNotificationsEnabled,
      isAiDataUsageEnabled: isAiDataUsageEnabled ?? this.isAiDataUsageEnabled,
      isAnalyticsEnabled: isAnalyticsEnabled ?? this.isAnalyticsEnabled,
      isPersonalizedRecommendationsEnabled:
          isPersonalizedRecommendationsEnabled ??
              this.isPersonalizedRecommendationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lockType': lockType,
      'pin': pin,
      'password': password,
      'pattern': pattern,
      'autoLockTime': autoLockTime,
      'isPrivacyBlurEnabled': isPrivacyBlurEnabled,
      'isDiscreteNotificationsEnabled': isDiscreteNotificationsEnabled,
      'isAiDataUsageEnabled': isAiDataUsageEnabled,
      'isAnalyticsEnabled': isAnalyticsEnabled,
      'isPersonalizedRecommendationsEnabled':
          isPersonalizedRecommendationsEnabled,
    };
  }

  factory PrivacySecurityState.fromJson(Map<String, dynamic> json) {
    return PrivacySecurityState(
      lockType: json['lockType'] as String? ?? 'None',
      pin: json['pin'] as String? ?? '1234',
      password: json['password'] as String? ?? '',
      pattern: json['pattern'] as String? ?? '0,1,2,5,8',
      autoLockTime: json['autoLockTime'] as String? ?? '5 minutes',
      isPrivacyBlurEnabled: json['isPrivacyBlurEnabled'] as bool? ?? true,
      isDiscreteNotificationsEnabled:
          json['isDiscreteNotificationsEnabled'] as bool? ?? true,
      isAiDataUsageEnabled: json['isAiDataUsageEnabled'] as bool? ?? true,
      isAnalyticsEnabled: json['isAnalyticsEnabled'] as bool? ?? true,
      isPersonalizedRecommendationsEnabled:
          json['isPersonalizedRecommendationsEnabled'] as bool? ?? true,
    );
  }
}

class PrivacySecurityNotifier extends StateNotifier<PrivacySecurityState> {
  PrivacySecurityNotifier([PrivacySecurityState? initialState])
      : super(initialState ?? const PrivacySecurityState());

  void _persist() {
    SecurityStorageService.instance.saveSettings(state);
  }

  void setLockType(String type) {
    state = state.copyWith(lockType: type);
    _persist();
  }

  void setPin(String newPin) {
    state = state.copyWith(pin: newPin, lockType: 'PIN');
    _persist();
  }

  void setPassword(String newPassword) {
    state = state.copyWith(password: newPassword, lockType: 'Password');
    _persist();
  }

  void setPattern(String newPattern) {
    state = state.copyWith(pattern: newPattern, lockType: 'Pattern');
    _persist();
  }

  void setAutoLockTime(String time) {
    state = state.copyWith(autoLockTime: time);
    _persist();
  }

  void togglePrivacyBlur(bool value) {
    state = state.copyWith(isPrivacyBlurEnabled: value);
    _persist();
  }

  void toggleDiscreteNotifications(bool value) {
    state = state.copyWith(isDiscreteNotificationsEnabled: value);
    _persist();
  }

  void toggleAiDataUsage(bool value) {
    state = state.copyWith(isAiDataUsageEnabled: value);
    _persist();
  }

  void toggleAnalytics(bool value) {
    state = state.copyWith(isAnalyticsEnabled: value);
    _persist();
  }

  void togglePersonalizedRecommendations(bool value) {
    state = state.copyWith(isPersonalizedRecommendationsEnabled: value);
    _persist();
  }
}

final privacySecurityProvider =
    StateNotifierProvider<PrivacySecurityNotifier, PrivacySecurityState>((ref) {
  return PrivacySecurityNotifier();
});
