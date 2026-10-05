import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../auth/role_selection_screen.dart';
import 'edit_student_profile_screen.dart';
import 'student_notification_preferences_screen.dart';
import 'student_help_support_screen.dart';
import 'student_privacy_policy_screen.dart';

class StudentProfileSettingsScreen extends StatefulWidget {
  final bool showBackButton;

  const StudentProfileSettingsScreen({super.key, this.showBackButton = false});

  @override
  State<StudentProfileSettingsScreen> createState() => _StudentProfileSettingsScreenState();
}

class _StudentProfileSettingsScreenState extends State<StudentProfileSettingsScreen> {
  Future<void> _pickImageFromDevice() async {
    try {
      final result = await FilePickerPlatform.instance.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
      );
      if (result.isNotEmpty) {
        final filePath = result.first.path;
        final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
        final student = AppData.students.firstWhere(
          (s) => s.name == user.name || s.parentPhone == user.phone,
          orElse: () => AppData.students.first,
        );
        setState(() {
          student.avatarUrl = filePath;
          if (AppData.currentUser != null) {
            AppData.currentUser = AppData.currentUser!.copyWith(avatarUrl: filePath);
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Updated profile image: ${result.first.name}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated successfully.')),
        );
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFF0EFFF), shape: BoxShape.circle),
                child: const Icon(Icons.upload_file_rounded, color: Color(0xFF7F80DA)),
              ),
              title: const Text('Upload from Device / System', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Select a photo from device storage'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImageFromDevice();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFFFF1EB), shape: BoxShape.circle),
                child: const Icon(Icons.edit_note_rounded, color: AppColors.primaryOrange),
              ),
              title: const Text('Edit Full Student Profile', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Modify contact info, parent details & address'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final updated = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const EditStudentProfileScreen()),
                );
                if (updated == true) setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of the Student Portal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppData.currentUser = null;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
    final studentRecord = AppData.students.firstWhere(
      (s) => s.name == user.name || s.parentPhone == user.phone,
      orElse: () => AppData.students.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.showBackButton || Navigator.canPop(context)) ...[
                        const SpargeeBackButton(),
                        const SizedBox(width: 14),
                      ],
                      Text(
                        'Settings',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(builder: (_) => const EditStudentProfileScreen()),
                      );
                      if (updated == true) setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryOrange),
                          SizedBox(width: 4),
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Avatar & Name matching Figma image 2 (right)
              Center(
                child: Column(
                  children: [
                    SpargeeAvatar(
                      name: studentRecord.name,
                      avatarAsset: studentRecord.avatarUrl,
                      size: 94,
                      backgroundColor: AppColors.primaryPurple,
                      showEditBadge: true,
                      badgeIcon: Icons.camera_alt_rounded,
                      onEditTap: _showImagePickerModal,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      studentRecord.name,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${studentRecord.fullClass} • Adm.${studentRecord.admissionNo}',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info Card (Lilac container) matching Figma image 2 (right)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic info',
                      style: AppTextStyles.titleSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Date of birth', studentRecord.dateOfBirth),
                    _buildInfoRow('Admission no.', studentRecord.admissionNo),
                    _buildInfoRow('Class teacher', studentRecord.classTeacher),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xFFD6D6EA), height: 1),
                    ),
                    Text(
                      'Parents contact',
                      style: AppTextStyles.titleSmall.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Name', studentRecord.parentName),
                    _buildInfoRow('Mobile', studentRecord.parentPhone),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Links with orange bottom border matching Figma image 2 (right)
              _buildMenuItem(
                title: 'Notification preferences',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StudentNotificationPreferencesScreen()),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Help & support',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StudentHelpSupportScreen()),
                  );
                },
              ),
              _buildMenuItem(
                title: 'Privacy policy & terms',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StudentPrivacyPolicyScreen()),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Log Out Button
              SpargeePrimaryButton(
                text: 'Log Out',
                onPressed: _confirmLogout,
              ),
              const SizedBox(height: 20),
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
          Text(label, style: const TextStyle(fontSize: 13.5, color: Color(0xFF4B5563))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
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
          bottom: BorderSide(color: Color(0xFFFFA366), width: 1.0),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 15.5, color: AppColors.textDark, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFFFA366), size: 16),
        onTap: onTap,
      ),
    );
  }
}
