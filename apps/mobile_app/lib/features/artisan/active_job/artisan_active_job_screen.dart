import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/models/booking_model.dart';
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
    if (code == '4921') {
      setState(() => _startOtpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start Code 4921 verified! Stopwatch activated.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code! Ask customer for their 4-digit start code.')),
      );
    }
  }

  void _addPart() {
    setState(() {
      _parts.add(
        BillPartItem(
          id: 'p${_parts.length + 1}',
          name: 'Finolex 2.5 sq mm Copper Wire (5m)',
          unitPrice: 220,
          quantity: 1,
        ),
      );
    });
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
          onPressed: () => context.pop(),
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
                        Text('ON-SITE REPAIR STOPWATCH', style: AppTypography.labelSm.copyWith(color: AppColors.secondary)),
                        Text('28m 14s Elapsed', style: AppTypography.headlineMd.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
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
                        Text('Step 1: Enter Customer Start Code', style: AppTypography.labelLg),
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
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_rounded, color: AppColors.tertiary, size: 20),
                    SizedBox(width: 8),
                    Text('Start Code 4921 Verified • Doorstep Handshake Complete', style: TextStyle(color: AppColors.tertiary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Step 2: Dynamic Parts & Materials Bill Builder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dynamic Bill Builder', style: AppTypography.headlineSm),
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
                              Text(part.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (part.receiptPhotoUrl != null)
                                Row(
                                  children: const [
                                    Icon(Icons.receipt_long_rounded, size: 14, color: AppColors.tertiary),
                                    SizedBox(width: 4),
                                    Text('Receipt Photo Attached', style: TextStyle(fontSize: 11, color: AppColors.tertiary)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Text('₹${part.total}', style: AppTypography.numericPrice.copyWith(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),

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
                  Text('Total Invoiced to Customer', style: AppTypography.labelLg),
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
                if (pin == '7294') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('IMPS Payout Settled!'),
                      content: Text('₹$totalBill has been transferred to your registered bank account via RazorpayX / IMPS at 0% guild fee!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ctx.pop();
                            context.go('/artisan/radar');
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
          ],
        ),
      ),
    );
  }
}
