import 'package:flutter/material.dart';

enum UserRole {
  management,
  admin,
  teacher,
  student;

  String get displayName {
    switch (this) {
      case UserRole.management:
        return 'Management';
      case UserRole.admin:
        return 'Admin';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.student:
        return 'Student';
    }
  }
}

class AppUser {
  final UserRole role;
  String name;
  String phone;
  String email;
  String? avatarUrl;
  String designation;
  String schoolName;

  AppUser({
    required this.role,
    required this.name,
    required this.phone,
    required this.email,
    this.avatarUrl,
    required this.designation,
    this.schoolName = 'Little Scholar',
  });

  AppUser copyWith({
    UserRole? role,
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    String? designation,
    String? schoolName,
  }) {
    return AppUser(
      role: role ?? this.role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      designation: designation ?? this.designation,
      schoolName: schoolName ?? this.schoolName,
    );
  }
}

class TermFeeRecord {
  final String term;
  final String date;
  final String status; // 'Paid', 'Partial', 'Due'

  TermFeeRecord({required this.term, required this.date, required this.status});
}

class TeacherClassSubject {
  final String className;
  final String subject;

  TeacherClassSubject({required this.className, required this.subject});
}

class Student {
  final String id;
  String name;
  String grade;
  String section;
  String admissionNo;
  String rollNo;
  String? avatarUrl;
  String dateOfBirth;
  String classTeacher;
  String parentName;
  String parentPhone;
  double attendancePercentage;
  String feeStatus; // 'Paid', 'Partial', 'Pending', 'Due'
  double feeDue;
  double totalFee;
  double paidFee;
  List<TermFeeRecord> feeHistory;
  List<String> receipts;
  bool isActive;

  Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.admissionNo,
    required this.rollNo,
    this.avatarUrl = 'assets/images/student_avatar.png',
    this.dateOfBirth = '14 Mar 2016',
    this.classTeacher = 'Sana Kapoor',
    this.parentName = 'Nikhil Kapoor',
    this.parentPhone = '9876543210',
    this.attendancePercentage = 98.0,
    this.feeStatus = 'Partial',
    this.feeDue = 18000.0,
    this.totalFee = 48000.0,
    this.paidFee = 30000.0,
    List<TermFeeRecord>? feeHistory,
    List<String>? receipts,
    this.isActive = true,
  })  : feeHistory = feeHistory ?? [
          TermFeeRecord(term: 'Term 1, 2026', date: '8 Apr, 2026', status: 'Paid'),
          TermFeeRecord(term: 'Term 2, 2026', date: '8 Apr, 2026', status: 'Paid'),
          TermFeeRecord(term: 'Term 3, 2026', date: '8 Apr, 2026', status: 'Partial'),
        ],
        receipts = receipts ?? ['Receipt - Term 3, 2026'];

  String get fullClass => 'Class $grade-$section';
  String get className => 'Class $grade';

  Student copyWith({
    String? id,
    String? name,
    String? grade,
    String? section,
    String? admissionNo,
    String? rollNo,
    String? avatarUrl,
    String? dateOfBirth,
    String? classTeacher,
    String? parentName,
    String? parentPhone,
    double? attendancePercentage,
    String? feeStatus,
    double? feeDue,
    double? totalFee,
    double? paidFee,
    List<TermFeeRecord>? feeHistory,
    List<String>? receipts,
    bool? isActive,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      admissionNo: admissionNo ?? this.admissionNo,
      rollNo: rollNo ?? this.rollNo,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      classTeacher: classTeacher ?? this.classTeacher,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      feeStatus: feeStatus ?? this.feeStatus,
      feeDue: feeDue ?? this.feeDue,
      totalFee: totalFee ?? this.totalFee,
      paidFee: paidFee ?? this.paidFee,
      feeHistory: feeHistory ?? List.from(this.feeHistory),
      receipts: receipts ?? List.from(this.receipts),
      isActive: isActive ?? this.isActive,
    );
  }
}

