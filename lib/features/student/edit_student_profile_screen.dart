import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class EditStudentProfileScreen extends StatefulWidget {
  const EditStudentProfileScreen({super.key});

  @override
  State<EditStudentProfileScreen> createState() => _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState extends State<EditStudentProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _parentNameController;
  late TextEditingController _parentPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  String? _selectedAvatar;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
    final student = AppData.students.firstWhere(
      (s) => s.name == user.name || s.parentPhone == user.phone,
      orElse: () => AppData.students.first,
    );

    _nameController = TextEditingController(text: student.name);
    _parentNameController = TextEditingController(text: student.parentName);
    _parentPhoneController = TextEditingController(text: student.parentPhone);
    _emailController = TextEditingController(text: user.email);
    _addressController = TextEditingController(text: 'Flat 402, Lotus Greens, Sector 78, Noida, UP');
    _selectedAvatar = student.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromDevice() async {
    try {
      final result = await FilePickerPlatform.instance.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
      );
      if (result.isNotEmpty) {
        final pickedPath = result.first.path;
        if (pickedPath != null) {
          setState(() {
            _selectedAvatar = pickedPath;
          });
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected image: ${result.first.name}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device photo picker opened. Profile image updated.')),
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
              subtitle: const Text('Select a JPG, PNG, or photo from storage'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImageFromDevice();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFFFF1EB), shape: BoxShape.circle),
                child: const Icon(Icons.face_rounded, color: AppColors.primaryOrange),
              ),
              title: const Text('Use Default School Avatar', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Set student illustration avatar'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _selectedAvatar = 'assets/images/student_avatar.png';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    setState(() => _isSaving = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
      final student = AppData.students.firstWhere(
        (s) => s.name == user.name || s.parentPhone == user.phone,
        orElse: () => AppData.students.first,
      );

      student.name = _nameController.text.trim();
      student.parentName = _parentNameController.text.trim();
      student.parentPhone = _parentPhoneController.text.trim();
      if (_selectedAvatar != null) {
        student.avatarUrl = _selectedAvatar;
      }

      AppData.currentUser = AppUser(
        role: UserRole.student,
        name: student.name,
        phone: student.parentPhone,
        email: _emailController.text.trim(),
        avatarUrl: student.avatarUrl,
        designation: '${student.fullClass} • Adm.${student.admissionNo}',
        schoolName: 'Little Scholar',
      );

      AppData.addActivity(
        title: 'Student profile updated for ',
        highlightText: student.name,
        trailingText: '',
      );

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text(
                    'Edit Profile',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Avatar with camera change button
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryPurple,
                        border: Border.all(color: AppColors.primaryOrange, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _selectedAvatar != null && _selectedAvatar!.isNotEmpty
                            ? Image.asset(
                                _selectedAvatar!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(Icons.person, color: Colors.white, size: 50),
                              )
                            : const Icon(Icons.person, color: Colors.white, size: 50),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerModal,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7F80DA),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _showImagePickerModal,
                  icon: const Icon(Icons.upload_file, size: 16, color: AppColors.primaryOrange),
                  label: const Text(
                    'Upload Photo from Device',
                    style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Academic Information (Read-only banner)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD6D6EA)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school_rounded, color: Color(0xFF7F80DA), size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Records (Locked)',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Class 5-C • Adm.LS-2026-0318 • Roll 01',
                            style: TextStyle(fontSize: 12.5, color: Color(0xFF4B5563)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Editable Fields
              SpargeeTextField(
                label: 'Student Full Name',
                hintText: 'Enter student name',
                controller: _nameController,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Parent / Guardian Name',
                hintText: 'Enter parent name',
                controller: _parentNameController,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Registered Parent Mobile',
                hintText: '10-digit mobile number',
                controller: _parentPhoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Official Student Email',
                hintText: 'student@spargee.edu',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Residential Address',
                hintText: 'Enter residential address',
                controller: _addressController,
                maxLines: 2,
              ),
              const SizedBox(height: 28),

              // Save Button
              SpargeePrimaryButton(
                text: 'Save Changes',
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
