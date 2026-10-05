import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';

class StudentTransferScreen extends StatefulWidget {
  final Student student;

  const StudentTransferScreen({super.key, required this.student});

  @override
  State<StudentTransferScreen> createState() => _StudentTransferScreenState();
}

class _StudentTransferScreenState extends State<StudentTransferScreen> {
  late String _selectedGrade;
  late String _selectedSection;
  final _effectiveDateController = TextEditingController(text: '01/11/2026');
  String _selectedReason = 'Academic Reallocation';

  final List<String> _grades = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  final List<String> _sections = ['A', 'B', 'C', 'D'];
  final List<String> _reasons = [
    'Academic Reallocation',
    'Parent Request',
    'Stream Change',
    'Special Needs Support',
    'Class Balancing',
  ];

  bool _isTransferring = false;

  @override
  void initState() {
    super.initState();
    _selectedGrade = widget.student.grade;
    _selectedSection = widget.student.section == 'A' ? 'B' : 'A';
  }

  @override
  void dispose() {
    _effectiveDateController.dispose();
    super.dispose();
  }

  void _handleTransfer() async {
    setState(() => _isTransferring = true);

    await DatabaseService.instance.transferStudentClass(
      studentId: widget.student.id,
      newGrade: _selectedGrade,
      newSection: _selectedSection,
      effectiveDate: _effectiveDateController.text.trim(),
      reason: _selectedReason,
    );

    setState(() => _isTransferring = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.student.name} successfully transferred to Class $_selectedGrade-$_selectedSection!'),
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
              Text(
                'Transfer Class',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Student Avatar & Info
              Center(
                child: Column(
                  children: [
                    SpargeeAvatar(
                      name: widget.student.name,
                      avatarAsset: widget.student.avatarUrl,
                      size: 88,
                      backgroundColor: AppColors.primaryPurple,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.student.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.student.fullClass} • Adm.${widget.student.admissionNo}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E9FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.student.attendancePercentage.toInt()}%',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1E2D),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Fee status',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.student.feeStatus == 'Paid'
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEAB308),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.student.feeStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Transfer to Section
              const Text(
                'Transfer to',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5355BD),
                ),
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
              const SizedBox(height: 16),

              // Effective Date & Reason Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Effective date', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() {
                                _effectiveDateController.text =
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
                                  _effectiveDateController.text,
                                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                ),
                                const Icon(Icons.calendar_today_outlined, color: AppColors.primaryPurple, size: 18),
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
                        const Text('Reason', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedReason,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
                              items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedReason = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Info Note Box matching Figma
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5D6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6B6CCF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'i',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Attendance and homework history from the current class will be preserved. The parent will be notified of this change.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B4530),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Action Button
              SpargeePrimaryButton(
                text: 'Confirm transfer',
                isLoading: _isTransferring,
                onPressed: _handleTransfer,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
