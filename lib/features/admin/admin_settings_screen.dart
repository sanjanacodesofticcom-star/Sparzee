import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../auth/role_selection_screen.dart';
import 'edit_admin_profile_screen.dart';
import 'admin_notification_preferences_screen.dart';
import 'admin_security_screen.dart';
import 'admin_help_support_screen.dart';
import 'admin_privacy_terms_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  final bool showBackButton;

  const AdminSettingsScreen({super.key, this.showBackButton = false});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.admin]!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Profile Avatar & Camera Badge
              Center(
                child: Column(
                  children: [
                    SpargeeAvatar(
                      name: user.name,
                      avatarAsset: user.avatarUrl,
                      size: 96,
                      backgroundColor: const Color(0xFF8182DE),
                      borderColor: Colors.transparent,
                      showEditBadge: true,
                      badgeIcon: Icons.camera_alt_rounded,
                      onEditTap: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditAdminProfileScreen()),
                        );
                        if (res == true) setState(() {});
                      },
                      onTap: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditAdminProfileScreen()),
                        );
                        if (res == true) setState(() {});
                      },
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.designation.isNotEmpty ? user.designation : 'Chief Administrator'} • Sparzee',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Admin Credentials & Access Card
              GestureDetector(
                onTap: () async {
                  final res = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditAdminProfileScreen()),
                  );
                  if (res == true) setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0FA),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Admin Credentials & Access',
                            style: AppTextStyles.titleSmall.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.primaryPurple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildInfoRow('Role', user.designation.isNotEmpty ? user.designation : 'Chief Administrator'),
                      _buildInfoRow('Admin ID', 'ADM-2026-002'),
                      _buildInfoRow('Registered Mobile', '+91 ${user.phone}'),
                      _buildInfoRow('Official Email', user.email),
                      _buildInfoRow('Assigned School', user.schoolName.isNotEmpty ? user.schoolName : 'Sparzee Central School'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              _buildMenuItem(
                title: 'Notification preferences',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminNotificationPreferencesScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Security & Access',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminSecurityScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Help & support',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminHelpSupportScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Privacy policy',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminPrivacyTermsScreen(),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
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
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.primaryOrange,
          size: 15,
        ),
        onTap: onTap,
      ),
    );
  }
}
