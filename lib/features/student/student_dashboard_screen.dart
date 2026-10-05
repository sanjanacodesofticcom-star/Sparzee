import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'student_homework_screen.dart';
import 'attendance_detail_screen.dart';
import 'notices_detail_screen.dart';
import 'fee_details_screen.dart';
import 'pay_fees_screen.dart';
import 'student_profile_settings_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentNavIndex,
          children: [
            _buildHomeTab(),
            const StudentHomeworkScreen(),
            const FeeDetailsScreen(showBackButton: false),
            const StudentProfileSettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: SpargeeBottomNavBar(
        currentIndex: _currentNavIndex,
        icons: const [
          Icons.home_outlined,
          Icons.edit_note_rounded,
          Icons.receipt_long_outlined,
          Icons.settings_outlined,
        ],
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeTab() {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.student]!;
    final studentRecord = AppData.students.firstWhere(
      (s) => s.name == user.name || s.parentPhone == user.phone,
      orElse: () => AppData.students.first,
    );

    final firstName = studentRecord.name.split(' ').first;
    final homeworkCount = AppData.homeworks.length;
    final noticeCount = AppData.notices.length;
    final feeAmountText = studentRecord.feeDue > 0 ? 'Rs.${studentRecord.feeDue.toInt()}' : 'Rs.0';

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar on Left, Bell Notification on Right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _currentNavIndex = 3),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFA366),
                    border: Border.all(color: const Color(0xFFFFA366), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFA366).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: studentRecord.avatarUrl != null && studentRecord.avatarUrl!.isNotEmpty
                        ? Image.asset(
                            studentRecord.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.person, color: Colors.white, size: 30),
                          )
                        : const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NoticesDetailScreen()),
                  );
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.5), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primaryOrangeDark,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Role Badge: Student-Aarav Mehta matching Figma image 1
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryOrange, width: 1.2),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                children: [
                  const TextSpan(text: 'Student-'),
                  TextSpan(
                    text: studentRecord.name,
                    style: const TextStyle(
                      color: Color(0xFF7F80DA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Greeting: Good morning, Aarav! matching Figma image 1
          RichText(
            text: TextSpan(
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: -0.3,
              ),
              children: [
                const TextSpan(text: 'Good morning, '),
                TextSpan(
                  text: '$firstName!',
                  style: const TextStyle(
                    color: Color(0xFF7F80DA),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle matching Figma image 1
          const Text(
            "Here's what's happening across your class today",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),

          // Stat 1: 2 Pending Today Homework (solid orange button Check)
          SpargeeStatCard(
            icon: Icons.edit_document,
            iconContainerColor: const Color(0xFF7F80DA),
            iconColor: Colors.white,
            value: '$homeworkCount Pending',
            label: 'Today Homework',
            buttonText: 'Check',
            isButtonSolid: true,
            onButtonTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StudentHomeworkScreen(showBackButton: true)),
              );
            },
          ),

          // Stat 2: Present Attendance Today (white button Check)
          SpargeeStatCard(
            icon: Icons.event_available_rounded,
            iconContainerColor: const Color(0xFF7F80DA),
            iconColor: Colors.white,
            value: 'Present',
            valueColor: const Color(0xFF22C55E),
            label: 'Attendance Today',
            buttonText: 'Check',
            isButtonSolid: false,
            onButtonTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AttendanceDetailScreen()),
              );
            },
          ),

          // Stat 3: 5 Today Notices (white button Check)
          SpargeeStatCard(
            icon: Icons.article_outlined,
            iconContainerColor: const Color(0xFF7F80DA),
            iconColor: Colors.white,
            value: '$noticeCount',
            label: 'Today Notices',
            buttonText: 'Check',
            isButtonSolid: false,
            onButtonTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NoticesDetailScreen()),
              );
            },
          ),

          // Stat 4: Rs.24,000 Upcoming fee due-10 Oct (white button Pay Fees)
          SpargeeStatCard(
            icon: Icons.payments_outlined,
            iconContainerColor: const Color(0xFF7F80DA),
            iconColor: Colors.white,
            value: feeAmountText,
            label: 'Upcoming fee due-10 Oct',
            buttonText: 'Pay Fees',
            isButtonSolid: false,
            onButtonTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PayFeesScreen(
                    amount: studentRecord.feeDue > 0 ? studentRecord.feeDue : 24000,
                    term: 'Term 2, 2026 - ${studentRecord.name}',
                  ),
                ),
              );
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FeeDetailsScreen(showBackButton: true)),
              );
            },
          ),
          const SizedBox(height: 12),

          // Recent Activity Pill Badge matching Figma image 1
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryOrange, width: 1.2),
              color: Colors.white,
            ),
            child: const Text(
              'Recent activity',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Activity Items matching Figma image 1
          ...AppData.recentActivities.map((act) => _buildActivityRow(act)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActivityRow(ActivityItemData act) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA366),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 11,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF7F80DA),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: act.title,
                    style: const TextStyle(color: Color(0xFF7F80DA)),
                  ),
                  if (act.highlightText.isNotEmpty)
                    TextSpan(
                      text: act.highlightText,
                      style: const TextStyle(
                        color: Color(0xFFFFA366),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (act.trailingText.isNotEmpty)
                    TextSpan(
                      text: act.trailingText,
                      style: const TextStyle(color: AppColors.textDark),
                    ),
                  TextSpan(
                    text: ' ${act.timeAgo}',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11.5,
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
