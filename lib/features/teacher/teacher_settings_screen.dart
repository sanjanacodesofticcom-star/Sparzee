import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../auth/role_selection_screen.dart';
import 'edit_teacher_profile_screen.dart';
import 'teacher_notification_preferences_screen.dart';
import 'teacher_security_screen.dart';
import 'teacher_help_support_screen.dart';
import 'teacher_privacy_policy_screen.dart';

class TeacherSettingsScreen extends StatefulWidget {
  final bool showBackButton;

  const TeacherSettingsScreen({super.key, this.showBackButton = false});

  @override
  State<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends State<TeacherSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.teacher]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  if (widget.showBackButton || Navigator.canPop(context)) ...[
                    const SpargeeBackButton(),
                    const SizedBox(width: 14),
                  ],
                  Text(
                    'Settings',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Avatar & Profile Info
              Center(
                child: Column(
                  children: [
                    SpargeeAvatar(
                      name: user.name,
                      avatarAsset: user.avatarUrl,
                      size: 96,
                      backgroundColor: const Color(0xFFFFA366),
                      showEditBadge: true,
                      badgeIcon: Icons.camera_alt_rounded,
                      onEditTap: () async {
                        final updated = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditTeacherProfileScreen(user: user),
                          ),
                        );
                        if (updated == true) setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.designation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Teacher Profile & Department Info Box
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Teacher Profile & Department',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EditTeacherProfileScreen(user: user),
                              ),
                            );
                            if (updated == true) setState(() {});
                          },
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFFFFA366),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Department', 'Mathematics & Logic'),
                    _buildInfoRow('Staff ID', 'TCH-2026-003'),
                    _buildInfoRow('Registered Mobile', '+91 ${user.phone}'),
                    _buildInfoRow('Assigned Classes', 'Class 6-A (Head Teacher), Class 6-B, Class 7-A'),
                    _buildInfoRow('Official Email', user.email),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Items
              _buildMenuItem(
                title: 'Notification preferences',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TeacherNotificationPreferencesScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Security & Access',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TeacherSecurityScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Help & support',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TeacherHelpSupportScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Privacy policy',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TeacherPrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Log Out Button
              SpargeePrimaryButton(
                text: 'Log Out',
                onPressed: () {
                  AppData.currentUser = null;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFFFB688), width: 1.0),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFFFFA366),
          size: 15,
        ),
        onTap: onTap,
      ),
    );
  }
}