class Teacher {
  final String id;
  String name;
  String subject;
  String email;
  String phone;
  String roleTitle;
  List<String> assignedClasses;
  String? avatarUrl;
  bool isActive;
  String joiningDate;
  int classesAssignedCount;
  double attendanceMarkedPercentage;
  List<TeacherClassSubject> classesHandled;
  List<ActivityItemData> recentActivities;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.email,
    required this.phone,
    required this.roleTitle,
    required this.assignedClasses,
    this.avatarUrl = 'assets/images/teacher_avatar.png',
    this.isActive = true,
    this.joiningDate = '12 Jun 2023',
    this.classesAssignedCount = 3,
    this.attendanceMarkedPercentage = 100.0,
    List<TeacherClassSubject>? classesHandled,
    List<ActivityItemData>? recentActivities,
  })  : classesHandled = classesHandled ?? [
          TeacherClassSubject(className: 'Class 6-A', subject: 'Mathematics'),
          TeacherClassSubject(className: 'Class 6-B', subject: 'Mathematics'),
          TeacherClassSubject(className: 'Class 7-A', subject: 'Mathematics'),
        ],
        recentActivities = recentActivities ?? [
          ActivityItemData(title: 'Assigned homework to Class 6-A', highlightText: '', trailingText: '', timeAgo: '2h ago'),
          ActivityItemData(title: 'Marked attendance for Class 7-A', highlightText: '', trailingText: '', timeAgo: 'Yesterday'),
          ActivityItemData(title: 'Marked attendance for Class 7-A', highlightText: '', trailingText: '', timeAgo: 'Yesterday'),
          ActivityItemData(title: 'Assigned homework to Class 6-A', highlightText: '', trailingText: '', timeAgo: '2h ago'),
        ];

  Teacher copyWith({
    String? id,
    String? name,
    String? subject,
    String? email,
    String? phone,
    String? roleTitle,
    List<String>? assignedClasses,
    String? avatarUrl,
    bool? isActive,
    String? joiningDate,
    int? classesAssignedCount,
    double? attendanceMarkedPercentage,
    List<TeacherClassSubject>? classesHandled,
    List<ActivityItemData>? recentActivities,
  }) {
    return Teacher(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      roleTitle: roleTitle ?? this.roleTitle,
      assignedClasses: assignedClasses ?? List.from(this.assignedClasses),
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      joiningDate: joiningDate ?? this.joiningDate,
      classesAssignedCount: classesAssignedCount ?? this.classesAssignedCount,
      attendanceMarkedPercentage: attendanceMarkedPercentage ?? this.attendanceMarkedPercentage,
      classesHandled: classesHandled ?? List.from(this.classesHandled),
      recentActivities: recentActivities ?? List.from(this.recentActivities),
    );
  }
}

class AdminUser {
  final String id;
  String name;
  String email;
  String phone;
  String role;
  List<String> permissions;
  String branch;
  String? avatarUrl;
  bool isActive;
  bool manageTeachers;
  bool manageStudents;
  bool manageFees;
  bool postNotices;
  List<ActivityItemData> recentActivities;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.permissions,
    this.branch = 'All branches',
    this.avatarUrl,
    this.isActive = true,
    this.manageTeachers = true,
    this.manageStudents = true,
    this.manageFees = false,
    this.postNotices = true,
    List<ActivityItemData>? recentActivities,
  }) : recentActivities = recentActivities ?? [
          ActivityItemData(title: 'Assigned homework to Class 6-A', highlightText: '', trailingText: '', timeAgo: '2h ago'),
          ActivityItemData(title: 'Marked attendance for Class 7-A', highlightText: '', trailingText: '', timeAgo: 'Yesterday'),
        ];

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    List<String>? permissions,
    String? branch,
    String? avatarUrl,
    bool? isActive,
    bool? manageTeachers,
    bool? manageStudents,
    bool? manageFees,
    bool? postNotices,
    List<ActivityItemData>? recentActivities,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      permissions: permissions ?? List.from(this.permissions),
      branch: branch ?? this.branch,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      manageTeachers: manageTeachers ?? this.manageTeachers,
      manageStudents: manageStudents ?? this.manageStudents,
      manageFees: manageFees ?? this.manageFees,
      postNotices: postNotices ?? this.postNotices,
      recentActivities: recentActivities ?? List.from(this.recentActivities),
    );
  }
}

