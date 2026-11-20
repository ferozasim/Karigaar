import '../../../l10n/localized_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/config/app_data_service.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/trust_shield_badge.dart';
import '../profile/widgets/retroactive_escrow_lock_sheet.dart';

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
      'cover': 25000,
      'daysSinceCompletion': 6,
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
      'cover': 10000,
      'daysSinceCompletion': 21,
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

  String _displayStatus(String status) {
    final strings = localizedStrings(context);
    return switch (status) {
      'All' => strings.accountStatusAll,
      'En-Route' => strings.accountStatusEnRoute,
      'Upcoming' => strings.accountStatusUpcoming,
      'Completed' => strings.accountStatusCompleted,
      'In Progress' => strings.accountStatusInProgress,
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context) {
    final customerId =
        ref.watch(verifiedPhoneIdentityProvider)?.userId ?? 'cust_01';
    final activeRecords = ref
        .watch(repositoryActiveBookingsProvider(customerId))
        .valueOrNull;
    final activeBooking = activeRecords == null || activeRecords.isEmpty
        ? ref.watch(activeBookingProvider)
        : (activeRecords.toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
            .first;
    final activeStatusText =
        activeBooking != null ? _statusLabel(activeBooking.status) : 'En-Route';

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
        title: Text(localizedStrings(context).accountBookingsTitle),
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
                    label: Text(_displayStatus(tab)),
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
                    localizedStrings(context).accountActiveDispatch,
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
                // Direct On-Site Visits & Inquiries (F-25 & F-36)
                _buildDirectOnSiteLeadCard(context),
                const SizedBox(height: 20),
                Text(
                  localizedStrings(context).accountPastOrders,
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
                        localizedStrings(context)
                            .accountEmptyBookings(_displayStatus(_selectedTab)),
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
                  localizedStrings(context)
                      .accountBookingReference(booking.bookingId),
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
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TrustShieldBadge(
                label: booking.damageCoverAmount >= 25000
                    ? localizedStrings(context).accountShield25
                    : localizedStrings(context).accountShield10,
              ),
              if (booking.isRetroactiveOnSiteLock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tertiarySurfaceTint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    localizedStrings(context).accountOnsiteLocked,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            booking.damageCoverLabel,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          // Scheduled Slot & Audio Memo Badges (Ticket T-08 F-10/F-11)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (booking.scheduledSlot != null || booking.isEmergencyDispatch)
                Container(
                  key: const Key('active_booking_slot_badge'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.isEmergencyDispatch
                        ? const Color(0xFFFEF2F2)
                        : AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: booking.isEmergencyDispatch
                          ? AppColors.errorContainer
                          : AppColors.borderSubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        booking.isEmergencyDispatch
                            ? Icons.bolt_rounded
                            : Icons.access_time_filled_rounded,
                        size: 13,
                        color: booking.isEmergencyDispatch
                            ? AppColors.error
                            : AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          booking.scheduledSlot ??
                              localizedStrings(context).accountScheduledWindow,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSm.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: booking.isEmergencyDispatch
                                ? AppColors.error
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (booking.audioMemoUrl != null ||
                  booking.audioMemoDurationSeconds != null)
                Container(
                  key: const Key('active_booking_audio_badge'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurfaceTint,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mic_rounded,
                          size: 13, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          localizedStrings(context).accountVoiceNote(
                              booking.audioMemoDurationSeconds ?? 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSm.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizedStrings(context)
                          .accountStartOtp(booking.startOtp),
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
                      localizedStrings(context)
                          .accountTotalEstimate(booking.totalFinalAmount),
                      style: AppTypography.numericPrice.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
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
                child: Text(localizedStrings(context).accountTrackLive),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDirectOnSiteLeadCard(BuildContext context) {
    final directArtisan = AppDataService.getAllSampleArtisans().firstWhere(
      (a) => a.artisanId == 'art_nanded_02',
      orElse: () => AppDataService.getAllSampleArtisans().first,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                localizedStrings(context)
                    .accountDirectLead(directArtisan.tradeTitle),
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  localizedStrings(context).accountDirectVisit,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            localizedStrings(context).accountOnsiteName(directArtisan.name),
            style: AppTypography.headlineSm.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            localizedStrings(context).accountOnsiteUpgradeExplanation,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('upgrade_booking_direct_lead_btn'),
              onPressed: () =>
                  RetroactiveEscrowLockSheet.show(context, directArtisan),
              icon: const Icon(Icons.shield_outlined, size: 16),
              label: Text(
                localizedStrings(context).accountUpgradeBooking,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
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
                    color:
                        isUpcoming ? AppColors.secondary : AppColors.tertiary,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                '₹${item['amount']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.numericPrice.copyWith(fontSize: 18),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onPressed: () =>
                    context.push('/customer/artisan/${item['artisanId']}'),
                child: Text(isUpcoming
                    ? localizedStrings(context).accountViewArtisan
                    : localizedStrings(context).accountBookAgain),
              ),
            ],
          ),
          if (!isUpcoming) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  key: Key('csat_${item['id']}'),
                  onPressed: () => _showCsatSheet(context, item),
                  icon: const Icon(Icons.star_outline_rounded, size: 16),
                  label: Text(localizedStrings(context).accountRateService),
                ),
                OutlinedButton.icon(
                  key: Key('warranty_claim_${item['id']}'),
                  onPressed: () => _showWarrantyClaimSheet(context, item),
                  icon: const Icon(Icons.shield_outlined, size: 16),
                  label: Text(localizedStrings(context).accountRaiseClaim),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showCsatSheet(
    BuildContext context,
    Map<String, dynamic> booking,
  ) async {
    var overall = 5;
    var cleanliness = 5;
    var sawdust = 5;
    final noteController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizedStrings(context).accountServiceQuestion,
                  style: AppTypography.headlineSm),
              const SizedBox(height: 12),
              _ratingRow(localizedStrings(context).accountOverall, overall,
                  (value) => setSheetState(() => overall = value)),
              _ratingRow(
                  localizedStrings(context).accountCleanliness,
                  cleanliness,
                  (value) => setSheetState(() => cleanliness = value)),
              _ratingRow(localizedStrings(context).accountCareFinish, sawdust,
                  (value) => setSheetState(() => sawdust = value)),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                    labelText: localizedStrings(context).accountFeedback),
                maxLength: 240,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result =
                        await KarigaarApiService.instance.submitPostJobCsat(
                      bookingId: booking['id'] as String,
                      overallRating: overall,
                      cleanlinessRating: cleanliness,
                      sawdustRating: sawdust,
                      feedbackNote: noteController.text,
                    );
                    ref.read(postJobCsatProvider.notifier).update((state) => {
                          ...state,
                          booking['id'] as String:
                              result['data'] as Map<String, dynamic>,
                        });
                    if (context.mounted) Navigator.pop(sheetContext);
                  },
                  child: Text(localizedStrings(context).accountSubmitRating),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    noteController.dispose();
  }

  Widget _ratingRow(String label, int rating, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.labelMd)),
        for (var value = 1; value <= 5; value++)
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged(value),
            icon: Icon(
              value <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: AppColors.secondary,
            ),
          ),
      ],
    );
  }

  Future<void> _showWarrantyClaimSheet(
    BuildContext context,
    Map<String, dynamic> booking,
  ) async {
    final amountController = TextEditingController(text: '1000');
    final reasonController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizedStrings(context).accountClaimTitle,
                style: AppTypography.headlineSm),
            const SizedBox(height: 8),
            Text(localizedStrings(context).accountDeductibleReview,
                style: AppTypography.bodySm),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizedStrings(context).accountDamageAmount,
                helperText: localizedStrings(context)
                    .accountCoverLimit(booking['cover'] as int? ?? 25000),
              ),
            ),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                  labelText: localizedStrings(context).accountDescribeIssue),
              maxLength: 400,
              maxLines: 3,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = int.tryParse(amountController.text.trim());
                  if (amount == null || reasonController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(localizedStrings(context)
                              .accountClaimValidation)),
                    );
                    return;
                  }
                  try {
                    final result =
                        await KarigaarApiService.instance.raiseWarrantyClaim(
                      bookingId: booking['id'] as String,
                      requestedAmountPaise: amount * 100,
                      damageCoverAmountPaise:
                          (booking['cover'] as int? ?? 25000) * 100,
                      completedAt: DateTime.now().subtract(
                        Duration(
                            days: booking['daysSinceCompletion'] as int? ?? 6),
                      ),
                      warrantyEligible: true,
                      reason: reasonController.text,
                    );
                    ref
                        .read(warrantyClaimsProvider.notifier)
                        .update((claims) => [
                              result['data'] as Map<String, dynamic>,
                              ...claims,
                            ]);
                    if (context.mounted) Navigator.pop(sheetContext);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                localizedStrings(context).accountClaimSent)),
                      );
                    }
                  } on ApiException catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.message)),
                      );
                    }
                  }
                },
                child: Text(localizedStrings(context).accountSubmitClaim),
              ),
            ),
          ],
        ),
      ),
    );
    amountController.dispose();
    reasonController.dispose();
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
            label: localizedStrings(context).explore,
            isActive: false,
            onTap: () => context.go('/customer/home'),
          ),
          _buildNavItem(
            icon: Icons.assignment_rounded,
            label: localizedStrings(context).bookings,
            isActive: true,
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: localizedStrings(context).messages,
            isActive: false,
            onTap: () => context.go('/customer/messages'),
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: localizedStrings(context).profile,
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
