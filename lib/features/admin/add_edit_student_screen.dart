import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _dobController;
  late final TextEditingController _admissionController;
  late final TextEditingController _parentNameController;
  late final TextEditingController _parentPhoneController;

  late String _selectedGrade;
  late String _selectedSection;
  String? _photoPath;
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _grades = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  final List<String> _sections = ['A', 'B', 'C', 'D'];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameController = TextEditingController(text: s?.name ?? '');
    _dobController = TextEditingController(text: s?.dateOfBirth ?? '');
    _admissionController = TextEditingController(text: s?.admissionNo ?? '');
    _parentNameController = TextEditingController(text: s?.parentName ?? '');
    _parentPhoneController = TextEditingController(text: s?.parentPhone ?? '');

    _selectedGrade = s != null && _grades.contains(s.grade) ? s.grade : '5';
    _selectedSection = s != null && _sections.contains(s.section) ? s.section : 'A';
    _photoPath = s?.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _admissionController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
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
              const Text('Select Student Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter student name')));
      return;
    }

    setState(() => _isSaving = true);

    if (widget.student != null) {
      final updated = widget.student!;
      updated.name = name;
      updated.dateOfBirth = _dobController.text.trim();
      updated.admissionNo = _admissionController.text.trim();
      updated.grade = _selectedGrade;
      updated.section = _selectedSection;
      updated.parentName = _parentNameController.text.trim();
      updated.parentPhone = _parentPhoneController.text.trim();
      if (_photoPath != null) updated.avatarUrl = _photoPath;
      await DatabaseService.instance.updateStudent(updated);
    } else {
      final newStudent = Student(
        id: 'S_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        grade: _selectedGrade,
        section: _selectedSection,
        admissionNo: _admissionController.text.trim(),
        rollNo: '${DatabaseService.instance.totalStudentsCount + 1}'.padLeft(2, '0'),
        dateOfBirth: _dobController.text.trim(),
        parentName: _parentNameController.text.trim(),
        parentPhone: _parentPhoneController.text.trim(),
        avatarUrl: _photoPath,
        attendancePercentage: 100.0,
        feeStatus: 'Paid',
        totalFee: 45000.0,
        paidFee: 45000.0,
        feeDue: 0.0,
      );
      await DatabaseService.instance.addStudent(newStudent);
    }

    setState(() => _isSaving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.student != null ? 'Student details updated successfully' : 'Student added successfully'),
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
        title: const Text('Deactivate Student'),
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
              if (widget.student != null) {
                await DatabaseService.instance.deleteStudent(widget.student!.id);
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) Navigator.pop(context, true);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student has been deactivated')),
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

              // Upload Photo / Avatar Circle
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
                        _photoPath != null || widget.student != null ? 'Change photo' : 'Upload photo',
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

              // Section: Add / Edit Student Details
              Text(
                widget.student != null ? 'Edit Student Details' : 'Add Student Details',
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
              _buildFigmaInputField(_nameController, 'Enter student name'),
              const SizedBox(height: 14),

              // Date of birth & Admission no.
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date of birth', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _dobController.text =
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
                                  _dobController.text.isNotEmpty ? _dobController.text : 'Select date of birth',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _dobController.text.isNotEmpty
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Admission no.', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        _buildFigmaInputField(_admissionController, 'Enter admission no.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Class & Section Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Class', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
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
                              value: _selectedGrade,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
                              items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedGrade = val);
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
                        const Text('Section', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
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
                              value: _selectedSection,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
                              items: _sections.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedSection = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section: Parent details
              const Text(
                'Parent details',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5355BD),
                ),
              ),
              const SizedBox(height: 12),

              // Parent name
              const Text('Parent name', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_parentNameController, 'Enter parent name'),
              const SizedBox(height: 14),

              // Parent mobile number
              const Text('Parent mobile number', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              _buildFigmaInputField(_parentPhoneController, 'Enter mobile number', keyboardType: TextInputType.phone),
              const SizedBox(height: 28),

              // Bottom Actions Row: Deactivate & Save / Add Student
              if (widget.student != null)
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
                          'Deactivate student',
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
                            'Add Student',
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
