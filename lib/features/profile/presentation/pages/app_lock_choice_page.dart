import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/privacy_security_provider.dart';
import '../providers/in_app_lock_runtime_provider.dart';
import '../widgets/pattern_lock_widget.dart';

class AppLockChoicePage extends ConsumerStatefulWidget {
  const AppLockChoicePage({super.key});

  @override
  ConsumerState<AppLockChoicePage> createState() => _AppLockChoicePageState();
}

class _AppLockChoicePageState extends ConsumerState<AppLockChoicePage> {
  @override
  Widget build(BuildContext context) {
    final secState = ref.watch(privacySecurityProvider);
    final secNotifier = ref.read(privacySecurityProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'App Lock',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Lock Method',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // 1. None
                    _buildMethodTile(
                      icon: Icons.lock_open_outlined,
                      title: 'None',
                      subtitle: 'No passcode required to open the app',
                      isSelected: secState.lockType == 'None',
                      onTap: () {
                        secNotifier.setLockType('None');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('App lock turned off.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 2. PIN
                    _buildMethodTile(
                      icon: Icons.pin_outlined,
                      title: 'PIN',
                      subtitle: secState.lockType == 'PIN'
                          ? 'Active 4-digit code (••••)'
                          : 'Set a 4-digit numeric passcode',
                      isSelected: secState.lockType == 'PIN',
                      trailingActionText:
                          secState.lockType == 'PIN' ? 'Change' : null,
                      onTap: () => _showSetPinDialog(context),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 3. Password
                    _buildMethodTile(
                      icon: Icons.password_rounded,
                      title: 'Password',
                      subtitle: secState.lockType == 'Password'
                          ? 'Custom password active'
                          : 'Set custom text or alphanumeric password',
                      isSelected: secState.lockType == 'Password',
                      trailingActionText:
                          secState.lockType == 'Password' ? 'Change' : null,
                      onTap: () => _showSetPasswordDialog(context),
                    ),
                    const Divider(color: AppColors.border, height: 1),

                    // 4. Pattern
                    _buildMethodTile(
                      icon: Icons.pattern_rounded,
                      title: 'Pattern',
                      subtitle: secState.lockType == 'Pattern'
                          ? 'Connected dots pattern active'
                          : 'Connect dots with lines to draw a pattern',
                      isSelected: secState.lockType == 'Pattern',
                      trailingActionText:
                          secState.lockType == 'Pattern' ? 'Change' : null,
                      onTap: () => _showSetPatternDialog(context),
                    ),
                  ],
                ),
              ),

              if (secState.isLockActive) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.lock_outline, size: 20),
                    label: Text(
                      'Lock App Now (Test ${secState.lockType})',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      ref.read(inAppLockRuntimeProvider.notifier).lock();
                    },
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // Security Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primaryPurple,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '100% In-App Security',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Your chosen lock method runs securely within Bloom and does not request Android device permissions or system credentials.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    String? trailingActionText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPurple
                    : AppColors.lightPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryPurple,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryPurple : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingActionText != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trailingActionText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primaryPurple : AppColors.border,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SET PIN MODAL
  // ==========================================
  void _showSetPinDialog(BuildContext context) {
    String firstPin = '';
    String confirmPin = '';
    bool isConfirming = false;
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            void onDigit(String d) {
              if (isConfirming) {
                if (confirmPin.length >= 4) return;
                HapticFeedback.lightImpact();
                setModalState(() {
                  confirmPin += d;
                  errorText = null;
                });
                if (confirmPin.length == 4) {
                  if (confirmPin == firstPin) {
                    ref.read(privacySecurityProvider.notifier).setPin(firstPin);
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PIN successfully set!'),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );
                  } else {
                    HapticFeedback.heavyImpact();
                    setModalState(() {
                      errorText = 'PINs do not match. Try again.';
                      confirmPin = '';
                    });
                  }
                }
              } else {
                if (firstPin.length >= 4) return;
                HapticFeedback.lightImpact();
                setModalState(() {
                  firstPin += d;
                  errorText = null;
                });
                if (firstPin.length == 4) {
                  setModalState(() {
                    isConfirming = true;
                  });
                }
              }
            }

            void onBackspace() {
              HapticFeedback.lightImpact();
              setModalState(() {
                if (isConfirming) {
                  if (confirmPin.isNotEmpty) {
                    confirmPin = confirmPin.substring(0, confirmPin.length - 1);
                  } else {
                    isConfirming = false;
                    firstPin = '';
                  }
                } else {
                  if (firstPin.isNotEmpty) {
                    firstPin = firstPin.substring(0, firstPin.length - 1);
                  }
                }
                errorText = null;
              });
            }

            final activePin = isConfirming ? confirmPin : firstPin;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isConfirming ? 'Confirm Your 4-Digit PIN' : 'Enter New 4-Digit PIN',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isConfirming
                          ? 'Re-enter the same PIN to confirm'
                          : 'Choose a PIN you will remember',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // PIN Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final filled = index < activePin.length;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled
                                ? AppColors.primaryPurple
                                : Colors.transparent,
                            border: Border.all(
                              color: filled
                                  ? AppColors.primaryPurple
                                  : AppColors.border,
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    ),

                    if (errorText != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        errorText!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // 3x4 Keypad
                    for (int r = 0; r < 3; r++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int c = 1; c <= 3; c++)
                            _buildDialogKeypadBtn(
                              '${r * 3 + c}',
                              () => onDigit('${r * 3 + c}'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 64, height: 64),
                        _buildDialogKeypadBtn('0', () => onDigit('0')),
                        InkWell(
                          onTap: onBackspace,
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            width: 64,
                            height: 64,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.backspace_outlined,
                              color: AppColors.text,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogKeypadBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.lightPurple.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SET PASSWORD MODAL
  // ==========================================
  void _showSetPasswordDialog(BuildContext context) {
    final textController = TextEditingController();
    final confirmController = TextEditingController();
    bool obscure = true;
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Set Password',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter an alphanumeric password to lock Bloom',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: textController,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setModalState(() => obscure = !obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: confirmController,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  if (errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorText!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final p1 = textController.text.trim();
                        final p2 = confirmController.text.trim();
                        if (p1.isEmpty) {
                          setModalState(
                              () => errorText = 'Password cannot be empty');
                          return;
                        }
                        if (p1 != p2) {
                          setModalState(
                              () => errorText = 'Passwords do not match');
                          return;
                        }
                        ref
                            .read(privacySecurityProvider.notifier)
                            .setPassword(p1);
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password successfully set!'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                      },
                      child: const Text(
                        'Save Password',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // SET PATTERN MODAL (CONNECTED LINES)
  // ==========================================
  void _showSetPatternDialog(BuildContext context) {
    List<int>? firstPattern;
    bool isConfirming = false;
    bool isError = false;
    String? statusMessage = 'Connect at least 4 dots to draw your pattern';
    final GlobalKey<PatternLockWidgetState> modalPatternKey = GlobalKey();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            void onPatternComplete(List<int> pattern) {
              if (pattern.length < 4) {
                HapticFeedback.heavyImpact();
                setModalState(() {
                  isError = true;
                  statusMessage = 'Pattern must connect at least 4 dots';
                });
                Future.delayed(const Duration(milliseconds: 700), () {
                  setModalState(() {
                    isError = false;
                  });
                  modalPatternKey.currentState?.clearPattern();
                });
                return;
              }

              if (!isConfirming) {
                HapticFeedback.mediumImpact();
                setModalState(() {
                  firstPattern = List.from(pattern);
                  isConfirming = true;
                  statusMessage = 'Draw the same pattern again to confirm';
                });
                modalPatternKey.currentState?.clearPattern();
              } else {
                final match = pattern.join(',') == firstPattern!.join(',');
                if (match) {
                  HapticFeedback.mediumImpact();
                  ref
                      .read(privacySecurityProvider.notifier)
                      .setPattern(pattern.join(','));
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pattern successfully set!'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                } else {
                  HapticFeedback.heavyImpact();
                  setModalState(() {
                    isError = true;
                    statusMessage = 'Patterns did not match. Try again.';
                  });
                  Future.delayed(const Duration(milliseconds: 700), () {
                    setModalState(() {
                      isError = false;
                      isConfirming = false;
                      firstPattern = null;
                      statusMessage = 'Connect at least 4 dots to draw pattern';
                    });
                    modalPatternKey.currentState?.clearPattern();
                  });
                }
              }
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isConfirming ? 'Confirm Pattern' : 'Set Unlock Pattern',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      statusMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isError ? FontWeight.bold : FontWeight.normal,
                        color:
                            isError ? Colors.red : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Connected Dots Pattern Canvas
                    PatternLockWidget(
                      key: modalPatternKey,
                      isError: isError,
                      size: 260,
                      onPatternStart: () {
                        setModalState(() {
                          isError = false;
                        });
                      },
                      onPatternComplete: onPatternComplete,
                    ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          isConfirming = false;
                          firstPattern = null;
                          isError = false;
                          statusMessage =
                              'Connect at least 4 dots to draw pattern';
                        });
                        modalPatternKey.currentState?.clearPattern();
                      },
                      child: const Text('Reset Pattern'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
