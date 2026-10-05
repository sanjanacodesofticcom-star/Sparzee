import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';
import 'students_list_screen.dart';
import 'add_edit_student_screen.dart';
import 'admin_teachers_list_screen.dart';
import 'admin_settings_screen.dart';
import '../management/add_edit_teacher_screen.dart';
import '../management/fee_overview_screen.dart';
import '../management/notepad_screen.dart';
import '../student/notices_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
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
            const NotepadScreen(),
            const AdminTeachersListScreen(),
            const AdminSettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: SpargeeBottomNavBar(
        currentIndex: _currentNavIndex,
        icons: const [
          Icons.home_outlined,
          Icons.note_add_outlined,
          Icons.groups_outlined,
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
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.admin]!;

    return StreamBuilder<List<Student>>(
      stream: DatabaseService.instance.studentsStream,
      initialData: DatabaseService.instance.students,
      builder: (context, studentSnap) {
        return StreamBuilder<List<Teacher>>(
          stream: DatabaseService.instance.teachersStream,
          initialData: DatabaseService.instance.teachers,
          builder: (context, teacherSnap) {
            final students = studentSnap.data ?? AppData.students;
            final teachers = teacherSnap.data ?? AppData.teachers;
            final totalStudents = students.length;
            final totalTeachers = teachers.length;
            final totalNotices = AppData.notices.length;

            final paidCount = students.where((s) => s.feeStatus == 'Paid').length;
            final feePercentage = totalStudents > 0 ? ((paidCount / totalStudents) * 100).toInt() : 76;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  SpargeeHeader(
                    roleName: 'Admin',
                    userName: user.name,
                    subtitle: "Here's what's happening across your school today",
                    avatarAsset: user.avatarUrl,
                    avatarBgColor: AppColors.primaryOrange,
                    avatarBorderColor: AppColors.primaryOrange,
                    bellColor: AppColors.primaryOrange,
                    bellBorderColor: AppColors.primaryOrange,
                    roleBadgeColor: AppColors.primaryOrange,
                    roleBadgeTextColor: AppColors.textPrimary,
                    onAvatarTap: () {
                      setState(() => _currentNavIndex = 3);
                    },
                    onNotificationTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NoticesDetailScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Stat 1: Total students
                  SpargeeStatCard(
                    imageAsset: 'assets/images/dash_icon_student.png',
                    iconContainerColor: const Color(0xFF6B6CCF),
                    value: '$totalStudents',
                    label: totalStudents == 1 ? 'Total student' : 'Total students',
                    buttonText: '+Add Student',
                    isButtonSolid: true,
                    onButtonTap: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
                      );
                      if (res == true) setState(() {});
                    },
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const StudentsListScreen(showBackButton: true)),
                      );
                      setState(() {});
                    },
                  ),

                  // Stat 2: Total teachers
                  SpargeeStatCard(
                    imageAsset: 'assets/images/dash_icon_teacher.png',
                    iconContainerColor: const Color(0xFF6B6CCF),
                    value: '$totalTeachers',
                    label: totalTeachers == 1 ? 'Total teacher' : 'Total teachers',
                    buttonText: '+Add Teacher',
                    isButtonSolid: false,
                    onButtonTap: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddEditTeacherScreen()),
                      );
                      if (res == true) setState(() {});
                    },
                    onTap: () {
                      setState(() => _currentNavIndex = 2);
                    },
                  ),

                  // Stat 3: Fee collection this month
                  SpargeeStatCard(
                    imageAsset: 'assets/images/dash_icon_fee.png',
                    iconContainerColor: const Color(0xFF6B6CCF),
                    value: '$feePercentage%',
                    label: 'Fee collection this month',
                    buttonText: 'Check Fee',
                    isButtonSolid: false,
                    onButtonTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FeeOverviewScreen()),
                      );
                    },
                  ),

                  // Stat 4: Post Notice / Add a Note
                  SpargeeStatCard(
                    icon: Icons.note_add_outlined,
                    iconContainerColor: const Color(0xFF6B6CCF),
                    iconColor: Colors.white,
                    value: '$totalNotices',
                    label: 'Post Notice',
                    buttonText: '+Add a Note',
                    isButtonSolid: false,
                    onButtonTap: () {
                      setState(() => _currentNavIndex = 1);
                    },
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NoticesDetailScreen()),
                      );
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 16),

                  // Recent Activity Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Recent activity',
                      style: AppTextStyles.pillBadge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Activity Stream
                  _buildActivityList(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActivityList() {
    // Custom formatted recent activities matching Figma
    final activities = AppData.recentActivities.isNotEmpty
        ? AppData.recentActivities
        : [
            ActivityItemData(
              title: 'Admin Priya',
              highlightText: ' 9 students',
              trailingText: ' to Class 4-B',
              timeAgo: '- 2h ago',
            ),
            ActivityItemData(
              title: 'Teacher Sana',
              highlightText: '',
              trailingText: ' marked attendance',
              timeAgo: '- 4h ago',
            ),
          ];

    return Column(
      children: activities.map((act) => _buildActivityRow(act)).toList(),
    );
  }

  Widget _buildActivityRow(ActivityItemData act) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                ),
                children: [
                  TextSpan(
                    text: act.title,
                    style: const TextStyle(
                      color: Color(0xFF6B6CCF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (act.highlightText.isNotEmpty)
                    TextSpan(
                      text: act.highlightText,
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  TextSpan(
                    text: ' ${act.trailingText.trim()}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: '  ${act.timeAgo}',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
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
