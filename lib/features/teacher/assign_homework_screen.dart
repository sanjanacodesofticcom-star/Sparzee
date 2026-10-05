import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class AssignHomeworkScreen extends StatefulWidget {
  final String? preselectedClass;

  const AssignHomeworkScreen({super.key, this.preselectedClass});

  @override
  State<AssignHomeworkScreen> createState() => _AssignHomeworkScreenState();
}

class _AssignHomeworkScreenState extends State<AssignHomeworkScreen> {
  late String _selectedClass;
  String _selectedSubject = 'Mathematics';
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _dueDate = 'Due 22 sep';
  String? _attachedFileName = 'Fraction_Practice_Ch4.pdf';
  bool _isUploading = false;

  final List<String> _classes = ['Class 6-A', 'Class 6-B', 'Class 7-A', 'Class 5-A'];
  final List<String> _subjects = ['Mathematics', 'Science', 'English', 'Social Studies', 'Computer'];

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.preselectedClass ?? 'Class 6-A';
    if (!_classes.contains(_selectedClass)) {
      _selectedClass = _classes.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickPdfFile() async {
    setState(() => _isUploading = true);
    try {
      final result = await FilePickerPlatform.instance.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result.isNotEmpty) {
        final file = result.first;
        setState(() {
          _attachedFileName = file.name;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Attached: ${file.name}')),
                ],
              ),
              backgroundColor: const Color(0xFF27AE60),
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
            content: Text('File picker notice: $e'),
            backgroundColor: const Color(0xFFFFA366),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _submitHomework() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter homework chapter or title'),
          backgroundColor: Color(0xFFEB5757),
        ),
      );
      return;
    }

    final teacherName = AppData.currentUser?.name ?? 'Sedha';
    final totalStudentsInClass = _selectedClass == 'Class 6-A'
        ? 32
        : _selectedClass == 'Class 7-A'
            ? 30
            : 28;

    final newHomework = HomeworkItem(
      id: 'HW_${DateTime.now().millisecondsSinceEpoch}',
      subject: _selectedSubject,
      teacherName: teacherName,
      title: title,
      instructions: _instructionsController.text.trim().isEmpty
          ? 'Complete the assignment worksheet questions carefully.'
          : _instructionsController.text.trim(),
      attachmentName: _attachedFileName ?? 'Homework_Sheet.pdf',
      dueDate: _dueDate,
      assignedClass: _selectedClass,
      totalStudents: totalStudentsInClass,
      submittedCount: 0,
      isDueToday: _dueDate.toLowerCase().contains('today') || _dueDate.toLowerCase().contains('22'),
    );

    AppData.homeworks.insert(0, newHomework);

    AppData.addActivity(
      title: 'Teacher $teacherName assigned ',
      highlightText: title,
      trailingText: ' to $_selectedClass',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Homework assigned to $_selectedClass!'),
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
              // Top Bar
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text(
                    'Assign Homework',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Class & Subject Selectors
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Target Class',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _classes.contains(_selectedClass) ? _selectedClass : _classes.first,
                              items: _classes
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(
                                          c,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedClass = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Subject',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedSubject,
                              items: _subjects
                                  .map((s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(
                                          s,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedSubject = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Homework Title / Chapter',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Fraction Practice',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Due Date Pills
              const Text(
                'Due Date',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Due 22 sep', 'Due 21 sep', 'Due Tomorrow'].map((d) {
                  final isSelected = _dueDate == d;
                  return ChoiceChip(
                    label: Text(d),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _dueDate = d);
                    },
                    selectedColor: const Color(0xFFFFA366),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFFFA366) : const Color(0xFFE5E7EB),
                      width: 1.2,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Instructions
              const Text(
                'Detailed Instructions',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                ),
                child: TextField(
                  controller: _instructionsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Complete exercises 4.1 to 4.3 with step-by-step working.',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Attach Homework (With Device File Picker Upload Option)
              const Text(
                'Attach Homework (PDF)',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _attachedFileName != null ? const Color(0xFFFFA366) : const Color(0xFFE5E7EB),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EFFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Color(0xFF7F80DA),
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _attachedFileName ?? 'No PDF attached yet',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'PDF Document • Ready to attach',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Upload Button
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _isUploading ? null : _pickPdfFile,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0EFFF),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFF7F80DA), width: 1.2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isUploading)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF7F80DA),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.upload_file_rounded,
                                      color: Color(0xFF7F80DA),
                                      size: 18,
                                    ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Upload from Device',
                                    style: TextStyle(
                                      color: Color(0xFF7F80DA),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_attachedFileName != null) ...[
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _attachedFileName = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFFEB5757),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SpargeePrimaryButton(
                text: 'Assign Homework',
                onPressed: _submitHomework,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
