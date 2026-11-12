import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/contact_intent_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/trust_shield_badge.dart';

class LiveTrackingScreen extends ConsumerWidget {
  final String bookingId;

  const LiveTrackingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(activeBookingProvider);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Tracking')),
        body: const Center(child: Text('No active booking found')),
      );
    }

    final effectiveBookingId =
        booking.bookingId.isNotEmpty ? booking.bookingId : bookingId;
    final feedAsync = ref.watch(liveTrackingFeedProvider(effectiveBookingId));
    final feed = feedAsync.valueOrNull ??
        ref.watch(telemetryServiceProvider).getLatestFeed(effectiveBookingId);

    final effectiveStatus = feed.isGeofenceTriggered
        ? BookingStatus.artisanArrived
        : booking.status;
    final activeStage = _stageForStatus(effectiveStatus);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('Live Dispatch Radar'),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simulated Vector Map Card with Route Polyline
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Stack(
                    children: [
                      // Grid background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: MapGridPainter(),
                        ),
                      ),
                      // Destination Point (Customer)
                      Positioned(
                        right: 40,
                        top: 50,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('Your Home', style: AppTypography.labelSm),
                            ),
                          ],
                        ),
                      ),
                      // Artisan Motorcycle Marker (Moving)
                      Positioned(
                        left: (60.0 +
                                (1.0 - (feed.remainingDistanceKm / 2.0).clamp(0.0, 1.0)) *
                                    140.0)
                            .clamp(20.0, 260.0),
                        bottom: (60.0 +
                                (1.0 - (feed.remainingDistanceKm / 2.0).clamp(0.0, 1.0)) *
                                    60.0)
                            .clamp(30.0, 160.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondary,
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${booking.assignedArtisanName?.split(' ').first ?? 'Ganesh'} • ${feed.isGeofenceTriggered ? "Arrived" : "${feed.etaMinutes} mins away"}',
                                style: AppTypography.labelSm.copyWith(color: AppColors.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ETA Badge Top-Left
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: feed.isGeofenceTriggered
                                      ? AppColors.tertiary
                                      : AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                feed.isGeofenceTriggered
                                    ? 'Arrived at Doorstep (0 km)'
                                    : 'Arriving in ~${feed.etaMinutes} mins (${feed.remainingDistanceKm.toStringAsFixed(1)} km)',
                                style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Live Speed & Telemetry Tag
                      Positioned(
                        left: 16,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.speed_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                feed.isGeofenceTriggered
                                    ? 'Stationary • At Destination'
                                    : '${feed.currentLocationLabel} • 45° NE',
                                style: AppTypography.labelSm.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 200m Doorstep Geofence Arrival Alert Banner
                if (feed.isGeofenceTriggered) ...[
                  const SizedBox(height: 16),
                  Container(
                    key: const Key('geofence_arrival_banner'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.near_me_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Karigaar within 200m of doorstep! Ready your Start Code ${booking.startOtp}.',
                                style: AppTypography.labelMd.copyWith(
                                  color: const Color(0xFF92400E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Artisan has arrived in your vicinity. Provide code once at your door.',
                                style: AppTypography.bodySm.copyWith(color: const Color(0xFFB45309)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Doorstep Arrival Dwell Warning Notice
                if (feed.isGeofenceTriggered || booking.status == BookingStatus.artisanArrived) ...[
                  const SizedBox(height: 12),
                  Container(
                    key: const Key('doorstep_dwell_warning_card'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF87171), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doorstep Arrival Dwell Warning (${booking.dwellMinutesAtDestination}m)',
                                style: AppTypography.labelMd.copyWith(color: const Color(0xFF991B1B), fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Artisan is waiting outside. Standby ₹99 transit fee applies if doorstep entry is unreachable or denied for >15 mins.',
                                style: AppTypography.bodySm.copyWith(color: const Color(0xFFB91C1C), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Security Start Code Display (4921)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurfaceTint,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondaryContainer),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_rounded, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'DOORSTEP SECURITY START CODE',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondary,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.startOtp,
                        style: AppTypography.displayLg.copyWith(
                          fontSize: 36,
                          letterSpacing: 8,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Share this 4-digit code verbally ONLY when your Karigaar arrives at your doorstep.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Assigned Artisan Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.tertiary, width: 2),
                        ),
                        child: const Icon(Icons.person_rounded, size: 30, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.assignedArtisanName ?? 'Ganesh Kadam', style: AppTypography.labelLg),
                            Text('${booking.tradeName} • Master Tier', style: AppTypography.bodySm),
                            const SizedBox(height: 4),
                            const TrustShieldBadge.policeVerified(),
                          ],
                        ),
                      ),
                      // WhatsApp Chat & Call Buttons
                      IconButton(
                        onPressed: () {
                          ContactIntentService.openWhatsAppChat(
                            context,
                            phoneNumber: booking.assignedArtisanPhone ?? '+919822012345',
                            prefilledMessage:
                                'Hello ${booking.assignedArtisanName ?? "Karigaar"}, tracking your arrival for Booking #${booking.bookingId}',
                            contactName: booking.assignedArtisanName,
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366)),
                      ),
                      IconButton(
                        onPressed: () {
                          ContactIntentService.makePhoneCall(
                            context,
                            phoneNumber: booking.assignedArtisanPhone ?? '+919822012345',
                            contactName: booking.assignedArtisanName,
                          );
                        },
                        icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Canned Quick Chips for Landmark & Doorstep Navigation (Contract 3)
                Text('Quick Doorstep Directions', style: AppTypography.headlineSm),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: feed.cannedQuickChips.map((chip) {
                    return ActionChip(
                      avatar: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.primary),
                      label: Text(chip, style: AppTypography.labelSm),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.borderSubtle),
                      onPressed: () {
                        ContactIntentService.openWhatsAppChat(
                          context,
                          phoneNumber: booking.assignedArtisanPhone ?? '+919822012345',
                          prefilledMessage: chip,
                          contactName: booking.assignedArtisanName,
                        );
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                // 5-Stage Milestone Progress
                Text('Booking Milestones', style: AppTypography.headlineSm),
                const SizedBox(height: 14),
                _buildMilestoneStep(
                  title: 'Booking Confirmed & Escrow Held',
                  time: '12 mins ago',
                  isCompleted: activeStage > 0,
                  isCurrent: activeStage == 0,
                ),
                _buildMilestoneStep(
                  title: 'Artisan Dispatched from Anand Nagar',
                  time: '8 mins ago',
                  isCompleted: activeStage > 1,
                  isCurrent: activeStage == 1,
                ),
                _buildMilestoneStep(
                  title: feed.isGeofenceTriggered
                      ? 'Arrived at Doorstep (Within 200m)'
                      : 'En Route to Doorstep (~${feed.etaMinutes} mins)',
                  time: feed.isGeofenceTriggered
                      ? 'Arrived at doorstep'
                      : (activeStage > 2 ? 'Arrived at doorstep' : 'Live tracking active'),
                  isCompleted: activeStage > 2,
                  isCurrent: activeStage == 2,
                ),
                _buildMilestoneStep(
                  title: 'Start Code ${booking.startOtp} Verified',
                  time: activeStage > 3 ? 'Handshake verified' : 'Pending arrival',
                  isCompleted: activeStage > 3,
                  isCurrent: activeStage == 3,
                ),
                _buildMilestoneStep(
                  title: 'Work Completed & Completion OTP',
                  time: activeStage > 4
                      ? 'IMPS payout settled'
                      : (activeStage == 4 ? 'Repair in progress' : 'Pending finish'),
                  isCompleted: activeStage > 4,
                  isCurrent: activeStage == 4,
                  isLast: true,
                ),

                const SizedBox(height: 24),

                // Customer Invoice Review & Completion OTP Card
                Container(
                  key: const Key('customer_invoice_review_card'),
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
                            child: Row(
                              children: [
                                const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Customer Invoice Review',
                                    style: AppTypography.headlineSm.copyWith(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: booking.status == BookingStatus.completed || booking.status == BookingStatus.settled
                                  ? AppColors.tertiarySurfaceTint
                                  : AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              booking.status == BookingStatus.completed || booking.status == BookingStatus.settled
                                  ? 'Paid & Settled'
                                  : 'Pending Review',
                              style: AppTypography.labelSm.copyWith(
                                color: booking.status == BookingStatus.completed || booking.status == BookingStatus.settled
                                    ? AppColors.tertiary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('Labor & Diagnostic Inspection', style: AppTypography.bodySm)),
                          const SizedBox(width: 8),
                          Text('₹${booking.laborFee}', style: AppTypography.labelMd),
                        ],
                      ),
                      if (booking.parts.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        ...booking.parts.map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${p.name} (Receipt Attached)',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySm,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('₹${p.total}', style: AppTypography.labelMd),
                                ],
                              ),
                            )),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('2% Parts Gateway Surcharge', style: AppTypography.bodySm)),
                            const SizedBox(width: 8),
                            Text('+₹${booking.partsGatewaySurcharge}', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('18% GST (Labor & Surcharge)', style: AppTypography.bodySm)),
                          const SizedBox(width: 8),
                          Text('+₹${booking.gstAmount}', style: AppTypography.labelMd.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('Grand Total Payable', style: AppTypography.labelLg.copyWith(fontWeight: FontWeight.bold))),
                          const SizedBox(width: 8),
                          Text('₹${booking.grandTotal}', style: AppTypography.numericPrice.copyWith(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Completion OTP Reveal Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondarySurfaceTint,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.secondaryContainer),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'YOUR 4-DIGIT COMPLETION OTP',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondary,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.completionOtp,
                              style: AppTypography.displayLg.copyWith(
                                fontSize: 32,
                                letterSpacing: 6,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Share verbally with artisan only after satisfactory completion.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showCustomerInvoiceReviewSheet(context, ref, booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Review Detailed Invoice & Release OTP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerInvoiceReviewSheet(BuildContext context, WidgetRef ref, BookingModel booking) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderSubtle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Itemized Service Invoice', style: AppTypography.headlineSm.copyWith(fontSize: 18)),
                          Text('Booking #${booking.bookingId}', style: AppTypography.labelSm.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('Labor & Diagnostic Inspection', style: AppTypography.bodySm)),
                          const SizedBox(width: 8),
                          Text('₹${booking.laborFee}', style: AppTypography.labelMd),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (booking.parts.isNotEmpty) ...[
                        Text('Spare Parts & Materials', style: AppTypography.labelSm.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        ...booking.parts.map((p) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.secondary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${p.name} (Receipt Attached)',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodySm.copyWith(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('₹${p.total}', style: AppTypography.labelSm),
                                ],
                              ),
                            )),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('2% Parts Payment Gateway Surcharge', style: AppTypography.bodySm)),
                            const SizedBox(width: 8),
                            Text('+₹${booking.partsGatewaySurcharge}', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('18% GST (Labor & Gateway Surcharge)', style: AppTypography.bodySm)),
                          const SizedBox(width: 8),
                          Text('+₹${booking.gstAmount}', style: AppTypography.labelMd.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('Grand Total', style: AppTypography.labelLg.copyWith(fontWeight: FontWeight.bold))),
                          const SizedBox(width: 8),
                          Text('₹${booking.grandTotal}', style: AppTypography.numericPrice.copyWith(fontSize: 22)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurfaceTint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondaryContainer),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'RELEASE COMPLETION OTP TO ARTISAN',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.completionOtp,
                        style: AppTypography.displayLg.copyWith(
                          fontSize: 32,
                          letterSpacing: 6,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By revealing and releasing this OTP, you verify job completion and authorize escrow release.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final api = ref.read(apiServiceProvider);
                        await api.verifyCustomerCompletion(
                          bookingId: booking.bookingId,
                          completionOtp: booking.completionOtp,
                          customerRating: 5,
                          feedbackNote: 'Service completed satisfactorily.',
                        );
                        await api.releaseUpiMandate(
                          bookingId: booking.bookingId,
                          mandateId: booking.mandateId ?? 'man_preauth_9981',
                        );

                        ref.read(activeBookingProvider.notifier).state = booking.copyWith(
                          status: BookingStatus.completed,
                          mandateStatus: UpiMandateStatus.released,
                        );

                        if (sheetCtx.mounted) {
                          Navigator.pop(sheetCtx);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Completion Verified! Standby ₹99 mandate released, escrow settled.'),
                              backgroundColor: AppColors.tertiary,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Verification error: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Verify & Release Completion OTP (${booking.completionOtp})',
                      style: AppTypography.labelLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _stageForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.draft:
      case BookingStatus.broadcasting:
        return 0;
      case BookingStatus.claimed:
      case BookingStatus.assigned:
        return 1;
      case BookingStatus.artisanEnRoute:
        return 2;
      case BookingStatus.artisanArrived:
        return 3;
      case BookingStatus.workInProgress:
      case BookingStatus.partsPendingApproval:
      case BookingStatus.completionPendingOtp:
        return 4;
      case BookingStatus.completed:
      case BookingStatus.settled:
        return 5;
      case BookingStatus.cancelledByCustomer:
      case BookingStatus.cancelledByArtisan:
      case BookingStatus.disputed:
        return 0;
    }
  }

  Widget _buildMilestoneStep({
    required String title,
    required String time,
    required bool isCompleted,
    required bool isCurrent,
    bool isLast = false,
  }) {
    Color iconColor;
    Color lineColor = AppColors.borderSubtle;

    if (isCompleted) {
      iconColor = AppColors.tertiary;
      lineColor = AppColors.tertiary;
    } else if (isCurrent) {
      iconColor = AppColors.secondary;
    } else {
      iconColor = AppColors.borderSubtle;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.tertiary
                    : (isCurrent ? AppColors.secondarySurfaceTint : AppColors.surfaceSubtle),
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : (isCurrent
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: lineColor,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelMd.copyWith(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  color: isCurrent ? AppColors.textPrimary : (isCompleted ? AppColors.textPrimary : AppColors.textMuted),
                ),
              ),
              Text(time, style: AppTypography.bodySm.copyWith(fontSize: 11)),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Polyline Route
    final routePaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(60, size.height - 60);
    path.lineTo(120, size.height - 90);
    path.lineTo(180, 100);
    path.lineTo(size.width - 40, 50);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
