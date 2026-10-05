import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class AdminNotificationPreferencesScreen extends StatefulWidget {
  const AdminNotificationPreferencesScreen({super.key});

  @override
  State<AdminNotificationPreferencesScreen> createState() =>
      _AdminNotificationPreferencesScreenState();
}

class _AdminNotificationPreferencesScreenState
    extends State<AdminNotificationPreferencesScreen> {
  // Notification Toggles
  bool _studentAdmissions = true;
  bool _teacherAttendance = true;
  bool _feeCollections = true;
  bool _noticeBroadcasts = true;
  bool _securityLogins = true;
  bool _emailSummary = false;
  bool _smsAlerts = true;
  bool _quietHours = false;

  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  bool _isSaving = false;

  void _savePreferences() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Notification preferences saved successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    'Notification Settings',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B6CCF), Color(0xFF8B8CEF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B6CCF).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
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
                            'Administrative Alerts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure real-time updates for school operations and staff activities.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section 1: Academic & Operational Alerts
              _buildSectionHeader('School Operations'),
              const SizedBox(height: 10),
              _buildToggleTile(
                icon: Icons.person_add_alt_1_rounded,
                iconColor: const Color(0xFF6B6CCF),
                title: 'Student Admissions & Transfers',
                subtitle: 'Notify when new students register or transfer classes',
                value: _studentAdmissions,
                onChanged: (v) => setState(() => _studentAdmissions = v),
              ),
              _buildToggleTile(
                icon: Icons.assignment_turned_in_rounded,
                iconColor: AppColors.primaryOrange,
                title: 'Teacher Attendance Submissions',
                subtitle: 'Alert when teachers mark daily class attendance',
                value: _teacherAttendance,
                onChanged: (v) => setState(() => _teacherAttendance = v),
              ),
              _buildToggleTile(
                icon: Icons.receipt_long_rounded,
                iconColor: const Color(0xFF22C55E),
                title: 'Fee Payments & Invoices',
                subtitle: 'Real-time receipts for tuition fee collections',
                value: _feeCollections,
                onChanged: (v) => setState(() => _feeCollections = v),
              ),
              _buildToggleTile(
                icon: Icons.campaign_rounded,
                iconColor: const Color(0xFF9333EA),
                title: 'School Notice Broadcasts',
                subtitle: 'Alerts when urgent notices are posted or updated',
                value: _noticeBroadcasts,
                onChanged: (v) => setState(() => _noticeBroadcasts = v),
              ),
              const SizedBox(height: 20),

              // Section 2: Delivery Channels & Security
              _buildSectionHeader('Channels & Security'),
              const SizedBox(height: 10),
              _buildToggleTile(
                icon: Icons.security_rounded,
                iconColor: const Color(0xFFEF4444),
                title: 'Security & Login Alerts',
                subtitle: 'Immediate alerts on unknown device logins',
                value: _securityLogins,
                onChanged: (v) => setState(() => _securityLogins = v),
              ),
              _buildToggleTile(
                icon: Icons.mail_outline_rounded,
                iconColor: const Color(0xFF3B82F6),
                title: 'Daily Digest Email',
                subtitle: 'Receive daily summary report to official email',
                value: _emailSummary,
                onChanged: (v) => setState(() => _emailSummary = v),
              ),
              _buildToggleTile(
                icon: Icons.sms_outlined,
                iconColor: AppColors.primaryOrange,
                title: 'Emergency SMS Alerts',
                subtitle: 'Critical notifications sent via SMS to registered mobile',
                value: _smsAlerts,
                onChanged: (v) => setState(() => _smsAlerts = v),
              ),
              const SizedBox(height: 20),

              // Section 3: Quiet Hours
              _buildSectionHeader('Quiet Hours'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E9F6), width: 1.2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.bedtime_rounded,
                            color: Color(0xFF6B6CCF),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enable Quiet Hours',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Mute non-critical sound alerts overnight',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _quietHours,
                          activeTrackColor: AppColors.primaryOrange,
                          onChanged: (v) => setState(() => _quietHours = v),
                        ),
                      ],
                    ),
                    if (_quietHours) ...[
                      const Divider(height: 24, color: Color(0xFFF1F1F8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimeSelector(
                            label: 'From',
                            time: _quietStart,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _quietStart,
                              );
                              if (picked != null) setState(() => _quietStart = picked);
                            },
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.textSecondary, size: 18),
                          _buildTimeSelector(
                            label: 'To',
                            time: _quietEnd,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _quietEnd,
                              );
                              if (picked != null) setState(() => _quietEnd = picked);
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Save Button
              SpargeePrimaryButton(
                text: 'Save Preferences',
                isLoading: _isSaving,
                onPressed: _savePreferences,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF5355BD),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
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
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primaryOrange,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E4F0)),
        ),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Text(
              time.format(context),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B6CCF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
