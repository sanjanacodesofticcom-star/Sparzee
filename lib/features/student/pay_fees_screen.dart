import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class PayFeesScreen extends StatefulWidget {
  final double amount;
  final String term;

  const PayFeesScreen({
    super.key,
    this.amount = 24000,
    this.term = 'Term 2, 2026 - Aarav Mehta',
  });

  @override
  State<PayFeesScreen> createState() => _PayFeesScreenState();
}

class _PayFeesScreenState extends State<PayFeesScreen> {
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;

  void _processPayment() {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
      final student = AppData.students.firstWhere(
        (s) => s.name == user.name || s.parentPhone == user.phone,
        orElse: () => AppData.students.first,
      );

      // Update state
      student.feeStatus = 'Paid';
      student.paidFee = student.totalFee;
      student.feeDue = 0.0;

      AppData.addActivity(
        title: 'Fee payment of ₹${widget.amount.toInt()} completed for ',
        highlightText: student.name,
        trailingText: ' via $_selectedMethod',
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 48),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${widget.amount.toInt()} paid successfully via $_selectedMethod.\nReceipt #LS-RCP-9941 generated.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF4B5563), height: 1.4),
                ),
                const SizedBox(height: 24),
                SpargeePrimaryButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

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
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text(
                    'Pay Fees',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title & Amount Header matching Figma image 2 (middle)
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.term,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '₹24,000',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7F80DA),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Due 10 Oct 2026',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Select Payment Method Header matching Figma image 2 (middle)
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 14),

              // Payment options
              _buildPaymentOption(
                title: 'UPI',
                icon: Icons.qr_code_scanner_rounded,
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                title: 'Debit/Credit card',
                icon: Icons.credit_card_outlined,
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                title: 'Net banking',
                icon: Icons.account_balance_outlined,
              ),

              const Spacer(),

              // Amount Row matching Figma image 2 (middle)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
                  ),
                  Text(
                    'Rs.${widget.amount.toInt()}',
                    style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pay Button matching Figma image 2 (middle)
              SpargeePrimaryButton(
                text: 'Pay Rs.${widget.amount.toInt()}',
                isLoading: _isProcessing,
                onPressed: _processPayment,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == title;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0EFFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF7F80DA) : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF7F80DA),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15.5,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF7F80DA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
