import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class SchoolProfileScreen extends StatefulWidget {
  const SchoolProfileScreen({super.key});

  @override
  State<SchoolProfileScreen> createState() => _SchoolProfileScreenState();
}

class _SchoolProfileScreenState extends State<SchoolProfileScreen> {
  void _openEditSchoolDialog() {
    final nameCtrl = TextEditingController(text: AppData.schoolProfile.name);
    final tagCtrl = TextEditingController(text: AppData.schoolProfile.tagline);
    final affCtrl = TextEditingController(text: AppData.schoolProfile.affiliationNo);
    final boardCtrl = TextEditingController(text: AppData.schoolProfile.board);
    final princCtrl = TextEditingController(text: AppData.schoolProfile.principalName);
    final phoneCtrl = TextEditingController(text: AppData.schoolProfile.phone);
    final emailCtrl = TextEditingController(text: AppData.schoolProfile.email);
    final addrCtrl = TextEditingController(text: AppData.schoolProfile.address);
    final webCtrl = TextEditingController(text: AppData.schoolProfile.website);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit School Profile', style: AppTextStyles.titleMedium),
                const SizedBox(height: 16),
                SpargeeTextField(label: 'School Name', hintText: 'School Name', controller: nameCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Motto / Tagline', hintText: 'Tagline', controller: tagCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Affiliation No.', hintText: 'e.g. CBSE 1930281', controller: affCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Board', hintText: 'e.g. CBSE / ICSE', controller: boardCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Principal Name', hintText: 'Principal', controller: princCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Contact Phone', hintText: 'Phone', controller: phoneCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Official Email', hintText: 'Email', controller: emailCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Campus Address', hintText: 'Address', controller: addrCtrl, maxLines: 2),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Website', hintText: 'Website URL', controller: webCtrl),
                const SizedBox(height: 20),
                SpargeePrimaryButton(
                  text: 'Save Details',
                  onPressed: () {
                    setState(() {
                      AppData.schoolProfile.name = nameCtrl.text.trim();
                      AppData.schoolProfile.tagline = tagCtrl.text.trim();
                      AppData.schoolProfile.affiliationNo = affCtrl.text.trim();
                      AppData.schoolProfile.board = boardCtrl.text.trim();
                      AppData.schoolProfile.principalName = princCtrl.text.trim();
                      AppData.schoolProfile.phone = phoneCtrl.text.trim();
                      AppData.schoolProfile.email = emailCtrl.text.trim();
                      AppData.schoolProfile.address = addrCtrl.text.trim();
                      AppData.schoolProfile.website = webCtrl.text.trim();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('School profile updated successfully!')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final school = AppData.schoolProfile;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SpargeeBackButton(),
                      const SizedBox(width: 14),
                      Text('School Profile', style: AppTextStyles.titleMedium.copyWith(fontSize: 22)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primaryOrange),
                    onPressed: _openEditSchoolDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Header Card with Logo and School Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7F80DA), Color(0xFF6B6CCF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.school_rounded, color: AppColors.primaryPurple, size: 40),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      school.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      school.tagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        school.affiliationNo,
                        style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Detailed Profile Fields
              _buildSectionCard('Affiliation & Accreditation', [
                _buildRow('Board', school.board),
                _buildRow('Established Year', school.establishedYear),
                _buildRow('Academic Session', school.academicSession),
              ]),
              const SizedBox(height: 16),

              _buildSectionCard('Administration', [
                _buildRow('Principal', school.principalName),
                _buildRow('Total Student Strength', '${AppData.totalStudentsCount} Students'),
                _buildRow('Teaching Faculty', '${AppData.totalTeachersCount} Faculty Members'),
                _buildRow('Administrative Staff', '${AppData.totalAdminsCount} Administrators'),
              ]),
              const SizedBox(height: 16),

              _buildSectionCard('Campus & Communication', [
                _buildRow('Official Phone', school.phone),
                _buildRow('Official Email', school.email),
                _buildRow('Website', school.website),
                _buildRow('Campus Address', school.address),
              ]),
              const SizedBox(height: 24),

              SpargeePrimaryButton(
                text: 'Edit School Information',
                onPressed: _openEditSchoolDialog,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
