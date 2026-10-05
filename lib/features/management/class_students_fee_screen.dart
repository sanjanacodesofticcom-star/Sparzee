import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';
import 'student_fee_profile_screen.dart';

class ClassStudentsFeeScreen extends StatefulWidget {
  final String className;

  const ClassStudentsFeeScreen({super.key, this.className = 'Class 5'});

  @override
  State<ClassStudentsFeeScreen> createState() => _ClassStudentsFeeScreenState();
}

class _ClassStudentsFeeScreenState extends State<ClassStudentsFeeScreen> {
  final _searchController = TextEditingController();
  String _selectedSectionFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: DatabaseService.instance.studentsStream,
      initialData: DatabaseService.instance.currentStudents,
      builder: (context, snapshot) {
        final allStudents = snapshot.data ?? [];
        final query = _searchController.text.trim().toLowerCase();

        // Filter students for this class and section/search
        final classStudents = allStudents.where((s) {
          if (!s.className.toLowerCase().contains(widget.className.toLowerCase()) &&
              !widget.className.toLowerCase().contains(s.className.toLowerCase())) {
            // Also allow if widget.className is "Class 5" and s.className is "5"
            final cNum = widget.className.replaceAll(RegExp(r'[^0-9]'), '');
            final sNum = s.className.replaceAll(RegExp(r'[^0-9]'), '');
            if (cNum.isNotEmpty && sNum.isNotEmpty && cNum != sNum) return false;
          }
          return true;
        }).toList();

        final filteredStudents = classStudents.where((s) {
          if (_selectedSectionFilter != 'All') {
            final sec = _selectedSectionFilter.replaceAll('section-', '').trim().toUpperCase();
            if (s.section.toUpperCase() != sec) return false;
          }
          if (query.isNotEmpty) {
            final matchName = s.name.toLowerCase().contains(query);
            final matchAdm = s.admissionNo.toLowerCase().contains(query);
            if (!matchName && !matchAdm) return false;
          }
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpargeeBackButton(),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.className,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${filteredStudents.length} total',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 14),

                  // Search Bar with icon and orange border
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFFFF9559), size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'Search by student or admission no.',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Filter Section Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterPill('All'),
                        const SizedBox(width: 8),
                        _buildFilterPill('section-A'),
                        const SizedBox(width: 8),
                        _buildFilterPill('section-B'),
                        const SizedBox(width: 8),
                        _buildFilterPill('section-C'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Students List
            Expanded(
              child: filteredStudents.isEmpty
                  ? Center(
                      child: Text(
                        'No students found',
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8)),
                      ),
                    )
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return _buildStudentFeeCard(student);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildFilterPill(String title) {
    final isSelected = _selectedSectionFilter == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedSectionFilter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9559) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9559) : const Color(0xFFFFB688),
            width: 1.2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentFeeCard(Student student) {
    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StudentFeeProfileScreen(student: student),
          ),
        );
        if (updated == true) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B6CCF).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SpargeeAvatar(
              name: student.name,
              avatarAsset: student.avatarUrl,
              size: 48,
              backgroundColor: AppColors.primaryPurple,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      _buildStatusBadge(student.feeStatus),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      children: [
                        TextSpan(text: 'Total ₹${student.totalFee.toInt()} / Paid ₹${student.paidFee.toInt()}/ '),
                        TextSpan(
                          text: 'Pending ₹${student.feeDue.toInt()}',
                          style: TextStyle(
                            color: student.feeDue > 0 ? const Color(0xFFEAB308) : const Color(0xFF22C55E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    if (status.toLowerCase() == 'paid') {
      bg = const Color(0xFF22C55E);
    } else if (status.toLowerCase() == 'partial') {
      bg = const Color(0xFFEAB308);
    } else {
      bg = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
