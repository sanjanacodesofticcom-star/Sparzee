import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final bool showBackButton;

  const AttendanceDetailScreen({super.key, this.showBackButton = true});

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  int _selectedDay = 15;

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
                  if (widget.showBackButton || Navigator.canPop(context)) ...[
                    const SpargeeBackButton(),
                    const SizedBox(width: 14),
                  ],
                  Text(
                    'Attendance Detail',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Overview Banner (Lilac container)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.softLilac,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'September Attendance',
                          style: AppTextStyles.titleSmall.copyWith(fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '76%',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 76,
                            child: Container(
                              height: 8,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          Expanded(
                            flex: 24,
                            child: Container(
                              height: 8,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Attendance Calendar Card (Warm Cream)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attendance',
                          style: AppTextStyles.titleSmall.copyWith(fontSize: 18),
                        ),
                        const Icon(Icons.cancel_outlined, color: AppColors.textPrimary, size: 22),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Month Navigator Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.softPeach,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                        ),
                        Text(
                          'September 2026',
                          style: AppTextStyles.titleSmall.copyWith(fontSize: 17),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.softPeach,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.arrow_forward, color: AppColors.textPrimary, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Weekdays Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
                        return SizedBox(
                          width: 38,
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Days Grid
                    _buildDaysGrid(),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Present', AppColors.statusPresentBg, AppColors.statusPresent),
                  const SizedBox(width: 16),
                  _buildLegendItem('Absent', AppColors.statusAbsentBg, AppColors.statusAbsent),
                  const SizedBox(width: 16),
                  _buildLegendItem('Leave', AppColors.statusLeaveBg, AppColors.statusLeave),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysGrid() {
    // Days in September starting from Tuesday (index 2)
    // Previous month filler: 29, 30, 31
    final List<Map<String, dynamic>> gridCells = [
      {'day': 29, 'prev': true, 'status': 'present'},
      {'day': 30, 'prev': true, 'status': 'leave'},
      {'day': 31, 'prev': true, 'status': 'present'},
      {'day': 1, 'status': 'present'},
      {'day': 2, 'status': 'present'},
      {'day': 3, 'status': 'present'},
      {'day': 4, 'status': 'present'},
      {'day': 5, 'status': 'present'},
      {'day': 6, 'status': 'present'},
      {'day': 7, 'status': 'present'},
      {'day': 8, 'status': 'present'},
      {'day': 9, 'status': 'leave'},
      {'day': 10, 'status': 'present'},
      {'day': 11, 'status': 'present'},
      {'day': 12, 'status': 'present'},
      {'day': 13, 'status': 'absent'},
      {'day': 14, 'status': 'present'},
      {'day': 15, 'status': 'today'},
      {'day': 16, 'status': 'future'},
      {'day': 17, 'status': 'future'},
      {'day': 18, 'status': 'future'},
      {'day': 19, 'status': 'future'},
      {'day': 20, 'status': 'future'},
      {'day': 21, 'status': 'future'},
      {'day': 22, 'status': 'future'},
      {'day': 23, 'status': 'future'},
      {'day': 24, 'status': 'future'},
      {'day': 25, 'status': 'future'},
      {'day': 26, 'status': 'future'},
      {'day': 27, 'status': 'future'},
      {'day': 28, 'status': 'future'},
      {'day': 29, 'status': 'future'},
      {'day': 30, 'status': 'future'},
      {'day': 31, 'status': 'future'},
      {'day': 1, 'next': true, 'status': 'future'},
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 10,
      children: gridCells.map((cell) {
        final day = cell['day'] as int;
        final status = cell['status'] as String;
        final isToday = status == 'today' || (day == _selectedDay && cell['prev'] != true && cell['next'] != true);
        final isAbsent = status == 'absent';
        final isLeave = status == 'leave';
        final isPresent = status == 'present';

        Color bgColor = Colors.transparent;
        Color textColor = AppColors.textPrimary;

        if (isToday) {
          bgColor = AppColors.primaryOrange;
          textColor = Colors.white;
        } else if (isAbsent) {
          bgColor = AppColors.statusAbsentBg;
          textColor = const Color(0xFF903030);
        } else if (isLeave) {
          bgColor = AppColors.statusLeaveBg;
          textColor = const Color(0xFF7A6010);
        } else if (isPresent) {
          bgColor = AppColors.statusPresentBg;
          textColor = const Color(0xFF336033);
        } else {
          textColor = AppColors.textSecondary.withValues(alpha: 0.6);
        }

        return GestureDetector(
          onTap: () {
            if (cell['prev'] != true && cell['next'] != true) {
              setState(() => _selectedDay = day);
            }
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontWeight: (isToday || isAbsent || isLeave || isPresent) ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color dotBg, Color dotColor) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: dotBg,
            shape: BoxShape.circle,
            border: Border.all(color: dotColor.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }
}
