import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class TeacherPrivacyPolicyScreen extends StatelessWidget {
  const TeacherPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Teacher & Student Data Protection',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero Shield Gradient Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5355BD), Color(0xFF7F80DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5355BD).withValues(alpha: 0.28),
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
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FERPA & GDPR Compliant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Classroom & Student Record Confidentiality',
                                style: TextStyle(
                                  color: Color(0xFFFFD9C2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'All student submissions, attendance records, exam scores, and teacher evaluations are protected with AES-256 encryption. We uphold zero data monetization.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildTrustBadge('🔒 256-Bit Encrypted'),
                        _buildTrustBadge('🚫 No Ads or Selling'),
                        _buildTrustBadge('🏫 School Owned'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              const Text(
                'Classroom Privacy Standards',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7F80DA),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),

              _buildPolicyCard(
                icon: Icons.school_rounded,
                iconColor: const Color(0xFF7F80DA),
                iconBg: const Color(0xFFF0EFFF),
                title: 'Student Work & Assignment Privacy',
                intro: 'Student homework uploads, worksheets, and grades are strictly private:',
                bullets: [
                  'Homework files are accessible exclusively by the assigned teacher, student, and authorized school admins.',
                  'No third-party training on student submissions or uploaded worksheets.',
                  'Automatic virus scan and secure cloud storage for all uploaded PDFs.',
                ],
              ),

              _buildPolicyCard(
                icon: Icons.checklist_rtl_rounded,
                iconColor: const Color(0xFFFFA366),
                iconBg: const Color(0xFFFFEDD5),
                title: 'Attendance & Performance Data',
                intro: 'Academic metrics and attendance records are guarded by strict governance:',
                bullets: [
                  'Tamper-evident logs maintain historical audit integrity for report cards and attendance records.',
                  'Direct synchronization with parent mobile app for transparency.',
                  'Restricted visibility to assigned grade and subject sections.',
                ],
              ),

              _buildPolicyCard(
                icon: Icons.support_agent_rounded,
                iconColor: const Color(0xFF27AE60),
                iconBg: const Color(0xFFDCFCE7),
                title: 'Data Protection Officer (DPO)',
                intro: 'For institutional compliance queries or data rights assistance:',
                bullets: [
                  'Email: privacy-compliance@sparzee.edu',
                  'Support Hours: Monday to Friday, 8:00 AM - 6:00 PM EST',
                  'Immediate data export or student archive purge support.',
                ],
              ),

              const SizedBox(height: 16),
              SpargeePrimaryButton(
                text: 'Download Privacy Agreement (PDF)',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.download_done_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Privacy Agreement downloaded successfully'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF27AE60),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTrustBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String intro,
    required List<String> bullets,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EFFF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F80DA).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            intro,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF374151),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
