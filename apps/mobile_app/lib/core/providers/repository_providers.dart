import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_data_service.dart';
import '../models/artisan_profile_model.dart';
import '../models/booking_model.dart';
import '../models/user_profile_model.dart';
import '../models/user_role.dart';
import '../models/wallet_model.dart';
import '../repositories/fallback/fallback_repositories.dart';
import '../repositories/firestore/firestore_repositories.dart';
import '../repositories/interfaces/artisan_repository.dart';
import '../repositories/interfaces/booking_repository.dart';
import '../repositories/interfaces/mandate_repository.dart';
import '../repositories/interfaces/user_repository.dart';
import '../repositories/interfaces/wallet_repository.dart';
import '../repositories/local/in_memory_repositories.dart';

/// Whether Firebase was initialized by the host application. Tests and local
/// builds intentionally remain offline-first without credentials.
final isFirebaseLiveProvider = Provider<bool>((ref) {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (!ref.watch(isFirebaseLiveProvider)) return null;
  return FirebaseFirestore.instance;
});

class RepositoryBundle {
  RepositoryBundle({
    required this.user,
    required this.artisan,
    required this.booking,
    required this.mandate,
    required this.wallet,
    required this.isFirebaseLive,
  });

  final IUserRepository user;
  final IArtisanRepository artisan;
  final IBookingRepository booking;
  final IMandateRepository mandate;
  final IWalletRepository wallet;
  final bool isFirebaseLive;

  Future<void> dispose() async {
    if (user is InMemoryUserRepository) {
      await (user as InMemoryUserRepository).dispose();
    }
    if (artisan is InMemoryArtisanRepository) {
      await (artisan as InMemoryArtisanRepository).dispose();
    }
    if (booking is InMemoryBookingRepository) {
      await (booking as InMemoryBookingRepository).dispose();
    }
    if (wallet is InMemoryWalletRepository) {
      await (wallet as InMemoryWalletRepository).dispose();
    }
  }
}

RepositoryBundle createLocalRepositoryBundle({
  Iterable<ArtisanProfileModel>? artisans,
  Iterable<BookingModel> bookings = const [],
  Iterable<UserProfileModel>? users,
  Iterable<WalletModel>? wallets,
}) {
  final now = DateTime.now();
  return RepositoryBundle(
    user: InMemoryUserRepository(users ??
        [
          UserProfileModel(
            userId: 'cust_01',
            displayName: 'Asim Farooqui',
            phone: '+919822199882',
            activeRole: UserRole.customer,
            cityId: 'city_nanded_01',
            createdAt: now,
            updatedAt: now,
          ),
        ]),
    artisan: InMemoryArtisanRepository(
      artisans ?? AppDataService.getAllSampleArtisans(),
    ),
    booking: InMemoryBookingRepository(bookings),
    mandate: InMemoryMandateRepository(),
    wallet: InMemoryWalletRepository(
      wallets: wallets ??
          [
            WalletModel(
              artisanId: 'art_partner_self',
              availableBalancePaise: 462000,
              reserveBalancePaise: 200000,
              updatedAt: now,
            ),
          ],
    ),
    isFirebaseLive: false,
  );
}

final repositoryBundleProvider = Provider<RepositoryBundle>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final localBundle = createLocalRepositoryBundle();
  ref.onDispose(() => unawaited(localBundle.dispose()));
  if (firestore == null) return localBundle;

  return RepositoryBundle(
    user: FallbackUserRepository(
      FirestoreUserRepository(firestore),
      localBundle.user,
    ),
    artisan: FallbackArtisanRepository(
      FirestoreArtisanRepository(firestore),
      localBundle.artisan,
    ),
    booking: FallbackBookingRepository(
      FirestoreBookingRepository(firestore),
      localBundle.booking,
    ),
    mandate: FallbackMandateRepository(
      FirestoreMandateRepository(firestore),
      localBundle.mandate,
    ),
    wallet: FallbackWalletRepository(
      FirestoreWalletRepository(firestore),
      localBundle.wallet,
    ),
    isFirebaseLive: true,
  );
});

final userRepositoryProvider = Provider<IUserRepository>(
  (ref) => ref.watch(repositoryBundleProvider).user,
);
final artisanRepositoryProvider = Provider<IArtisanRepository>(
  (ref) => ref.watch(repositoryBundleProvider).artisan,
);
final bookingRepositoryProvider = Provider<IBookingRepository>(
  (ref) => ref.watch(repositoryBundleProvider).booking,
);
final mandateRepositoryProvider = Provider<IMandateRepository>(
  (ref) => ref.watch(repositoryBundleProvider).mandate,
);
final walletRepositoryProvider = Provider<IWalletRepository>(
  (ref) => ref.watch(repositoryBundleProvider).wallet,
);

/// Simple test helper: callers can override this provider with a custom
/// deterministic bundle without configuring Firebase or global state.
Override localRepositoryOverride(RepositoryBundle bundle) =>
    repositoryBundleProvider.overrideWithValue(bundle);

final repositoryArtisansProvider =
    StreamProvider.family<List<ArtisanProfileModel>, String>((ref, cityId) {
  return ref.watch(artisanRepositoryProvider).streamArtisans(cityId);
});

final repositoryActiveBookingsProvider =
    StreamProvider.family<List<BookingModel>, String>((ref, customerId) {
  return ref.watch(bookingRepositoryProvider).streamActiveBookings(customerId);
});

final repositoryWalletProvider =
    StreamProvider.family<WalletModel?, String>((ref, artisanId) {
  return ref.watch(walletRepositoryProvider).streamWallet(artisanId);
});
