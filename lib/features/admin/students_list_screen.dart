import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';
import 'add_edit_student_screen.dart';
import 'student_profile_screen.dart';

class StudentsListScreen extends StatefulWidget {
  final bool showBackButton;

  const StudentsListScreen({super.key, this.showBackButton = false});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  String _searchQuery = '';
  String _selectedClassFilter = 'All';

  final List<String> _classFilters = ['All', 'Class 5-A', 'Class 6-A', 'Class 6-B', 'Class 7-A'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.showBackButton || Navigator.canPop(context)) ...[
                        const SpargeeBackButton(),
                        const SizedBox(width: 14),
                      ],
                      Text(
                        'Students List',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
                      );
                      if (result == true) setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Add',
                            style: AppTextStyles.buttonSmall.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderGrey, width: 1.2),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search by student name, roll no...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Filter Chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _classFilters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _classFilters[index];
                    final isSelected = _selectedClassFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedClassFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryOrange : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryOrange : AppColors.primaryOrange.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Students List
              Expanded(
                child: StreamBuilder<List<Student>>(
                  stream: DatabaseService.instance.studentsStream,
                  initialData: DatabaseService.instance.students,
                  builder: (context, snapshot) {
                    final allStudents = snapshot.data ?? [];
                    final filteredStudents = allStudents.where((s) {
                      final matchesSearch = s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          s.admissionNo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          s.rollNo.contains(_searchQuery);
                      final matchesClass = _selectedClassFilter == 'All' || s.fullClass == _selectedClassFilter;
                      return matchesSearch && matchesClass;
                    }).toList();

                    if (filteredStudents.isEmpty) {
                      return Center(
                        child: Text(
                          'No students found matching your criteria.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filteredStudents.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return _buildStudentCard(student);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => StudentProfileScreen(student: student)),
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.softLilac, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Student Avatar
            SpargeeAvatar(
              name: student.name,
              avatarAsset: student.avatarUrl,
              size: 50,
              backgroundColor: AppColors.primaryPurple,
              borderColor: AppColors.primaryOrange,
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        student.name,
                        style: AppTextStyles.titleSmall.copyWith(fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: student.feeStatus == 'Paid'
                              ? AppColors.statusPresentBg
                              : AppColors.statusLeaveBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          student.feeStatus,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: student.feeStatus == 'Paid'
                                ? AppColors.statusPresent
                                : AppColors.statusPartial,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${student.fullClass} • Roll No: ${student.rollNo}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Adm: ${student.admissionNo}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryPurple,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primaryOrange,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
