import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class TeacherHelpSupportScreen extends StatefulWidget {
  const TeacherHelpSupportScreen({super.key});

  @override
  State<TeacherHelpSupportScreen> createState() => _TeacherHelpSupportScreenState();
}

class _TeacherHelpSupportScreenState extends State<TeacherHelpSupportScreen> {
  final _messageController = TextEditingController();
  String _selectedCategory = 'Homework & Grading';

  final List<String> _categories = [
    'Homework & Grading',
    'Attendance Marking',
    'Class Roster Sync',
    'Student Records',
    'Account & Login',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendTicket() {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your query details'),
          backgroundColor: Color(0xFFEB5757),
        ),
      );
      return;
    }

    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Support ticket submitted! ID: #TCH-8921'),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

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
                  Text(
                    'Help & Support',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contact Helpline Cards
              Row(
                children: [
                  Expanded(
                    child: _buildContactBox(
                      icon: Icons.headset_mic_rounded,
                      title: 'Teacher Support',
                      detail: '+91 98765 00000',
                      badgeColor: const Color(0xFF7F80DA),
                      bgColor: const Color(0xFFF0EFFF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactBox(
                      icon: Icons.mail_outline_rounded,
                      title: 'Email Helpdesk',
                      detail: 'teachers@sparzee.edu',
                      badgeColor: const Color(0xFFFFA366),
                      bgColor: const Color(0xFFFFEDD5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7F80DA),
                ),
              ),
              const SizedBox(height: 12),

              _buildFaqTile(
                'How do I attach a PDF worksheet to homework?',
                'Navigate to Homework -> Assign Homework, tap "Upload from Device", and select your desired PDF file from device storage.',
              ),
              _buildFaqTile(
                'Can I edit attendance after submitting?',
                'Yes. Select the target class and date from Mark Attendance, adjust student statuses, and tap Save Attendance.',
              ),
              _buildFaqTile(
                'How to review and grade student homework?',
                'Open Homework -> select the assignment -> tap on any student submission to view their attached PDF, enter numerical marks, and provide feedback.',
              ),

              const SizedBox(height: 24),
              const Text(
                'Submit a Support Request',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7F80DA),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.w600))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFA366), width: 1.2),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe your issue or feature inquiry...',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.5),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SpargeePrimaryButton(
                text: 'Submit Support Ticket',
                onPressed: _sendTicket,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactBox({
    required IconData icon,
    required String title,
    required String detail,
    required Color badgeColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EFFF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: badgeColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 2),
          Text(detail, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EFFF), width: 1.2),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          question,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        children: [
          Text(
            answer,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF4B5563), height: 1.4),
          ),
        ],
      ),
    );
  }
}
