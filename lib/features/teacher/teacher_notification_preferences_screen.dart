import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class TeacherNotificationPreferencesScreen extends StatefulWidget {
  const TeacherNotificationPreferencesScreen({super.key});

  @override
  State<TeacherNotificationPreferencesScreen> createState() => _TeacherNotificationPreferencesScreenState();
}

class _TeacherNotificationPreferencesScreenState extends State<TeacherNotificationPreferencesScreen> {
  bool _homeworkSubmissions = true;
  bool _attendanceReminders = true;
  bool _schoolAnnouncements = true;
  bool _parentMessages = true;
  bool _examSchedules = true;
  bool _quietHours = false;

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
                    'Notification Preferences',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildSectionHeader('Class & Student Alerts'),
              _buildToggleCard(
                title: 'Homework Submissions',
                subtitle: 'Notify instantly when a student turns in homework or worksheets',
                value: _homeworkSubmissions,
                onChanged: (v) => setState(() => _homeworkSubmissions = v),
              ),
              _buildToggleCard(
                title: 'Daily Attendance Reminders',
                subtitle: 'Remind before first period to submit daily class roster',
                value: _attendanceReminders,
                onChanged: (v) => setState(() => _attendanceReminders = v),
              ),
              _buildToggleCard(
                title: 'Parent Queries & Messages',
                subtitle: 'Direct messages regarding student academic progress',
                value: _parentMessages,
                onChanged: (v) => setState(() => _parentMessages = v),
              ),

              const SizedBox(height: 16),
              _buildSectionHeader('Institutional Notices'),
              _buildToggleCard(
                title: 'School Circulars & Events',
                subtitle: 'Official notices, staff meetings, and holiday alerts',
                value: _schoolAnnouncements,
                onChanged: (v) => setState(() => _schoolAnnouncements = v),
              ),
              _buildToggleCard(
                title: 'Exam Date Sheets & Marks Entry',
                subtitle: 'Term examinations schedule and report card deadlines',
                value: _examSchedules,
                onChanged: (v) => setState(() => _examSchedules = v),
              ),

              const SizedBox(height: 16),
              _buildSectionHeader('Quiet Hours'),
              _buildToggleCard(
                title: 'Do Not Disturb (8 PM - 7 AM)',
                subtitle: 'Mute non-urgent class notifications outside school hours',
                value: _quietHours,
                onChanged: (v) => setState(() => _quietHours = v),
              ),

              const SizedBox(height: 24),
              SpargeePrimaryButton(
                text: 'Save Notification Settings',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Notification preferences saved successfully'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF27AE60),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7F80DA),
          letterSpacing: 0.2,
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFFFFA366),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
