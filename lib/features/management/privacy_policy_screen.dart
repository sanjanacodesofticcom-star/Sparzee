import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text('Privacy Policy & Terms', style: AppTextStyles.titleMedium.copyWith(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),

              _buildPolicyCard(
                title: '1. Student Data Protection & Encryption',
                content:
                    'All student records, attendance logs, homework submissions, and academic evaluations are encrypted in transit and at rest with AES-256 bit military-grade standards. Sparzee strictly complies with national education regulatory frameworks.',
              ),
              const SizedBox(height: 14),

              _buildPolicyCard(
                title: '2. Role-Based Access Governance',
                content:
                    'Administrative and financial data is strictly siloed. Only authorized management personnel and certified administrators can modify institution policies, fee structures, and staff assignments.',
              ),
              const SizedBox(height: 14),

              _buildPolicyCard(
                title: '3. Financial & Fee Privacy',
                content:
                    'Payment gateways are PCI-DSS Level 1 compliant. Sparzee does not store raw credit card or bank account PINs on local devices. All transactions are securely routed through RBI-authorized banking partners.',
              ),
              const SizedBox(height: 14),

              _buildPolicyCard(
                title: '4. Institutional Governance & Terms',
                content:
                    'By using the Sparzee School Management Suite, the institution agrees to maintain accurate student records, respect confidentiality of staff credentials, and follow academic guidelines issued by the affiliated education board.',
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'Version 2.4.0 • Updated October 2026',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 13, color: Color(0xFF5A443B), height: 1.45),
          ),
        ],
      ),
    );
  }
}
