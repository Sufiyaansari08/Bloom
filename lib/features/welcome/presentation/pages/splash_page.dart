import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/services/auth_storage_service.dart';

class _PetalMote {
  final double angle; // radians around center
  final double distance;
  final double size;
  final double baseOpacity;

  const _PetalMote({
    required this.angle,
    required this.distance,
    required this.size,
    required this.baseOpacity,
  });
}

const _kPetalMotes = [
  _PetalMote(angle: -0.65, distance: 74, size: 6, baseOpacity: 0.50), // top-right
  _PetalMote(angle: 0.40, distance: 82, size: 5, baseOpacity: 0.42),  // right-down
  _PetalMote(angle: 1.35, distance: 76, size: 6.5, baseOpacity: 0.48), // bottom-right
  _PetalMote(angle: 2.25, distance: 80, size: 4.5, baseOpacity: 0.38), // bottom-left
  _PetalMote(angle: -2.35, distance: 72, size: 5.5, baseOpacity: 0.46), // top-left
  _PetalMote(angle: -1.55, distance: 86, size: 4.0, baseOpacity: 0.36), // top
];

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

  // Layer 1: Ambient Glowing Bloom Aura
  late Animation<double> _glowScale;
  late Animation<double> _glowFade;

  // Layer 2: Expanding Concentric Petal Ripple Ring
  late Animation<double> _rippleScale;
  late Animation<double> _rippleFade;

  // Layer 3: Ambient Floating Petal Motes
  late Animation<double> _particleProgress;

  // Layer 4: Flower Blooming & Physics
  late Animation<double> _flowerScale;
  late Animation<double> _flowerRotation;
  late Animation<double> _flowerFade;

  // Layer 5: Title Animations ("Bloom")
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleScale;
  late Animation<double> _titleLetterSpacing;

  // Layer 6: Subtext Animations ("Your personal cycle tracker")
  late Animation<double> _subtextFade;
  late Animation<Offset> _subtextSlide;

  // Layer 7: Bottom Loading Indicator
  late Animation<double> _dotsFade;

  String? _target;

  @override
  void initState() {
    super.initState();
    _determineTarget();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // 1. Radiant Aura expands and breathes outwards
    _glowScale = Tween<double>(begin: 0.25, end: 1.45).animate(
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

    // 2. Concentric petal ripple wave expanding from the center
    _rippleScale = Tween<double>(begin: 0.20, end: 1.65).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.12, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _rippleFade = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.70)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.70, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.12, 0.75),
      ),
    );

    // 3. Floating Petal Particles outward drift
    _particleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // 4. Flower unfolds with lively spring overshoot & uncurling rotation
    _flowerScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _flowerRotation = Tween<double>(begin: -0.42, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _flowerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.03, 0.35, curve: Curves.easeIn),
      ),
    );

    // 5. "Bloom" Title: Slide + Fade + Letter-Spacing tracking
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.72, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.45),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _titleScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.72, curve: Curves.easeOutBack),
      ),
    );

    _titleLetterSpacing = Tween<double>(begin: 2.2, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    // 6. Subtext follows smoothly
    _subtextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.85, curve: Curves.easeIn),
      ),
    );

    _subtextSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // 7. Bottom pulse dots
    _dotsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.90, curve: Curves.easeIn),
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
        // Premium soft pinkish gradient background
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
              // Gentle floating breathing motion once flower unfolds
              double breathingOffsetY = 0.0;
              double breathingScale = 1.0;
              if (_controller.value > 0.52) {
                final cycleProgress = (_controller.value - 0.52) / 0.48;
                breathingOffsetY = math.sin(cycleProgress * math.pi * 2) * 3.5;
                breathingScale = 1.0 + 0.03 * math.sin(cycleProgress * math.pi * 2);
              }

              return Stack(
                children: [
                  // Center Content
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1. Blooming Florist Icon with Multi-Layered Dynamics
                          SizedBox(
                            width: 170,
                            height: 170,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Layer A: Soft radiant glowing halo expanding outwards
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
                                            alpha: 0.25 * _glowFade.value,
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

                                // Layer B: Expanding Concentric Petal Ripple Ring
                                Transform.scale(
                                  scale: _rippleScale.value,
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryPink.withValues(
                                          alpha: 0.35 * _rippleFade.value,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                // Layer C: Floating Petal Particles drifting softly outward
                                ...List.generate(_kPetalMotes.length, (index) {
                                  final mote = _kPetalMotes[index];
                                  final p = _particleProgress.value;
                                  final currentDist = mote.distance * (0.35 + 0.65 * p);
                                  final dx = math.cos(mote.angle) * currentDist;
                                  final dy = math.sin(mote.angle) * currentDist;
                                  final particleOpacity = (mote.baseOpacity * math.sin(p * math.pi)).clamp(0.0, 1.0);

                                  return Transform.translate(
                                    offset: Offset(dx, dy),
                                    child: Opacity(
                                      opacity: particleOpacity,
                                      child: Container(
                                        width: mote.size,
                                        height: mote.size,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryPink,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryPink.withValues(alpha: 0.4),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                // Layer D: Florist Icon with spring bloom, rotation & idle breathing float
                                Transform.translate(
                                  offset: Offset(0, breathingOffsetY),
                                  child: Transform.scale(
                                    scale: _flowerScale.value * breathingScale,
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
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 2. "Bloom" Brand Title (with slide, scale, and letter-spacing tracking)
                          SlideTransition(
                            position: _titleSlide,
                            child: FadeTransition(
                              opacity: _titleFade,
                              child: Transform.scale(
                                scale: _titleScale.value,
                                child: Text(
                                  'Bloom',
                                  style: GoogleFonts.outfit(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                    letterSpacing: _titleLetterSpacing.value,
                                  ),
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
                  ),

                  // Bottom subtle 3-dot loading pulse
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: Center(
                      child: Opacity(
                        opacity: _dotsFade.value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (i) {
                            final dotPulse = 0.5 + 0.5 * math.sin((_controller.value * 6 * math.pi) + (i * 0.8)).abs();
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3.5),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryPink.withValues(
                                  alpha: 0.25 + 0.55 * dotPulse,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
