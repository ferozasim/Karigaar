import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/partner_copy.dart';
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
    final copy = PartnerCopy.of(lang);

    final double reserve = profile.securityReserveAmount;
    final int balancePaise = (balance * 100).round();
    final int reservePaise = (reserve * 100).round();
    final int withdrawablePaise =
        balancePaise > reservePaise ? balancePaise - reservePaise : 0;
    final double withdrawable = withdrawablePaise / 100.0;

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
            _buildHeader(profile: profile, isElite: isElite, copy: copy),
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
                    copy: copy,
                  ),
                  const SizedBox(height: 16),
                  _buildEarningsBento(
                    todayEarnings: todayEarnings,
                    weeklyEarnings: weeklyEarnings,
                    isElite: isElite,
                    copy: copy,
                  ),
                  const SizedBox(height: 20),
                  _buildLedgerHeader(copy),
                  const SizedBox(height: 10),
                  if (filteredEntries.isEmpty)
                    _buildEmptyLedgerState(copy)
                  else
                    ...filteredEntries
                        .map((entry) => _buildSettlementCard(entry, copy)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ArtisanBottomNav(currentTab: ArtisanNavTab.wallet),
    );
  }

  String _formatRupeesCompact(double value) {
    final paise = (value * 100).round();
    if (paise % 100 == 0) {
      return (paise ~/ 100).toString();
    }
    return (paise / 100.0).toStringAsFixed(2);
  }

  Widget _buildHeader({
    required ArtisanProfileModel profile,
    required bool isElite,
    required PartnerCopy copy,
  }) {
    final badgeLabel = isElite
        ? copy.eliteFloorBadge
        : (profile.tier == GuildTier.masterGuildsman
            ? copy.masterRateBadge
            : copy.proRateBadge);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      copy.walletTitle,
                      style: AppTypography.headlineMd.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Guild ID: ${profile.guildId} • 24x7 IMPS Settlement',
                      style: AppTypography.bodySm.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Text(
                    badgeLabel,
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
      ),
    );
  }

  Widget _buildHeroWalletCard(
    BuildContext context, {
    required double balance,
    required double reserve,
    required double withdrawable,
    required ArtisanProfileModel profile,
    required PartnerCopy copy,
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
                  copy.clearedAvailableBalance,
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
                        copy.lockedSecurityReserve,
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
                        copy.instantWithdrawable,
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
                copy: copy,
              ),
              icon: const Icon(Icons.bolt_rounded, size: 20),
              label: Text(
                copy.withdrawImpsBtn,
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
    required PartnerCopy copy,
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
                  copy.todaysEarnings,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm,
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹${_formatRupeesCompact(todayEarnings)}',
                    key: const Key('wallet_today_earnings_text'),
                    style: AppTypography.numericPrice.copyWith(
                      color: AppColors.tertiary,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  copy.clearedImpsReady,
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
                  copy.weeklyEarnings,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm,
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹${_formatRupeesCompact(weeklyEarnings)}',
                    key: const Key('wallet_weekly_earnings_text'),
                    style: AppTypography.numericPrice.copyWith(
                      color: AppColors.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isElite
                      ? copy.eliteCommissionLabel
                      : copy.standardRateLabel,
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

  Widget _buildLedgerHeader(PartnerCopy copy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.ledgerTitle,
          style: AppTypography.headlineSm.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 4),
        Text(
          copy.ledgerSubtitle,
          style: AppTypography.bodySm.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ChoiceChip(
              key: const Key('ledger_filter_all'),
              label: Text(copy.filterAll),
              selected: _filter == _LedgerFilter.all,
              onSelected: (_) => setState(() => _filter = _LedgerFilter.all),
            ),
            ChoiceChip(
              key: const Key('ledger_filter_credits'),
              label: Text(copy.filterCredits),
              selected: _filter == _LedgerFilter.credits,
              onSelected: (_) =>
                  setState(() => _filter = _LedgerFilter.credits),
            ),
            ChoiceChip(
              key: const Key('ledger_filter_payouts'),
              label: Text(copy.filterPayouts),
              selected: _filter == _LedgerFilter.payouts,
              onSelected: (_) =>
                  setState(() => _filter = _LedgerFilter.payouts),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyLedgerState(PartnerCopy copy) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Center(
        child: Text(
          copy.emptyLedgerText,
          style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildSettlementCard(WalletSettlementEntry entry, PartnerCopy copy) {
    final bool isCredit = entry.isCredit;
    final Color amountColor =
        isCredit ? AppColors.tertiary : AppColors.secondary;
    final double maxAmountWidth = MediaQuery.sizeOf(context).width * 0.34;

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
              Flexible(
                flex: 0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxAmountWidth),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${isCredit ? '+' : '-'}₹${entry.netPayout.toStringAsFixed(2)}',
                      style: AppTypography.numericPrice.copyWith(
                        color: amountColor,
                        fontSize: 16,
                      ),
                    ),
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
                    copy.laborEarned,
                    '₹${_formatRupeesCompact(entry.laborAmount)}',
                  ),
                  const SizedBox(height: 4),
                  _breakdownRow(
                    copy.partsPassThrough,
                    '₹${_formatRupeesCompact(entry.partsPassThrough)}',
                  ),
                  const SizedBox(height: 4),
                  _breakdownRow(
                    '${copy.guildCommission} (${entry.commissionPercent}%)',
                    '-₹${_formatRupeesCompact(entry.commissionAmount)}',
                    valueColor: AppColors.error,
                  ),
                  const Divider(height: 12),
                  _breakdownRow(
                    copy.netPayoutCredited,
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
    required PartnerCopy copy,
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

    final String prefillText = withdrawable == withdrawable.truncateToDouble()
        ? withdrawable.toStringAsFixed(0)
        : withdrawable.toStringAsFixed(2);

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => _ImpsWithdrawalDialog(
        prefillText: prefillText,
        balance: balance,
        reserve: reserve,
        withdrawable: withdrawable,
        profile: profile,
        copy: copy,
        onConfirm: (requested) async {
          try {
            final api = ref.read(apiServiceProvider);
            final res = await api.withdrawWalletImps(
              artisanId: profile.artisanId,
              amount: requested,
              currentWalletBalance: balance,
              upiId: profile.upiId,
              minReserve: reserve,
            );
            final data = res['data'] as Map<String, dynamic>;
            final bankRef =
                data['bankReferenceNumber']?.toString() ?? 'RRN_IMPS';
            final remaining = (data['remainingBalance'] as num).toDouble();

            ref.read(artisanWalletBalanceProvider.notifier).state = remaining;
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
      ),
    );
  }
}

class _ImpsWithdrawalDialog extends StatefulWidget {
  final String prefillText;
  final double balance;
  final double reserve;
  final double withdrawable;
  final ArtisanProfileModel profile;
  final PartnerCopy copy;
  final Future<void> Function(double requested) onConfirm;

  const _ImpsWithdrawalDialog({
    required this.prefillText,
    required this.balance,
    required this.reserve,
    required this.withdrawable,
    required this.profile,
    required this.copy,
    required this.onConfirm,
  });

  @override
  State<_ImpsWithdrawalDialog> createState() => _ImpsWithdrawalDialogState();
}

class _ImpsWithdrawalDialogState extends State<_ImpsWithdrawalDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: widget.prefillText);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = widget.copy;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                copy.impsDialogTitle,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: 10),
              Text(
                'Transfer cleared surplus to ${widget.profile.bankName} ${widget.profile.maskedAccountNumber} (${widget.profile.upiId}).',
                style: AppTypography.bodyMd,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurfaceTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Max Withdrawable: ₹${widget.withdrawable.toStringAsFixed(2)} (₹${widget.reserve.toStringAsFixed(0)} reserve locked)',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('wallet_imps_amount_field'),
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  labelText: copy.withdrawalAmountLabel,
                ),
                validator: (val) {
                  final parsed = double.tryParse((val ?? '').trim());
                  if (parsed == null || !parsed.isFinite || parsed <= 0) {
                    return copy.invalidAmountError;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(copy.cancelBtn),
        ),
        ElevatedButton(
          key: const Key('wallet_confirm_imps_btn'),
          onPressed: () async {
            if (!(_formKey.currentState?.validate() ?? false)) {
              return;
            }
            final requested = double.parse(_amountCtrl.text.trim());
            Navigator.pop(context);
            await widget.onConfirm(requested);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(copy.confirmWithdrawBtn),
        ),
      ],
    );
  }
}
