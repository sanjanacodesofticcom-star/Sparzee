import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'firebase_service.dart';

/// Comprehensive Real-Time Database Service with Cloud Firestore integration
/// and reactive broadcast streams for instantaneous UI synchronization.
class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  // Internal reactive cache
  List<Student> _students = [];
  List<Teacher> _teachers = [];
  List<AdminUser> _admins = [];
  List<ActivityItemData> _activities = [];
  List<NoteItem> _notes = [];
  List<NoticeItem> _notices = [];
  final SchoolProfileData _schoolProfile = AppData.schoolProfile;

  // Real-time Stream Controllers
  final _studentsController = StreamController<List<Student>>.broadcast();
  final _teachersController = StreamController<List<Teacher>>.broadcast();
  final _adminsController = StreamController<List<AdminUser>>.broadcast();
  final _activitiesController = StreamController<List<ActivityItemData>>.broadcast();
  final _notesController = StreamController<List<NoteItem>>.broadcast();
  final _noticesController = StreamController<List<NoticeItem>>.broadcast();

  // Stream Getters
  Stream<List<Student>> get studentsStream => _studentsController.stream;
  Stream<List<Teacher>> get teachersStream => _teachersController.stream;
  Stream<List<AdminUser>> get adminsStream => _adminsController.stream;
  Stream<List<ActivityItemData>> get activitiesStream => _activitiesController.stream;
  Stream<List<NoteItem>> get notesStream => _notesController.stream;
  Stream<List<NoticeItem>> get noticesStream => _noticesController.stream;

  // Synchronous Getters
  List<Student> get students => List.unmodifiable(_students);
  List<Teacher> get teachers => List.unmodifiable(_teachers);
  List<AdminUser> get admins => List.unmodifiable(_admins);
  List<ActivityItemData> get activities => List.unmodifiable(_activities);
  List<NoteItem> get notes => List.unmodifiable(_notes);
  List<NoticeItem> get notices => List.unmodifiable(_notices);
  List<Student> get currentStudents => List.unmodifiable(_students);
  List<Teacher> get currentTeachers => List.unmodifiable(_teachers);
  List<AdminUser> get currentAdmins => List.unmodifiable(_admins);
  List<ActivityItemData> get currentActivities => List.unmodifiable(_activities);
  List<NoteItem> get currentNotes => List.unmodifiable(_notes);
  List<NoticeItem> get currentNotices => List.unmodifiable(_notices);
  SchoolProfileData get schoolProfile => _schoolProfile;

  // Real-Time Aggregate Computations
  int get totalStudentsCount => _students.length;
  int get totalTeachersCount => _teachers.length;
  int get totalAdminsCount => _admins.length;

  double get totalFeeCollectedAmount {
    return _students.fold(0.0, (acc, s) => acc + s.paidFee);
  }

  double get totalFeePendingAmount {
    return _students.fold(0.0, (acc, s) => acc + s.feeDue);
  }

  int get feeCollectionPercentage {
    final total = _students.fold(0.0, (acc, s) => acc + s.totalFee);
    final paid = totalFeeCollectedAmount;
    if (total == 0) return 76;
    return ((paid / total) * 100).round();
  }

  /// Initialize database listeners
  Future<void> initialize() async {
    // Populate initial dataset from AppData
    _students = List.from(AppData.students);
    _teachers = List.from(AppData.teachers);
    _admins = List.from(AppData.admins);
    _activities = List.from(AppData.recentActivities);
    _notes = List.from(AppData.notes);
    _notices = List.from(AppData.notices);

    _emitAll();

    // Attach Cloud Firestore listeners if Firebase is initialized
    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      _listenToFirestore(firestore);
    }
  }

  void _listenToFirestore(FirebaseFirestore firestore) {
    try {
      firestore.collection('students').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _students = snapshot.docs.map((doc) => _studentFromDoc(doc)).toList();
          _studentsController.add(List.unmodifiable(_students));
          AppData.students = _students;
        }
      }, onError: (e) => debugPrint('Firestore students listener: $e'));

      firestore.collection('teachers').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _teachers = snapshot.docs.map((doc) => _teacherFromDoc(doc)).toList();
          _teachersController.add(List.unmodifiable(_teachers));
          AppData.teachers = _teachers;
        }
      }, onError: (e) => debugPrint('Firestore teachers listener: $e'));

      firestore.collection('admins').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _admins = snapshot.docs.map((doc) => _adminFromDoc(doc)).toList();
          _adminsController.add(List.unmodifiable(_admins));
          AppData.admins = _admins;
        }
      }, onError: (e) => debugPrint('Firestore admins listener: $e'));

      firestore.collection('notes').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _notes = snapshot.docs.map((doc) => _noteFromDoc(doc)).toList();
          _notesController.add(List.unmodifiable(_notes));
          AppData.notes = _notes;
        }
      }, onError: (e) => debugPrint('Firestore notes listener: $e'));

      firestore.collection('activities').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _activities = snapshot.docs.map((doc) => _activityFromDoc(doc)).toList();
          _activitiesController.add(List.unmodifiable(_activities));
          AppData.recentActivities = _activities;
        }
      }, onError: (e) => debugPrint('Firestore activities listener: $e'));
    } catch (e) {
      debugPrint('Firestore listen setup error: $e');
    }
  }

  void _emitAll() {
    _studentsController.add(List.unmodifiable(_students));
    _teachersController.add(List.unmodifiable(_teachers));
    _adminsController.add(List.unmodifiable(_admins));
    _activitiesController.add(List.unmodifiable(_activities));
    _notesController.add(List.unmodifiable(_notes));
    _noticesController.add(List.unmodifiable(_notices));
    AppData.students = _students;
    AppData.teachers = _teachers;
    AppData.admins = _admins;
    AppData.notes = _notes;
    AppData.notices = _notices;
    AppData.recentActivities = _activities;
  }

  // -------------------------------------------------------------
  // STUDENT REAL-TIME MUTATIONS
  // -------------------------------------------------------------
  Future<void> addStudent(Student student) async {
    _students.insert(0, student);
    _logActivity('Added new student', student.name, 'to ${student.fullClass}', 'Just now');
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('students').doc(student.id).set(_studentToMap(student));
      } catch (e) {
        debugPrint('Firestore save student error: $e');
      }
    }
  }

  Future<void> updateStudent(Student student) async {
    final idx = _students.indexWhere((s) => s.id == student.id);
    if (idx != -1) {
      _students[idx] = student;
      _logActivity('Updated student profile for', student.name, '', 'Just now');
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('students').doc(student.id).set(_studentToMap(student));
        } catch (e) {
          debugPrint('Firestore update student error: $e');
        }
      }
    }
  }

  Future<void> deleteStudent(String studentId) async {
    _students.removeWhere((s) => s.id == studentId);
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('students').doc(studentId).delete();
      } catch (e) {
        debugPrint('Firestore delete student error: $e');
      }
    }
  }

  Future<void> transferStudentClass({
    required String studentId,
    required String newGrade,
    required String newSection,
    required String effectiveDate,
    required String reason,
  }) async {
    final idx = _students.indexWhere((s) => s.id == studentId);
    if (idx != -1) {
      final s = _students[idx];
      s.grade = newGrade;
      s.section = newSection;
      _students[idx] = s;
      _logActivity('Transferred student', s.name, 'to Class $newGrade-$newSection', 'Just now');
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('students').doc(studentId).update({
            'grade': newGrade,
            'section': newSection,
            'lastTransferredDate': effectiveDate,
            'transferReason': reason,
          });
        } catch (e) {
          debugPrint('Firestore transfer student error: $e');
        }
      }
    }
  }

  Future<void> recordFeePayment({
    required String studentId,
    required double amount,
    required String paymentMode,
    String? term,
  }) async {
    final idx = _students.indexWhere((s) => s.id == studentId);
    if (idx != -1) {
      final s = _students[idx];
      s.paidFee += amount;
      s.feeDue = (s.totalFee - s.paidFee).clamp(0.0, double.infinity);
      s.feeStatus = s.feeDue == 0 ? 'Paid' : 'Partial';

      final receiptName = 'Receipt - ${term ?? 'Term 3'} (₹${amount.toInt()})';
      if (!s.receipts.contains(receiptName)) {
        s.receipts.insert(0, receiptName);
      }

      _students[idx] = s;
      _logActivity('Recorded fee payment of ₹${amount.toInt()} for', s.name, 'via $paymentMode', 'Just now');
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('students').doc(studentId).set(_studentToMap(s));
          await firestore.collection('fees_transactions').add({
            'studentId': studentId,
            'studentName': s.name,
            'amount': amount,
            'paymentMode': paymentMode,
            'timestamp': FieldValue.serverTimestamp(),
            'term': term ?? 'Term 3',
          });
        } catch (e) {
          debugPrint('Firestore record fee error: $e');
        }
      }
    }
  }

  // -------------------------------------------------------------
  // TEACHER REAL-TIME MUTATIONS
  // -------------------------------------------------------------
  Future<void> addTeacher(Teacher teacher) async {
    _teachers.insert(0, teacher);
    _logActivity('Added teacher', teacher.name, '(${teacher.subject})', 'Just now');
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('teachers').doc(teacher.id).set(_teacherToMap(teacher));
      } catch (e) {
        debugPrint('Firestore add teacher error: $e');
      }
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    final idx = _teachers.indexWhere((t) => t.id == teacher.id);
    if (idx != -1) {
      _teachers[idx] = teacher;
      _logActivity('Updated teacher profile for', teacher.name, '', 'Just now');
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('teachers').doc(teacher.id).set(_teacherToMap(teacher));
        } catch (e) {
          debugPrint('Firestore update teacher error: $e');
        }
      }
    }
  }

  Future<void> deleteTeacher(String teacherId) async {
    _teachers.removeWhere((t) => t.id == teacherId);
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('teachers').doc(teacherId).delete();
      } catch (e) {
        debugPrint('Firestore delete teacher error: $e');
      }
    }
  }

  Future<void> reassignTeacherClass({
    required String teacherId,
    required String newClass,
    required String subject,
  }) async {
    final idx = _teachers.indexWhere((t) => t.id == teacherId);
    if (idx != -1) {
      final t = _teachers[idx];
      if (!t.assignedClasses.contains(newClass)) {
        t.assignedClasses.add(newClass);
      }
      t.classesAssignedCount = t.assignedClasses.length;
      t.classesHandled.add(TeacherClassSubject(className: newClass, subject: subject));
      _teachers[idx] = t;
      _logActivity('Reassigned teacher', t.name, 'to $newClass ($subject)', 'Just now');
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('teachers').doc(teacherId).set(_teacherToMap(t));
        } catch (e) {
          debugPrint('Firestore reassign teacher error: $e');
        }
      }
    }
  }

  // -------------------------------------------------------------
  // ADMIN REAL-TIME MUTATIONS
  // -------------------------------------------------------------
  Future<void> addAdmin(AdminUser admin) async {
    _admins.insert(0, admin);
    _logActivity('Added administrator', admin.name, '(${admin.role})', 'Just now');
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('admins').doc(admin.id).set(_adminToMap(admin));
      } catch (e) {
        debugPrint('Firestore add admin error: $e');
      }
    }
  }

  Future<void> updateAdmin(AdminUser admin) async {
    final idx = _admins.indexWhere((a) => a.id == admin.id);
    if (idx != -1) {
      _admins[idx] = admin;
      _logActivity('Updated administrator', admin.name, '', 'Just now');
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('admins').doc(admin.id).set(_adminToMap(admin));
        } catch (e) {
          debugPrint('Firestore update admin error: $e');
        }
      }
    }
  }

  Future<void> deleteAdmin(String adminId) async {
    _admins.removeWhere((a) => a.id == adminId);
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('admins').doc(adminId).delete();
      } catch (e) {
        debugPrint('Firestore delete admin error: $e');
      }
    }
  }

  // -------------------------------------------------------------
  // NOTES & NOTICES REAL-TIME MUTATIONS
  // -------------------------------------------------------------
  Future<void> addNote(NoteItem note) async {
    _notes.insert(0, note);
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('notes').doc(note.id).set({
          'id': note.id,
          'title': note.title,
          'content': note.content,
          'date': note.date,
          'isPinned': note.isPinned,
          'visibleTo': note.visibleTo,
        });
      } catch (e) {
        debugPrint('Firestore add note error: $e');
      }
    }
  }

  Future<void> updateNote(NoteItem note) async {
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx != -1) {
      _notes[idx] = note;
      _emitAll();

      final firestore = FirebaseService.firestore;
      if (firestore != null && FirebaseService.isInitialized) {
        try {
          await firestore.collection('notes').doc(note.id).set({
            'id': note.id,
            'title': note.title,
            'content': note.content,
            'date': note.date,
            'isPinned': note.isPinned,
            'visibleTo': note.visibleTo,
          });
        } catch (e) {
          debugPrint('Firestore update note error: $e');
        }
      }
    }
  }

  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((n) => n.id == noteId);
    _emitAll();

    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isInitialized) {
      try {
        await firestore.collection('notes').doc(noteId).delete();
      } catch (e) {
        debugPrint('Firestore delete note error: $e');
      }
    }
  }

  void _logActivity(String title, String highlight, String trailing, String timeAgo) {
    _activities.insert(
      0,
      ActivityItemData(
        title: '$title ',
        highlightText: highlight,
        trailingText: ' $trailing',
        timeAgo: timeAgo,
      ),
    );
  }

  // -------------------------------------------------------------
  // FIRESTORE SERIALIZERS / DESERIALIZERS
  // -------------------------------------------------------------
  Map<String, dynamic> _studentToMap(Student s) => {
        'id': s.id,
        'name': s.name,
        'grade': s.grade,
        'section': s.section,
        'admissionNo': s.admissionNo,
        'rollNo': s.rollNo,
        'avatarUrl': s.avatarUrl,
        'dateOfBirth': s.dateOfBirth,
        'classTeacher': s.classTeacher,
        'parentName': s.parentName,
        'parentPhone': s.parentPhone,
        'attendancePercentage': s.attendancePercentage,
        'feeStatus': s.feeStatus,
        'feeDue': s.feeDue,
        'totalFee': s.totalFee,
        'paidFee': s.paidFee,
        'isActive': s.isActive,
        'receipts': s.receipts,
      };

  Student _studentFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      grade: data['grade'] ?? '5',
      section: data['section'] ?? 'A',
      admissionNo: data['admissionNo'] ?? '',
      rollNo: data['rollNo'] ?? '',
      avatarUrl: data['avatarUrl'] ?? 'assets/images/student_avatar.png',
      dateOfBirth: data['dateOfBirth'] ?? '14 Mar 2016',
      classTeacher: data['classTeacher'] ?? 'Sana Kapoor',
      parentName: data['parentName'] ?? '',
      parentPhone: data['parentPhone'] ?? '',
      attendancePercentage: (data['attendancePercentage'] as num?)?.toDouble() ?? 98.0,
      feeStatus: data['feeStatus'] ?? 'Paid',
      feeDue: (data['feeDue'] as num?)?.toDouble() ?? 0.0,
      totalFee: (data['totalFee'] as num?)?.toDouble() ?? 48000.0,
      paidFee: (data['paidFee'] as num?)?.toDouble() ?? 48000.0,
      isActive: data['isActive'] ?? true,
      receipts: List<String>.from(data['receipts'] ?? ['Receipt - Term 3, 2026']),
    );
  }

  Map<String, dynamic> _teacherToMap(Teacher t) => {
        'id': t.id,
        'name': t.name,
        'subject': t.subject,
        'email': t.email,
        'phone': t.phone,
        'roleTitle': t.roleTitle,
        'assignedClasses': t.assignedClasses,
        'avatarUrl': t.avatarUrl,
        'isActive': t.isActive,
        'joiningDate': t.joiningDate,
        'classesAssignedCount': t.classesAssignedCount,
        'attendanceMarkedPercentage': t.attendanceMarkedPercentage,
      };

  Teacher _teacherFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Teacher(
      id: doc.id,
      name: data['name'] ?? '',
      subject: data['subject'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      roleTitle: data['roleTitle'] ?? 'Teacher',
      assignedClasses: List<String>.from(data['assignedClasses'] ?? []),
      avatarUrl: data['avatarUrl'] ?? 'assets/images/teacher_avatar.png',
      isActive: data['isActive'] ?? true,
      joiningDate: data['joiningDate'] ?? '12 Jun 2023',
      classesAssignedCount: data['classesAssignedCount'] ?? 3,
      attendanceMarkedPercentage: (data['attendanceMarkedPercentage'] as num?)?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> _adminToMap(AdminUser a) => {
        'id': a.id,
        'name': a.name,
        'email': a.email,
        'phone': a.phone,
        'role': a.role,
        'permissions': a.permissions,
        'branch': a.branch,
        'avatarUrl': a.avatarUrl,
        'isActive': a.isActive,
        'manageTeachers': a.manageTeachers,
        'manageStudents': a.manageStudents,
        'manageFees': a.manageFees,
        'postNotices': a.postNotices,
      };

  AdminUser _adminFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'Administrator',
      permissions: List<String>.from(data['permissions'] ?? []),
      branch: data['branch'] ?? 'All branches',
      avatarUrl: data['avatarUrl'],
      isActive: data['isActive'] ?? true,
      manageTeachers: data['manageTeachers'] ?? true,
      manageStudents: data['manageStudents'] ?? true,
      manageFees: data['manageFees'] ?? false,
      postNotices: data['postNotices'] ?? true,
    );
  }

  NoteItem _noteFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteItem(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      isPinned: data['isPinned'] ?? false,
      visibleTo: data['visibleTo'] ?? 'All management & admins',
    );
  }

  ActivityItemData _activityFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityItemData(
      title: data['title'] ?? '',
      highlightText: data['highlightText'] ?? '',
      trailingText: data['trailingText'] ?? '',
      timeAgo: data['timeAgo'] ?? 'Just now',
    );
  }
}
