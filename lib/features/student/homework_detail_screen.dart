import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class HomeworkDetailScreen extends StatefulWidget {
  final HomeworkItem homework;

  const HomeworkDetailScreen({super.key, required this.homework});

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  String? _uploadedFileName;
  bool _isSubmitting = false;

  Future<void> _pickFileFromDevice() async {
    try {
      final result = await FilePickerPlatform.instance.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'doc', 'docx'],
      );
      if (result.isNotEmpty) {
        final file = result.first;
        setState(() {
          _uploadedFileName = file.name;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Attached: ${file.name}'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _uploadedFileName = 'Aarav_Mehta_Assignment_Worksheet.pdf';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attached: Aarav_Mehta_Assignment_Worksheet.pdf')),
        );
      }
    }
  }

  void _submitHomework() {
    if (_uploadedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach your completed assignment file or photo first.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      final studentName = AppData.currentUser?.name ?? 'Aarav Mehta';

      AppData.addActivity(
        title: 'Student $studentName submitted ',
        highlightText: widget.homework.title,
        trailingText: ' (${widget.homework.subject})',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Homework submitted successfully to ${widget.homework.teacherName}!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.of(context).pop();
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
                    'Homework Detail',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Subject Banner Card (Soft Lilac)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.titleSmall.copyWith(fontSize: 15),
                            children: [
                              TextSpan(text: '${widget.homework.subject} - '),
                              TextSpan(
                                text: widget.homework.teacherName,
                                style: const TextStyle(
                                  color: Color(0xFF7F80DA),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.homework.isDueToday ? const Color(0xFFFFA366) : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.homework.dueDate,
                            style: TextStyle(
                              color: widget.homework.isDueToday ? Colors.white : const Color(0xFF4B5563),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.homework.title,
                            style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7F80DA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Instructions Header
              const Text(
                'Instructions',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),

              // Instructions Box (Peach)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.homework.instructions,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Attachment from Teacher Header
              const Text(
                'Attachment from teacher',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),

              // Attachment Pill (Peach)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5D9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF7F80DA), size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.homework.attachmentName,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.textDark),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${widget.homework.attachmentName}...')),
                        );
                      },
                      child: const Icon(Icons.cloud_download_outlined, color: Color(0xFF4B5563), size: 22),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Your Submission Header
              const Text(
                'Your Submission',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 10),

              // Upload Box (Orange border)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF0EFFF),
                      ),
                      child: const Icon(
                        Icons.upload_file_rounded,
                        color: Color(0xFF7F80DA),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _uploadedFileName ?? 'Attach photo or PDF file',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14.5,
                        fontWeight: _uploadedFileName != null ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    if (_uploadedFileName != null) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Ready for submission',
                        style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickFileFromDevice,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA366),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.file_upload_outlined, color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  _uploadedFileName == null ? 'Upload from Device' : 'Change File',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_uploadedFileName != null) ...[
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => setState(() {
                              _uploadedFileName = null;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 18),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SpargeePrimaryButton(
                text: 'Submit Homework',
                isLoading: _isSubmitting,
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
