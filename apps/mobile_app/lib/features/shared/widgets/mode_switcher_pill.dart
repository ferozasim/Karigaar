import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/user_role.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ModeSwitcherPill extends ConsumerWidget {
  final bool compact;

  const ModeSwitcherPill({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(userRoleProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleTab(
            context: context,
            role: UserRole.customer,
            isActive: currentRole == UserRole.customer,
            label: compact ? 'Homeowner' : 'Homeowner Mode',
            icon: Icons.home_rounded,
            onTap: () {
              ref.read(userRoleProvider.notifier).state = UserRole.customer;
              try {
                final location = GoRouterState.of(context).uri.path;
                if (location.startsWith('/artisan')) {
                  context.go('/customer/home');
                }
              } catch (_) {
                // Not in router context
              }
            },
          ),
          const SizedBox(width: 4),
          _buildRoleTab(
            context: context,
            role: UserRole.artisan,
            isActive: currentRole == UserRole.artisan,
            label: compact ? 'Karigaar' : 'Artisan Mode',
            icon: Icons.handyman_rounded,
            onTap: () {
              ref.read(userRoleProvider.notifier).state = UserRole.artisan;
              try {
                final location = GoRouterState.of(context).uri.path;
                if (location.startsWith('/customer')) {
                  context.go('/artisan/radar');
                }
              } catch (_) {
                // Not in router context
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTab({
    required BuildContext context,
    required UserRole role,
    required bool isActive,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.onPrimary : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMd.copyWith(
                color: isActive ? AppColors.onPrimary : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
