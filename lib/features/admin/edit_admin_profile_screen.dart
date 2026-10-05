import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({super.key});

  @override
  State<EditAdminProfileScreen> createState() => _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState extends State<EditAdminProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _roleTitleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _schoolNameController;
  String? _currentAvatar;

  final ImagePicker _imagePicker = ImagePicker();
  bool _isSaving = false;
  bool _isPickingImage = false;

  final List<String> _presetAvatars = [
    'assets/images/role_admin.png',
    'assets/images/management_avatar.png',
    'assets/images/teacher_avatar.png',
    'assets/images/student_avatar.png',
  ];

  @override
  void initState() {
    super.initState();
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.admin]!;
    _nameController = TextEditingController(text: user.name);
    _roleTitleController = TextEditingController(
      text: user.designation.isNotEmpty ? user.designation : 'Chief Administrator',
    );
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _schoolNameController = TextEditingController(
      text: user.schoolName.isNotEmpty ? user.schoolName : 'Sparzee Central School',
    );
    _currentAvatar = user.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleTitleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _schoolNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isPickingImage = true);
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 88,
      );
      if (picked != null) {
        setState(() {
          _currentAvatar = picked.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Profile photo updated from device'),
                ],
              ),
              backgroundColor: const Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick photo: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Change Profile Photo', style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                const Text(
                  'Upload from device',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5355BD),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.gallery);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E4F0), width: 1.2),
                          ),
                          child: Column(
                            children: const [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFEDE9FE),
                                child: Icon(Icons.photo_library_rounded, color: AppColors.primaryPurple, size: 22),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Media / Files',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pick from gallery',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.camera);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E4F0), width: 1.2),
                          ),
                          child: Column(
                            children: const [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFFFEDD5),
                                child: Icon(Icons.camera_alt_rounded, color: AppColors.primaryOrange, size: 22),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Take new photo',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Or choose a preset avatar',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5355BD),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _presetAvatars.map((asset) {
                    final isSelected = _currentAvatar == asset;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentAvatar = asset;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryPurple.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(asset),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final roleTitle = _roleTitleController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final schoolName = _schoolNameController.text.trim();

    setState(() => _isSaving = true);

    try {
      // 1. Update AppData.currentUser
      final currentUser = AppData.currentUser ?? AppData.allowedUsers[UserRole.admin]!;
      currentUser.name = name;
      currentUser.designation = roleTitle;
      currentUser.phone = phone;
      currentUser.email = email;
      currentUser.schoolName = schoolName;
      currentUser.avatarUrl = _currentAvatar;
      AppData.currentUser = currentUser;

      // 2. Sync to DatabaseService Admin list
      final admins = DatabaseService.instance.currentAdmins;
      final existingIndex = admins.indexWhere(
        (a) => a.phone == phone || a.email.toLowerCase() == email.toLowerCase() || a.name == name,
      );

      if (existingIndex != -1) {
        final existing = admins[existingIndex];
        existing.name = name;
        existing.email = email;
        existing.phone = phone;
        existing.role = roleTitle;
        existing.branch = schoolName;
        existing.avatarUrl = _currentAvatar;
        DatabaseService.instance.updateAdmin(existing).timeout(
          const Duration(milliseconds: 600),
          onTimeout: () {},
        );
      } else {
        final newAdmin = AdminUser(
          id: 'ADM-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
          phone: phone,
          role: roleTitle,
          permissions: const ['Manage Teachers', 'Manage Students', 'Post Notices'],
          branch: schoolName,
          avatarUrl: _currentAvatar,
          isActive: true,
          manageTeachers: true,
          manageStudents: true,
          manageFees: false,
          postNotices: true,
        );
        DatabaseService.instance.addAdmin(newAdmin).timeout(
          const Duration(milliseconds: 600),
          onTimeout: () {},
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Admin Profile updated successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SpargeeBackButton(),
                    const SizedBox(width: 14),
                    Text(
                      'Edit Admin Profile',
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Photo Stack
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryPurple, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.2),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _isPickingImage
                                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                                  : (_currentAvatar != null && _currentAvatar!.isNotEmpty
                                      ? (_currentAvatar!.startsWith('assets/')
                                          ? Image.asset(
                                              _currentAvatar!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) => _buildDefaultAvatar(),
                                            )
                                          : Image.file(
                                              File(_currentAvatar!),
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) => _buildDefaultAvatar(),
                                            ))
                                      : _buildDefaultAvatar()),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showPhotoOptions,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4F46E5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _showPhotoOptions,
                        child: const Text(
                          'Change Photo',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Full Name
                _buildValidatedField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Name is required';
                    if (val.trim().length < 2) return 'Enter a valid name';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Role / Designation
                _buildValidatedField(
                  label: 'Role / Designation',
                  hint: 'e.g. Chief Administrator',
                  controller: _roleTitleController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Role title is required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Registered Phone
                _buildValidatedField(
                  label: 'Registered Mobile Number',
                  hint: 'Enter 10-digit mobile number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Phone number is required';
                    final cleaned = val.replaceAll(RegExp(r'\D'), '');
                    if (cleaned.length != 10) return 'Enter a valid 10-digit mobile number';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Official Email
                _buildValidatedField(
                  label: 'Official Email',
                  hint: 'e.g. priya.sharma@spargee.edu',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email is required';
                    if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Assigned School / Branch
                _buildValidatedField(
                  label: 'Assigned School / Institution',
                  hint: 'e.g. Sparzee Central School',
                  controller: _schoolNameController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'School name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Save and Cancel buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFFF9559), width: 1.2),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primaryOrange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primaryPurple,
      child: Center(
        child: Text(
          _nameController.text.trim().isNotEmpty ? _nameController.text.trim()[0].toUpperCase() : 'A',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildValidatedField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
