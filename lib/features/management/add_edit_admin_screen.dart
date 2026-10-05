import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/spargee_widgets.dart';

import '../../core/services/database_service.dart';

class AddEditAdminScreen extends StatefulWidget {
  final AdminUser? admin;

  const AddEditAdminScreen({super.key, this.admin});

  @override
  State<AddEditAdminScreen> createState() => _AddEditAdminScreenState();
}

class _AddEditAdminScreenState extends State<AddEditAdminScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  bool _manageTeachers = true;
  bool _manageStudents = true;
  bool _manageFees = false;
  bool _postNotices = true;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.admin;
    _nameController = TextEditingController(text: a?.name ?? '');
    _phoneController = TextEditingController(text: a?.phone ?? '');
    _emailController = TextEditingController(text: a?.email ?? '');

    if (a != null) {
      _manageTeachers = a.manageTeachers;
      _manageStudents = a.manageStudents;
      _manageFees = a.manageFees;
      _postNotices = a.postNotices;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter admin name')));
      return;
    }

    setState(() => _isSaving = true);

    final perms = <String>[];
    if (_manageStudents) perms.add('Manage Students');
    if (_manageTeachers) perms.add('Manage Teachers');
    if (_manageFees) perms.add('Fee Records');
    if (_postNotices) perms.add('Notices');

    if (widget.admin != null) {
      final updated = widget.admin!.copyWith(
        name: name,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        permissions: perms,
        manageTeachers: _manageTeachers,
        manageStudents: _manageStudents,
        manageFees: _manageFees,
        postNotices: _postNotices,
      );
      await DatabaseService.instance.updateAdmin(updated);
    } else {
      final newAdmin = AdminUser(
        id: 'A_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: 'Admin - All branches',
        permissions: perms,
        manageTeachers: _manageTeachers,
        manageStudents: _manageStudents,
        manageFees: _manageFees,
        postNotices: _postNotices,
      );
      await DatabaseService.instance.addAdmin(newAdmin);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.admin != null ? 'Admin details updated successfully' : 'Admin added successfully'),
        backgroundColor: const Color(0xFF22C55E),
      ),
    );

    Navigator.of(context).pop(true);
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

              // Upload Photo Avatar
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Photo uploaded successfully.')),
                        );
                      },
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7B7BDA),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload photo',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B6CCF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              const Text('Full name', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_nameController, 'Enter full name'),
              const SizedBox(height: 14),

              // Mobile number
              const Text('Mobile number', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_phoneController, 'Enter mobile number', keyboardType: TextInputType.phone),
              const SizedBox(height: 14),

              // Email
              const Text('Email', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_emailController, 'Enter email address', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),

              // ID proof (optional)
              const Text('ID proof (optional)', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID Proof: Admin_Government_ID.pdf')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9559),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'view uploaded file',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Permission Header
              const Text(
                'Permission',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5355BD),
                ),
              ),
              const SizedBox(height: 10),

              _buildPermissionToggle('Manage teachers', _manageTeachers, (v) {
                setState(() => _manageTeachers = v);
              }),
              _buildPermissionToggle('Manage students', _manageStudents, (v) {
                setState(() => _manageStudents = v);
              }),
              _buildPermissionToggle('Manage fees', _manageFees, (v) {
                setState(() => _manageFees = v);
              }),
              _buildPermissionToggle('Post notices', _postNotices, (v) {
                setState(() => _postNotices = v);
              }),
              const SizedBox(height: 28),

              // Save Changes Button
              SpargeePrimaryButton(
                text: 'Save changes',
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaInputField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.5, color: AppColors.textSecondary.withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
          ),
          Transform.scale(
            scale: 0.85,
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
