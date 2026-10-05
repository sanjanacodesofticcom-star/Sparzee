import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class NoticesDetailScreen extends StatefulWidget {
  final bool showBackButton;

  const NoticesDetailScreen({super.key, this.showBackButton = true});

  @override
  State<NoticesDetailScreen> createState() => _NoticesDetailScreenState();
}

class _NoticesDetailScreenState extends State<NoticesDetailScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Holidays', 'Events', 'General'];

  void _openAddNoticeDialog() {
    final titleController = TextEditingController();
    String category = 'General';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                    'Post School Notice',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SpargeeTextField(
                    label: 'Notice Title / Announcement',
                    hintText: 'e.g. Sports Day Schedule Announcement',
                    controller: titleController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  Text('Category', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['General', 'Holidays', 'Events'].map((cat) {
                      final isSel = category == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        onSelected: (selected) {
                          if (selected) setModalState(() => category = cat);
                        },
                        selectedColor: AppColors.primaryOrange,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSel ? AppColors.primaryOrange : AppColors.borderGrey,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SpargeePrimaryButton(
                    text: 'Publish Notice',
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) return;
                      setState(() {
                        AppData.notices.insert(
                          0,
                          NoticeItem(
                            id: 'N${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim(),
                            category: category,
                            timeAgo: 'Just now',
                            date: '05 Oct 2026',
                          ),
                        );
                        AppData.addActivity(
                          title: 'New notice posted: ',
                          highlightText: titleController.text.trim(),
                          trailingText: ' ($category)',
                        );
                      });
                      Navigator.of(ctx).pop();
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
    final filteredNotices = AppData.notices.where((n) {
      if (_selectedCategory == 'All') return true;
      return n.category == _selectedCategory;
    }).toList();

    final isStaff = AppData.currentUser?.role == UserRole.management || AppData.currentUser?.role == UserRole.admin;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.showBackButton || Navigator.canPop(context)) ...[
                        const SpargeeBackButton(),
                        const SizedBox(width: 14),
                      ],
                      Text(
                        'Notices Detail',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  if (isStaff)
                    GestureDetector(
                      onTap: _openAddNoticeDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Post',
                              style: AppTextStyles.buttonSmall.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),

              // Filter Chips Row
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryOrange : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryOrange,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Notices Cards
              Expanded(
                child: filteredNotices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.article_outlined, size: 52, color: AppColors.textSecondary),
                            const SizedBox(height: 12),
                            Text(
                              'No notices in this category.',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                            if (isStaff) ...[
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _openAddNoticeDialog,
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text('Post First Notice', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredNotices.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final notice = filteredNotices[index];
                          return _buildNoticeCard(notice);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeCard(NoticeItem notice) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softPeach,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notice.category,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${notice.date} • ${notice.timeAgo}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Purple Tag on left
          Positioned(
            left: 12,
            top: 14,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