class HomeworkItem {
  final String id;
  final String subject;
  final String teacherName;
  final String title;
  final String instructions;
  final String attachmentName;
  final String dueDate;
  final bool isDueToday;
  final bool isCompleted;
  final String assignedClass;
  final int totalStudents;
  final int submittedCount;

  HomeworkItem({
    required this.id,
    required this.subject,
    required this.teacherName,
    required this.title,
    required this.instructions,
    this.attachmentName = 'Assignment_Doc.pdf',
    required this.dueDate,
    this.isDueToday = true,
    this.isCompleted = false,
    this.assignedClass = 'Class 5-A',
    this.totalStudents = 1,
    this.submittedCount = 0,
  });
}

enum AttendanceStatus { present, absent, leave }

class AttendanceRecord {
  final DateTime date;
  final AttendanceStatus status;

  AttendanceRecord({required this.date, required this.status});
}

class NoticeItem {
  final String id;
  final String title;
  final String category; // 'Holidays', 'Events', 'General'
  final String timeAgo;
  final String date;

  NoticeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.timeAgo,
    required this.date,
  });
}

class NoteItem {
  final String id;
  String title;
  String content;
  String date;
  bool isPinned;
  String visibleTo;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.isPinned = false,
    this.visibleTo = 'All management & admins',
  });

  NoteItem copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    bool? isPinned,
    String? visibleTo,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      isPinned: isPinned ?? this.isPinned,
      visibleTo: visibleTo ?? this.visibleTo,
    );
  }
}

class ActivityItemData {
  final String title;
  final String highlightText;
  final String trailingText;
  final String timeAgo;

  ActivityItemData({
    required this.title,
    required this.highlightText,
    required this.trailingText,
    required this.timeAgo,
  });
}

class SchoolProfileData {
  String name;
  String tagline;
  String affiliationNo;
  String board;
  String establishedYear;
  String principalName;
  String email;
  String phone;
  String address;
  String website;
  String academicSession;

  SchoolProfileData({
    required this.name,
    required this.tagline,
    required this.affiliationNo,
    required this.board,
    required this.establishedYear,
    required this.principalName,
    required this.email,
    required this.phone,
    required this.address,
    required this.website,
    required this.academicSession,
  });
}

class ClassSectionItem {
  String className;
  String section;
  int studentCount;
  String classTeacher;
  String roomNo;

  ClassSectionItem({
    required this.className,
    required this.section,
    required this.studentCount,
    required this.classTeacher,
    required this.roomNo,
  });
}

class FeeTemplateItem {
  String id;
  String title;
  double amount;
  String frequency;
  String dueDate;
  String description;
  String applicableGrades;

  FeeTemplateItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.frequency,
    required this.dueDate,
    required this.description,
    required this.applicableGrades,
  });
}

class NoticeCategoryItem {
  String id;
  String name;
  String description;
  Color badgeColor;
  bool isEnabled;

  NoticeCategoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.badgeColor,
    this.isEnabled = true,
  });
}

class NotificationPreferencesData {
  bool pushNotifications;
  bool smsAlerts;
  bool whatsappUpdates;
  bool feeDueAlerts;
  bool attendanceAlerts;
  bool examAnnouncements;
  bool dailySummary;

  NotificationPreferencesData({
    this.pushNotifications = true,
    this.smsAlerts = true,
    this.whatsappUpdates = false,
    this.feeDueAlerts = true,
    this.attendanceAlerts = true,
    this.examAnnouncements = true,
    this.dailySummary = true,
  });
}

