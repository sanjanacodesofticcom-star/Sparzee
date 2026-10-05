import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class AdminHelpSupportScreen extends StatefulWidget {
  const AdminHelpSupportScreen({super.key});

  @override
  State<AdminHelpSupportScreen> createState() => _AdminHelpSupportScreenState();
}

class _AdminHelpSupportScreenState extends State<AdminHelpSupportScreen> {
  final _ticketSubjectController = TextEditingController();
  final _ticketDescController = TextEditingController();
  String _selectedCategory = 'Teacher Management';
  bool _isSubmittingTicket = false;

  final List<String> _ticketCategories = [
    'Teacher Management',
    'Student Records & Admissions',
    'Fee Collection & Reports',
    'Notice & Broadcasts',
    'Account & Permissions',
    'Technical / Bug Report',
  ];

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I add or reassign a teacher to a class?',
      'answer':
          'Navigate to the Teachers tab (3rd tab in bottom navigation), tap "+ Add" in the top right to register a new teacher, or tap any teacher profile and select "Reassign class" to change their subjects and sections.',
    },
    {
      'question': 'How does the monthly fee collection percentage calculate?',
      'answer':
          'The dashboard calculates the live percentage of total paid students against total enrolled students in your assigned school branch in real-time.',
    },
    {
      'question': 'How do I broadcast urgent notices to parents and teachers?',
      'answer':
          'From the Admin Dashboard, tap "+Add a Note" or switch to the Notices / Notepad tab (2nd tab) to compose, edit, and publish notice announcements across classes.',
    },
    {
      'question': 'How can I update my profile details or change photo?',
      'answer':
          'Go to Settings (4th tab) and tap your profile avatar or the "Admin Credentials & Access" card. You can pick photos from your device gallery, take a photo with your camera, or select preset avatars.',
    },
  ];

  @override
  void dispose() {
    _ticketSubjectController.dispose();
    _ticketDescController.dispose();
    super.dispose();
  }

  void _submitTicket() async {
    if (_ticketSubjectController.text.trim().isEmpty ||
        _ticketDescController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both subject and description'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isSubmittingTicket = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isSubmittingTicket = false;
        _ticketSubjectController.clear();
        _ticketDescController.clear();
      });

      final ticketId = 'TKT-${DateTime.now().millisecondsSinceEpoch % 100000}';
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 28),
              SizedBox(width: 10),
              Text('Ticket Submitted', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your ticket ($ticketId) has been assigned to the Sparzee Enterprise Support team.'),
              const SizedBox(height: 10),
              const Text(
                'A support engineer will respond to your official email within 2-4 business hours.',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
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
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                  Text(
                    'Help & Support',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contact Channels Row
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.headset_mic_rounded,
                      iconBg: const Color(0xFFEDE9FE),
                      iconColor: const Color(0xFF6B6CCF),
                      title: 'Call Helpline',
                      subtitle: '+1 (800) 555-0199',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dialing Sparzee Admin Hotline...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.email_rounded,
                      iconBg: const Color(0xFFFFEDD5),
                      iconColor: AppColors.primaryOrange,
                      title: 'Email Support',
                      subtitle: 'admin-help@sparzee.edu',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening email client...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // FAQs Section
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5355BD),
                ),
              ),
              const SizedBox(height: 12),
              ..._faqs.map((faq) => _buildFaqTile(faq['question']!, faq['answer']!)),
              const SizedBox(height: 24),

              // Submit a Ticket Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE8E9F6), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B6CCF).withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.confirmation_number_outlined, color: Color(0xFF6B6CCF), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Raise a Support Ticket',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Category Selector
                    const Text('Issue Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E4F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          items: _ticketCategories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat, style: const TextStyle(fontSize: 13.5)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subject Field
                    const Text('Subject', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E4F0)),
                      ),
                      child: TextField(
                        controller: _ticketSubjectController,
                        style: const TextStyle(fontSize: 13.5),
                        decoration: const InputDecoration(
                          hintText: 'Brief summary of the issue',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description Field
                    const Text('Details & Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E4F0)),
                      ),
                      child: TextField(
                        controller: _ticketDescController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 13.5),
                        decoration: const InputDecoration(
                          hintText: 'Explain the details so our support team can assist quickly...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmittingTicket ? null : _submitTicket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _isSubmittingTicket
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Submit Support Ticket',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // System Version Badge
              Center(
                child: Text(
                  'Sparzee Admin Suite v2.4.1 • All Systems Operational',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
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
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: const Color(0xFF6B6CCF),
          collapsedIconColor: AppColors.textSecondary,
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
