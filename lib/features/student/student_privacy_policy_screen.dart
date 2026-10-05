import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class StudentPrivacyPolicyScreen extends StatelessWidget {
  const StudentPrivacyPolicyScreen({super.key});

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
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy Policy & Terms',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                      ),
                      const Text(
                        'Student & Guardian Privacy Protection',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // FERPA Badge Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F80DA),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7F80DA).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Confidentiality',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Encrypted & COPPA / FERPA Compliant',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'All student academic submissions, fee payment receipts, exam scores, and attendance data are strictly protected and never shared with third parties.',
                      style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Policy Clauses
              _buildSection(
                icon: Icons.lock_outline_rounded,
                title: '1. Student Academic Data Ownership',
                content:
                    'All homework files, assignment responses, and examination scores uploaded by students remain the exclusive intellectual property of the student and school. No data is shared, sold, or used for commercial training.',
              ),
              const SizedBox(height: 14),

              _buildSection(
                icon: Icons.payments_outlined,
                title: '2. Payment Security & Invoicing',
                content:
                    'Online fee payments via UPI, Debit/Credit Card, and Net banking are processed via PCI-DSS Level 1 encrypted payment tunnels. Bank credentials and PINs are never stored on local or school servers.',
              ),
              const SizedBox(height: 14),

              _buildSection(
                icon: Icons.people_outline_rounded,
                title: '3. Guardian & Parent Access Rights',
                content:
                    'Registered parents and guardians hold full transparency access to real-time attendance logs, report cards, fee receipts, and teacher feedback for their enrolled children.',
              ),
              const SizedBox(height: 14),

              _buildSection(
                icon: Icons.gavel_rounded,
                title: '4. Terms of Digital Learning',
                content:
                    'Students are expected to adhere to institutional academic integrity standards when submitting digital assignments, attending virtual sessions, and interacting through the school portal.',
              ),
              const SizedBox(height: 28),

              // Download Policy PDF Button
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Student_Handbook_Privacy_Policy.pdf...')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primaryOrange),
                label: const Text(
                  'Download Student Handbook & Policy (PDF)',
                  style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF7F80DA), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), height: 1.45),
          ),
        ],
      ),
    );
  }
}