/// Central Real Data Store & Authentication Manager
class AppData {
  // Allowed Users Map
  static final Map<UserRole, AppUser> allowedUsers = {
    UserRole.management: AppUser(
      role: UserRole.management,
      name: 'Rohan Gupta',
      phone: '9876500001',
      email: 'rohan.gupta@spargee.edu',
      designation: 'Management - Little Scholar',
      schoolName: 'Little Scholar',
      avatarUrl: 'assets/images/management_avatar.png',
    ),
    UserRole.admin: AppUser(
      role: UserRole.admin,
      name: 'Priya Sharma',
      phone: '9876500002',
      email: 'priya.sharma@spargee.edu',
      designation: 'Chief Administrator',
      schoolName: 'Little Scholar',
    ),
    UserRole.teacher: AppUser(
      role: UserRole.teacher,
      name: 'Amandeep Singh',
      phone: '9876500003',
      email: 'amandeep.singh@spargee.edu',
      avatarUrl: 'assets/images/teacher_avatar.png',
      designation: 'Senior Teacher • Mathematics',
      schoolName: 'Little Scholar',
    ),
    UserRole.student: AppUser(
      role: UserRole.student,
      name: 'Aarav Mehta',
      phone: '9876500004',
      email: 'aarav.mehta@spargee.edu',
      avatarUrl: 'assets/images/student_avatar.png',
      designation: 'Class 5-C • Adm.LS-2026-0318',
      schoolName: 'Little Scholar',
    ),
  };

  static AppUser? currentUser;

  /// Check if the phone number is allowed for the chosen role
  static AppUser? validateUser(UserRole role, String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final allowed = allowedUsers[role];
    if (allowed != null && cleanPhone == allowed.phone) {
      return allowed;
    }
    return null;
  }

  // School Profile Data
  static SchoolProfileData schoolProfile = SchoolProfileData(
    name: 'Little Scholar International School',
    tagline: 'Inspiring Excellence & Character Since 2008',
    affiliationNo: 'CBSE / AFF-1930281',
    board: 'CBSE (Central Board of Secondary Education)',
    establishedYear: '2008',
    principalName: 'Dr. Sunita Sharma (Ph.D., M.Ed.)',
    email: 'contact@littlescholar.edu',
    phone: '+91 98765 00001',
    address: 'Plot 42, Knowledge Boulevard, Sector 62, Noida, UP - 201309',
    website: 'https://littlescholar.spargee.edu',
    academicSession: '2026 - 2027 (Term 2)',
  );

  // Real-Time Collections
  static List<Teacher> teachers = [
    Teacher(
      id: 'T0',
      name: 'Sedha',
      subject: 'Mathematics',
      email: 'sedhaschool@gmail.com',
      phone: '9876543210',
      roleTitle: 'Senior Teacher',
      assignedClasses: ['Class 6-A', 'Class 6-B', 'Class 7-A'],
      avatarUrl: 'assets/images/teacher_avatar.png',
      joiningDate: '12 Jun 2023',
      classesAssignedCount: 3,
      attendanceMarkedPercentage: 100.0,
    ),
    Teacher(
      id: 'T1',
      name: 'Amandeep Singh',
      subject: 'Mathematics',
      email: 'amandeep.singh@spargee.edu',
      phone: '9876500003',
      roleTitle: 'Senior Teacher',
      assignedClasses: ['Class 5-A', 'Class 6-A'],
      avatarUrl: 'assets/images/teacher_avatar.png',
    ),
    Teacher(
      id: 'T2',
      name: 'Kavita Verma',
      subject: 'Science & Physics',
      email: 'kavita.verma@spargee.edu',
      phone: '9876500012',
      roleTitle: 'Department Head',
      assignedClasses: ['Class 8-A', 'Class 9-B'],
    ),
    Teacher(
      id: 'T3',
      name: 'Rajesh Kumar',
      subject: 'English Literature',
      email: 'rajesh.kumar@spargee.edu',
      phone: '9876500013',
      roleTitle: 'Senior Teacher',
      assignedClasses: ['Class 6-B', 'Class 7-A'],
    ),
    Teacher(
      id: 'T4',
      name: 'Meenakshi Sundaram',
      subject: 'Computer Science & AI',
      email: 'meenakshi.s@spargee.edu',
      phone: '9876500014',
      roleTitle: 'Lab Incharge',
      assignedClasses: ['Class 9-A', 'Class 10-A'],
    ),
  ];

