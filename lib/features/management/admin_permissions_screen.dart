import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class AdminPermissionsScreen extends StatefulWidget {
  final AdminUser admin;

  const AdminPermissionsScreen({super.key, required this.admin});

  @override
  State<AdminPermissionsScreen> createState() => _AdminPermissionsScreenState();
}

class _AdminPermissionsScreenState extends State<AdminPermissionsScreen> {
  late List<String> _permissions;

  final List<Map<String, String>> _allAvailablePermissions = [
    {'title': 'Manage Students', 'desc': 'Create, edit, view, and transfer student records.'},
    {'title': 'Manage Teachers', 'desc': 'Add teachers, assign subjects and classes.'},
    {'title': 'Fee Records', 'desc': 'View fee dues, collection status, and invoices.'},
    {'title': 'Attendance', 'desc': 'Approve leaves, view daily attendance reports.'},
    {'title': 'Notices', 'desc': 'Broadcast school-wide circulars and announcements.'},
    {'title': 'System Config', 'desc': 'Manage school academic year, terms, and system settings.'},
  ];

  @override
  void initState() {
    super.initState();
    _permissions = List.from(widget.admin.permissions);
  }

  void _savePermissions() {
    final idx = MockData.admins.indexWhere((a) => a.id == widget.admin.id);
    if (idx != -1) {
      MockData.admins[idx] = AdminUser(
        id: widget.admin.id,
        name: widget.admin.name,
        email: widget.admin.email,
        phone: widget.admin.phone,
        role: widget.admin.role,
        permissions: _permissions,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissions updated successfully!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text(
                    'Admin Permissions',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Admin badge summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softLilac,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security_rounded, color: AppColors.primaryPurple, size: 32),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.admin.name, style: AppTextStyles.titleSmall.copyWith(fontSize: 16)),
                        Text(widget.admin.role, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Access Control Modules',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: _allAvailablePermissions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _allAvailablePermissions[index];
                    final title = item['title']!;
                    final desc = item['desc']!;
                    final isEnabled = _permissions.contains(title);

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isEnabled ? AppColors.primaryPurple : AppColors.borderGrey,
                          width: 1.2,
                        ),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          title,
                          style: AppTextStyles.titleSmall.copyWith(fontSize: 15),
                        ),
                        subtitle: Text(
                          desc,
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        ),
                        activeThumbColor: AppColors.primaryPurple,
                        value: isEnabled,
                        onChanged: (val) {
                          setState(() {
                            if (val) {
                              _permissions.add(title);
                            } else {
                              _permissions.remove(title);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              SpargeePrimaryButton(
                text: 'Save Permissions',
                onPressed: _savePermissions,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
