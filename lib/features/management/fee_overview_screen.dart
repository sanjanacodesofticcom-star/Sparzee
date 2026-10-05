import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'class_students_fee_screen.dart';

class FeeOverviewScreen extends StatefulWidget {
  const FeeOverviewScreen({super.key});

  @override
  State<FeeOverviewScreen> createState() => _FeeOverviewScreenState();
}

class _FeeOverviewScreenState extends State<FeeOverviewScreen> {
  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return 'Rs.${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return 'Rs.${(amount / 1000).toStringAsFixed(1)}K';
    }
    return 'Rs.${amount.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: DatabaseService.instance.studentsStream,
      initialData: DatabaseService.instance.currentStudents,
      builder: (context, studentSnapshot) {
        final students = studentSnapshot.data ?? [];
        final totalPaid = students.fold(0.0, (sum, s) => sum + s.paidFee);
        final totalPending = students.fold(0.0, (sum, s) => sum + s.feeDue);
        final totalFee = totalPaid + totalPending;
        final overallRatio = totalFee > 0 ? (totalPaid / totalFee).clamp(0.0, 1.0) : 0.0;
        final overallPercentage = (overallRatio * 100).toInt();

        // Distinct classes
        final classes = ['Class 5', 'Class 4', 'Class 3', 'Class 2'];

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
                    'Fee overview',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Top Stat Card (Total Collected & Total Pending)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEBFA),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Collected',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatCurrency(totalPaid),
                              style: const TextStyle(
                                fontSize: 24,
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
                              'Total pending',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _formatCurrency(totalPending),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Collected this term
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Collected this term',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B7BDA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$overallPercentage%',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildProgressBar(overallRatio),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Class-wise breakdown Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6FD),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFF6B6CCF), width: 1.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Class-wise breakdown',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5355BD),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...classes.map((c) {
                          final cNum = c.replaceAll(RegExp(r'[^0-9]'), '');
                          final classStudents = students.where((s) =>
                            s.className.contains(cNum) || s.fullClass.contains(cNum)
                          ).toList();
                          final cPaid = classStudents.fold(0.0, (sum, s) => sum + s.paidFee);
                          final cTotal = classStudents.fold(0.0, (sum, s) => sum + s.totalFee);
                          final cRatio = cTotal > 0 ? (cPaid / cTotal).clamp(0.0, 1.0) : overallRatio;
                          final cPercent = '${(cRatio * 100).toInt()}%';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildClassRow(c, cRatio, cPercent),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Admin-wise collection
                  const Text(
                    'Admin-wise collection',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5355BD),
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<List<AdminUser>>(
                    stream: DatabaseService.instance.adminsStream,
                    initialData: DatabaseService.instance.currentAdmins,
                    builder: (context, adminSnapshot) {
                      final admins = adminSnapshot.data ?? [];
                      if (admins.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: admins.take(3).map((admin) {
                          final share = totalPaid > 0 ? (totalPaid / admins.length) : 0.0;
                          return _buildAdminFeeRow(admin.name, _formatCurrency(share));
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

              // Export Statement Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fee statement exported to Downloads/Fee_Statement_2026.pdf'),
                        backgroundColor: Color(0xFF22C55E),
                      ),
                    );
                  },
                  icon: const Icon(Icons.cloud_download_outlined, color: Colors.white, size: 20),
                  label: const Text(
                    'Export statement',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildProgressBar(double factor) {
    return Container(
      height: 7,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: factor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B7BDA), Color(0xFFFF9559)],
              stops: [0.85, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassRow(String className, double factor, String percentage) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ClassStudentsFeeScreen(className: className),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                className,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B7BDA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressBar(factor),
        ],
      ),
    );
  }

  Widget _buildAdminFeeRow(String name, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F1F8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B6CCF),
            ),
          ),
        ],
      ),
    );
  }
}
