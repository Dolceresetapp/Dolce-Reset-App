import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../common_widget/custom_button.dart';
import '../../helpers/navigation_service.dart';

class VideoCongratsScreen extends StatefulWidget {
  final String duration; // Format: "M:SS"
  final int kcal;
  const VideoCongratsScreen({
    super.key,
    required this.duration,
    required this.kcal,
  });

  @override
  State<VideoCongratsScreen> createState() => _VideoCongratsScreenState();
}

class _VideoCongratsScreenState extends State<VideoCongratsScreen>
    with TickerProviderStateMixin {
  // Confetti
  late AnimationController _confettiController;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  // Content animations
  late AnimationController _contentController;
  late Animation<double> _iconScale;
  late Animation<double> _iconFloat;
  late Animation<double> _titleSlide;
  late Animation<double> _subtitleSlide;
  late Animation<double> _stat1Scale;
  late Animation<double> _stat2Scale;
  late Animation<Offset> _buttonSlide;

  // Pulse animation for glow
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Floating animation
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    // Confetti controller
    _confettiController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Content controller
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Pulse controller for glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Float controller
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Icon animations
    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
      ),
    );

    _iconFloat = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Title animation
    _titleSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Subtitle animation
    _subtitleSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // Stats animations (staggered)
    _stat1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.45, 0.7, curve: Curves.elasticOut),
      ),
    );

    _stat2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.55, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Button slide
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Generate particles
    _generateParticles();

    // Start animations
    _confettiController.forward();
    _contentController.forward();

    // Loop confetti
    _confettiController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _generateParticles();
        _confettiController.reset();
        _confettiController.forward();
      }
    });
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 60; i++) {
      _particles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: -_random.nextDouble() * 0.3,
        size: _random.nextDouble() * 10 + 5,
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        speed: _random.nextDouble() * 0.4 + 0.15,
        wobble: _random.nextDouble() * 2 - 1,
        rotation: _random.nextDouble() * pi * 2,
      ));
    }
  }

  static const List<Color> _confettiColors = [
    Color(0xFFF566A9), // Pink (app color)
    Color(0xFFFFD700), // Gold
    Color(0xFFFF6B6B), // Coral
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFE66D), // Yellow
    Color(0xFFFF8C94), // Light pink
    Color(0xFFA8E6CF), // Mint
  ];

  @override
  void dispose() {
    _confettiController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(
                  particles: _particles,
                  progress: _confettiController.value,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UIHelper.verticalSpace(20.h),

                        // Animated like icon with glow
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _iconScale,
                            _iconFloat,
                            _pulseAnimation,
                          ]),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, sin(_iconFloat.value * pi) * 10),
                              child: Transform.scale(
                                scale: _iconScale.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF566A9)
                                            .withValues(alpha: _pulseAnimation.value),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    Assets.images.likeIcon.path,
                                    width: 200.w,
                                    height: 200.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        UIHelper.verticalSpace(20.h),

                        // Title with slide animation
                        AnimatedBuilder(
                          animation: _titleSlide,
                          builder: (context, child) {
                            final progress = 1 - (_titleSlide.value / 50);
                            return Transform.translate(
                              offset: Offset(0, _titleSlide.value),
                              child: Opacity(
                                opacity: progress.clamp(0.0, 1.0),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [
                                      Color(0xFFF566A9),
                                      Color(0xFFFF6B6B),
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    "Congratulazioni!",
                                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                        .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 32.sp,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        UIHelper.verticalSpace(15.h),

                        // Subtitle with slide animation
                        AnimatedBuilder(
                          animation: _subtitleSlide,
                          builder: (context, child) {
                            final progress = 1 - (_subtitleSlide.value / 50);
                            return Transform.translate(
                              offset: Offset(0, _subtitleSlide.value),
                              child: Opacity(
                                opacity: progress.clamp(0.0, 1.0),
                                child: Text(
                                  "Hai completato l'allenamento\ncon successo!",
                                  textAlign: TextAlign.center,
                                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                      .copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        UIHelper.verticalSpace(35.h),

                        // Stats row with staggered scale animations
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Duration stat
                            AnimatedBuilder(
                              animation: _stat1Scale,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _stat1Scale.value,
                                  child: _buildStatItem(
                                    icon: Assets.images.watchicon.path,
                                    value: widget.duration,
                                    label: "Tempo",
                                  ),
                                );
                              },
                            ),

                            // Kcal stat
                            AnimatedBuilder(
                              animation: _stat2Scale,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _stat2Scale.value,
                                  child: _buildStatItemWithEmoji(
                                    emoji: "🔥",
                                    value: widget.kcal.toString(),
                                    label: "kcal",
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        UIHelper.verticalSpace(30.h),
                      ],
                    ),
                  ),
                ),

                // Bottom button with slide animation
                SlideTransition(
                  position: _buttonSlide,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                    child: CustomButton(
                      onPressed: () {
                        NavigationService.navigateToReplacement(
                          Routes.navigationScreen,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continua",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          ),
                          SizedBox(width: 10.w),
                          SvgPicture.asset(
                            Assets.icons.arrowRight,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(icon, width: 50.w, height: 50.h),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItemWithEmoji({
    required String emoji,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 45.sp)),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// Confetti particle model
class ConfettiParticle {
  double x;
  double y;
  double size;
  Color color;
  double speed;
  double wobble;
  double rotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.wobble,
    required this.rotation,
  });
}

// Confetti painter
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final opacity = (1 - progress * 0.3).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width +
          sin(progress * 8 + particle.wobble * 4) * 40;
      final y = (particle.y + progress * particle.speed * 2.5) * size.height;

      if (y > size.height + 50) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + progress * particle.wobble * 4);

      // Draw confetti shapes (mix of rectangles and circles)
      if (particle.wobble > 0) {
        // Rectangle
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.5,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      } else {
        // Circle
        canvas.drawCircle(Offset.zero, particle.size * 0.4, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
