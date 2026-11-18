import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/artisan_profile_model.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/models/mandate_model.dart';
import 'package:karigaar_app/core/models/user_profile_model.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/models/wallet_model.dart';
import 'package:karigaar_app/core/repositories/firestore/firestore_serializers.dart';

void main() {
  final timestamp = DateTime.utc(2026, 11, 18, 10);

  test(
      'Firestore user and mandate records preserve owner fields required by rules',
      () {
    final user = UserProfileModel(
      userId: 'cust_01',
      displayName: 'Asim',
      phone: '+919800000000',
      activeRole: UserRole.customer,
      cityId: 'city_nanded_01',
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    final mandate = MandateModel(
      mandateId: 'man_01',
      bookingId: 'BK_01',
      customerId: user.userId,
      upiVpa: 'asim@okaxis',
      amountPaise: 9900,
      status: UpiMandateStatus.authorized,
      idempotencyKey: 'BK_01-preauth',
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    expect(
        UserProfileModel.fromJson(user.toJson()).activeRole, UserRole.customer);
    expect(mandate.toJson()['customerId'], user.userId);
    expect(MandateModel.fromJson(mandate.toJson()).amountPaise, 9900);
  });

  test('Firestore artisan directory schema round-trips public profile fields',
      () {
    const artisan = ArtisanProfileModel(
      artisanId: 'art_01',
      name: 'Ganesh',
      phone: '+919811111111',
      primaryTradeId: 'trade_electrician',
      tradeTitle: 'Electrician',
      yearsExperience: 8,
      rating: 4.9,
      reviewCount: 40,
      distanceKm: 1.2,
      bio: 'Verified',
      inspectionFee: 199,
      cityId: 'city_nanded_01',
      localityId: 'loc_anand_nagar',
    );

    final data = FirestoreSerializers.artisanToJson(artisan);
    expect(data['artisanId'], artisan.artisanId);
    expect(data['cityId'], 'city_nanded_01');
    expect(
      FirestoreSerializers.artisanFromJson(data).localizedRoleTitle,
      artisan.localizedRoleTitle,
    );
  });

  test('Firestore booking and wallet schema use stable document identities',
      () {
    final booking = BookingModel(
      bookingId: 'BK_01',
      customerId: 'cust_01',
      customerName: 'Asim',
      customerPhone: '+919800000000',
      tradeId: 'trade_electrician',
      tradeName: 'Electrician',
      localityId: 'loc_anand_nagar',
      localityName: 'Anand Nagar',
      address: 'Plot 1',
      status: BookingStatus.broadcasting,
      createdAt: timestamp,
    );
    final wallet = WalletModel(
      artisanId: 'art_01',
      availableBalancePaise: 462000,
      reserveBalancePaise: 200000,
      updatedAt: timestamp,
    );

    expect(
        BookingModel.fromJson(booking.toJson()).bookingId, booking.bookingId);
    expect(wallet.toJson()['artisanId'], wallet.artisanId);
    expect(WalletModel.fromJson(wallet.toJson()).withdrawablePaise, 262000);
  });
}
