import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';
import '../../core/services/database_service.dart';
import 'add_edit_admin_screen.dart';
import 'admin_profile_screen.dart';

class AdminsListScreen extends StatefulWidget {
  final bool showBackButton;

  const AdminsListScreen({super.key, this.showBackButton = false});

  @override
  State<AdminsListScreen> createState() => _AdminsListScreenState();
}

class _AdminsListScreenState extends State<AdminsListScreen> {
  @override
  Widget build(BuildContext context) {
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
                        'Administrators',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddEditAdminScreen()),
                      );
                    },
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
                            'Add',
                            style: AppTextStyles.buttonSmall.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Admins List
              Expanded(
                child: StreamBuilder<List<AdminUser>>(
                  stream: DatabaseService.instance.adminsStream,
                  initialData: DatabaseService.instance.currentAdmins,
                  builder: (context, snapshot) {
                    final admins = snapshot.data ?? [];
                    if (admins.isEmpty) {
                      return Center(
                        child: Text(
                          'No administrators registered yet. Tap +Add to register.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: admins.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final admin = admins[index];
                        return _buildAdminCard(admin);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(AdminUser admin) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdminProfileScreen(admin: admin),
          ),
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.softLilac, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SpargeeAvatar(
                  name: admin.name,
                  avatarAsset: admin.avatarUrl,
                  size: 48,
                  backgroundColor: AppColors.primaryPurple,
                  borderColor: AppColors.primaryOrange,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(admin.name, style: AppTextStyles.titleSmall.copyWith(fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(
                        admin.role,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryOrangeDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primaryOrange,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Permissions:',
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: admin.permissions.map((p) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.softLilac.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.primaryPurple),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
