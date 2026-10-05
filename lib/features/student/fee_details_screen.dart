import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'pay_fees_screen.dart';

class FeeDetailsScreen extends StatefulWidget {
  final bool showBackButton;

  const FeeDetailsScreen({super.key, this.showBackButton = true});

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
    final studentRecord = AppData.students.firstWhere(
      (s) => s.name == user.name || s.parentPhone == user.phone,
      orElse: () => AppData.students.first,
    );

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
                    'Fee Details',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Student Avatar & Name matching Figma image 2 (left)
              Center(
                child: Column(
                  children: [
                    SpargeeAvatar(
                      name: studentRecord.name,
                      avatarAsset: studentRecord.avatarUrl,
                      size: 94,
                      backgroundColor: AppColors.primaryPurple,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      studentRecord.name,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${studentRecord.fullClass} • Adm.${studentRecord.admissionNo}',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.75)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Attendance & Fee Status Card (Lilac container) matching Figma image 2 (left)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(22),
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
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${studentRecord.attendancePercentage.toInt()}%',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
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
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: studentRecord.feeStatus == 'Paid' ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            studentRecord.feeStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Due Alert Banner (Peach container) matching Figma image 2 (left)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5D9),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentRecord.feeStatus == 'Paid' ? 'Current Status' : 'Next Payment due',
                          style: const TextStyle(
                            color: Color(0xFF4B5563),
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          studentRecord.feeStatus == 'Paid' ? 'All dues cleared' : '10 Oct 2026',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    if (studentRecord.feeStatus != 'Paid')
                      ElevatedButton(
                        onPressed: () async {
                          final paid = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => PayFeesScreen(
                                amount: studentRecord.feeDue > 0 ? studentRecord.feeDue : 24000,
                                term: 'Term 2, 2026 - ${studentRecord.name}',
                              ),
                            ),
                          );
                          if (paid == true) setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F80DA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Pay Fee',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF22C55E),
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 20),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fee history header matching Figma image 2 (left)
              const Text(
                'Fee history',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 14),

              // History Rows matching Figma image 2 (left)
              _buildHistoryRow('Term 1, 2026', 'Paid', const Color(0xFF22C55E)),
              const SizedBox(height: 10),
              _buildHistoryRow('Term 2, 2026', 'Paid', const Color(0xFF22C55E)),
              const SizedBox(height: 10),
              _buildHistoryRow(
                'Term 3, 2026',
                studentRecord.feeStatus == 'Paid' ? 'Paid' : 'Partial',
                studentRecord.feeStatus == 'Paid' ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryRow(String term, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            term,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
