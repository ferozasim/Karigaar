import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/trust_shield_badge.dart';

class CustomerBookingsScreen extends ConsumerStatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  ConsumerState<CustomerBookingsScreen> createState() =>
      _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState
    extends ConsumerState<CustomerBookingsScreen> {
  String _selectedTab = 'All';

  static const List<String> _tabs = [
    'All',
    'En-Route',
    'Upcoming',
    'Completed',
  ];

  static const List<Map<String, dynamic>> _historicalBookings = [
    {
      'id': 'BK_NANDED_8904',
      'trade': 'Master Plumber',
      'artisanName': 'Suresh Jadhav',
      'artisanId': 'art_nanded_02',
      'issue': 'Concealed Diverter Cartridge & Pressure Check',
      'locality': 'Vazirabad, Nanded',
      'scheduledSlot': 'Tomorrow, 10:30 AM',
      'amount': 399,
      'status': 'Upcoming',
      'warranty': '30-Day Guild Guarantee',
    },
    {
      'id': 'BK_NANDED_8412',
      'trade': 'Master Carpenter',
      'artisanName': 'Abdul Shaikh',
      'artisanId': 'art_nanded_03',
      'issue': 'Modular Kitchen Soft-Close Hinge Alignment',
      'locality': 'Anand Nagar, Nanded',
      'scheduledSlot': '02 Nov 2026 • Completed',
      'amount': 640,
      'status': 'Completed',
      'warranty': 'Warranty Active (24 days left)',
    },
    {
      'id': 'BK_NANDED_8109',
      'trade': 'AC & Refrigeration',
      'artisanName': 'Ganesh Kadam',
      'artisanId': 'art_nanded_01',
      'issue': 'Split AC Jet Pump Deep Servicing & Gas Top-Up',
      'locality': 'CIDCO, Nanded',
      'scheduledSlot': '18 Oct 2026 • Completed',
      'amount': 1150,
      'status': 'Completed',
      'warranty': 'Warranty Active (9 days left)',
    },
  ];

  String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.artisanEnRoute:
        return 'En-Route';
      case BookingStatus.workInProgress:
        return 'In Progress';
      case BookingStatus.settled:
      case BookingStatus.completed:
        return 'Completed';
      default:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeBooking = ref.watch(activeBookingProvider);
    final activeStatusText = activeBooking != null
        ? _statusLabel(activeBooking.status)
        : 'En-Route';

    final showActiveCard = activeBooking != null &&
        (_selectedTab == 'All' ||
            (_selectedTab == 'En-Route' &&
                (activeStatusText == 'En-Route' ||
                    activeStatusText == 'In Progress')) ||
            (_selectedTab == 'Completed' && activeStatusText == 'Completed') ||
            (_selectedTab == 'Upcoming' && activeStatusText == 'Upcoming'));

    final filteredHistory = _historicalBookings.where((item) {
      if (_selectedTab == 'All') return true;
      return item['status'] == _selectedTab;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('My Service Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/customer/home');
            }
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: _tabs.map((tab) {
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    key: ValueKey('booking_tab_$tab'),
                    label: Text(tab),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surfaceRaised,
                    labelStyle: AppTypography.labelMd.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    onSelected: (_) => setState(() => _selectedTab = tab),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                if (showActiveCard) ...[
                  Text(
                    'ACTIVE DISPATCH',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.secondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildActiveBookingCard(
                    context,
                    activeBooking,
                    activeStatusText,
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  'UPCOMING & PAST ORDERS',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                if (filteredHistory.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Center(
                      child: Text(
                        'No bookings in $_selectedTab tab.',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  )
                else
                  ...filteredHistory.map(
                    (item) => _buildHistoricalCard(context, item),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildActiveBookingCard(
    BuildContext context,
    BookingModel booking,
    String statusText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.secondary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Booking #${booking.bookingId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  statusText,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(booking.issueTitle, style: AppTypography.headlineSm),
          const SizedBox(height: 4),
          Text(
            '${booking.artisanName} • ${booking.customerAddress}',
            style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          const TrustShieldBadge(label: '₹25,000 Guild Damage Shield Active'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Start Handshake OTP: ${booking.startOtp}',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total Estimate: ₹${booking.totalFinalAmount}',
                        style: AppTypography.numericPrice.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.push(
                  '/customer/active-tracking/${booking.bookingId}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: const Text('Track Live'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalCard(BuildContext context, Map<String, dynamic> item) {
    final isUpcoming = item['status'] == 'Upcoming';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item['trade']} • #${item['id']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? AppColors.secondarySurfaceTint
                      : AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  item['status'] as String,
                  style: AppTypography.labelSm.copyWith(
                    color: isUpcoming ? AppColors.secondary : AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item['issue'] as String,
            style: AppTypography.headlineSm.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${item['artisanName']} • ${item['locality']}',
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: 4),
          Text(
            '${item['scheduledSlot']} • ${item['warranty']}',
            style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '₹${item['amount']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.numericPrice.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onPressed: () =>
                    context.push('/customer/artisan/${item['artisanId']}'),
                child: Text(isUpcoming ? 'View Artisan' : 'Book Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.explore_rounded,
            label: 'Explore',
            isActive: false,
            onTap: () => context.go('/customer/home'),
          ),
          _buildNavItem(
            icon: Icons.assignment_rounded,
            label: 'Bookings',
            isActive: true,
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            isActive: false,
            onTap: () => context.go('/customer/messages'),
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: false,
            onTap: () => context.go('/customer/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textSubtle,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTypography.labelSm.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textSubtle,
                    fontSize: 11,
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
