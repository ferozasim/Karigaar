import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/artisan_profile_model.dart';
import '../../../core/models/wallet_settlement_entry.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../widgets/artisan_bottom_nav.dart';

enum _LedgerFilter { all, credits, payouts }

class ArtisanWalletHistoryScreen extends ConsumerStatefulWidget {
  const ArtisanWalletHistoryScreen({super.key});

  @override
  ConsumerState<ArtisanWalletHistoryScreen> createState() =>
      _ArtisanWalletHistoryScreenState();
}

class _ArtisanWalletHistoryScreenState
    extends ConsumerState<ArtisanWalletHistoryScreen> {
  _LedgerFilter _filter = _LedgerFilter.all;

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(artisanWalletBalanceProvider);
    final profile = ref.watch(currentArtisanProfileProvider);
    final isElite =
        profile.isGuildElite || ref.watch(guildEliteSubscriptionProvider);
    final entries = ref.watch(walletSettlementLedgerProvider);
    final todayEarnings = ref.watch(todayEarningsProvider);
    final weeklyEarnings = ref.watch(weeklyEarningsProvider);
    final lang = ref.watch(partnerLanguageProvider);

    final double reserve = profile.securityReserveAmount;
    final double withdrawable = balance > reserve ? balance - reserve : 0.0;

    final filteredEntries = entries.where((entry) {
      switch (_filter) {
        case _LedgerFilter.credits:
          return entry.isCredit;
        case _LedgerFilter.payouts:
          return entry.isImpsWithdrawal;
        case _LedgerFilter.all:
          return true;
      }
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(profile: profile, isElite: isElite, lang: lang),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroWalletCard(
                    context,
                    balance: balance,
                    reserve: reserve,
                    withdrawable: withdrawable,
                    profile: profile,
                  ),
                  const SizedBox(height: 16),
                  _buildEarningsBento(
                    todayEarnings: todayEarnings,
                    weeklyEarnings: weeklyEarnings,
                    isElite: isElite,
                  ),
                  const SizedBox(height: 20),
                  _buildLedgerHeader(),
                  const SizedBox(height: 10),
                  if (filteredEntries.isEmpty)
                    _buildEmptyLedgerState()
                  else
                    ...filteredEntries.map(_buildSettlementCard),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ArtisanBottomNav(currentTab: ArtisanNavTab.wallet),
    );
  }

  Widget _buildHeader({
    required ArtisanProfileModel profile,
    required bool isElite,
    required String lang,
  }) {
    final title = switch (lang) {
      'hi' => 'गिल्ड वॉलेट और कमाई',
      'mr' => 'गिल्ड वॉलेट आणि कमाई',
      _ => 'Guild Wallet & Earnings',
    };

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineMd.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Guild ID: ${profile.guildId} • 24x7 IMPS Settlement',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Text(
                  isElite ? '5% Elite Floor' : '12% Pro Rate',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondaryLight,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroWalletCard(
    BuildContext context, {
    required double balance,
    required double reserve,
    required double withdrawable,
    required ArtisanProfileModel profile,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'CLEARED AVAILABLE BALANCE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(
                Icons.verified_user_rounded,
                color: AppColors.tertiaryLight,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '₹${balance.toStringAsFixed(2)}',
              key: const Key('wallet_cleared_balance_text'),
              style: AppTypography.numericPrice.copyWith(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOCKED SECURITY RESERVE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '₹${reserve.toStringAsFixed(2)}',
                          key: const Key('wallet_locked_reserve_text'),
                          style: AppTypography.numericPrice.copyWith(
                            color: AppColors.secondaryLight,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white12,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INSTANT WITHDRAWABLE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '₹${withdrawable.toStringAsFixed(2)}',
                          key: const Key('wallet_withdrawable_text'),
                          style: AppTypography.numericPrice.copyWith(
                            color: AppColors.tertiaryLight,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.account_balance_rounded,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${profile.bankName} ${profile.maskedAccountNumber} • ${profile.upiId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('wallet_withdraw_imps_btn'),
              onPressed: () => _handleWithdrawTap(
                context,
                balance: balance,
                reserve: reserve,
                withdrawable: withdrawable,
                profile: profile,
              ),
              icon: const Icon(Icons.bolt_rounded, size: 20),
              label: const Text(
                'Instant IMPS Bank Withdrawal (₹0 Fee)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsBento({
    required double todayEarnings,
    required double weeklyEarnings,
    required bool isElite,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Earnings",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm,
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹${todayEarnings.toStringAsFixed(0)}',
                    key: const Key('wallet_today_earnings_text'),
                    style: AppTypography.numericPrice.copyWith(
                      color: AppColors.tertiary,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cleared & IMPS Ready',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Earnings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm,
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹${weeklyEarnings.toStringAsFixed(0)}',
                    key: const Key('wallet_weekly_earnings_text'),
                    style: AppTypography.numericPrice.copyWith(
                      color: AppColors.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isElite ? '5% Elite Commission Floor' : '12% Standard Rate',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLedgerHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completed Job Settlement Ledger',
          style: AppTypography.headlineSm.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 4),
        Text(
          'Itemized labor, 0% fee parts pass-through, guild commission & net IMPS payouts',
          style: AppTypography.bodySm.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ChoiceChip(
              key: const Key('ledger_filter_all'),
              label: const Text('All'),
              selected: _filter == _LedgerFilter.all,
              onSelected: (_) => setState(() => _filter = _LedgerFilter.all),
            ),
            ChoiceChip(
              key: const Key('ledger_filter_credits'),
              label: const Text('Job Credits'),
              selected: _filter == _LedgerFilter.credits,
              onSelected: (_) =>
                  setState(() => _filter = _LedgerFilter.credits),
            ),
            ChoiceChip(
              key: const Key('ledger_filter_payouts'),
              label: const Text('IMPS Payouts'),
              selected: _filter == _LedgerFilter.payouts,
              onSelected: (_) =>
                  setState(() => _filter = _LedgerFilter.payouts),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyLedgerState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Center(
        child: Text(
          'No ledger entries found for this filter.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildSettlementCard(WalletSettlementEntry entry) {
    final bool isCredit = entry.isCredit;
    final Color amountColor =
        isCredit ? AppColors.tertiary : AppColors.secondary;

    return Container(
      key: Key('ledger_entry_${entry.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCredit
                      ? AppColors.tertiarySurfaceTint
                      : AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCredit
                      ? Icons.task_alt_rounded
                      : Icons.account_balance_rounded,
                  size: 18,
                  color: amountColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.jobTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelLg.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${entry.bookingId} • ${entry.customerLocality}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(fontSize: 11.5),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          entry.completedAtLabel,
                          style: AppTypography.bodySm.copyWith(fontSize: 11),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isCredit
                                ? AppColors.tertiarySurfaceTint
                                : AppColors.secondarySurfaceTint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            entry.statusLabel,
                            style: AppTypography.labelSm.copyWith(
                              color: amountColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${isCredit ? '+' : '-'}₹${entry.netPayout.toStringAsFixed(2)}',
                  style: AppTypography.numericPrice.copyWith(
                    color: amountColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          if (isCredit) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _breakdownRow(
                    'Labor Earned',
                    '₹${entry.laborAmount.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 4),
                  _breakdownRow(
                    'Parts Pass-Through (0% fee)',
                    '₹${entry.partsPassThrough.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 4),
                  _breakdownRow(
                    'Guild Commission (${entry.commissionPercent}%)',
                    '-₹${entry.commissionAmount.toStringAsFixed(0)}',
                    valueColor: AppColors.error,
                  ),
                  const Divider(height: 12),
                  _breakdownRow(
                    'Net Payout Credited',
                    '+₹${entry.netPayout.toStringAsFixed(2)}',
                    isBold: true,
                    valueColor: AppColors.tertiary,
                  ),
                ],
              ),
            ),
          ] else if (entry.bankReference != null) ...[
            const SizedBox(height: 8),
            Text(
              'IMPS Bank Ref: ${entry.bankReference}',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _breakdownRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (isBold ? AppTypography.labelMd : AppTypography.bodySm)
                .copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTypography.labelMd.copyWith(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _handleWithdrawTap(
    BuildContext context, {
    required double balance,
    required double reserve,
    required double withdrawable,
    required ArtisanProfileModel profile,
  }) {
    if (balance <= 0 || withdrawable <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Cannot withdraw. A mandatory ₹${reserve.toStringAsFixed(0)} security reserve must be maintained.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }

    final amountCtrl =
        TextEditingController(text: withdrawable.toStringAsFixed(0));

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Instant IMPS Bank Withdrawal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transfer cleared surplus to ${profile.bankName} ${profile.maskedAccountNumber} (${profile.upiId}).',
                style: AppTypography.bodyMd,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Max Withdrawable: ₹${withdrawable.toStringAsFixed(2)} (₹${reserve.toStringAsFixed(0)} reserve locked)',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('wallet_imps_amount_field'),
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  labelText: 'Withdrawal Amount',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('wallet_confirm_imps_btn'),
            onPressed: () async {
              final requested = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
              Navigator.pop(dialogCtx);
              try {
                final api = ref.read(apiServiceProvider);
                final res = await api.withdrawWalletImps(
                  artisanId: profile.artisanId,
                  amount: requested,
                  currentWalletBalance: balance,
                  upiId: profile.upiId,
                );
                final data = res['data'] as Map<String, dynamic>;
                final bankRef =
                    data['bankReferenceNumber']?.toString() ?? 'RRN_IMPS';
                final remaining =
                    (data['remainingBalance'] as num).toDouble();

                ref.read(artisanWalletBalanceProvider.notifier).state =
                    remaining;
                ref
                    .read(walletSettlementLedgerProvider.notifier)
                    .recordImpsWithdrawal(
                      amount: requested,
                      bankLabel:
                          '${profile.bankName} ${profile.maskedAccountNumber}',
                      bankReference: bankRef,
                    );

                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '₹${requested.toStringAsFixed(2)} transferred via IMPS! Ref #$bankRef',
                        ),
                        backgroundColor: AppColors.tertiary,
                      ),
                    );
                }
              } on ApiException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(e.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                }
              }
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
}
