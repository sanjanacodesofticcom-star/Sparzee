import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class AdminPrivacyTermsScreen extends StatelessWidget {
  const AdminPrivacyTermsScreen({super.key});

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
              // Top Bar with Back Button & Title
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
                          'School & Student Data Protection',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Institutional Grade Data Protection',
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
                      'All student records, parent contacts, teacher profiles, and fee transactions are protected with banking-grade AES-256 encryption. We enforce zero data monetization.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildTrustBadge('🔒 AES-256 Encrypted'),
                        _buildTrustBadge('🚫 Zero Ads or Selling'),
                        _buildTrustBadge('🏫 100% School Owned'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Heading
              const Text(
                'Policy Provisions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5355BD),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),

              // Section 1: Information We Collect
              _buildPolicyCard(
                number: '1',
                icon: Icons.folder_shared_rounded,
                iconColor: const Color(0xFF6B6CCF),
                iconBg: const Color(0xFFEDE9FE),
                title: 'Information We Collect',
                intro:
                    'Sparzee collects administrative and academic data strictly required to run school operations:',
                bullets: [
                  'Student & Parent Information: Full names, enrolled grades, emergency contact numbers, and verified home addresses.',
                  'Staff & Faculty Records: Teacher directory, subject assignments, qualification records, and attendance logs.',
                  'Financial & Fee Data: Tuition fee invoices, transaction IDs, payment methods, and scholarship allocations.',
                ],
              ),

              // Section 2: How Data is Used & Protected
              _buildPolicyCard(
                number: '2',
                icon: Icons.lock_rounded,
                iconColor: AppColors.primaryOrangeDark,
                iconBg: const Color(0xFFFFEDD5),
                title: 'How Data is Used & Protected',
                intro:
                    'Administrative and student records are stored in dedicated, highly secured cloud infrastructure:',
                bullets: [
                  'Military-Grade Encryption: All data at rest is encrypted with AES-256; network transmission is secured via TLS 1.3.',
                  'Zero Data Monetization: We never sell, lease, or monetize school or student data with any third-party advertisers.',
                  'Granular Access Control: Teachers access only their assigned classes; Admins access their assigned institution branch.',
                ],
              ),

              // Section 3: Admin Responsibilities & Access Control
              _buildPolicyCard(
                number: '3',
                icon: Icons.admin_panel_settings_rounded,
                iconColor: const Color(0xFF27AE60),
                iconBg: const Color(0xFFDCFCE7),
                title: 'Admin Responsibilities & Access Control',
                intro:
                    'As an authorized school administrator, you uphold institutional confidentiality:',
                bullets: [
                  'Credential Safeguarding: Admins must maintain strong unique passwords and activate two-factor authentication.',
                  'Tamper-Evident Audit Trails: All grade updates, attendance modifications, and fee approvals are logged with timestamps.',
                  'Legitimate Educational Use: Access to student records is permitted exclusively for educational and administrative governance.',
                ],
              ),

              // Section 4: Data Retention & School Offboarding
              _buildPolicyCard(
                number: '4',
                icon: Icons.cloud_sync_rounded,
                iconColor: const Color(0xFF2F80ED),
                iconBg: const Color(0xFFDBEAFE),
                title: 'Data Retention & School Offboarding',
                intro:
                    'Your institution retains 100% sovereignty and export rights over your data at all times:',
                bullets: [
                  'Instant Data Exports: Export complete school rosters, attendance histories, and fee receipts anytime in standard formats.',
                  'Guaranteed 30-Day Purge: Upon school offboarding or contract termination, all school data is completely erased within 30 days.',
                  'No Residual Backups: Decommissioned database archives are sanitized according to industry privacy standards.',
                ],
              ),

              const SizedBox(height: 8),

              // Data Protection Officer Contact Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8E9F6), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDE9FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.support_agent_rounded,
                        color: Color(0xFF5355BD),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Protection Officer (DPO)',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'privacy-compliance@sparzee.edu',
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
              ),
              const SizedBox(height: 24),

              // Action: Download PDF Button
              SpargeePrimaryButton(
                text: 'Download Privacy Agreement (PDF)',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.download_done_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Privacy Agreement PDF downloaded successfully',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF27AE60),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
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
    required String number,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String intro,
    required List<String> bullets,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5355BD).withValues(alpha: 0.04),
            blurRadius: 12,
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
                  '$number. $title',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            intro,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          ...bullets.map(
            (bullet) {
              final parts = bullet.split(': ');
              final hasPrefix = parts.length > 1;
              final prefix = hasPrefix ? parts[0] : '';
              final rest = hasPrefix ? parts.sublist(1).join(': ') : bullet;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                            height: 1.35,
                          ),
                          children: [
                            if (hasPrefix)
                              TextSpan(
                                text: '$prefix: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            TextSpan(
                              text: rest,
                              style: const TextStyle(
                                color: Color(0xFF4B5563),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
