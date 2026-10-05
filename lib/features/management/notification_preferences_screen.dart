import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final prefs = AppData.notificationPreferences;

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
                  Text('Notification Preferences', style: AppTextStyles.titleMedium.copyWith(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),

              _buildSectionHeader('Communication Channels'),
              _buildToggleItem(
                title: 'Push Notifications',
                subtitle: 'Receive instant app push alerts for major school updates',
                value: prefs.pushNotifications,
                onChanged: (val) => setState(() => prefs.pushNotifications = val),
              ),
              _buildToggleItem(
                title: 'SMS Alerts',
                subtitle: 'Send SMS on emergency closures and urgent notices',
                value: prefs.smsAlerts,
                onChanged: (val) => setState(() => prefs.smsAlerts = val),
              ),
              _buildToggleItem(
                title: 'WhatsApp Updates',
                subtitle: 'Receive fee receipts and homework notifications on WhatsApp',
                value: prefs.whatsappUpdates,
                onChanged: (val) => setState(() => prefs.whatsappUpdates = val),
              ),
              const SizedBox(height: 18),

              _buildSectionHeader('Academic & Administrative Alerts'),
              _buildToggleItem(
                title: 'Fee Due & Collection Reminders',
                subtitle: 'Get alerts when student fee deadlines approach',
                value: prefs.feeDueAlerts,
                onChanged: (val) => setState(() => prefs.feeDueAlerts = val),
              ),
              _buildToggleItem(
                title: 'Attendance & Leave Approvals',
                subtitle: 'Notify when teacher attendance is submitted or staff request leave',
                value: prefs.attendanceAlerts,
                onChanged: (val) => setState(() => prefs.attendanceAlerts = val),
              ),
              _buildToggleItem(
                title: 'Exam & Result Announcements',
                subtitle: 'Alerts for upcoming test schedules and marks published',
                value: prefs.examAnnouncements,
                onChanged: (val) => setState(() => prefs.examAnnouncements = val),
              ),
              _buildToggleItem(
                title: 'Daily Evening Digest',
                subtitle: 'Comprehensive daily summary report of school activities',
                value: prefs.dailySummary,
                onChanged: (val) => setState(() => prefs.dailySummary = val),
              ),
              const SizedBox(height: 24),

              SpargeePrimaryButton(
                text: 'Save Preferences',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preferences saved successfully!'),
                      backgroundColor: AppColors.primaryPurple,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryOrange,
            activeTrackColor: AppColors.primaryPurple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