  static int totalStudentsCount = 318;
  static int totalTeachersCount = 24;
  static int totalAdminsCount = 5;
  static int feeCollectionPercentage = 76;

  static List<Student> students = [
    Student(
      id: 'S0',
      name: 'Aarav Mehta',
      grade: '5',
      section: 'C',
      admissionNo: 'LS-2026-0318',
      rollNo: '01',
      avatarUrl: 'assets/images/student_avatar.png',
      dateOfBirth: '14 Mar 2016',
      classTeacher: 'Sana Kapoor',
      parentName: 'Deepak Mehta',
      parentPhone: '9876543210',
      attendancePercentage: 98.0,
      feeStatus: 'Partial',
      totalFee: 48000.0,
      paidFee: 24000.0,
      feeDue: 24000.0,
    ),
    Student(
      id: 'S_PV',
      name: 'Priya Verma',
      grade: '5',
      section: 'C',
      admissionNo: 'LS-2026-0318',
      rollNo: '04',
      avatarUrl: 'assets/images/student_avatar.png',
      dateOfBirth: '14 Mar 2016',
      classTeacher: 'Sana Kapoor',
      parentName: 'Nikhil Verma',
      parentPhone: '9876543210',
      attendancePercentage: 98.0,
      feeStatus: 'Partial',
      totalFee: 48000.0,
      paidFee: 30000.0,
      feeDue: 18000.0,
    ),
    Student(
      id: 'S_AM',
      name: 'Aarav Mehta',
      grade: '5',
      section: 'A',
      admissionNo: 'LS-2026-0102',
      rollNo: '01',
      avatarUrl: 'assets/images/student_avatar.png',
      dateOfBirth: '10 Feb 2016',
      classTeacher: 'Sana Kapoor',
      parentName: 'Deepak Mehta',
      parentPhone: '9876500021',
      attendancePercentage: 99.0,
      feeStatus: 'Paid',
      totalFee: 45000.0,
      paidFee: 45000.0,
      feeDue: 0.0,
    ),
    Student(
      id: 'S_SY',
      name: 'Siya Yadav',
      grade: '5',
      section: 'A',
      admissionNo: 'LS-2026-0105',
      rollNo: '02',
      avatarUrl: 'assets/images/student_avatar.png',
      dateOfBirth: '18 May 2016',
      classTeacher: 'Sana Kapoor',
      parentName: 'Suresh Yadav',
      parentPhone: '9876500022',
      attendancePercentage: 97.0,
      feeStatus: 'Paid',
      totalFee: 45000.0,
      paidFee: 45000.0,
      feeDue: 0.0,
    ),
    Student(
      id: 'S_KR',
      name: 'Kabir Rao',
      grade: '5',
      section: 'B',
      admissionNo: 'LS-2026-0201',
      rollNo: '05',
      avatarUrl: 'assets/images/student_avatar.png',
      dateOfBirth: '22 Jul 2016',
      classTeacher: 'Sana Kapoor',
      parentName: 'Ramesh Rao',
      parentPhone: '9876500023',
      attendancePercentage: 92.0,
      feeStatus: 'Paid',
      totalFee: 45000.0,
      paidFee: 45000.0,
      feeDue: 0.0,
    ),
    Student(
      id: 'S1',
      name: 'Simran Kaur',
      grade: '5',
      section: 'A',
      admissionNo: 'SK-2026-0001',
      rollNo: '06',
      avatarUrl: 'assets/images/student_avatar.png',
      dateOfBirth: '12 Aug 2016',
      classTeacher: 'Amandeep Singh',
      parentName: 'Harpreet Kaur',
      parentPhone: '9876500004',
      attendancePercentage: 100.0,
      feeStatus: 'Paid',
      totalFee: 45000.0,
      paidFee: 45000.0,
      feeDue: 0.0,
    ),
    Student(
      id: 'S2',
      name: 'Aarav Patel',
      grade: '6',
      section: 'A',
      admissionNo: 'AP-2026-0042',
      rollNo: '07',
      dateOfBirth: '15 Jan 2015',
      classTeacher: 'Amandeep Singh',
      parentName: 'Deepak Patel',
      parentPhone: '9876500021',
      attendancePercentage: 94.5,
      feeStatus: 'Due',
      totalFee: 48000.0,
      paidFee: 24000.0,
      feeDue: 24000.0,
    ),
    Student(
      id: 'S3',
      name: 'Ananya Sharma',
      grade: '8',
      section: 'B',
      admissionNo: 'AS-2026-0089',
      rollNo: '08',
      dateOfBirth: '09 Nov 2013',
      classTeacher: 'Kavita Verma',
      parentName: 'Manoj Sharma',
      parentPhone: '9876500032',
      attendancePercentage: 98.0,
      feeStatus: 'Paid',
      totalFee: 45000.0,
      paidFee: 45000.0,
      feeDue: 0.0,
    ),
  ];

