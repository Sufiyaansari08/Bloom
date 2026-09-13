import 'package:flutter_riverpod/flutter_riverpod.dart';

class InAppLockRuntimeState {
  final bool isLocked;
  final DateTime? lastPausedAt;
  final bool isAppHidden;

  const InAppLockRuntimeState({
    this.isLocked = false,
    this.lastPausedAt,
    this.isAppHidden = false,
  });

  InAppLockRuntimeState copyWith({
    bool? isLocked,
    DateTime? lastPausedAt,
    bool clearLastPausedAt = false,
    bool? isAppHidden,
  }) {
    return InAppLockRuntimeState(
      isLocked: isLocked ?? this.isLocked,
      lastPausedAt:
          clearLastPausedAt ? null : (lastPausedAt ?? this.lastPausedAt),
      isAppHidden: isAppHidden ?? this.isAppHidden,
    );
  }
}

class InAppLockRuntimeNotifier extends StateNotifier<InAppLockRuntimeState> {
  InAppLockRuntimeNotifier() : super(const InAppLockRuntimeState());

  void unlock() {
    state = state.copyWith(
      isLocked: false,
      clearLastPausedAt: true,
    );
  }

  void lock() {
    state = state.copyWith(isLocked: true);
  }

  void onAppPaused() {
    state = state.copyWith(
      lastPausedAt: DateTime.now(),
      isAppHidden: true,
    );
  }

  void onAppResumed({
    required bool isLockActive,
    required String autoLockTime,
  }) {
    state = state.copyWith(isAppHidden: false);

    if (!isLockActive) {
      if (state.isLocked) {
        unlock();
      }
      return;
    }

    final pausedAt = state.lastPausedAt;
    if (pausedAt != null) {
      final elapsedSeconds = DateTime.now().difference(pausedAt).inSeconds;
      final thresholdSeconds = _parseAutoLockSeconds(autoLockTime);

      if (elapsedSeconds >= thresholdSeconds) {
        state = state.copyWith(isLocked: true);
      }
      state = state.copyWith(clearLastPausedAt: true);
    }
  }

  int _parseAutoLockSeconds(String time) {
    final lower = time.toLowerCase().trim();
    if (lower.contains('immediately')) return 0;
    if (lower.contains('1 min')) return 60;
    if (lower.contains('5 min')) return 300;
    if (lower.contains('15 min')) return 900;
    if (lower.contains('30 min')) return 1800;
    return 0;
  }
}

final inAppLockRuntimeProvider =
    StateNotifierProvider<InAppLockRuntimeNotifier, InAppLockRuntimeState>(
        (ref) {
  return InAppLockRuntimeNotifier();
});
