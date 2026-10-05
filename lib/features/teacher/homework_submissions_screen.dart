import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'review_homework_screen.dart';

class HomeworkSubmissionsScreen extends StatefulWidget {
  final HomeworkItem homework;

  const HomeworkSubmissionsScreen({super.key, required this.homework});

  @override
  State<HomeworkSubmissionsScreen> createState() => _HomeworkSubmissionsScreenState();
}

class _HomeworkSubmissionsScreenState extends State<HomeworkSubmissionsScreen> {
  String _selectedFilter = 'Submitted';

  @override
  Widget build(BuildContext context) {
    final students = AppData.students;
    final totalCount = widget.homework.totalStudents;
    final submittedCount = widget.homework.submittedCount > 0 ? widget.homework.submittedCount : 18;
    final pendingCount = totalCount > submittedCount ? totalCount - submittedCount : 14;
    const reviewedCount = 6;

    final displayStudents = _selectedFilter == 'Pending'
        ? students.skip(3).toList()
        : students;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back button, Title, and Right Class tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SpargeeBackButton(),
                      const SizedBox(width: 14),
                      Text(
                        widget.homework.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.homework.assignedClass.toLowerCase().replaceAll(' ', '-'),
                    style: const TextStyle(
                      color: Color(0xFFFFA366),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 3 Metric Cards in Purple Rounded Rectangles (matching Figma)
              Row(
                children: [
                  _buildMetricCard('$submittedCount', 'Submitted'),
                  const SizedBox(width: 10),
                  _buildMetricCard('$pendingCount', 'Pending'),
                  const SizedBox(width: 10),
                  _buildMetricCard('$reviewedCount', 'Reviewed'),
                ],
              ),
              const SizedBox(height: 18),

              // Filter Pills: Submitted (18) vs Pending (14)
              Row(
                children: [
                  _buildFilterPill('Submitted ($submittedCount)', 'Submitted'),
                  const SizedBox(width: 10),
                  _buildFilterPill('Pending ($pendingCount)', 'Pending'),
                ],
              ),
              const SizedBox(height: 16),

              // Submissions Roster List
              Expanded(
                child: displayStudents.isEmpty
                    ? const Center(
                        child: Text(
                          'No submissions in this filter.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: displayStudents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final student = displayStudents[index];
                          // Status distribution to match Figma (Graded, To Review, Decline)
                          String status = 'Graded';
                          Color statusColor = const Color(0xFF27AE60);
                          if (index == 1) {
                            status = 'To Review';
                            statusColor = const Color(0xFFF39C12);
                          } else if (index == 2) {
                            status = 'Decline';
                            statusColor = const Color(0xFFEB5757);
                          }

                          return GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ReviewHomeworkScreen(
                                    student: student,
                                    homework: widget.homework,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFF0EFFF), width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SpargeeAvatar(
                                    name: student.name,
                                    avatarAsset: student.avatarUrl,
                                    size: 44,
                                    backgroundColor: const Color(0xFF7F80DA),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Submitted • 22 Sep, 9:08pm',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.description_outlined,
                                    color: Color(0xFF7F80DA),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      status,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildMetricCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF7F80DA),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7F80DA).withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, String key) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFA366) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFA366) : const Color(0xFFE5E7EB),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