  static List<AdminUser> admins = [
    AdminUser(
      id: 'A0',
      name: 'Sujata Sharma',
      email: 'sujadmin@gmail.com',
      phone: '9876543210',
      role: 'Admin - All branches',
      permissions: ['Manage Students', 'Manage Teachers', 'Fee Records', 'Notices'],
      branch: 'All branches',
      manageTeachers: true,
      manageStudents: true,
      manageFees: false,
      postNotices: true,
    ),
    AdminUser(
      id: 'A1',
      name: 'Priya Sharma',
      email: 'priya.sharma@spargee.edu',
      phone: '9876500002',
      role: 'Chief Administrator',
      permissions: ['Manage Students', 'Manage Teachers', 'Fee Records', 'Notices', 'System Config'],
    ),
    AdminUser(
      id: 'A2',
      name: 'Vikram Joshi',
      email: 'vikram.joshi@spargee.edu',
      phone: '9876500008',
      role: 'Accounts Admin',
      permissions: ['Fee Records', 'Invoicing', 'Expense Reports'],
    ),
  ];

  static List<HomeworkItem> homeworks = [
    HomeworkItem(
      id: 'HW1',
      subject: 'Mathematics',
      teacherName: 'Sedha',
      title: 'Fraction Practice',
      instructions: 'Complete exercises 4.1 to 4.3 on fractions and decimals with neat working steps.',
      attachmentName: 'Fraction_Practice_Ch4.pdf',
      dueDate: 'Due 22 sep',
      assignedClass: 'Class 6-A',
      totalStudents: 32,
      submittedCount: 18,
      isDueToday: true,
    ),
    HomeworkItem(
      id: 'HW2',
      subject: 'Mathematics',
      teacherName: 'Sedha',
      title: 'Geometry worksheet',
      instructions: 'Solve angle bisector and polygon construction problems in notebook.',
      attachmentName: 'Geometry_Worksheet_Ch7.pdf',
      dueDate: 'Due 21 sep',
      assignedClass: 'Class 7-A',
      totalStudents: 30,
      submittedCount: 14,
      isDueToday: false,
    ),
  ];

