import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Hero Illustration from Figma
              Expanded(
                flex: 9,
                child: Center(
                  child: Image.asset(
                    'assets/images/welcome_hero.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppColors.softPeach,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(Icons.school_rounded, size: 90, color: AppColors.primaryOrange),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Manage your school,\neffortlessly',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                'Classes, staff, and students — all\nconnected.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  color: AppColors.textPrimary.withValues(alpha: 0.85),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
              // Pill Indicator
              Container(
                width: 28,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Spacer(),
              // Get Started Button
              SpargeePrimaryButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                  );
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
