import '../../models/wallet_model.dart';
import '../../models/wallet_settlement_entry.dart';

abstract interface class IWalletRepository {
  Future<WalletModel?> getWalletByArtisanId(String artisanId);
  Future<WalletSettlementEntry> recordSettlement(
    String artisanId,
    WalletSettlementEntry entry,
  );
  Future<WalletSettlementEntry> withdrawImps(
    String artisanId, {
    required int amountPaise,
    required String bankReference,
  });
  Future<List<WalletSettlementEntry>> getLedgerHistory(String artisanId);
  Stream<WalletModel?> streamWallet(String artisanId);
  Stream<List<WalletSettlementEntry>> streamLedgerHistory(String artisanId);
}
