import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Header Title
              RichText(
                text: TextSpan(
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                  children: [
                    const TextSpan(text: "Who's "),
                    TextSpan(
                      text: "logging",
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: " in\ntoday?"),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Role Cards List
              _buildRoleCard(
                context: context,
                title: 'Management',
                role: UserRole.management,
                imageAsset: 'assets/images/role_management.png',
                isPrimaryPurple: true,
              ),
              const SizedBox(height: 18),
              _buildRoleCard(
                context: context,
                title: 'Admin',
                role: UserRole.admin,
                imageAsset: 'assets/images/role_admin.png',
              ),
              const SizedBox(height: 18),
              _buildRoleCard(
                context: context,
                title: 'Teacher',
                role: UserRole.teacher,
                imageAsset: 'assets/images/role_teacher.png',
              ),
              const SizedBox(height: 18),
              _buildRoleCard(
                context: context,
                title: 'Student',
                role: UserRole.student,
                imageAsset: 'assets/images/role_student.png',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required UserRole role,
    required String imageAsset,
    bool isPrimaryPurple = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LoginScreen(selectedRole: role),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (isPrimaryPurple ? AppColors.primaryPurple : Colors.black).withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 648 / 238,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
