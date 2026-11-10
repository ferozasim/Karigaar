import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/contact_intent_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/karigaar_button.dart';

class ArtisanActiveJobScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const ArtisanActiveJobScreen({super.key, required this.bookingId});

  @override
  ConsumerState<ArtisanActiveJobScreen> createState() => _ArtisanActiveJobScreenState();
}

class _ArtisanActiveJobScreenState extends ConsumerState<ArtisanActiveJobScreen> {
  bool _startOtpVerified = false;
  final TextEditingController _startOtpController = TextEditingController();
  final TextEditingController _completionOtpController = TextEditingController();

  final List<BillPartItem> _parts = [
    const BillPartItem(
      id: 'p1',
      name: 'Havells 32A Double Pole MCB',
      unitPrice: 380,
      quantity: 1,
      receiptPhotoUrl: 'hardware_receipt_01.jpg',
    ),
  ];

  void _verifyStartOtp() {
    final code = _startOtpController.text.trim();
    final booking = ref.read(activeBookingProvider);
    final isValid = booking != null ? booking.verifyStartOtp(code) : code == '4921';
    if (isValid) {
      setState(() => _startOtpVerified = true);
      if (booking != null) {
        ref.read(activeBookingProvider.notifier).state = booking.copyWith(
          status: BookingStatus.workInProgress,
          arrivalTime: DateTime.now(),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Start Code $code verified! Stopwatch activated.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code! Ask customer for their 4-digit start code.')),
      );
    }
  }

  void _addPart() {
    final newPart = BillPartItem(
      id: 'p${_parts.length + 1}',
      name: 'Finolex 2.5 sq mm Copper Wire (5m)',
      unitPrice: 220,
      quantity: 1,
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

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(activeBookingProvider);
    final labor = booking?.laborFee ?? 249;
    final partsTotal = _parts.fold(0, (sum, p) => sum + p.total);
    final totalBill = labor + partsTotal;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('Active Job & Bill Builder'),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_rounded, color: AppColors.secondary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ON-SITE REPAIR STOPWATCH', style: AppTypography.labelSm.copyWith(color: AppColors.secondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('28m 14s Elapsed', style: AppTypography.headlineMd.copyWith(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Live Log', style: AppTypography.labelSm.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Step 1: Start Code Verification
            if (!_startOtpVerified) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security_rounded, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Step 1: Enter Customer Start Code', style: AppTypography.labelLg),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ask homeowner for their 4-digit security code (Demo: 4921) to confirm doorstep arrival.',
                      style: AppTypography.bodySm,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _startOtpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      style: AppTypography.headlineSm.copyWith(letterSpacing: 4),
                      decoration: const InputDecoration(
                        hintText: 'Enter 4-digit Start Code',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 12),
                    KarigaarButton(
                      label: 'Verify Code & Begin Repair',
                      onPressed: _verifyStartOtp,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.tertiarySurfaceTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: AppColors.tertiary, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Start Code 4921 Verified • Doorstep Handshake Complete',
                        style: TextStyle(color: AppColors.tertiary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Step 2: Dynamic Parts & Materials Bill Builder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Dynamic Bill Builder',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addPart,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Part'),
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
                  const Icon(Icons.handyman_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Labor & Diagnostic Inspection', style: TextStyle(fontWeight: FontWeight.w600))),
                  Text('₹$labor', style: AppTypography.numericPrice.copyWith(fontSize: 16)),
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
                        const Icon(Icons.inventory_2_rounded, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(part.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (part.receiptPhotoUrl != null)
                                const Row(
                                  children: [
                                    Icon(Icons.receipt_long_rounded, size: 14, color: AppColors.tertiary),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Receipt Photo Attached',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 11, color: AppColors.tertiary),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('₹${part.total}', style: AppTypography.numericPrice.copyWith(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            // Bill Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Total Invoiced to Customer', style: AppTypography.labelLg),
                  ),
                  const SizedBox(width: 8),
                  Text('₹$totalBill', style: AppTypography.numericPrice.copyWith(fontSize: 22)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 3: Completion PIN
            Text('Step 3: Collect Completion PIN', style: AppTypography.headlineSm),
            const SizedBox(height: 6),
            Text('Ask customer for their 4-digit verbal completion PIN (Demo: 7294)', style: AppTypography.bodySm),
            const SizedBox(height: 12),
            TextField(
              controller: _completionOtpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: AppTypography.headlineSm.copyWith(letterSpacing: 4),
              decoration: const InputDecoration(
                hintText: 'Enter 4-digit Completion PIN',
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),

            // Payout Button
            KarigaarButton(
              label: 'Finish Job & Claim ₹$totalBill Instant IMPS Payout',
              variant: KarigaarButtonVariant.urgent,
              onPressed: () {
                final pin = _completionOtpController.text.trim();
                final currentBooking = ref.read(activeBookingProvider);
                final isPinValid = currentBooking != null
                    ? currentBooking.verifyCompletionOtp(pin)
                    : pin == '7294';
                if (isPinValid) {
                  if (currentBooking != null) {
                    ref.read(activeBookingProvider.notifier).state = currentBooking.copyWith(
                      status: BookingStatus.settled,
                      parts: List<BillPartItem>.from(_parts),
                      completionTime: DateTime.now(),
                    );
                  }
                  ref.read(artisanWalletBalanceProvider.notifier).update(
                        (balance) => balance + totalBill,
                      );
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('IMPS Payout Settled!'),
                      content: Text(
                        '₹$totalBill has been transferred to your registered bank account via RazorpayX / IMPS at 0% guild fee!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            try {
                              context.go('/artisan/radar');
                            } catch (_) {}
                          },
                          child: const Text('Back to Radar'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid completion PIN! Enter 7294 for demo.')),
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
                      child: const Icon(Icons.workspace_premium_rounded, color: AppColors.secondary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gold Guildsman',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headlineSm.copyWith(fontSize: 16),
                          ),
                          Text(
                            'Tier Level 4 Craftsman',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSm.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'Top 5% Partner',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Milestone: Master Guildsman',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ),
              const SizedBox(width: 8),
              Text('42 / 50 Jobs', style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: const LinearProgressIndicator(
              value: 0.84, // 42/50
              minHeight: 10,
              backgroundColor: AppColors.surfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.secondary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Only 8 jobs remaining to unlock 0% commission master tier!',
                  style: AppTypography.bodySm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
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
                  const Icon(Icons.account_balance_wallet_rounded, color: AppColors.secondary, size: 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Guild Wallet',
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
                    'Instant IMPS Live',
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
                'CLEARED AVAILABLE PAYOUT',
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              const SizedBox(height: 18),
              // Withdraw to Bank via IMPS Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showInstantWithdrawalDialog(context, balance),
                  icon: const Icon(Icons.bolt_rounded, size: 20),
                  label: const Text(
                    'Withdraw to Bank via UPI / IMPS (₹0 Fee)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    textStyle: AppTypography.labelLg.copyWith(fontWeight: FontWeight.w700),
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
                      contactName: 'Karigaar Partner Support',
                    );
                  },
                  icon: const Icon(Icons.forward_to_inbox_rounded, size: 18, color: AppColors.tertiaryLight),
                  label: Text(
                    'Send Weekly Earnings Summary to WhatsApp',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Verified Settlement Bank Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_rounded, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'HDFC Bank •••• 2104',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Verified Guild Vault',
                    maxLines: 1,
                    style: AppTypography.labelSm.copyWith(color: AppColors.tertiaryLight, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInstantWithdrawalDialog(BuildContext context, double currentBalance) {
    if (currentBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cleared balance available for withdrawal.'),
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.secondary),
            const SizedBox(width: 8),
            Text('Instant IMPS Payout', style: AppTypography.headlineSm.copyWith(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdraw available cleared balance of ₹${currentBalance.toStringAsFixed(2)} directly to verified HDFC vault?',
              style: AppTypography.bodyMd,
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
                  Text('Bank: HDFC Bank Limited (Nanded Main Branch)', style: AppTypography.labelSm),
                  Text('Account: •••• •••• 2104', style: AppTypography.labelSm),
                  Text('IFSC: HDFC0001824', style: AppTypography.labelSm),
                  Text('Payout Fee: ₹0.00 (Guild Covered)', style: AppTypography.labelSm.copyWith(color: AppColors.tertiary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(artisanWalletBalanceProvider.notifier).state = 0.00;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('₹${currentBalance.toStringAsFixed(2)} transferred via IMPS! Ref #IMPS_NANDED_88291'),
                  backgroundColor: AppColors.tertiary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm IMPS Payout'),
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
                  'Recent Activity',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Text('View Ledger', style: AppTypography.labelMd.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          // Tx 1: Job Credit
          _buildTransactionRow(
            icon: Icons.add_task_rounded,
            iconColor: AppColors.tertiary,
            title: 'MCB & Wiring Repair',
            subtitle: 'Anand Nagar, Nanded • Today, 11:20 AM',
            amount: '+₹480.00',
            amountColor: AppColors.tertiary,
            status: 'Credited',
          ),
          const Divider(height: 20, color: AppColors.borderSubtle),
          // Tx 2: Bank Payout Debit
          _buildTransactionRow(
            icon: Icons.send_to_mobile_rounded,
            iconColor: AppColors.secondary,
            title: 'Daily Payout to HDFC',
            subtitle: 'Ref #IMPS99824 • Yesterday',
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
                const Icon(Icons.shield_rounded, color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Guild guarantee: Guaranteed immediate IMPS payout processing 24/7 with zero service deduction.',
                    style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11),
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
              Text(title, style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: AppTypography.labelLg.copyWith(color: amountColor, fontWeight: FontWeight.w700)),
            Text(status, style: AppTypography.labelSm.copyWith(color: AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

