import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class NoticeCategoriesScreen extends StatefulWidget {
  const NoticeCategoriesScreen({super.key});

  @override
  State<NoticeCategoriesScreen> createState() => _NoticeCategoriesScreenState();
}

class _NoticeCategoriesScreenState extends State<NoticeCategoriesScreen> {
  void _openAddCategoryDialog([NoticeCategoryItem? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    Color selectedColor = existing?.badgeColor ?? AppColors.primaryPurple;

    final colorOptions = [
      AppColors.primaryPurple,
      AppColors.primaryOrange,
      const Color(0xFF27AE60),
      const Color(0xFF0284C7),
      const Color(0xFFEB5757),
      const Color(0xFFF1C40F),
      const Color(0xFF8E44AD),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    existing == null ? 'Add Notice Category' : 'Edit Notice Category',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SpargeeTextField(label: 'Category Name', hintText: 'e.g. Science Fair & Exhibitions', controller: nameCtrl),
                  const SizedBox(height: 12),
                  SpargeeTextField(label: 'Description', hintText: 'Brief summary of notices in this category', controller: descCtrl, maxLines: 2),
                  const SizedBox(height: 14),
                  const Text('Category Color Tag', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: colorOptions.map((c) {
                      final isSelected = selectedColor == c;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedColor = c),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SpargeePrimaryButton(
                    text: existing == null ? 'Create Category' : 'Save Category',
                    onPressed: () {
                      if (nameCtrl.text.trim().isEmpty) return;
                      setState(() {
                        if (existing == null) {
                          AppData.noticeCategories.insert(
                            0,
                            NoticeCategoryItem(
                              id: 'NC${DateTime.now().millisecondsSinceEpoch}',
                              name: nameCtrl.text.trim(),
                              description: descCtrl.text.trim(),
                              badgeColor: selectedColor,
                              isEnabled: true,
                            ),
                          );
                        } else {
                          existing.name = nameCtrl.text.trim();
                          existing.description = descCtrl.text.trim();
                          existing.badgeColor = selectedColor;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      Text('Notice Categories', style: AppTextStyles.titleMedium.copyWith(fontSize: 22)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primaryOrange, size: 28),
                    onPressed: () => _openAddCategoryDialog(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: AppData.noticeCategories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cat = AppData.noticeCategories[index];
                  return _buildCategoryCard(cat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(NoticeCategoryItem cat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: cat.badgeColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 48,
            decoration: BoxDecoration(
              color: cat.badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  cat.description,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: cat.isEnabled,
            activeThumbColor: AppColors.primaryOrange,
            activeTrackColor: AppColors.primaryPurple,
            onChanged: (val) {
              setState(() {
                cat.isEnabled = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