  static List<NoticeItem> notices = [
    NoticeItem(
      id: 'N1',
      title: 'Follow up with Class 6-A parents on Term 2 dues before Oct 10',
      category: 'General',
      timeAgo: '2h ago',
      date: '05 Oct 2026',
    ),
    NoticeItem(
      id: 'N2',
      title: 'Science lab equipment order pending for Class 8 - check with vendor',
      category: 'Events',
      timeAgo: '4h ago',
      date: '05 Oct 2026',
    ),
    NoticeItem(
      id: 'N3',
      title: 'Science lab equipment order pending for Class 8 - check with vendor',
      category: 'Events',
      timeAgo: '1d ago',
      date: '04 Oct 2026',
    ),
    NoticeItem(
      id: 'N4',
      title: 'Follow up with Class 6-A parents on Term 2 dues before Oct 10',
      category: 'Holidays',
      timeAgo: '2d ago',
      date: '03 Oct 2026',
    ),
    NoticeItem(
      id: 'N5',
      title: 'Science lab equipment order pending for Class 8 - check with vendor',
      category: 'General',
      timeAgo: '3d ago',
      date: '02 Oct 2026',
    ),
  ];

  // Default notes matching exact screenshot design
  static List<NoteItem> notes = [
    NoteItem(
      id: 'NT1',
      title: 'Class 6-A Parents Dues',
      content: 'Follow up with Class 6-A parents on Term 2 dues before Oct 10',
      date: '05/10/2026',
      isPinned: true,
      visibleTo: 'All management & admins',
    ),
    NoteItem(
      id: 'NT2',
      title: 'Science Lab Equipment',
      content: 'Science lab equipment order pending for Class 8 - check with vendor',
      date: '04/10/2026',
      isPinned: true,
      visibleTo: 'All management & admins',
    ),
    NoteItem(
      id: 'NT3',
      title: 'Science Lab Equipment (Secondary)',
      content: 'Science lab equipment order pending for Class 8 - check with vendor',
      date: '03/10/2026',
      isPinned: false,
      visibleTo: 'All management & admins',
    ),
  ];

  // Class & Section Structure Dummy Data
  static List<ClassSectionItem> classSections = [
    ClassSectionItem(className: 'Class 1', section: 'A', studentCount: 32, classTeacher: 'Neeta Kapoor', roomNo: 'Room 101'),
    ClassSectionItem(className: 'Class 2', section: 'A', studentCount: 35, classTeacher: 'Sangeeta Roy', roomNo: 'Room 102'),
    ClassSectionItem(className: 'Class 3', section: 'A', studentCount: 34, classTeacher: 'Pooja Bhatia', roomNo: 'Room 103'),
    ClassSectionItem(className: 'Class 4', section: 'B', studentCount: 38, classTeacher: 'Suresh Raina', roomNo: 'Room 104'),
    ClassSectionItem(className: 'Class 5', section: 'A', studentCount: 40, classTeacher: 'Amandeep Singh', roomNo: 'Room 201'),
    ClassSectionItem(className: 'Class 6', section: 'A', studentCount: 36, classTeacher: 'Amandeep Singh', roomNo: 'Room 202'),
    ClassSectionItem(className: 'Class 6', section: 'B', studentCount: 35, classTeacher: 'Rajesh Kumar', roomNo: 'Room 203'),
    ClassSectionItem(className: 'Class 7', section: 'A', studentCount: 37, classTeacher: 'Rajesh Kumar', roomNo: 'Room 204'),
    ClassSectionItem(className: 'Class 8', section: 'A', studentCount: 33, classTeacher: 'Kavita Verma', roomNo: 'Room 301'),
    ClassSectionItem(className: 'Class 9', section: 'A', studentCount: 38, classTeacher: 'Meenakshi Sundaram', roomNo: 'Room 302'),
    ClassSectionItem(className: 'Class 10', section: 'A', studentCount: 39, classTeacher: 'Anurag Mishra', roomNo: 'Room 303'),
  ];

