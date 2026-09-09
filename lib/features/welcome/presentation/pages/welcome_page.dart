import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bloom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE1EA), // Distinct pinkish background for the welcome page
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isSmallScreen ? 40 : 60), // Consistent top spacing
                // "Welcome to" text
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // "Bloom" Title
                Text(
                  'Bloom',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 52,
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 40), // Pushes image down slightly
                // Illustration placeholder
                Center(
                  child: Container(
                    height: isSmallScreen ? 180 : 240, // Made the image smaller
                    width: isSmallScreen ? 180 : 240,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightPink,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/welcome_illustration.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.eco_rounded,
                              size: 100,
                              color: AppColors.primaryPink,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 40), // Gives room below image
                // Subtitle
                Text(
                  'Your personal menstrual\nhealth companion',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48), // Guaranteed large space before buttons
                // Primary Button
                BloomButton(
                  text: 'Let\'s get started',
                  onPressed: () {
                    context.push('/signup');
                  },
                ),
                const SizedBox(height: 16),
                // "Already have an account"
                TextButton(
                  onPressed: () {
                    context.push('/login');
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Already have an account? Log in',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 40), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
