import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/user_role.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/contact_intent_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localized_strings.dart';
import '../../shared/widgets/karigaar_button.dart';
import '../../shared/support/support_case_sheet.dart';

class ArtisanActiveJobScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const ArtisanActiveJobScreen({super.key, required this.bookingId});

  @override
  ConsumerState<ArtisanActiveJobScreen> createState() =>
      _ArtisanActiveJobScreenState();
}

class _ArtisanActiveJobScreenState
    extends ConsumerState<ArtisanActiveJobScreen> {
  bool _startOtpVerified = false;
  int _dwellMinutes = 16;
  bool _invoiceSubmitted = false;
  late AppLocalizations _strings;
  final TextEditingController _startOtpController = TextEditingController();
  final TextEditingController _completionOtpController =
      TextEditingController();

  final List<BillPartItem> _parts = [
    const BillPartItem(
      id: 'p1',
      name: 'Havells 32A Double Pole MCB',
      unitPrice: 380,
      quantity: 1,
      receiptPhotoUrl: 'hardware_receipt_01.jpg',
      hardwareStoreName: 'Gupta Electricals, Sector 48',
      isApproved: true,
      is2FaApproved: true,
    ),
  ];

  Future<BookingModel> _transitionBooking(
    BookingModel booking,
    BookingStatus to, {
    required String eventKey,
    String? reason,
  }) {
    final identity = ref.read(verifiedPhoneIdentityProvider);
    final actorId = identity?.userId ??
        booking.assignedArtisanId ??
        'art_nanded_01';
    return ref.read(bookingRepositoryProvider).transitionBooking(
          bookingId: booking.bookingId,
          to: to,
          actorId: actorId,
          actorRole: UserRole.artisan,
          eventKey: eventKey,
          reason: reason,
        );
  }

  Future<void> _verifyStartOtp() async {
    final code = _startOtpController.text.trim();
    final booking = ref.read(activeBookingProvider);
    final isValid =
        booking != null ? booking.verifyStartOtp(code) : code == '4921';
    if (isValid) {
      if (booking != null) {
        try {
          var updated = booking;
          if (updated.status == BookingStatus.artisanEnRoute) {
            updated = await _transitionBooking(
              updated,
              BookingStatus.artisanArrived,
              eventKey: '${updated.idempotencyKey}_arrived',
            );
          }
          if (updated.status == BookingStatus.artisanArrived) {
            updated = await _transitionBooking(
              updated,
              BookingStatus.workInProgress,
              eventKey: '${updated.idempotencyKey}_work_started',
            );
          }
          if (updated.status != BookingStatus.workInProgress) {
            throw StateError('Booking is not ready to start work.');
          }
          ref.read(activeBookingProvider.notifier).state = updated;
          if (mounted) setState(() => _startOtpVerified = true);
        } catch (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not start this booking: $error')),
            );
          }
          return;
        }
      } else {
        setState(() => _startOtpVerified = true);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Start Code $code verified! Stopwatch activated.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_strings.jobInvalidStart)),
      );
    }
  }

  Future<void> _triggerDoorstepDenial() async {
    final booking = ref.read(activeBookingProvider);
    final bookingId = booking?.bookingId ?? widget.bookingId;
    final api = ref.read(apiServiceProvider);

    try {
      final res = await api.triggerDoorstepAccessDenied(
        bookingId: bookingId,
        dwellMinutes: _dwellMinutes,
      );
      final compensation =
          res['data']['transitCompensation'] as Map<String, dynamic>?;
      final credited =
          (compensation?['creditedToArtisanGuildWallet'] as num?)?.toDouble() ??
              80.0;

      ref
          .read(artisanWalletBalanceProvider.notifier)
          .update((bal) => bal + credited);
      if (booking != null) {
        final updated = await _transitionBooking(
          booking,
          BookingStatus.cancelledByArtisan,
          eventKey: '${booking.idempotencyKey}_doorstep_denied',
          reason: 'Customer denied access after arrival dwell time.',
        );
        ref.read(activeBookingProvider.notifier).state = updated;
      }

      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(_strings.jobAccessDenied),
            content: Text(
              'Doorstep access denial verified via dwell time (${_dwellMinutes}m >= 15m).\n\n₹${credited.toStringAsFixed(2)} transit fee has been credited to your Guild Wallet. Standby pre-auth captured.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    try {
                      context.go('/artisan/radar');
                    } catch (_) {}
                  }
                },
                child: Text(_strings.jobCloseJob),
              ),
            ],
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _addPart(
      {String? name, int? price, String? receiptUrl, String? storeName}) {
    final partName = name ?? 'Finolex 2.5 sq mm Copper Wire (5m)';
    final partPrice = price ?? 220;
    final newPart = BillPartItem(
      id: 'p${_parts.length + 1}',
      name: partName,
      unitPrice: partPrice,
      quantity: 1,
      receiptPhotoUrl: receiptUrl ?? 'hardware_receipt_02.jpg',
      hardwareStoreName: storeName ?? 'Gupta Electricals, Anand Nagar',
      isApproved: true,
      is2FaApproved: true,
    );
    setState(() {
      _parts.add(newPart);
    });
    final booking = ref.read(activeBookingProvider);
    if (booking != null) {
      ref.read(activeBookingProvider.notifier).state = booking.copyWith(
        parts: List<BillPartItem>.from(_parts),
      );
    }
  }

  void _showAddCustomPartDialog() {
    final nameController =
        TextEditingController(text: 'Havells MCB 16A Single Pole');
    final priceController = TextEditingController(text: '180');
    final storeController =
        TextEditingController(text: 'Shree Balaji Hardware, Station Rd');
    bool hasReceipt = true;

    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_strings.jobAddPart2fa),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                          InputDecoration(labelText: _strings.jobPartName),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: _strings.jobUnitPrice),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: storeController,
                      decoration:
                          InputDecoration(labelText: _strings.jobStoreName),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: hasReceipt,
                      title: Text(_strings.jobAttachReceipt,
                          style: const TextStyle(fontSize: 13)),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) =>
                          setDialogState(() => hasReceipt = val ?? false),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _strings.jobPartsDisclaimer,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(_strings.jobCancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final price =
                        int.tryParse(priceController.text.trim()) ?? 180;
                    _addPart(
                      name: nameController.text.trim(),
                      price: price,
                      receiptUrl: hasReceipt
                          ? 'hardware_receipt_${_parts.length + 1}.jpg'
                          : null,
                      storeName: storeController.text.trim(),
                    );
                    Navigator.pop(dialogCtx);
                  },
                  child: Text(_strings.jobAddPartBill),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitDecoupledInvoice() async {
    final booking = ref.read(activeBookingProvider);
    final bookingId = booking?.bookingId ?? widget.bookingId;
    final labor = booking?.laborFee ?? 249;
    final api = ref.read(apiServiceProvider);

    try {
      final res = await api.submitDecoupledInvoice(
        bookingId: bookingId,
        parts: _parts,
        laborBase: labor,
      );
      final data = res['data'] as Map<String, dynamic>?;

      setState(() => _invoiceSubmitted = true);
      if (booking != null) {
        final updated = booking.status == BookingStatus.completionPendingOtp
            ? booking
            : await _transitionBooking(
                booking,
                BookingStatus.completionPendingOtp,
                eventKey: '${booking.idempotencyKey}_invoice_submitted',
              );
        ref.read(activeBookingProvider.notifier).state = updated.copyWith(
          parts: List<BillPartItem>.from(_parts),
          partsGatewaySurcharge: data?['partsGatewaySurcharge2Percent'] as int?,
          gstAmount: data?['gst18Percent'] as int?,
          grandTotal: data?['grandTotal'] as int?,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_strings.jobInvoiceSubmitted),
            backgroundColor: AppColors.tertiary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit invoice: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _strings = localizedStrings(context);
    ref.listen(repositoryBookingProvider(widget.bookingId), (previous, next) {
      final persisted = next.valueOrNull;
      if (persisted != null && mounted) {
        ref.read(activeBookingProvider.notifier).state = persisted;
      }
    });
    final booking = ref.watch(activeBookingProvider);
    final telemetryStatus = ref.watch(artisanTelemetryStatusProvider);
    final labor = booking?.laborFee ?? 249;
    final partsTotal = _parts.fold(0, (sum, p) => sum + p.total);
    final partsSurcharge = (partsTotal * 0.02).round();
    final subtotal = labor + partsTotal + partsSurcharge;
    final gst18 = (subtotal * 0.18).round();
    final totalBill = subtotal + gst18;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: Text(_strings.jobActiveBill),
        actions: [
          IconButton(
            key: Key('artisan_support_${widget.bookingId}'),
            tooltip: 'Report a booking issue',
            onPressed: booking == null
                ? null
                : () => showSupportCaseSheet(
                      context: context,
                      ref: ref,
                      booking: booking,
                      reporterId: booking.assignedArtisanId ??
                          ref.read(verifiedPhoneIdentityProvider)?.userId ??
                          'artisan_demo',
                      reporterRole: 'artisan',
                    ),
            icon: const Icon(Icons.support_agent_rounded),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/artisan/radar');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Elapsed Stopwatch Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_rounded,
                      color: AppColors.secondary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_strings.jobStopwatch,
                            style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondary, fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(_strings.jobElapsed,
                            style: AppTypography.headlineSm
                                .copyWith(color: Colors.white, fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(_strings.jobLiveLog,
                        style: AppTypography.labelSm
                            .copyWith(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // En-Route Telemetry Streaming HUD (Contract 3)
            if (booking?.status == BookingStatus.artisanEnRoute ||
                !_startOtpVerified) ...[
              Container(
                key: const Key('enroute_telemetry_hud'),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: telemetryStatus.isGeofenceTriggered
                        ? const Color(0xFFF59E0B)
                        : AppColors.secondary,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: telemetryStatus.isStreaming
                                ? const Color(0xFF10B981)
                                : AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _strings.jobGpsStreaming,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.secondary,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: telemetryStatus.isForeground
                                ? AppColors.secondary.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            telemetryStatus.isForeground
                                ? _strings.jobForeground
                                : _strings.jobBackground,
                            style: AppTypography.labelSm.copyWith(
                              fontSize: 10,
                              color: telemetryStatus.isForeground
                                  ? AppColors.secondary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTelemetryMetric(
                            icon: Icons.speed_rounded,
                            label: _strings.jobSpeed,
                            value:
                                '${telemetryStatus.currentSpeedKmph.toStringAsFixed(0)} km/h',
                          ),
                        ),
                        Expanded(
                          child: _buildTelemetryMetric(
                            icon: Icons.navigation_rounded,
                            label: _strings.jobHeading,
                            value:
                                '${telemetryStatus.headingDegrees.toStringAsFixed(0)}° NE',
                          ),
                        ),
                        Expanded(
                          child: _buildTelemetryMetric(
                            icon: Icons.battery_charging_full_rounded,
                            label: _strings.jobBattery,
                            value: '${telemetryStatus.batteryPercent}%',
                          ),
                        ),
                        Expanded(
                          child: _buildTelemetryMetric(
                            icon: Icons.route_rounded,
                            label: _strings.jobRemaining,
                            value:
                                '${telemetryStatus.remainingDistanceKm.toStringAsFixed(1)} km',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Foreground vs. Background Toggle Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Streaming Mode: ${telemetryStatus.isForeground ? "High-Accuracy Foreground" : "Battery-Saver Background"}',
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.textMuted, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                          child: Switch.adaptive(
                            key: const Key('telemetry_streaming_mode_toggle'),
                            value: telemetryStatus.isForeground,
                            activeThumbColor: AppColors.secondary,
                            onChanged: (bool isFg) {
                              ref
                                  .read(artisanTelemetryStatusProvider.notifier)
                                  .state = telemetryStatus.copyWith(
                                isForeground: isFg,
                                pingIntervalSeconds: isFg ? 3 : 15,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (telemetryStatus.isGeofenceTriggered) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.near_me_rounded,
                                size: 14, color: Color(0xFFB45309)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _strings.jobGeofence,
                                style: AppTypography.labelSm.copyWith(
                                    color: const Color(0xFF92400E),
                                    fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Step 1: Start Code Verification & Doorstep Denial
            if (!_startOtpVerified) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security_rounded,
                            color: AppColors.secondary, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(_strings.jobEnterStart,
                              style:
                                  AppTypography.labelLg.copyWith(fontSize: 15)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _strings.jobStartDescription,
                      style: AppTypography.bodySm.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _startOtpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      style:
                          AppTypography.headlineSm.copyWith(letterSpacing: 4),
                      decoration: InputDecoration(
                        hintText: _strings.jobStartHint,
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    KarigaarButton(
                      label: _strings.jobVerifyBegin,
                      onPressed: _verifyStartOtp,
                    ),
                    const SizedBox(height: 12),
                    // Doorstep Access Denial & Dwell Time Guard
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined,
                                  size: 16, color: AppColors.secondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Doorstep Dwell: ${_dwellMinutes}m (Min 15m for denial)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelSm
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    key: const Key('dwell_decrement_btn'),
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 18),
                                    onPressed: () {
                                      if (_dwellMinutes > 0) {
                                        setState(() => _dwellMinutes--);
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    key: const Key('dwell_increment_btn'),
                                    icon: const Icon(Icons.add_circle_outline,
                                        size: 18),
                                    onPressed: () {
                                      setState(() => _dwellMinutes++);
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              key: const Key('doorstep_access_denied_btn'),
                              onPressed: _triggerDoorstepDenial,
                              icon: const Icon(Icons.door_front_door_outlined,
                                  size: 16, color: Color(0xFFDC2626)),
                              label: Text(
                                _strings.jobDeniedTransit,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFFDC2626)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.tertiary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _strings.jobStartComplete,
                        style: const TextStyle(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Step 2: Dynamic Parts & Materials Bill Builder
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  _strings.jobBillBuilder,
                  style: AppTypography.headlineSm,
                ),
                TextButton.icon(
                  onPressed: _showAddCustomPartDialog,
                  icon: const Icon(Icons.playlist_add_rounded, size: 16),
                  label: Text(_strings.jobCustomPart),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addPart,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(_strings.jobAddPart),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Labor item
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.handyman_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(_strings.jobLaborDiagnostic,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                  Text('₹$labor',
                      style: AppTypography.numericPrice.copyWith(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Parts Items
            ..._parts.map((part) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_rounded,
                            color: AppColors.secondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(part.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              if (part.receiptPhotoUrl != null)
                                Row(
                                  children: [
                                    const Icon(Icons.receipt_long_rounded,
                                        size: 14, color: AppColors.tertiary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _strings.jobReceiptAttached,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.tertiary),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('₹${part.total}',
                            style: AppTypography.numericPrice
                                .copyWith(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            // Bill Summary & Itemized Breakdown
            Container(
              padding: const EdgeInsets.all(16),
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
                      Expanded(
                          child: Text(_strings.jobLaborBase,
                              style: AppTypography.bodySm)),
                      const SizedBox(width: 8),
                      Text('₹$labor', style: AppTypography.labelMd),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('Spare Parts (${_parts.length} items)',
                              style: AppTypography.bodySm)),
                      const SizedBox(width: 8),
                      Text('₹$partsTotal', style: AppTypography.labelMd),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                                child: Text(_strings.jobPartsSurcharge,
                                    style: AppTypography.bodySm,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 4),
                            const Icon(Icons.info_outline_rounded,
                                size: 12, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('+₹$partsSurcharge',
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.secondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(_strings.jobGst,
                              style: AppTypography.bodySm)),
                      const SizedBox(width: 8),
                      Text('+₹$gst18',
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(_strings.jobTotalInvoiced,
                            style: AppTypography.labelLg
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text('₹$totalBill',
                          style: AppTypography.numericPrice
                              .copyWith(fontSize: 22)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Decoupled Invoicing Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const Key('submit_decoupled_invoice_btn'),
                onPressed: _invoiceSubmitted ? null : _submitDecoupledInvoice,
                icon: Icon(
                  _invoiceSubmitted
                      ? Icons.check_circle_outline_rounded
                      : Icons.receipt_long_rounded,
                  size: 18,
                ),
                label: Text(
                  _invoiceSubmitted
                      ? _strings.jobWaitingPin
                      : _strings.jobSubmitInvoice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _invoiceSubmitted
                      ? AppColors.tertiary
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Step 3: Completion PIN
            Text(_strings.jobCompletionHeading,
                style: AppTypography.headlineSm),
            const SizedBox(height: 6),
            Text(_strings.jobCompletionDescription,
                style: AppTypography.bodySm),
            const SizedBox(height: 12),
            TextField(
              controller: _completionOtpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: AppTypography.headlineSm.copyWith(letterSpacing: 4),
              decoration: InputDecoration(
                hintText: _strings.jobCompletionHint,
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),

            // Payout Button
            KarigaarButton(
              label: 'Finish Job & Claim ₹$totalBill Instant IMPS Payout',
              variant: KarigaarButtonVariant.urgent,
              onPressed: () async {
                final pin = _completionOtpController.text.trim();
                final currentBooking = ref.read(activeBookingProvider);
                final isPinValid = currentBooking != null
                    ? currentBooking.verifyCompletionOtp(pin)
                    : pin == '7294';
                if (isPinValid) {
                  if (currentBooking != null) {
                    var completed = currentBooking;
                    if (currentBooking.status ==
                        BookingStatus.completionPendingOtp) {
                      completed = await _transitionBooking(
                        currentBooking,
                        BookingStatus.completed,
                        eventKey:
                            '${currentBooking.idempotencyKey}_artisan_completion',
                      );
                    }
                    ref.read(activeBookingProvider.notifier).state =
                        completed.copyWith(
                      parts: List<BillPartItem>.from(_parts),
                      partsGatewaySurcharge: partsSurcharge,
                      gstAmount: gst18,
                      grandTotal: totalBill,
                    );
                  }
                  ref.read(artisanWalletBalanceProvider.notifier).update(
                        (balance) => balance + totalBill,
                      );
                  if (!context.mounted) return;
                  final router = GoRouter.of(context);
                  await showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(_strings.jobPayoutSettled),
                      content: Text(
                        '₹$totalBill has been transferred to your registered bank account via RazorpayX / IMPS at 0% guild fee!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            try {
                              router.go('/artisan/radar');
                            } catch (_) {}
                          },
                          child: Text(_strings.jobBackRadar),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_strings.jobInvalidCompletion)),
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // Guild Tier Progress Card
            _buildGuildTierProgressCard(),

            const SizedBox(height: 24),

            // Guild Wallet Hero Card & Instant IMPS Withdrawal
            _buildGuildWalletSection(totalBill),

            const SizedBox(height: 24),

            // Recent Transactions Activity Ledger
            _buildTransactionsLedger(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuildTierProgressCard() {
    final isElite = ref.watch(guildEliteSubscriptionProvider);
    final walletBalance = ref.watch(artisanWalletBalanceProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondarySurfaceTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isElite
                                ? _strings.jobElitePartner
                                : _strings.jobGoldGuildsman,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppTypography.headlineSm.copyWith(fontSize: 16),
                          ),
                          Text(
                            isElite
                                ? _strings.jobFloorActive
                                : _strings.jobTier4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSm.copyWith(
                              color: isElite
                                  ? AppColors.tertiary
                                  : AppColors.textMuted,
                              fontWeight:
                                  isElite ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isElite
                      ? AppColors.tertiarySurfaceTint
                      : AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  isElite ? _strings.jobTakeRate : _strings.jobTopPartner,
                  style: AppTypography.labelSm.copyWith(
                    color: isElite ? AppColors.tertiary : AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4-Node Milestone Progression Track
          Row(
            children: [
              _buildTierNode('Apprentice\n(15%)', isCompleted: true),
              _buildTierConnector(isCompleted: true),
              _buildTierNode('Pro\n(12%)', isCompleted: true),
              _buildTierConnector(isCompleted: false),
              _buildTierNode('Master\n(8%)',
                  isCurrent: !isElite, isCompleted: isElite),
              _buildTierConnector(isCompleted: isElite),
              _buildTierNode('Elite\n(5% Floor)',
                  isElite: true, isCurrent: isElite, isCompleted: isElite),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isElite
                      ? _strings.jobEliteMilestone
                      : _strings.jobMasterMilestone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _strings.jobJobsProgress,
                style:
                    AppTypography.labelMd.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: isElite ? 1.0 : 0.84, // 42/50
              minHeight: 10,
              backgroundColor: AppColors.surfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(
                isElite ? AppColors.tertiary : AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.stars_rounded,
                color: isElite ? AppColors.tertiary : AppColors.secondary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isElite
                      ? _strings.jobEliteDescription
                      : _strings.jobMasterDescription,
                  style: AppTypography.bodySm.copyWith(
                    color: isElite ? AppColors.tertiary : AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Guild Elite Subscription Card
          Container(
            key: const Key('guild_elite_subscription_card'),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isElite
                    ? [
                        AppColors.tertiarySurfaceTint,
                        AppColors.surfaceRaised,
                      ]
                    : [
                        AppColors.surfaceRaised,
                        AppColors.surfaceSubtle,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isElite
                    ? AppColors.tertiary.withValues(alpha: 0.5)
                    : AppColors.secondary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Text(
                      _strings.jobKarigaarElite,
                      style: AppTypography.headlineSm.copyWith(fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _strings.jobKeep95,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _strings.jobMonthlyDeduction,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_strings.jobEliteBenefitFees}\n'
                  '${_strings.jobEliteBenefitRadar}\n'
                  '${_strings.jobEliteBenefitImps}\n'
                  '${_strings.jobEliteBenefitBadge}',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                if (!isElite)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('upgrade_to_guild_elite_btn'),
                      onPressed: () =>
                          _showGuildEliteModal(context, walletBalance),
                      icon:
                          const Icon(Icons.workspace_premium_rounded, size: 16),
                      label: Text(
                        _strings.jobUpgradeElite,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    key: const Key('guild_elite_active_badge'),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.tertiarySurfaceTint,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.tertiary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.tertiary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _strings.jobEliteLocked,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

  Widget _buildTierNode(
    String label, {
    bool isCompleted = false,
    bool isCurrent = false,
    bool isElite = false,
  }) {
    Color nodeColor;
    if (isCompleted) {
      nodeColor = isElite ? AppColors.tertiary : AppColors.secondary;
    } else if (isCurrent) {
      nodeColor = AppColors.primary;
    } else {
      nodeColor = AppColors.borderSubtle;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: nodeColor.withValues(alpha: 0.15),
              border: Border.all(color: nodeColor, width: 2),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, size: 12, color: nodeColor)
                  : (isCurrent
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: nodeColor,
                          ),
                        )
                      : null),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSm.copyWith(
              fontSize: 9,
              color: (isCompleted || isCurrent)
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierConnector({bool isCompleted = false}) {
    return Container(
      width: 14,
      height: 2,
      color: isCompleted ? AppColors.secondary : AppColors.borderSubtle,
      margin: const EdgeInsets.only(bottom: 22),
    );
  }

  void _showGuildEliteModal(BuildContext context, double currentBalance) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
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
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _strings.jobSubscribeElite,
                            style:
                                AppTypography.headlineSm.copyWith(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _strings.jobLockFloor,
                            style: AppTypography.bodySm
                                .copyWith(color: AppColors.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_strings.jobSubscriptionFee,
                              style: AppTypography.bodySm),
                          Text('₹999.00',
                              style: AppTypography.headlineSm
                                  .copyWith(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_strings.jobWalletBalance,
                              style: AppTypography.bodySm
                                  .copyWith(color: AppColors.textMuted)),
                          Text('₹${currentBalance.toStringAsFixed(2)}',
                              style: AppTypography.bodySm
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_strings.jobPostDeduction,
                              style: AppTypography.bodySm
                                  .copyWith(color: AppColors.textMuted)),
                          Text(
                              '₹${(currentBalance - 999.0).toStringAsFixed(2)}',
                              style: AppTypography.bodySm.copyWith(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('confirm_guild_elite_subscription_btn'),
                    onPressed: () {
                      ref
                          .read(artisanWalletBalanceProvider.notifier)
                          .update((b) => b - 999.0);
                      ref
                          .read(currentArtisanProfileProvider.notifier)
                          .toggleGuildElite(true);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _strings.jobSubscribed,
                          ),
                          backgroundColor: AppColors.tertiary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _strings.jobConfirmDeduct,
                      style: AppTypography.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuildWalletSection(int currentJobBill) {
    final balance = ref.watch(artisanWalletBalanceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded,
                      color: AppColors.secondary, size: 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _strings.jobGuildWallet,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.tertiarySurfaceTint,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _strings.jobImpsLive,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Balance Hero Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strings.jobClearedPayout,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.secondaryLight,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '₹${balance.toStringAsFixed(2)}',
                    style: AppTypography.displayLg.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      '+₹$currentJobBill pending',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.tertiaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Reserve Breakdown Pods
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _strings.jobLockedReserve,
                            style: AppTypography.labelSm.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹2,000.00',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.secondaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 28, color: Colors.white24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _strings.jobAvailablePayout,
                            style: AppTypography.labelSm.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${(balance > 2000.0 ? balance - 2000.0 : 0.0).toStringAsFixed(2)}',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.tertiaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Withdraw to Bank via IMPS Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showInstantWithdrawalDialog(context, balance),
                  icon: const Icon(Icons.bolt_rounded, size: 20),
                  label: Text(
                    _strings.jobWithdrawBank,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    textStyle: AppTypography.labelLg
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Send Summary to WhatsApp Button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    ContactIntentService.openWhatsAppChat(
                      context,
                      phoneNumber: '+919822012345',
                      prefilledMessage:
                          'Karigaar Guild Weekly Summary:\nTotal Cleared Balance: ₹${balance.toStringAsFixed(2)}\nActive Completed Jobs: 42\nTier: Gold Guildsman (Top 5%)\nSettlement Bank: HDFC Bank •••• 2104',
                      contactName: _strings.jobSupport,
                    );
                  },
                  icon: const Icon(Icons.forward_to_inbox_rounded,
                      size: 18, color: AppColors.tertiaryLight),
                  label: Text(
                    _strings.jobWeeklySummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd
                        .copyWith(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Verified Settlement Bank Details
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_balance_rounded,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'HDFC Bank •••• 2104',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySm
                              .copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _strings.jobVerifiedVault,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSm.copyWith(
                        color: AppColors.tertiaryLight,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInstantWithdrawalDialog(
      BuildContext context, double currentBalance) {
    if (currentBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_strings.jobNoBalance),
        ),
      );
      return;
    }

    const double minReserve = 2000.0;
    final double available =
        currentBalance > minReserve ? currentBalance - minReserve : 0.0;

    if (available <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_strings.jobReserveRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        actionsOverflowButtonSpacing: 8,
        title: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.secondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _strings.jobInstantPayout,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineSm.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdraw available cleared balance of ₹${available.toStringAsFixed(2)} directly to verified HDFC vault?',
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _strings.jobReserveLocked,
                style: AppTypography.labelSm
                    .copyWith(color: const Color(0xFF92400E), fontSize: 11),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_strings.jobBankNanded, style: AppTypography.labelSm),
                  Text(_strings.jobMaskedAccount, style: AppTypography.labelSm),
                  Text('IFSC: HDFC0001824', style: AppTypography.labelSm),
                  Text(_strings.jobPayoutFee,
                      style: AppTypography.labelSm.copyWith(
                          color: AppColors.tertiary,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_strings.jobCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final api = ref.read(apiServiceProvider);
                await api.withdrawWalletImps(
                  artisanId: 'art_nanded_01',
                  amount: available,
                  currentWalletBalance: currentBalance,
                  upiVpa: 'artisan@okaxis',
                );
                ref.read(artisanWalletBalanceProvider.notifier).state =
                    currentBalance - available;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '₹${available.toStringAsFixed(2)} transferred via IMPS! Ref #IMPS_NANDED_88291'),
                      backgroundColor: AppColors.tertiary,
                    ),
                  );
                }
              } on ApiException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(e.message), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(_strings.jobConfirmPayout),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsLedger() {
    return Container(
      padding: const EdgeInsets.all(18),
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
                  _strings.jobRecentActivity,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Text(_strings.jobViewLedger,
                  style: AppTypography.labelMd.copyWith(
                      color: AppColors.secondary, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          // Tx 1: Job Credit
          _buildTransactionRow(
            icon: Icons.add_task_rounded,
            iconColor: AppColors.tertiary,
            title: _strings.jobWiringRepair,
            subtitle: _strings.jobActivityToday,
            amount: '+₹480.00',
            amountColor: AppColors.tertiary,
            status: 'Credited',
          ),
          const Divider(height: 20, color: AppColors.borderSubtle),
          // Tx 2: Bank Payout Debit
          _buildTransactionRow(
            icon: Icons.send_to_mobile_rounded,
            iconColor: AppColors.secondary,
            title: _strings.jobDailyPayout,
            subtitle: _strings.jobActivityYesterday,
            amount: '-₹2,100.00',
            amountColor: AppColors.primary,
            status: 'Success',
          ),
          const SizedBox(height: 14),
          // Guild guarantee note
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded,
                    color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _strings.jobGuildGuarantee,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
    required String status,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTypography.labelMd
                      .copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style: AppTypography.labelLg
                    .copyWith(color: amountColor, fontWeight: FontWeight.w700)),
            Text(status,
                style: AppTypography.labelSm
                    .copyWith(color: AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildTelemetryMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.secondary),
        const SizedBox(height: 2),
        Text(value,
            style: AppTypography.labelSm.copyWith(fontWeight: FontWeight.bold)),
        Text(label,
            style: AppTypography.bodySm
                .copyWith(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}