  // Fee Structure Templates
  static List<FeeTemplateItem> feeTemplates = [
    FeeTemplateItem(
      id: 'FT1',
      title: 'Term 1 Composite Tuition Fee',
      amount: 35000,
      frequency: 'Quarterly',
      dueDate: '15 Apr 2026',
      description: 'Includes tuition, digital classrooms, library access & laboratory maintenance.',
      applicableGrades: 'Class 1 to 12',
    ),
    FeeTemplateItem(
      id: 'FT2',
      title: 'Term 2 Composite Tuition Fee',
      amount: 35000,
      frequency: 'Quarterly',
      dueDate: '10 Oct 2026',
      description: 'Term 2 academic session charges, co-curriculars & examination fees.',
      applicableGrades: 'Class 1 to 12',
    ),
    FeeTemplateItem(
      id: 'FT3',
      title: 'AC Bus Transport Fee (Zone 1)',
      amount: 3800,
      frequency: 'Monthly',
      dueDate: '05 Every Month',
      description: 'GPS-enabled air-conditioned bus transport within 5 km radius.',
      applicableGrades: 'All Opted Students',
    ),
    FeeTemplateItem(
      id: 'FT4',
      title: 'Robotics & AI Innovation Lab Fee',
      amount: 4500,
      frequency: 'Half-Yearly',
      dueDate: '20 Jul 2026',
      description: 'Advanced STEM kits, 3D printing & AI programming workshop kits.',
      applicableGrades: 'Class 6 to 10',
    ),
    FeeTemplateItem(
      id: 'FT5',
      title: 'Annual Sports & Activity Fee',
      amount: 6000,
      frequency: 'Annual',
      dueDate: '01 May 2026',
      description: 'Swimming coaching, basketball academy, martial arts & annual athletic meet.',
      applicableGrades: 'Class 1 to 12',
    ),
  ];

  // Notice Categories
  static List<NoticeCategoryItem> noticeCategories = [
    NoticeCategoryItem(
      id: 'NC1',
      name: 'Academic & Curriculum',
      description: 'Syllabus updates, project submissions, timetable changes.',
      badgeColor: const Color(0xFF7F80DA),
      isEnabled: true,
    ),
    NoticeCategoryItem(
      id: 'NC2',
      name: 'Examinations & Results',
      description: 'Date sheets, admit cards, report card publication dates.',
      badgeColor: const Color(0xFFF28B45),
      isEnabled: true,
    ),
    NoticeCategoryItem(
      id: 'NC3',
      name: 'Sports & Co-Curricular',
      description: 'Inter-school competitions, club activities, athletic meets.',
      badgeColor: const Color(0xFF27AE60),
      isEnabled: true,
    ),
    NoticeCategoryItem(
      id: 'NC4',
      name: 'Holidays & Scheduled Breaks',
      description: 'Gazetted holidays, vacation announcements, bad weather alerts.',
      badgeColor: const Color(0xFF0284C7),
      isEnabled: true,
    ),
    NoticeCategoryItem(
      id: 'NC5',
      name: 'Urgent Management Alerts',
      description: 'Parent-teacher conferences, security protocols, administrative changes.',
      badgeColor: const Color(0xFFEB5757),
      isEnabled: true,
    ),
    NoticeCategoryItem(
      id: 'NC6',
      name: 'Fee Deadlines & Reminders',
      description: 'Quarterly dues notifications, late fee alerts, discount schemes.',
      badgeColor: const Color(0xFFF1C40F),
      isEnabled: true,
    ),
  ];

  // Notification Preferences
  static NotificationPreferencesData notificationPreferences = NotificationPreferencesData();

  // Recent Activities
  static List<ActivityItemData> recentActivities = [
    ActivityItemData(
      title: 'Admin Priya added ',
      highlightText: '9 students',
      trailingText: ' to Class 4-B',
      timeAgo: '- 2h ago',
    ),
    ActivityItemData(
      title: 'Teacher Sana marked attendance',
      highlightText: '',
      trailingText: '',
      timeAgo: '- 4h ago',
    ),
  ];

  static void addActivity({
    required String title,
    required String highlightText,
    required String trailingText,
  }) {
    recentActivities.insert(
      0,
      ActivityItemData(
        title: title,
        highlightText: highlightText,
        trailingText: trailingText,
        timeAgo: 'Just now',
      ),
    );
  }
}

// Backward compatibility alias
typedef MockData = AppData;
