import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class EditTeacherProfileScreen extends StatefulWidget {
  final AppUser user;

  const EditTeacherProfileScreen({super.key, required this.user});

  @override
  State<EditTeacherProfileScreen> createState() => _EditTeacherProfileScreenState();
}

class _EditTeacherProfileScreenState extends State<EditTeacherProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _designationController;
  late final TextEditingController _schoolController;
  String? _selectedAvatarAsset;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
    _designationController = TextEditingController(text: widget.user.designation);
    _schoolController = TextEditingController(text: widget.user.schoolName);
    _selectedAvatarAsset = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.of(context).pop();
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedAvatarAsset = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Profile Photo',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF7F80DA)),
                title: const Text('Upload from Device'),
                onTap: _pickImageFromGallery,
              ),
              ListTile(
                leading: const Icon(Icons.face_rounded, color: Color(0xFFFFA366)),
                title: const Text('Use Default Teacher Avatar'),
                onTap: () {
                  setState(() {
                    _selectedAvatarAsset = 'assets/images/teacher_avatar.png';
                  });
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name')),
      );
      return;
    }

    widget.user.name = newName;
    widget.user.phone = _phoneController.text.trim();
    widget.user.email = _emailController.text.trim();
    widget.user.designation = _designationController.text.trim();
    widget.user.schoolName = _schoolController.text.trim();
    widget.user.avatarUrl = _selectedAvatarAsset;

    final teacherIndex = AppData.teachers.indexWhere((t) => t.phone == widget.user.phone || t.email == widget.user.email);
    if (teacherIndex != -1) {
      AppData.teachers[teacherIndex].name = newName;
      AppData.teachers[teacherIndex].avatarUrl = _selectedAvatarAsset;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Teacher profile updated successfully'),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text(
                    'Edit Profile',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Center(
                child: SpargeeAvatar(
                  name: _nameController.text.isEmpty ? 'Teacher' : _nameController.text,
                  avatarAsset: _selectedAvatarAsset,
                  size: 100,
                  backgroundColor: const Color(0xFFFFA366),
                  showEditBadge: true,
                  badgeIcon: Icons.camera_alt_rounded,
                  onEditTap: _showPhotoOptions,
                  onTap: _showPhotoOptions,
                ),
              ),
              const SizedBox(height: 24),

              SpargeeTextField(
                label: 'Full Name',
                hintText: 'Enter full name',
                controller: _nameController,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Official Email',
                hintText: 'Enter email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Registered Phone Number',
                hintText: 'Enter 10-digit mobile number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Designation & Subject',
                hintText: 'e.g. Senior Teacher • Mathematics',
                controller: _designationController,
              ),
              const SizedBox(height: 16),

              SpargeeTextField(
                label: 'Assigned School',
                hintText: 'School name',
                controller: _schoolController,
              ),
              const SizedBox(height: 28),

              SpargeePrimaryButton(
                text: 'Save Changes',
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
