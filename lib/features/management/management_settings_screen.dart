import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../auth/role_selection_screen.dart';
import 'edit_profile_screen.dart';
import 'school_profile_screen.dart';
import 'class_section_structure_screen.dart';
import 'fee_structure_templates_screen.dart';
import 'notice_categories_screen.dart';
import 'notification_preferences_screen.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';

class ManagementSettingsScreen extends StatefulWidget {
  final bool showBackButton;

  const ManagementSettingsScreen({super.key, this.showBackButton = false});

  @override
  State<ManagementSettingsScreen> createState() => _ManagementSettingsScreenState();
}

class _ManagementSettingsScreenState extends State<ManagementSettingsScreen> {
  Future<void> _navigateToEditProfile() async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (updated == true || mounted) {
      setState(() {});
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Confirm Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of Sparzee School Management?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppData.currentUser = null;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.management]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Button
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                ],
              ),
              const SizedBox(height: 16),

              // Title: Settings
              Text(
                'Settings',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Profile Section with Avatar, Camera Badge, Name & Subtitle
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _navigateToEditProfile,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.18),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                user.avatarUrl ?? 'assets/images/management_avatar.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.primaryPurple,
                                  child: const Center(
                                    child: Icon(Icons.person, color: Colors.white, size: 45),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Camera Badge on top right of the avatar
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B6CCF),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Name in Purple Uppercase matching Figma
                    GestureDetector(
                      onTap: _navigateToEditProfile,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7F80DA),
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF7F80DA)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle matching Figma
                    Text(
                      user.designation.isNotEmpty ? user.designation : 'Management - Little Scholar',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Settings Options List matching Figma design
              _buildFigmaMenuItem(
                title: 'School Profile',
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SchoolProfileScreen()),
                  );
                  setState(() {});
                },
              ),
              _buildFigmaMenuItem(
                title: 'Class & section structure',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ClassSectionStructureScreen()),
                  );
                },
              ),
              _buildFigmaMenuItem(
                title: 'Fee structure templates',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FeeStructureTemplatesScreen()),
                  );
                },
              ),
              _buildFigmaMenuItem(
                title: 'Notice categories',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NoticeCategoriesScreen()),
                  );
                },
              ),
              _buildFigmaMenuItem(
                title: 'Notification preferences',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationPreferencesScreen()),
                  );
                },
              ),
              _buildFigmaMenuItem(
                title: 'Help & support',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                  );
                },
              ),
              _buildFigmaMenuItem(
                title: 'Privacy policy & terms',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                  );
                },
              ),
              const SizedBox(height: 36),

              // Solid Orange Log Out Button matching Figma
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _confirmLogout,
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaMenuItem({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFFFCBB0), // Soft orange/peach underline from Figma
              width: 1.1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6E6059), // Figma soft charcoal
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primaryOrange,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
