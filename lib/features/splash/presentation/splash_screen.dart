import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed Vice City Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_vice_city.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.background),
            ),
          ),

          // Dark gradient overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withAlpha(140),
                    Colors.transparent,
                    AppColors.background.withAlpha(200),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Neon GTA VI Logo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(160),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sports_esports_rounded,
                    size: 54,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.easeOutBack)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ).createShader(bounds),
                  child: Text(
                    'GTA VI',
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      letterSpacing: 4.0,
                      fontSize: 48,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                Text(
                  'COMPANION',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 8.0,
                    fontWeight: FontWeight.w800,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

                const SizedBox(height: 8),

                Text(
                  'VICE CITY • 2026',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary.withAlpha(180),
                    letterSpacing: 3.0,
                    fontSize: 11,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms),

                const Spacer(flex: 2),

                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ).animate().fadeIn(delay: 900.ms),

                const SizedBox(height: 12),

                Text(
                  'Carregando Vice City...',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ).animate().fadeIn(delay: 1000.ms),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
