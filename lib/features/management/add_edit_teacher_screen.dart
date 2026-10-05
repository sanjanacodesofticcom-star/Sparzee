import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';

class AddEditTeacherScreen extends StatefulWidget {
  final Teacher? teacher;

  const AddEditTeacherScreen({super.key, this.teacher});

  @override
  State<AddEditTeacherScreen> createState() => _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _joiningDateController;
  late final TextEditingController _subjectController;

  String _selectedClassSection = '5/A';
  final List<String> _classSections = ['5/A', '5/B', '6/A', '6/B', '7/A', '8/A', '9/B'];
  String? _photoPath;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.teacher;
    _nameController = TextEditingController(text: t?.name ?? '');
    _phoneController = TextEditingController(text: t?.phone ?? '');
    _emailController = TextEditingController(text: t?.email ?? '');
    _joiningDateController = TextEditingController(text: t?.joiningDate ?? '');
    _subjectController = TextEditingController(text: t?.subject ?? '');
    _photoPath = t?.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _joiningDateController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Teacher Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEDE9FE),
                  child: Icon(Icons.photo_library_rounded, color: AppColors.primaryPurple),
                ),
                title: const Text('Choose from Gallery / Files', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() => _photoPath = picked.path);
                  }
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEDD5),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primaryOrange),
                ),
                title: const Text('Take Photo with Camera', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await _imagePicker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() => _photoPath = picked.path);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter teacher name')));
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    if (widget.teacher != null) {
      final updated = widget.teacher!;
      updated.name = name;
      updated.phone = _phoneController.text.trim();
      updated.email = _emailController.text.trim();
      updated.joiningDate = _joiningDateController.text.trim();
      updated.subject = _subjectController.text.trim();
      if (_photoPath != null) updated.avatarUrl = _photoPath;
      await DatabaseService.instance.updateTeacher(updated);
    } else {
      final newTeacher = Teacher(
        id: 'T_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        subject: _subjectController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarUrl: _photoPath,
        roleTitle: 'Senior Teacher',
        assignedClasses: ['Class ${_selectedClassSection.replaceAll('/', '-')}'],
        joiningDate: _joiningDateController.text.trim(),
      );
      await DatabaseService.instance.addTeacher(newTeacher);
    }

    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.teacher != null ? 'Teacher details updated successfully' : 'Teacher added successfully'),
        backgroundColor: const Color(0xFF22C55E),
      ),
    );

    Navigator.of(context).pop(true);
  }

  void _handleDeactivate() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Deactivate Teacher'),
        content: Text('Are you sure you want to deactivate ${_nameController.text}?'),
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
              if (widget.teacher != null) {
                await DatabaseService.instance.deleteTeacher(widget.teacher!.id);
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) Navigator.pop(context, true);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Teacher has been deactivated')),
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

              // Upload Photo Avatar
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7B7BDA),
                          image: _photoPath != null
                              ? (_photoPath!.startsWith('assets/')
                                  ? DecorationImage(image: AssetImage(_photoPath!), fit: BoxFit.cover)
                                  : DecorationImage(image: FileImage(File(_photoPath!)), fit: BoxFit.cover))
                              : null,
                        ),
                        child: _photoPath == null
                            ? const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 32,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Text(
                        _photoPath != null || widget.teacher != null ? 'Change photo' : 'Upload photo',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B6CCF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              Text(
                widget.teacher != null ? 'Edit Teacher Details' : 'Add Teacher Details',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5355BD),
                ),
              ),
              const SizedBox(height: 12),

              // Full Name
              const Text('Full name', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_nameController, 'Enter teacher full name'),
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
              const SizedBox(height: 14),

              // Class/Section & Joining date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Class/Section', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedClassSection,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
                              items: _classSections.map((cs) => DropdownMenuItem(value: cs, child: Text(cs))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedClassSection = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Joining date', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2035),
                            );
                            if (picked != null) {
                              setState(() {
                                _joiningDateController.text =
                                    '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                              });
                            }
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _joiningDateController.text.isNotEmpty ? _joiningDateController.text : 'Select date',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _joiningDateController.text.isNotEmpty
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary.withValues(alpha: 0.6),
                                  ),
                                ),
                                const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B6CCF), size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Subject
              const Text('Subject', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_subjectController, 'Enter subject (e.g. Mathematics)'),
              const SizedBox(height: 16),

              // ID Proof (optional) button
              const Text('ID proof (optional)', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID Proof: National_ID_Document.pdf')),
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
              const SizedBox(height: 28),

              // Bottom Row: Deactivate & Save / Add Teacher
              if (widget.teacher != null)
                Row(
                  children: [
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
                          'Deactivate teacher',
                          style: TextStyle(
                            color: Color(0xFFFF6B6B),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
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
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
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
                            'Add Teacher',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
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
}
