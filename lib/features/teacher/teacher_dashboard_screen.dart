import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import 'mark_attendance_screen.dart';
import 'homework_list_screen.dart';
import 'class_students_screen.dart';
import 'teacher_settings_screen.dart';
import '../student/notices_detail_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _currentNavIndex = 0;
  final ScrollController _scheduleScrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scheduleScrollController.addListener(_onScheduleScroll);
  }

  void _onScheduleScroll() {
    if (_scheduleScrollController.hasClients) {
      final maxScroll = _scheduleScrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        setState(() {
          _scrollProgress = (_scheduleScrollController.offset / maxScroll).clamp(0.0, 1.0);
        });
      }
    }
  }

  @override
  void dispose() {
    _scheduleScrollController.removeListener(_onScheduleScroll);
    _scheduleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentNavIndex,
          children: [
            _buildHomeTab(),
            const ClassStudentsScreen(showBackButton: false),
            const HomeworkListScreen(showBackButton: false),
            const TeacherSettingsScreen(showBackButton: false),
          ],
        ),
      ),
      bottomNavigationBar: SpargeeBottomNavBar(
        currentIndex: _currentNavIndex,
        icons: const [
          Icons.home_outlined,
          Icons.people_outline_rounded,
          Icons.note_add_outlined,
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
    final user = AppData.currentUser ?? AppData.allowedUsers[UserRole.teacher]!;
    final firstName = user.name.split(' ').first;

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
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrange,
                    border: Border.all(color: AppColors.primaryOrange, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                        ? Image.asset(
                            user.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _buildAvatarFallback(firstName),
                          )
                        : _buildAvatarFallback(firstName),
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

          // Role Badge: Teacher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryOrange, width: 1.2),
            ),
            child: const Text(
              'Teacher',
              style: TextStyle(
                color: AppColors.primaryOrangeDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Greeting: Good morning, Sedha!
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

          // Subtitle
          const Text(
            "Here's what's happening across your Classes today",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // Today's Schedule Card (Orange Container with proper padding, no edge clipping)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA366),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA366).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Schedule",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                      ),
                    ),
                    Icon(Icons.access_time_rounded, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 78,
                  child: ListView(
                    controller: _scheduleScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildScheduleCard('9:00am', 'Class 5-A', isCurrent: true),
                      const SizedBox(width: 10),
                      _buildScheduleCard('10:30am', 'Class 6-A'),
                      const SizedBox(width: 10),
                      _buildScheduleCard('1:00pm', 'Class 7-A'),
                      const SizedBox(width: 10),
                      _buildScheduleCard('2:15pm', 'Class 8-A'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Horizontal scroll progress pill
                Container(
                  height: 5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_scrollProgress * 0.6 + 0.4).clamp(0.4, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 3 Action Buttons Row: Homework, Attendance, Notice
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                label: 'Homework',
                icon: Icons.menu_book_rounded,
                onTap: () {
                  setState(() => _currentNavIndex = 2);
                },
              ),
              _buildActionButton(
                label: 'Attendance',
                icon: Icons.event_available_rounded,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MarkAttendanceScreen(initialClass: 'Class 6-A'),
                    ),
                  );
                  setState(() {});
                },
              ),
              _buildActionButton(
                label: 'Notice',
                icon: Icons.note_add_rounded,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NoticesDetailScreen()),
                  );
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // My Classes Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryOrange, width: 1.2),
              color: Colors.white,
            ),
            child: const Text(
              'My Classes',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Class-wise breakdown card (Light Lilac Container)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFFF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Class-wise breakdown',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _buildClassCard(
                  className: 'Class 6-A',
                  badgeText: 'Head teacher',
                  isOrangeBadge: true,
                  studentCount: 'Mathematics-32 students',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ClassStudentsScreen(
                          initialClass: 'Class 6-A',
                          showBackButton: true,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildClassCard(
                  className: 'Class 6-B',
                  badgeText: 'Class teacher',
                  isOrangeBadge: false,
                  studentCount: 'Mathematics-30 students',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ClassStudentsScreen(
                          initialClass: 'Class 6-B',
                          showBackButton: true,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildClassCard(
                  className: 'Class 7-A',
                  badgeText: 'Subject teacher',
                  isOrangeBadge: false,
                  studentCount: 'Mathematics-28 students',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ClassStudentsScreen(
                          initialClass: 'Class 7-A',
                          showBackButton: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      color: AppColors.primaryOrange,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'T',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(String time, String className, {bool isCurrent = false}) {
    return Container(
      width: 106,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrent
            ? Border.all(color: const Color(0xFF7F80DA), width: 2)
            : Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF7F80DA),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            className,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFF7F80DA),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7F80DA).withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 34),
                ),
              ),
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA366),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard({
    required String className,
    required String badgeText,
    required bool isOrangeBadge,
    required String studentCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        className,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: isOrangeBadge ? const Color(0xFFFFA366) : const Color(0xFF7F80DA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    studentCount,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFFA366),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
