import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

import '../../core/services/database_service.dart';

class StudentFeeProfileScreen extends StatefulWidget {
  final Student student;

  const StudentFeeProfileScreen({super.key, required this.student});

  @override
  State<StudentFeeProfileScreen> createState() => _StudentFeeProfileScreenState();
}

class _StudentFeeProfileScreenState extends State<StudentFeeProfileScreen> {
  late Student _currentStudent;

  @override
  void initState() {
    super.initState();
    _currentStudent = widget.student;
  }

  void _showRecordPaymentSheet() {
    final amountController = TextEditingController(text: '${_currentStudent.feeDue.toInt()}');
    String paymentMode = 'UPI / Online';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Record Fee Payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Student: ${_currentStudent.name} (${_currentStudent.fullClass})',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  const Text('Payment Amount (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
                    ),
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mode
                  const Text('Payment Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFB688), width: 1.2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: paymentMode,
                        isExpanded: true,
                        items: ['UPI / Online', 'Cash', 'Bank Transfer', 'Cheque']
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setSheetState(() => paymentMode = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Payment
                  SpargeePrimaryButton(
                    text: 'Confirm & Generate Receipt',
                    onPressed: () async {
                      final enteredAmount = double.tryParse(amountController.text.trim()) ?? 0.0;
                      final messenger = ScaffoldMessenger.of(context);
                      if (enteredAmount <= 0) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Please enter a valid amount')),
                        );
                        return;
                      }

                      await DatabaseService.instance.recordFeePayment(
                        studentId: _currentStudent.id,
                        amount: enteredAmount,
                        paymentMode: paymentMode,
                      );

                      if (mounted) {
                        setState(() {
                          final found = DatabaseService.instance.currentStudents.firstWhere(
                            (s) => s.id == _currentStudent.id,
                            orElse: () => _currentStudent,
                          );
                          _currentStudent = found;
                        });
                      }

                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                      }

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Payment of ₹${enteredAmount.toInt()} successfully recorded!'),
                          backgroundColor: const Color(0xFF22C55E),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                'Students Profile',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Student Avatar with Fee Status Badge
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SpargeeAvatar(
                          name: _currentStudent.name,
                          avatarAsset: _currentStudent.avatarUrl,
                          size: 88,
                          backgroundColor: AppColors.primaryPurple,
                        ),
                        Positioned(
                          bottom: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_currentStudent.feeStatus),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              _currentStudent.feeStatus,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _currentStudent.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_currentStudent.fullClass} • Adm.${_currentStudent.admissionNo}',
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

              // Parent Contact Card matching Figma
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEBFA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_currentStudent.parentName} (parent)',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _currentStudent.parentPhone,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildContactCircleButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          iconColor: const Color(0xFF22C55E),
                          bgColor: Colors.white,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opening WhatsApp chat with ${_currentStudent.parentPhone}')),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildContactCircleButton(
                          icon: Icons.call_outlined,
                          iconColor: const Color(0xFF6B6CCF),
                          bgColor: Colors.white,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling parent ${_currentStudent.parentPhone}')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 3-Column Stats Grid (Total, Paid, Pending)
              Row(
                children: [
                  Expanded(
                    child: _buildFeeMetricBox(
                      label: 'Total',
                      amount: 'Rs.${_currentStudent.totalFee.toInt()}',
                      bgColor: const Color(0xFFECEBFA),
                      textColor: const Color(0xFF1E1E2D),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFeeMetricBox(
                      label: 'Paid',
                      amount: 'Rs.${_currentStudent.paidFee.toInt()}',
                      bgColor: const Color(0xFFDCFCE7),
                      textColor: const Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFeeMetricBox(
                      label: 'Pending',
                      amount: 'Rs.${_currentStudent.feeDue.toInt()}',
                      bgColor: const Color(0xFFFEF9C3),
                      textColor: const Color(0xFFCA8A04),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fee History List Card
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
                    const Text(
                      'Fee history',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5355BD),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._currentStudent.feeHistory.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.term,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                            ),
                            Text(
                              item.date,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            _buildStatusPill(item.status),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Receipts Box matching Figma
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6FD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E9F6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receipts',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5355BD),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._currentStudent.receipts.map(
                      (rc) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rc,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloading $rc.pdf...')),
                              );
                            },
                            icon: Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF7B7BDA),
                              ),
                              child: const Icon(Icons.cloud_download_outlined, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Record Payment Button
              SpargeePrimaryButton(
                text: 'Record Payment',
                onPressed: _showRecordPaymentSheet,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCircleButton({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildFeeMetricBox({
    required String label,
    required String amount,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.toLowerCase() == 'paid') return const Color(0xFF22C55E);
    if (status.toLowerCase() == 'partial') return const Color(0xFFEAB308);
    return const Color(0xFFEF4444);
  }

  Widget _buildStatusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
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
