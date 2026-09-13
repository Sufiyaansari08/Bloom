import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/privacy_security_provider.dart';
import '../providers/in_app_lock_runtime_provider.dart';
import 'in_app_lock_screen.dart';

class InAppSecurityGate extends ConsumerStatefulWidget {
  final Widget child;

  const InAppSecurityGate({super.key, required this.child});

  @override
  ConsumerState<InAppSecurityGate> createState() => _InAppSecurityGateState();
}

class _InAppSecurityGateState extends ConsumerState<InAppSecurityGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial check on app cold launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final secState = ref.read(privacySecurityProvider);
      if (secState.isLockActive) {
        ref.read(inAppLockRuntimeProvider.notifier).lock();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final secState = ref.read(privacySecurityProvider);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(inAppLockRuntimeProvider.notifier).onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      ref.read(inAppLockRuntimeProvider.notifier).onAppResumed(
            isLockActive: secState.isLockActive,
            autoLockTime: secState.autoLockTime,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final secState = ref.watch(privacySecurityProvider);
    final runtimeState = ref.watch(inAppLockRuntimeProvider);

    final showLockScreen = secState.isLockActive && runtimeState.isLocked;
    final showPrivacyBlur =
        secState.isPrivacyBlurEnabled && runtimeState.isAppHidden;

    return Stack(
      children: [
        widget.child,

        // Privacy Blur Veil (Recent Apps / Multitasking Switcher Shield)
        if (showPrivacyBlur)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.88),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Flower icon exactly like in Notes page (no image/no white box)
                          const Icon(
                            Icons.local_florist,
                            size: 68,
                            color: AppColors.primaryPink,
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            'Bloom',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtext
                          const Text(
                            'Your personal cycle data is protected',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryText,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // In-App Unlock Screen
        if (showLockScreen)
          const Positioned.fill(
            child: InAppLockScreen(),
          ),
      ],
    );
  }
}
