import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'teachers_list_screen.dart';
import 'add_edit_teacher_screen.dart';
import 'admins_list_screen.dart';
import 'add_edit_admin_screen.dart';
import 'fee_overview_screen.dart';
import 'notepad_screen.dart';
import 'management_settings_screen.dart';
import '../admin/add_edit_student_screen.dart';
import '../admin/students_list_screen.dart';
import '../student/notices_detail_screen.dart';

class ManagementDashboardScreen extends StatefulWidget {
  const ManagementDashboardScreen({super.key});

  @override
  State<ManagementDashboardScreen> createState() => _ManagementDashboardScreenState();
}

class _ManagementDashboardScreenState extends State<ManagementDashboardScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _buildCurrentTab(),
        ),
      ),
      bottomNavigationBar: SpargeeBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return KeyedSubtree(
          key: const ValueKey('ManagementHomeTab'),
          child: _buildHomeTab(),
        );
      case 1:
        return const KeyedSubtree(
          key: ValueKey('ManagementNotepadTab'),
          child: NotepadScreen(),
        );
      case 2:
        return const KeyedSubtree(
          key: ValueKey('ManagementTeachersTab'),
          child: TeachersListScreen(),
        );
      case 3:
      default:
        return const KeyedSubtree(
          key: ValueKey('ManagementSettingsTab'),
          child: ManagementSettingsScreen(),
        );
    }
  }

  Widget _buildHomeTab() {
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.management]!;

    return StreamBuilder<List<Student>>(
      stream: DatabaseService.instance.studentsStream,
      initialData: DatabaseService.instance.currentStudents,
      builder: (context, studentSnap) {
        final students = studentSnap.data ?? [];
        final totalStudents = students.length;
        final totalPaid = students.fold(0.0, (sum, s) => sum + s.paidFee);
        final totalFee = students.fold(0.0, (sum, s) => sum + s.totalFee);
        final feePercentage = totalFee > 0 ? ((totalPaid / totalFee) * 100).toInt() : 76;

        return StreamBuilder<List<Teacher>>(
          stream: DatabaseService.instance.teachersStream,
          initialData: DatabaseService.instance.currentTeachers,
          builder: (context, teacherSnap) {
            final teachers = teacherSnap.data ?? [];
            final totalTeachers = teachers.length;

            return StreamBuilder<List<AdminUser>>(
              stream: DatabaseService.instance.adminsStream,
              initialData: DatabaseService.instance.currentAdmins,
              builder: (context, adminSnap) {
                final admins = adminSnap.data ?? [];
                final totalAdmins = admins.length;

                return StreamBuilder<List<ActivityItemData>>(
                  stream: DatabaseService.instance.activitiesStream,
                  initialData: DatabaseService.instance.currentActivities,
                  builder: (context, activitySnap) {
                    final activities = activitySnap.data ?? [];

                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _currentNavIndex = 3),
                                child: Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryOrange,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryOrange.withValues(alpha: 0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          user.avatarUrl ?? 'assets/images/management_avatar.png',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white, size: 30),
                                        ),
                                      ),
                                    ),
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
                                    border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: AppColors.primaryOrange,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Role pill badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Management',
                              style: AppTextStyles.pillBadge.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Greeting matching Figma
                          RichText(
                            text: TextSpan(
                              style: AppTextStyles.headlineGreeting.copyWith(fontSize: 24),
                              children: [
                                const TextSpan(text: 'Good morning, '),
                                TextSpan(
                                  text: '${user.name.split(' ').first}!',
                                  style: AppTextStyles.headlineGreeting.copyWith(
                                    color: const Color(0xFF7F80DA),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Subtitle
                          Text(
                            "Here's what's happening across your school today",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF222222),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Stat 1: Total students
                          SpargeeStatCard(
                            imageAsset: 'assets/images/dash_icon_student.png',
                            iconContainerColor: const Color(0xFF6B6CCF),
                            value: '$totalStudents',
                            label: 'Total students',
                            buttonText: '+Add Student',
                            isButtonSolid: true,
                            onButtonTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
                              );
                            },
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const StudentsListScreen(showBackButton: true)),
                              );
                            },
                          ),

                          // Stat 2: Total teachers
                          SpargeeStatCard(
                            imageAsset: 'assets/images/dash_icon_teacher.png',
                            iconContainerColor: const Color(0xFF6B6CCF),
                            value: '$totalTeachers',
                            label: 'Total teachers',
                            buttonText: '+Add Teacher',
                            isButtonSolid: false,
                            onButtonTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddEditTeacherScreen()),
                              );
                            },
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const TeachersListScreen(showBackButton: true)),
                              );
                            },
                          ),

                          // Stat 3: Total admin
                          SpargeeStatCard(
                            imageAsset: 'assets/images/dash_icon_admin.png',
                            iconContainerColor: const Color(0xFF6B6CCF),
                            value: '$totalAdmins',
                            label: 'Total admin',
                            buttonText: '+Add Admin',
                            isButtonSolid: false,
                            onButtonTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddEditAdminScreen()),
                              );
                            },
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AdminsListScreen(showBackButton: true)),
                              );
                            },
                          ),

                          // Stat 4: Fee collection
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
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const FeeOverviewScreen()),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Recent Activity Section Pill
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

                          // Activity Items
                          if (activities.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'No recent activities yet',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            )
                          else
                            ...activities.take(6).map((act) => _buildActivityRow(act)),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
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
                  TextSpan(text: act.title),
                  TextSpan(
                    text: act.highlightText,
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: act.trailingText),
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
