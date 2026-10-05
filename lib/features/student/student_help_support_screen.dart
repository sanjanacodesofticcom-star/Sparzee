import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class StudentHelpSupportScreen extends StatefulWidget {
  const StudentHelpSupportScreen({super.key});

  @override
  State<StudentHelpSupportScreen> createState() => _StudentHelpSupportScreenState();
}

class _StudentHelpSupportScreenState extends State<StudentHelpSupportScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedTopic = 'Homework & Submission';
  bool _isSubmitting = false;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I upload homework worksheets from my device?',
      'answer': 'Go to Homework -> Tap the assignment -> Under "Your Submission", tap "Upload from Device" and select a PDF or image file from your system storage, then tap "Submit Homework".'
    },
    {
      'question': 'How can I pay my school fees online?',
      'answer': 'Navigate to Fee Details -> Tap the "Pay Fee" button -> Select your preferred payment method (UPI, Card, or Net banking) -> Complete the transaction to instantly get a receipt.'
    },
    {
      'question': 'Who can I contact if my attendance is marked incorrectly?',
      'answer': 'Please contact your class teacher Sana Kapoor or visit the administrative office helpdesk to request an attendance audit correction.'
    },
    {
      'question': 'Where can I find school event notices and holiday schedules?',
      'answer': 'Tap the notification bell on the Home screen or open Notices Detail to filter announcements by Holidays, Events, or General notices.'
    },
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (_queryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your query or problem first.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _queryController.clear();
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: const Text('Support Ticket Received', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text(
              'Ticket #STU-9921 has been logged with the Student Helpdesk. Our administration team will contact you within 24 hours.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK', style: TextStyle(color: Color(0xFFFFA366), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    });
  }

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
                  Text(
                    'Help & Support',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contact Helpline Cards Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFD6D6EA)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.headset_mic_rounded, color: Color(0xFF7F80DA), size: 26),
                          SizedBox(height: 8),
                          Text('Student Support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                          SizedBox(height: 2),
                          Text('+91 98765 00004', style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFD8C2)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.mail_outline_rounded, color: AppColors.primaryOrange, size: 26),
                          SizedBox(height: 8),
                          Text('Helpdesk Email', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                          SizedBox(height: 2),
                          Text('support@spargee.edu', style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Frequently Asked Questions
              Text(
                'Frequently Asked Questions',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 15, color: const Color(0xFF7F80DA)),
              ),
              const SizedBox(height: 12),

              ..._faqs.map((faq) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.textDark),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Text(
                            faq['answer']!,
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF4B5563), height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),

              // Submit a Query
              Text(
                'Submit an Inquiry or Request',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 15, color: const Color(0xFF7F80DA)),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTopic,
                    isExpanded: true,
                    items: [
                      'Homework & Submission',
                      'Fee Payment & Receipts',
                      'Attendance Query',
                      'Technical Issue with App',
                      'General Question',
                    ].map((topic) => DropdownMenuItem(value: topic, child: Text(topic))).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedTopic = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _queryController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your issue or question in detail...',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.5),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFF7F80DA), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SpargeePrimaryButton(
                text: 'Submit Support Ticket',
                isLoading: _isSubmitting,
                onPressed: _submitTicket,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
