import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class FeeStructureTemplatesScreen extends StatefulWidget {
  const FeeStructureTemplatesScreen({super.key});

  @override
  State<FeeStructureTemplatesScreen> createState() => _FeeStructureTemplatesScreenState();
}

class _FeeStructureTemplatesScreenState extends State<FeeStructureTemplatesScreen> {
  final currencyFormatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0, locale: 'en_IN');

  void _openAddEditTemplate([FeeTemplateItem? existing]) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final amountCtrl = TextEditingController(text: existing != null ? '${existing.amount.toInt()}' : '');
    final freqCtrl = TextEditingController(text: existing?.frequency ?? 'Quarterly');
    final dueCtrl = TextEditingController(text: existing?.dueDate ?? '10th of Quarter');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final gradesCtrl = TextEditingController(text: existing?.applicableGrades ?? 'Class 1 to 12');

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
                Text(
                  existing == null ? 'New Fee Template' : 'Edit Fee Template',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 16),
                SpargeeTextField(label: 'Template Title', hintText: 'e.g. Term 1 Tuition Fee', controller: titleCtrl),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SpargeeTextField(
                        label: 'Amount (₹)',
                        hintText: '35000',
                        controller: amountCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SpargeeTextField(
                        label: 'Frequency',
                        hintText: 'Quarterly / Monthly / Annual',
                        controller: freqCtrl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Due Date', hintText: 'e.g. 15 Apr 2026', controller: dueCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(label: 'Applicable Grades', hintText: 'e.g. Class 1 to 12', controller: gradesCtrl),
                const SizedBox(height: 12),
                SpargeeTextField(
                  label: 'Description / Inclusions',
                  hintText: 'Brief explanation of what fee covers',
                  controller: descCtrl,
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                SpargeePrimaryButton(
                  text: existing == null ? 'Create Template' : 'Save Template',
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;
                    final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                    setState(() {
                      if (existing == null) {
                        AppData.feeTemplates.insert(
                          0,
                          FeeTemplateItem(
                            id: 'FT${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            amount: amt,
                            frequency: freqCtrl.text.trim(),
                            dueDate: dueCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                            applicableGrades: gradesCtrl.text.trim(),
                          ),
                        );
                      } else {
                        existing.title = titleCtrl.text.trim();
                        existing.amount = amt;
                        existing.frequency = freqCtrl.text.trim();
                        existing.dueDate = dueCtrl.text.trim();
                        existing.description = descCtrl.text.trim();
                        existing.applicableGrades = gradesCtrl.text.trim();
                      }
                    });
                    Navigator.pop(ctx);
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
                      Text('Fee Templates', style: AppTextStyles.titleMedium.copyWith(fontSize: 22)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primaryOrange, size: 28),
                    onPressed: () => _openAddEditTemplate(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: AppData.feeTemplates.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final t = AppData.feeTemplates[index];
                  return _buildTemplateCard(t);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(FeeTemplateItem item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softPeach,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryOrangeDark, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Applies to: ${item.applicableGrades}',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onSelected: (val) {
                  if (val == 'edit') {
                    _openAddEditTemplate(item);
                  } else if (val == 'delete') {
                    setState(() {
                      AppData.feeTemplates.removeWhere((x) => x.id == item.id);
                    });
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit Template')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: const TextStyle(fontSize: 13, color: Color(0xFF5A443B), height: 1.35),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F1F8)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fee Amount', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                  Text(
                    currencyFormatter.format(item.amount),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryPurple),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.softLilac,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${item.frequency} • Due ${item.dueDate}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
