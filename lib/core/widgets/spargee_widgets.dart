import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Universal Sparzee Avatar Widget:
/// Displays either real profile image or clean dynamic initial letter with background color.
/// Can also display a camera/edit badge for settings screens.
class SpargeeAvatar extends StatelessWidget {
  final String name;
  final String? avatarAsset;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final bool showEditBadge;
  final IconData? badgeIcon;
  final VoidCallback? onEditTap;
  final VoidCallback? onTap;

  const SpargeeAvatar({
    super.key,
    required this.name,
    this.avatarAsset,
    this.size = 56,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.showEditBadge = false,
    this.badgeIcon,
    this.onEditTap,
    this.onTap,
  });

  String get _initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.primaryPurple;
    final effectiveBorder = borderColor ?? Colors.transparent;

    Widget avatarContent;
    if (avatarAsset != null && avatarAsset!.isNotEmpty) {
      if (avatarAsset!.startsWith('http://') || avatarAsset!.startsWith('https://')) {
        avatarContent = Image.network(
          avatarAsset!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildInitials(effectiveBg),
        );
      } else if (avatarAsset!.startsWith('assets/')) {
        avatarContent = Image.asset(
          avatarAsset!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildInitials(effectiveBg),
        );
      } else {
        avatarContent = Image.file(
          File(avatarAsset!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildInitials(effectiveBg),
        );
      }
    } else {
      avatarContent = _buildInitials(effectiveBg);
    }

    Widget mainAvatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: effectiveBg,
        border: effectiveBorder != Colors.transparent
            ? Border.all(color: effectiveBorder, width: 2.0)
            : null,
        boxShadow: [
          BoxShadow(
            color: effectiveBg.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(child: avatarContent),
    );

    if (onTap != null) {
      mainAvatar = GestureDetector(onTap: onTap, child: mainAvatar);
    }

    if (!showEditBadge) {
      return mainAvatar;
    }

    final badgeSize = (size * 0.32).clamp(24.0, 36.0);

    return Stack(
      children: [
        mainAvatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEditTap ?? onTap,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                badgeIcon ?? Icons.camera_alt_rounded,
                color: Colors.white,
                size: badgeSize * 0.55,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitials(Color bg) {
    final fontSize = size * 0.38;
    return Container(
      width: size,
      height: size,
      color: bg,
      child: Center(
        child: Text(
          _initial,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Top Header with Avatar, Role Pill, Greeting, and Notification Bell
class SpargeeHeader extends StatelessWidget {
  final String roleName;
  final String userName;
  final String subtitle;
  final String? avatarAsset;
  final Widget? customAvatar;
  final Color? avatarBgColor;
  final Color? avatarBorderColor;
  final Color? bellColor;
  final Color? bellBorderColor;
  final Color? roleBadgeColor;
  final Color? roleBadgeTextColor;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const SpargeeHeader({
    super.key,
    required this.roleName,
    required this.userName,
    required this.subtitle,
    this.avatarAsset,
    this.customAvatar,
    this.avatarBgColor,
    this.avatarBorderColor,
    this.bellColor,
    this.bellBorderColor,
    this.roleBadgeColor,
    this.roleBadgeTextColor,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAvatarBg = avatarBgColor ?? AppColors.primaryOrange;
    final effectiveAvatarBorder = avatarBorderColor ?? Colors.transparent;
    final effectiveBellColor = bellColor ?? AppColors.primaryOrange;
    final effectiveBellBorder = bellBorderColor ?? AppColors.primaryOrange;
    final effectiveRoleBadge = roleBadgeColor ?? AppColors.primaryOrange;
    final effectiveRoleText = roleBadgeTextColor ?? AppColors.primaryOrange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar
            customAvatar ??
                SpargeeAvatar(
                  name: userName,
                  avatarAsset: avatarAsset,
                  size: 58,
                  backgroundColor: effectiveAvatarBg,
                  borderColor: effectiveAvatarBorder,
                  onTap: onAvatarTap,
                ),
            // Notification Bell
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: effectiveBellBorder, width: 1.2),
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: effectiveBellColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Role pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: effectiveRoleBadge, width: 1.2),
            color: Colors.white,
          ),
          child: Text(
            roleName,
            style: AppTextStyles.pillBadge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: effectiveRoleText,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Greeting
        RichText(
          text: TextSpan(
            style: AppTextStyles.headlineGreeting,
            children: [
              const TextSpan(text: 'Good morning, '),
              TextSpan(
                text: '$userName!',
                style: AppTextStyles.headlineGreeting.copyWith(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.85),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

/// Custom Back Button (Orange rounded outline with back arrow)
class SpargeeBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const SpargeeBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: 42,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryOrange, width: 1.2),
          color: Colors.white,
        ),
        child: const Center(
          child: Icon(
            Icons.keyboard_backspace_rounded,
            color: AppColors.primaryOrange,
            size: 18,
          ),
        ),
      ),
    );
  }
}

/// Signature Stat Card with Customizable Icon Box, Stat/Number, Label, and Action Button
class SpargeeStatCard extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String value;
  final String label;
  final String buttonText;
  final bool isButtonSolid;
  final Color? valueColor;
  final Color? iconContainerColor;
  final Color? iconColor;
  final VoidCallback? onButtonTap;
  final VoidCallback? onTap;

  const SpargeeStatCard({
    super.key,
    this.icon,
    this.imageAsset,
    required this.value,
    required this.label,
    required this.buttonText,
    this.isButtonSolid = false,
    this.valueColor,
    this.iconContainerColor,
    this.iconColor,
    this.onButtonTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconBg = iconContainerColor ?? AppColors.primaryPurple;
    final effectiveIconColor = iconColor ?? Colors.white;

    Widget iconDisplay;
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      iconDisplay = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imageAsset!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      );
    } else {
      iconDisplay = Icon(icon ?? Icons.analytics_outlined, color: effectiveIconColor, size: 28);
    }

    return GestureDetector(
      onTap: onTap ?? onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFF1F1F8), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: effectiveIconBg.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Styled Icon container matching screen and item theme
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: effectiveIconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: iconDisplay),
            ),
            const SizedBox(width: 14),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.statNumber.copyWith(
                      color: valueColor ?? AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: AppColors.textPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            // Action Button
            GestureDetector(
              onTap: onButtonTap ?? onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isButtonSolid ? AppColors.primaryOrange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isButtonSolid
                      ? null
                      : Border.all(color: AppColors.primaryOrange, width: 1.2),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isButtonSolid ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary Full-Width Orange Button
class SpargeePrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const SpargeePrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                text,
                style: AppTextStyles.buttonLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

/// Custom Styled Input Field matching Figma styling
class SpargeeTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final int maxLines;

  const SpargeeTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.85), width: 1.2),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            keyboardType: keyboardType,
            maxLines: isPassword ? 1 : maxLines,
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

/// Floating Bottom Navigation Bar with Highlighted Purple Bubble
class SpargeeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<IconData> icons;

  const SpargeeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.icons = const [
      Icons.home_outlined,
      Icons.note_add_outlined,
      Icons.people_outline_rounded,
      Icons.settings_outlined,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[index],
                color: isSelected ? Colors.white : AppColors.textPrimary,
                size: 24,
              ),
            ),
          );
        }),
      ),
    );
  }
}
