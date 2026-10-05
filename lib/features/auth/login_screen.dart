import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../management/management_dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../teacher/teacher_dashboard_screen.dart';
import '../student/student_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole selectedRole;

  const LoginScreen({super.key, required this.selectedRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final defaultUser = AppData.allowedUsers[widget.selectedRole];
    if (defaultUser != null) {
      _mobileController.text = defaultUser.phone;
      _passwordController.text = '123456';
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final inputPhone = _mobileController.text.trim();
    final inputPassword = _passwordController.text.trim();

    if (inputPhone.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your registered mobile number.';
      });
      return;
    }

    if (inputPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final validatedUser = AppData.validateUser(widget.selectedRole, inputPhone);

    if (validatedUser == null) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Invalid credentials or unauthorized mobile number for ${widget.selectedRole.displayName}.';
      });
      return;
    }

    AppData.currentUser = validatedUser;
    setState(() => _isLoading = false);

    Widget destination;
    switch (widget.selectedRole) {
      case UserRole.management:
        destination = const ManagementDashboardScreen();
        break;
      case UserRole.admin:
        destination = const AdminDashboardScreen();
        break;
      case UserRole.teacher:
        destination = const TeacherDashboardScreen();
        break;
      case UserRole.student:
        destination = const StudentDashboardScreen();
        break;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleName = widget.selectedRole.displayName;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpargeeBackButton(),
              const SizedBox(height: 32),

              // Title: Welcome back
              RichText(
                text: TextSpan(
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: 'Welcome ',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(
                      text: 'back',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                  children: [
                    const TextSpan(text: 'Log in as '),
                    TextSpan(
                      text: '$roleName\n',
                      style: const TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: 'using your registered mobile number'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Input 1: Mobile Number (empty by default)
              SpargeeTextField(
                label: 'Mobile Number',
                hintText: 'Enter 10-digit mobile number',
                controller: _mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),

              // Input 2: Password (empty by default)
              SpargeeTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onTogglePassword: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.statusAbsentBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.statusAbsent),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.statusAbsent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.statusAbsent,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset link sent to registered phone.')),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Primary Button
              SpargeePrimaryButton(
                text: 'Get Started',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
