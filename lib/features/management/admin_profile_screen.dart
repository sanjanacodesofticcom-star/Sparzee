import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';
import 'add_edit_admin_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  final AdminUser admin;

  const AdminProfileScreen({super.key, required this.admin});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late AdminUser _currentAdmin;

  @override
  void initState() {
    super.initState();
    _currentAdmin = widget.admin;
  }

  void _refreshAdmin() {
    final found = DatabaseService.instance.currentAdmins.firstWhere(
      (a) => a.id == _currentAdmin.id,
      orElse: () => _currentAdmin,
    );
    setState(() {
      _currentAdmin = found;
    });
  }

  void _updatePermission(void Function() updateFn) async {
    setState(updateFn);
    await DatabaseService.instance.updateAdmin(_currentAdmin);
  }

  void _handleDeactivate() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Deactivate Admin'),
        content: Text('Are you sure you want to deactivate ${_currentAdmin.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await DatabaseService.instance.deleteAdmin(_currentAdmin.id);
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Admin deactivated successfully')),
                );
              }
            },
            child: const Text('Deactivate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpargeeBackButton(),
              const SizedBox(height: 16),
              Text(
                'Admin Profile',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Admin Avatar with Active Badge
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SpargeeAvatar(
                          name: _currentAdmin.name,
                          avatarAsset: _currentAdmin.avatarUrl,
                          size: 88,
                          backgroundColor: AppColors.primaryPurple,
                        ),
                        Positioned(
                          bottom: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _currentAdmin.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentAdmin.role.contains('-') ? _currentAdmin.role : 'Admin - ${_currentAdmin.branch}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Main Card matching Figma
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6FD),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE8E9F6), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic info',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5355BD),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildFigmaInfoRow('Mobile', _currentAdmin.phone),
                    _buildFigmaInfoRow('Email', _currentAdmin.email),
                    const SizedBox(height: 16),

                    const Text(
                      'Permission',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5355BD),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildPermissionToggle('Manage teachers', _currentAdmin.manageTeachers, (v) {
                      _updatePermission(() => _currentAdmin.manageTeachers = v);
                    }),
                    _buildPermissionToggle('Manage students', _currentAdmin.manageStudents, (v) {
                      _updatePermission(() => _currentAdmin.manageStudents = v);
                    }),
                    _buildPermissionToggle('Manage fees', _currentAdmin.manageFees, (v) {
                      _updatePermission(() => _currentAdmin.manageFees = v);
                    }),
                    _buildPermissionToggle('Post notices', _currentAdmin.postNotices, (v) {
                      _updatePermission(() => _currentAdmin.postNotices = v);
                    }),
                    const SizedBox(height: 16),

                    const Text(
                      'Recent activity',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5355BD),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._currentAdmin.recentActivities.map(
                      (act) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECE5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.description_outlined, color: Color(0xFF6B6CCF), size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${act.title} - ${act.timeAgo}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5A483E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Row Buttons: Edit Profile & Deactivate
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddEditAdminScreen(admin: _currentAdmin),
                          ),
                        );
                        if (res == true) _refreshAdmin();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFD3D4F0), width: 1.2),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Edit profile',
                        style: TextStyle(
                          color: Color(0xFF6B6CCF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleDeactivate,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFFF9559), width: 1.2),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Deactivate',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          Transform.scale(
            scale: 0.82,
            child: Switch(
              value: value,
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF7B7BDA),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFFFB688),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
