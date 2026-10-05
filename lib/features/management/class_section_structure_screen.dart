import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class ClassSectionStructureScreen extends StatefulWidget {
  const ClassSectionStructureScreen({super.key});

  @override
  State<ClassSectionStructureScreen> createState() => _ClassSectionStructureScreenState();
}

class _ClassSectionStructureScreenState extends State<ClassSectionStructureScreen> {
  String _searchQuery = '';

  void _openAddEditSectionDialog([ClassSectionItem? existing]) {
    final classCtrl = TextEditingController(text: existing?.className ?? 'Class 11');
    final sectionCtrl = TextEditingController(text: existing?.section ?? 'A');
    final countCtrl = TextEditingController(text: existing != null ? '${existing.studentCount}' : '35');
    final teacherCtrl = TextEditingController(text: existing?.classTeacher ?? 'Rajesh Kumar');
    final roomCtrl = TextEditingController(text: existing?.roomNo ?? 'Room 304');

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existing == null ? 'Add New Section' : 'Edit Class Section',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 16),
              SpargeeTextField(label: 'Class Name', hintText: 'e.g. Class 11', controller: classCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SpargeeTextField(label: 'Section', hintText: 'A / B / C', controller: sectionCtrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SpargeeTextField(
                      label: 'Student Count',
                      hintText: '35',
                      controller: countCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SpargeeTextField(label: 'Class Teacher', hintText: 'Assigned Teacher Name', controller: teacherCtrl),
              const SizedBox(height: 12),
              SpargeeTextField(label: 'Room Number', hintText: 'e.g. Room 304', controller: roomCtrl),
              const SizedBox(height: 20),
              SpargeePrimaryButton(
                text: existing == null ? 'Create Section' : 'Save Section',
                onPressed: () {
                  if (classCtrl.text.trim().isEmpty) return;
                  final count = int.tryParse(countCtrl.text.trim()) ?? 35;
                  setState(() {
                    if (existing == null) {
                      AppData.classSections.insert(
                        0,
                        ClassSectionItem(
                          className: classCtrl.text.trim(),
                          section: sectionCtrl.text.trim().toUpperCase(),
                          studentCount: count,
                          classTeacher: teacherCtrl.text.trim(),
                          roomNo: roomCtrl.text.trim(),
                        ),
                      );
                    } else {
                      existing.className = classCtrl.text.trim();
                      existing.section = sectionCtrl.text.trim().toUpperCase();
                      existing.studentCount = count;
                      existing.classTeacher = teacherCtrl.text.trim();
                      existing.roomNo = roomCtrl.text.trim();
                    }
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = AppData.classSections.where((item) {
      final q = _searchQuery.toLowerCase();
      return item.className.toLowerCase().contains(q) ||
          item.section.toLowerCase().contains(q) ||
          item.classTeacher.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SpargeeBackButton(),
                      const SizedBox(width: 14),
                      Text('Class Structure', style: AppTextStyles.titleMedium.copyWith(fontSize: 22)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primaryOrange, size: 28),
                    onPressed: () => _openAddEditSectionDialog(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.5)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: AppColors.primaryOrange, size: 20),
                    hintText: 'Search by class or teacher...',
                    hintStyle: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemCount: filteredList.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return _buildClassCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(ClassSectionItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.softPeach,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                item.section,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryOrangeDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.className} • Section ${item.section}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Teacher: ${item.classTeacher}',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.softLilac,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.studentCount} Students',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Location: ${item.roomNo}',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.primaryPurple),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryOrange, size: 20),
            onPressed: () => _openAddEditSectionDialog(item),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
          ),
        ],
      ),
    );
  }
}
