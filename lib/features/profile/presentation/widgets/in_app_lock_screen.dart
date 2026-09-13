import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/privacy_security_provider.dart';
import '../providers/in_app_lock_runtime_provider.dart';
import 'pattern_lock_widget.dart';

class InAppLockScreen extends ConsumerStatefulWidget {
  const InAppLockScreen({super.key});

  @override
  ConsumerState<InAppLockScreen> createState() => _InAppLockScreenState();
}

class _InAppLockScreenState extends ConsumerState<InAppLockScreen> {
  // PIN State
  String _enteredPin = '';

  // Password State
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Pattern State
  bool _isPatternError = false;
  final GlobalKey<PatternLockWidgetState> _patternKey = GlobalKey();

  // Error Message
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onPinDigit(String digit) {
    if (_enteredPin.length >= 4) return;
    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin += digit;
      _errorMessage = null;
    });

    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _onPinBackspace() {
    if (_enteredPin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _errorMessage = null;
    });
  }

  void _verifyPin() {
    final secState = ref.read(privacySecurityProvider);
    final expectedPin = secState.pin.isNotEmpty ? secState.pin : '1234';

    if (_enteredPin == expectedPin) {
      HapticFeedback.mediumImpact();
      ref.read(inAppLockRuntimeProvider.notifier).unlock();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage = 'Incorrect PIN. Try again.';
        _enteredPin = '';
      });
    }
  }

  void _verifyPassword() {
    final secState = ref.read(privacySecurityProvider);
    final entered = _passwordController.text.trim();

    if (entered == secState.password) {
      HapticFeedback.mediumImpact();
      ref.read(inAppLockRuntimeProvider.notifier).unlock();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage = 'Incorrect password. Try again.';
      });
    }
  }

  void _onPatternComplete(List<int> drawnPattern) {
    final secState = ref.read(privacySecurityProvider);
    final patternStr = drawnPattern.join(',');

    if (patternStr == secState.pattern) {
      HapticFeedback.mediumImpact();
      ref.read(inAppLockRuntimeProvider.notifier).unlock();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _isPatternError = true;
        _errorMessage = 'Wrong pattern. Try again.';
      });

      Timer(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            _isPatternError = false;
          });
          _patternKey.currentState?.clearPattern();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final secState = ref.watch(privacySecurityProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Lock Emblem
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: AppColors.primaryPurple,
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Bloom',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                secState.lockType == 'Password'
                    ? 'Enter your password to unlock'
                    : secState.lockType == 'Pattern'
                        ? 'Connect dots to draw your pattern'
                        : 'Enter your 4-digit PIN to unlock',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 20),

              // Error Message
              if (_errorMessage != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 6),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Specific Unlock Body
              if (secState.lockType == 'Password')
                _buildPasswordView()
              else if (secState.lockType == 'Pattern')
                _buildPatternView()
              else
                _buildPinView(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // PIN VIEW
  // ==========================================
  Widget _buildPinView() {
    return Column(
      children: [
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = index < _enteredPin.length;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.primaryPurple : Colors.transparent,
                border: Border.all(
                  color: isFilled
                      ? AppColors.primaryPurple
                      : AppColors.secondaryText.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 36),

        // 3x4 Keypad
        SizedBox(
          width: 280,
          child: Column(
            children: [
              for (int row = 0; row < 3; row++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int col = 1; col <= 3; col++)
                      _buildKeypadButton('${row * 3 + col}'),
                  ],
                ),
                const SizedBox(height: 14),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 72, height: 72),
                  _buildKeypadButton('0'),
                  InkWell(
                    onTap: _onPinBackspace,
                    borderRadius: BorderRadius.circular(36),
                    child: Container(
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.backspace_outlined,
                        color: AppColors.text,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return InkWell(
      onTap: () => _onPinDigit(digit),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          digit,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // PASSWORD VIEW
  // ==========================================
  Widget _buildPasswordView() {
    return Column(
      children: [
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              autofocus: true,
              style: const TextStyle(fontSize: 16, color: AppColors.text),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your password',
                icon: const Icon(Icons.password_rounded,
                    color: AppColors.primaryPurple),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.secondaryText,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              onSubmitted: (_) => _verifyPassword(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            onPressed: _verifyPassword,
            child: const Text(
              'Unlock',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PATTERN VIEW (CONNECTED LINES)
  // ==========================================
  Widget _buildPatternView() {
    return Column(
      children: [
        PatternLockWidget(
          key: _patternKey,
          isError: _isPatternError,
          onPatternStart: () {
            setState(() {
              _errorMessage = null;
              _isPatternError = false;
            });
          },
          onPatternComplete: _onPatternComplete,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _errorMessage = null;
              _isPatternError = false;
            });
            _patternKey.currentState?.clearPattern();
          },
          child: const Text(
            'Clear Pattern',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
