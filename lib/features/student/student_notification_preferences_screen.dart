import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class StudentNotificationPreferencesScreen extends StatefulWidget {
  const StudentNotificationPreferencesScreen({super.key});

  @override
  State<StudentNotificationPreferencesScreen> createState() => _StudentNotificationPreferencesScreenState();
}

class _StudentNotificationPreferencesScreenState extends State<StudentNotificationPreferencesScreen> {
  bool _homeworkAlerts = true;
  bool _feeDueReminders = true;
  bool _attendanceAlerts = true;
  bool _schoolCirculars = true;
  bool _examDateSheets = true;
  bool _quietHours = false;

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings updated successfully!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    Navigator.of(context).pop();
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
                    'Notification Preferences',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Academic Alerts Section
              Text(
                'Academic & Classroom Alerts',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 15, color: const Color(0xFF7F80DA)),
              ),
              const SizedBox(height: 10),

              _buildToggleCard(
                title: 'Homework & Assignment Deadlines',
                subtitle: 'Daily reminders for upcoming and pending homework',
                value: _homeworkAlerts,
                onChanged: (v) => setState(() => _homeworkAlerts = v),
              ),
              const SizedBox(height: 10),

              _buildToggleCard(
                title: 'Daily Attendance Updates',
                subtitle: 'Instant alerts when morning attendance is logged',
                value: _attendanceAlerts,
                onChanged: (v) => setState(() => _attendanceAlerts = v),
              ),
              const SizedBox(height: 10),

              _buildToggleCard(
                title: 'Exam Date Sheets & Marks',
                subtitle: 'Term examination schedules, admit cards, and report cards',
                value: _examDateSheets,
                onChanged: (v) => setState(() => _examDateSheets = v),
              ),
              const SizedBox(height: 24),

              // School & Fee Alerts
              Text(
                'Administrative & Fee Alerts',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 15, color: const Color(0xFF7F80DA)),
              ),
              const SizedBox(height: 10),

              _buildToggleCard(
                title: 'Fee Due & Receipt Alerts',
                subtitle: 'Upcoming quarterly tuition deadlines and receipt confirmations',
                value: _feeDueReminders,
                onChanged: (v) => setState(() => _feeDueReminders = v),
              ),
              const SizedBox(height: 10),

              _buildToggleCard(
                title: 'School Circulars & Holidays',
                subtitle: 'Official principal announcements, events, and vacation alerts',
                value: _schoolCirculars,
                onChanged: (v) => setState(() => _schoolCirculars = v),
              ),
              const SizedBox(height: 24),

              // Quiet Hours
              Text(
                'Quiet Hours',
                style: AppTextStyles.titleSmall.copyWith(fontSize: 15, color: const Color(0xFF7F80DA)),
              ),
              const SizedBox(height: 10),

              _buildToggleCard(
                title: 'Do Not Disturb (9 PM - 7 AM)',
                subtitle: 'Mute non-urgent notifications during night hours',
                value: _quietHours,
                onChanged: (v) => setState(() => _quietHours = v),
              ),
              const SizedBox(height: 32),

              SpargeePrimaryButton(
                text: 'Save Notification Settings',
                onPressed: _saveSettings,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textDark),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFFFFA366),
            activeTrackColor: const Color(0xFFFFA366).withValues(alpha: 0.4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE5E7EB),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
