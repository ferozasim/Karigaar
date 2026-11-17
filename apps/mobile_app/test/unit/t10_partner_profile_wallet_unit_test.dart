import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/config/app_data_service.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';
import 'package:karigaar_app/core/models/wallet_settlement_entry.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  group('Ticket T-10 Unit Tests: Models, Directory Sync & Settlement Ledger', () {
    test('KarigaarRoleType.thekedar properties, localized titles, and fromString', () {
      expect(KarigaarRoleType.thekedar.id, equals('thekedar'));
      expect(KarigaarRoleType.thekedar.standardLabel, equals('Thekedar / Team Contractor'));
      expect(KarigaarRoleType.thekedar.shortLabel, equals('Thekedar'));
      expect(KarigaarRoleType.thekedar.marathiLabel, equals('ठेकेदार / टीम लीडर'));
      expect(KarigaarRoleType.thekedar.badgeText, equals('👷 Thekedar'));
      expect(KarigaarRoleType.thekedar.rateMultiplier, equals(1.35));

      expect(
        KarigaarRoleType.thekedar.getLocalizedTitle('trade_electrician'),
        equals('Electrical Team Thekedar (ठेकेदार)'),
      );
      expect(
        KarigaarRoleType.thekedar.getLocalizedTitle('trade_mason'),
        equals('Civil & Masonry Thekedar (ठेकेदार)'),
      );
      expect(
        KarigaarRoleType.fromString('thekedar'),
        equals(KarigaarRoleType.thekedar),
      );
      expect(
        KarigaarRoleType.fromString('Team Contractor'),
        equals(KarigaarRoleType.thekedar),
      );
    });

    test('ArtisanProfileModel copyWith and guildTierDisplayLabel', () {
      const base = defaultCurrentPartnerProfile;
      expect(
        base.guildTierDisplayLabel,
        equals('Tier 3: Master Guildsman • 5% Commission Floor'),
      );

      final nonElite = base.copyWith(
        isGuildElite: false,
        tier: GuildTier.guildVerifiedPro,
        inspectionFee: 299,
        dailyDihadiRate: 1100,
      );

      expect(nonElite.inspectionFee, equals(299));
      expect(nonElite.dailyDihadiRate, equals(1100));
      expect(nonElite.guildTierDisplayLabel, equals(GuildTier.guildVerifiedPro.label));
      expect(nonElite.effectiveCommissionRate, equals(0.12));

      final portfolioCopy = base.portfolioItems.first.copyWith(title: 'Updated MCB Board');
      expect(portfolioCopy.title, equals('Updated MCB Board'));
      expect(portfolioCopy.location, equals(base.portfolioItems.first.location));
    });

    test('currentArtisanProfileProvider keeps default district count untouched until edited, then syncs live', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initially overrides map is empty so default Nanded sample list has 4 artisans
      expect(container.read(artisanDirectoryOverridesProvider), isEmpty);
      expect(container.read(topArtisansProvider).length, equals(4));

      // Edit rate card & bio
      container.read(currentArtisanProfileProvider.notifier).updateProfileAndRateCard(
            inspectionFee: 349,
            dailyDihadiRate: 1200,
            bio: 'Updated commercial & residential specialist.',
            roleType: KarigaarRoleType.thekedar,
          );

      final updated = container.read(currentArtisanProfileProvider);
      expect(updated.inspectionFee, equals(349));
      expect(updated.dailyDihadiRate, equals(1200));
      expect(updated.roleType, equals(KarigaarRoleType.thekedar));

      // Live synced to topArtisansProvider and artisanByIdProvider
      final directoryList = container.read(topArtisansProvider);
      expect(directoryList.length, equals(5));
      final synced = container.read(artisanByIdProvider(updated.artisanId));
      expect(synced.inspectionFee, equals(349));
      expect(synced.bio, equals('Updated commercial & residential specialist.'));
    });

    test('addPortfolioPhoto, toggleGuildElite, and syncFromRegistration update state & directory', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentArtisanProfileProvider.notifier).addPortfolioPhoto(
            const PortfolioWorkItem(
              id: 'pf_new',
              title: 'Solar Inverter Integration',
              location: 'Waghala, Nanded',
              badge: 'Grid Synced',
              duration: 'Completed in 4 hrs',
            ),
          );

      expect(container.read(currentArtisanProfileProvider).portfolioItems.first.title,
          equals('Solar Inverter Integration'));

      container.read(currentArtisanProfileProvider.notifier).toggleGuildElite(false);
      expect(container.read(currentArtisanProfileProvider).isGuildElite, isFalse);
      expect(container.read(guildEliteSubscriptionProvider), isFalse);

      container.read(currentArtisanProfileProvider.notifier).toggleGuildElite(true);
      expect(container.read(currentArtisanProfileProvider).isGuildElite, isTrue);
      expect(container.read(guildEliteSubscriptionProvider), isTrue);

      container.read(currentArtisanProfileProvider.notifier).syncFromRegistration(
            name: 'Vikram Deshmukh',
            phone: '+919800112233',
            primaryTradeId: 'trade_plumber',
            tradeTitle: 'Plumbing (Fittings & Pressure)',
            roleType: KarigaarRoleType.thekedar,
            experienceTierLabel: '10+ Master',
            cityId: 'city_nanded_01',
            localityId: 'loc_vazirabad',
          );

      final regProfile = container.read(currentArtisanProfileProvider);
      expect(regProfile.name, equals('Vikram Deshmukh'));
      expect(regProfile.primaryTradeId, equals('trade_plumber'));
      expect(
        container.read(topArtisansProvider).any((a) => a.name == 'Vikram Deshmukh'),
        isTrue,
      );
    });

    test('walletSettlementLedgerProvider calculates today & weekly earnings and records IMPS payouts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(todayEarningsProvider), equals(1875.0));
      expect(container.read(weeklyEarningsProvider), equals(5345.0));

      container.read(walletSettlementLedgerProvider.notifier).recordImpsWithdrawal(
            amount: 1000.0,
            bankLabel: 'HDFC Bank •••• 2104',
            bankReference: 'RRN_TEST_01',
          );

      final ledger = container.read(walletSettlementLedgerProvider);
      expect(ledger.first.isImpsWithdrawal, isTrue);
      expect(ledger.first.isCredit, isFalse);
      expect(ledger.first.netPayout, equals(1000.0));
      expect(ledger.first.bankReference, equals('RRN_TEST_01'));

      // Credit earnings totals remain unchanged by IMPS debit
      expect(container.read(todayEarningsProvider), equals(1875.0));
      expect(container.read(weeklyEarningsProvider), equals(5345.0));

      container.read(walletSettlementLedgerProvider.notifier).recordJobSettlement(
            const WalletSettlementEntry(
              id: 'stl_new',
              bookingId: 'BK_NANDED_9001',
              jobTitle: 'Earthing Rod Setup',
              customerLocality: 'Anand Nagar, Nanded',
              completedAtLabel: 'Just now',
              laborAmount: 500.0,
              partsPassThrough: 200.0,
              commissionRate: 0.05,
              commissionAmount: 25.0,
              netPayout: 675.0,
              isCredit: true,
              isImpsWithdrawal: false,
              statusLabel: 'Settled (5% Elite)',
              isToday: true,
              isThisWeek: true,
            ),
          );

      expect(container.read(todayEarningsProvider), equals(2550.0));
      expect(container.read(weeklyEarningsProvider), equals(6020.0));
    });

    test('withdrawWalletImps handles exact paise (2000.01 -> 0.01), rejects NaN/Infinity, and respects custom minReserve', () async {
      const api = KarigaarApiService();

      // 2000.01 - 2000.00 allows exact 0.01 withdrawal without IEEE-754 drift
      final paiseRes = await api.withdrawWalletImps(
        artisanId: 'art_partner_self',
        amount: 0.01,
        currentWalletBalance: 2000.01,
        upiId: 'ramesh.karigaar@okaxis',
      );
      expect(paiseRes['status'], equals('SUCCESS'));
      final paiseData = paiseRes['data'] as Map<String, dynamic>;
      expect(paiseData['amountDebited'], equals(0.01));
      expect(paiseData['remainingBalance'], equals(2000.0));

      // Reject NaN, Infinity, -Infinity, zero, negative
      for (final bad in [double.nan, double.infinity, double.negativeInfinity, 0.0, -50.0]) {
        await expectLater(
          () => api.withdrawWalletImps(
            artisanId: 'art_partner_self',
            amount: bad,
            currentWalletBalance: 4620.0,
            upiId: 'ramesh.karigaar@okaxis',
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_AMOUNT')),
        );
      }

      // Reject NaN balance
      await expectLater(
        () => api.withdrawWalletImps(
          artisanId: 'art_partner_self',
          amount: 100.0,
          currentWalletBalance: double.nan,
          upiId: 'ramesh.karigaar@okaxis',
        ),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'INVALID_BALANCE')),
      );

      // Custom minReserve = 3000.0
      await expectLater(
        () => api.withdrawWalletImps(
          artisanId: 'art_partner_self',
          amount: 2000.0,
          currentWalletBalance: 4620.0,
          upiId: 'ramesh.karigaar@okaxis',
          minReserve: 3000.0,
        ),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'SECURITY_RESERVE_VIOLATION')),
      );

      final customReserveOk = await api.withdrawWalletImps(
        artisanId: 'art_partner_self',
        amount: 1620.0,
        currentWalletBalance: 4620.0,
        upiId: 'ramesh.karigaar@okaxis',
        minReserve: 3000.0,
      );
      expect((customReserveOk['data'] as Map<String, dynamic>)['remainingBalance'], equals(3000.0));
    });

    test('KarigaarRoleType.fromString matches Mistri, मिस्त्री, and ठेकेदार', () {
      expect(KarigaarRoleType.fromString('Mistri'), equals(KarigaarRoleType.headMistry));
      expect(KarigaarRoleType.fromString('मिस्त्री'), equals(KarigaarRoleType.headMistry));
      expect(KarigaarRoleType.fromString('ठेकेदार'), equals(KarigaarRoleType.thekedar));
    });

    test('guildEliteSubscriptionProvider and currentArtisanProfileProvider start aligned false and sync bidirectionally', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(guildEliteSubscriptionProvider), isFalse);
      final initialProfile = container.read(currentArtisanProfileProvider);
      expect(initialProfile.isGuildElite, isFalse);
      expect(initialProfile.tier, equals(GuildTier.masterGuildsman));
      expect(initialProfile.effectiveCommissionRate, equals(0.08));
      expect(
        initialProfile.guildTierDisplayLabel,
        equals('Tier 3: Master Guildsman • 5% Commission Floor'),
      );

      // Toggling guildEliteSubscriptionProvider directly syncs currentArtisanProfileProvider
      container.read(guildEliteSubscriptionProvider.notifier).state = true;
      expect(container.read(currentArtisanProfileProvider).isGuildElite, isTrue);
      expect(container.read(currentArtisanProfileProvider).tier, equals(GuildTier.guildElite));
      expect(container.read(currentArtisanProfileProvider).effectiveCommissionRate, equals(0.05));

      // Toggling back via notifier syncs guildEliteSubscriptionProvider
      container.read(currentArtisanProfileProvider.notifier).toggleGuildElite(false);
      expect(container.read(guildEliteSubscriptionProvider), isFalse);
      expect(container.read(currentArtisanProfileProvider).isGuildElite, isFalse);
    });

    test('AppDataService trades use canonical trade_ac_refrig matching partner profile catalog', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final trades = await AppDataService.loadTrades();
      expect(trades.any((t) => t.tradeId == 'trade_ac_refrig'), isTrue);
      expect(trades.any((t) => t.tradeId == 'trade_ac_repair'), isFalse);
    });
  });
}
