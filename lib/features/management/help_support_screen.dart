import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  void _openTicketDialog() {
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submit Support Ticket', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              SpargeeTextField(label: 'Issue Subject', hintText: 'e.g. Fee Gateway Integration Query', controller: subjectCtrl),
              const SizedBox(height: 12),
              SpargeeTextField(
                label: 'Description',
                hintText: 'Please detail your issue or request...',
                controller: messageCtrl,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              SpargeePrimaryButton(
                text: 'Send Request',
                onPressed: () {
                  if (subjectCtrl.text.trim().isEmpty) return;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Support ticket #SPZ-9412 created successfully!'),
                        ],
                      ),
                      backgroundColor: AppColors.primaryPurple,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ],
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text('Help & Support', style: AppTextStyles.titleMedium.copyWith(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 20),

              // Contact Channels Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA366), Color(0xFFF28B45)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sparzee Dedicated Support',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Our technical & school operations team is available 24x7 to assist you.',
                      style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        const Text('+91 1800-SPARZEE (toll free)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        const Text('support@sparzee.edu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Frequently Asked Questions', style: AppTextStyles.titleSmall.copyWith(fontSize: 17)),
              const SizedBox(height: 12),

              _buildFaqItem(
                'How do I add or update a teacher account?',
                'Navigate to Teachers tab from the bottom navigation bar or Management Home and tap "+Add Teacher". Fill in the profile details, assign subjects & classes, and tap Save.',
              ),
              _buildFaqItem(
                'How are fee payment receipts generated?',
                'When fee status is marked "Paid" either via online payment gateway or manual counter entry, an automated digital receipt is generated and emailed to the registered parent.',
              ),
              _buildFaqItem(
                'Can I publish urgent notices to specific grades only?',
                'Yes! From the Notice Categories screen and Student Notices module, you can target specific grades or sections.',
              ),
              _buildFaqItem(
                'How does attendance synchronization work?',
                'Teachers submit daily attendance from their app. Management and Admins receive instant real-time sync with overall school attendance metrics.',
              ),
              const SizedBox(height: 24),

              SpargeePrimaryButton(
                text: 'Create Support Ticket',
                onPressed: _openTicketDialog,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.primaryPurple,
          collapsedIconColor: AppColors.primaryOrange,
          title: Text(
            question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(fontSize: 13, color: Color(0xFF5A443B), height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
