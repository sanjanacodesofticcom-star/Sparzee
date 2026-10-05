import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final String initialClass;

  const MarkAttendanceScreen({super.key, this.initialClass = 'Class 6-A'});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  late String _selectedClass;
  DateTime _selectedDate = DateTime.now();
  final Map<String, AttendanceStatus> _attendanceMap = {};

  final List<String> _classes = ['Class 6-A', 'Class 6-B', 'Class 7-A', 'Class 5-A'];

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.initialClass;
    if (!_classes.contains(_selectedClass)) {
      _selectedClass = _classes.first;
    }
    for (var s in AppData.students) {
      _attendanceMap[s.id] = AttendanceStatus.present;
    }
  }

  void _markAll(AttendanceStatus status) {
    setState(() {
      for (var s in AppData.students) {
        _attendanceMap[s.id] = status;
      }
    });
  }

  void _saveAttendance() {
    final presentCount = _attendanceMap.values.where((v) => v == AttendanceStatus.present).length;
    final absentCount = _attendanceMap.values.where((v) => v == AttendanceStatus.absent).length;
    final leaveCount = _attendanceMap.values.where((v) => v == AttendanceStatus.leave).length;

    final teacherName = AppData.currentUser?.name ?? 'Sedha';
    AppData.addActivity(
      title: 'Teacher $teacherName marked ',
      highlightText: 'attendance',
      trailingText: ' for $_selectedClass ($presentCount Present, $absentCount Absent)',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Attendance saved for $_selectedClass ($presentCount P, $absentCount A, $leaveCount L)'),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final students = AppData.students;
    final presentCount = _attendanceMap.values.where((v) => v == AttendanceStatus.present).length;
    final absentCount = _attendanceMap.values.where((v) => v == AttendanceStatus.absent).length;
    final leaveCount = _attendanceMap.values.where((v) => v == AttendanceStatus.leave).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
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
                    'Mark Attendance',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Class & Date selector row
              Row(
                children: [
                  // Class Dropdown
                  Expanded(
                    child: Container(
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
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedClass = val);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Date Chip
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2027),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF7F80DA)),
                          const SizedBox(width: 6),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF7F80DA)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Attendance Metrics
              Row(
                children: [
                  _buildMetricPill('Present: $presentCount', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                  const SizedBox(width: 8),
                  _buildMetricPill('Absent: $absentCount', const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
                  const SizedBox(width: 8),
                  _buildMetricPill('Leave: $leaveCount', const Color(0xFFFEF9C3), const Color(0xFFCA8A04)),
                ],
              ),
              const SizedBox(height: 14),

              // Quick Bulk Actions Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Students Roster (${students.length})',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _markAll(AttendanceStatus.present),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'All P',
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _markAll(AttendanceStatus.absent),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'All A',
                            style: TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Roster List
              Expanded(
                child: students.isEmpty
                    ? const Center(
                        child: Text(
                          'No students enrolled in this class.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: students.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final currentStatus = _attendanceMap[student.id] ?? AttendanceStatus.present;

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0EFFF), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFFEDD5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      student.rollNo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFEA580C),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        'Adm: ${student.admissionNo}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // P / A / L Selector
                                _buildStatusToggle(student.id, currentStatus),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 14),
              SpargeePrimaryButton(
                text: 'Save Attendance',
                onPressed: _saveAttendance,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricPill(String text, Color bg, Color textCol) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textCol,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusToggle(String studentId, AttendanceStatus current) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusOption(
          label: 'P',
          isSelected: current == AttendanceStatus.present,
          activeColor: const Color(0xFF27AE60),
          onTap: () => setState(() => _attendanceMap[studentId] = AttendanceStatus.present),
        ),
        const SizedBox(width: 6),
        _buildStatusOption(
          label: 'A',
          isSelected: current == AttendanceStatus.absent,
          activeColor: const Color(0xFFEB5757),
          onTap: () => setState(() => _attendanceMap[studentId] = AttendanceStatus.absent),
        ),
        const SizedBox(width: 6),
        _buildStatusOption(
          label: 'L',
          isSelected: current == AttendanceStatus.leave,
          activeColor: const Color(0xFFF1C40F),
          onTap: () => setState(() => _attendanceMap[studentId] = AttendanceStatus.leave),
        ),
      ],
    );
  }

  Widget _buildStatusOption({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFFF3F4F6),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
