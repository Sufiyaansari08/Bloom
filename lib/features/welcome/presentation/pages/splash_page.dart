import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/services/auth_storage_service.dart';

class SplashPage extends ConsumerStatefulWidget {
  final String? targetRoute;

  const SplashPage({
    super.key,
    this.targetRoute,
  });

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Glowing Bloom Aura Animations
  late Animation<double> _glowScale;
  late Animation<double> _glowFade;

  // Flower Blooming Animations
  late Animation<double> _flowerScale;
  late Animation<double> _flowerRotation;
  late Animation<double> _flowerFade;

  // Title Animations ("Bloom")
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  // Subtext Animations ("Your personal cycle tracker")
  late Animation<double> _subtextFade;
  late Animation<Offset> _subtextSlide;

  String? _target;

  @override
  void initState() {
    super.initState();
    _determineTarget();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 1. Radiant Aura expands and breathes outwards
    _glowScale = Tween<double>(begin: 0.2, end: 1.35).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _glowFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    // 2. Flower unfolds, scales up with a lively organic spring
    _flowerScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.06, 0.58, curve: Curves.easeOutBack),
      ),
    );

    // 3. Blooming rotation as flower unfolds (-20 degrees to 0)
    _flowerRotation = Tween<double>(begin: -0.35, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.06, 0.58, curve: Curves.easeOutCubic),
      ),
    );

    _flowerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.04, 0.38, curve: Curves.easeIn),
      ),
    );

    // 4. "Bloom" Title fades in and slides up gracefully
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.72, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    // 5. "Your personal cycle tracker" subtext follows smoothly
    _subtextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.86, curve: Curves.easeIn),
      ),
    );

    _subtextSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.86, curve: Curves.easeOutCubic),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          context.go(_target ?? widget.targetRoute ?? '/welcome');
        }
      }
    });

    _controller.forward();
  }

  Future<void> _determineTarget() async {
    if (widget.targetRoute != null && widget.targetRoute!.isNotEmpty) {
      _target = widget.targetRoute;
      return;
    }

    try {
      final db = ref.read(databaseProvider);
      final isLoggedIn = await AuthStorageService.instance.isLoggedIn(db: db);
      _target = isLoggedIn ? '/home' : '/welcome';
    } catch (_) {
      _target = '/welcome';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Premium soft pinkish gradient enhancement
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F5), // Delicate soft lavender blush
              Color(0xFFFFF8FA), // Clean pearlescent center
              Color(0xFFFFEBF2), // Gentle warm rose petal mist
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. Blooming Florist Icon with Radiant Aura
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft radiant glowing halo expanding behind the flower
                            Transform.scale(
                              scale: _glowScale.value,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primaryPink.withValues(
                                        alpha: 0.24 * _glowFade.value,
                                      ),
                                      AppColors.primaryPink.withValues(
                                        alpha: 0.08 * _glowFade.value,
                                      ),
                                      AppColors.primaryPink.withValues(
                                        alpha: 0.0,
                                      ),
                                    ],
                                    stops: const [0.0, 0.55, 1.0],
                                  ),
                                ),
                              ),
                            ),

                            // Florist Icon with organic spring bloom & rotation
                            Transform.scale(
                              scale: _flowerScale.value,
                              child: Transform.rotate(
                                angle: _flowerRotation.value,
                                child: Opacity(
                                  opacity: _flowerFade.value,
                                  child: const Icon(
                                    Icons.local_florist,
                                    size: 68,
                                    color: AppColors.primaryPink,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 2. "Bloom" Brand Title (matching in_app_security_gate)
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: Text(
                            'Bloom',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 3. "Your personal cycle tracker" Subtitle
                      SlideTransition(
                        position: _subtextSlide,
                        child: FadeTransition(
                          opacity: _subtextFade,
                          child: const Text(
                            'Your personal cycle tracker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryText,
                              height: 1.4,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
