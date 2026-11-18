import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/models/audio_memo_model.dart';
import 'package:karigaar_app/core/models/arrival_slot_model.dart';
import 'package:karigaar_app/core/models/whatsapp_template_model.dart';
import 'package:karigaar_app/core/services/whatsapp_telephony_service.dart';

/// Service exception thrown when an API request violates validation or business invariants.
class ApiException implements Exception {
  final String message;
  final String? code;
  final int statusCode;

  const ApiException(this.message, {this.code, this.statusCode = 400});

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}

/// Unified Microservice REST Client & Mock Backend Engine for Karigaar
/// Implementing Interface Contracts from PROJECT.md Section 5.
class KarigaarApiService {
  static const KarigaarApiService instance = KarigaarApiService();

  const KarigaarApiService();

  static const int warrantyReserveRatePercent = 30;
  static const int warrantyClaimDeductiblePaise = 25000;

  /// Reserve contribution is 30% of the platform labor take-rate, in paise.
  int calculateWarrantyReserveContributionPaise(
      int platformLaborTakeRatePaise) {
    if (platformLaborTakeRatePaise < 0) {
      throw const ApiException('Platform labor take-rate cannot be negative.',
          code: 'INVALID_TAKE_RATE', statusCode: 422);
    }
    return (platformLaborTakeRatePaise * warrantyReserveRatePercent) ~/ 100;
  }

  /// Submit a post-job satisfaction record after validating its rating fields.
  Future<Map<String, dynamic>> submitPostJobCsat({
    required String bookingId,
    required int overallRating,
    required int cleanlinessRating,
    required int sawdustRating,
    String feedbackNote = '',
  }) async {
    if (bookingId.trim().isEmpty) {
      throw const ApiException('Booking ID is required.',
          code: 'MISSING_BOOKING_ID', statusCode: 422);
    }
    for (final rating in [overallRating, cleanlinessRating, sawdustRating]) {
      if (rating < 1 || rating > 5) {
        throw const ApiException('Ratings must be between 1 and 5.',
            code: 'INVALID_RATING', statusCode: 422);
      }
    }
    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'overallRating': overallRating,
        'cleanlinessRating': cleanlinessRating,
        'sawdustRating': sawdustRating,
        'feedbackNote': feedbackNote.trim(),
        'submittedAt': DateTime.now().toUtc().toIso8601String(),
      },
    };
  }

  /// Open a protected booking claim, applying the customer deductible and tier cap.
  Future<Map<String, dynamic>> raiseWarrantyClaim({
    required String bookingId,
    required int requestedAmountPaise,
    required int damageCoverAmountPaise,
    required DateTime completedAt,
    required bool warrantyEligible,
    String reason = '',
  }) async {
    if (bookingId.trim().isEmpty) {
      throw const ApiException('Booking ID is required.',
          code: 'MISSING_BOOKING_ID', statusCode: 422);
    }
    if (!warrantyEligible) {
      throw const ApiException(
          'This booking is not covered by the Guild warranty.',
          code: 'WARRANTY_NOT_ELIGIBLE',
          statusCode: 403);
    }
    final now = DateTime.now();
    if (completedAt.isAfter(now) ||
        now.isAfter(completedAt.add(const Duration(days: 30)))) {
      throw const ApiException(
          'Warranty claims must be raised within 30 days of completion.',
          code: 'WARRANTY_WINDOW_EXPIRED',
          statusCode: 403);
    }
    if (requestedAmountPaise <= warrantyClaimDeductiblePaise ||
        requestedAmountPaise > damageCoverAmountPaise) {
      throw const ApiException(
          'Claim amount must exceed the ₹250 deductible and stay within the booking cover limit.',
          code: 'CLAIM_AMOUNT_OUT_OF_RANGE',
          statusCode: 422);
    }
    return {
      'status': 'SUCCESS',
      'data': {
        'claimId': 'wc_${DateTime.now().millisecondsSinceEpoch}',
        'bookingId': bookingId,
        'requestedAmountPaise': requestedAmountPaise,
        'eligiblePayoutPaise':
            requestedAmountPaise - warrantyClaimDeductiblePaise,
        'customerDeductiblePaise': warrantyClaimDeductiblePaise,
        'maximumCoverPaise': damageCoverAmountPaise,
        'claimStatus': 'PENDING_REVIEW',
        'reason': reason.trim(),
        'submittedAt': DateTime.now().toUtc().toIso8601String(),
      },
    };
  }

  /// Contract 1: WhatsApp Authentication Request OTP (`POST /api/v1/auth/whatsapp/otp/request`)
  Future<Map<String, dynamic>> requestWhatsAppOtp({
    required String phoneNumber,
    required String role,
    String language = 'hi_IN',
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleanPhone.isEmpty || cleanPhone.length < 10) {
      throw const ApiException(
          'Invalid Indian phone number. Expected 10 digits.',
          code: 'INVALID_PHONE',
          statusCode: 422);
    }

    final reqId =
        'req_auth_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    return {
      'status': 'SUCCESS',
      'data': {
        'requestId': reqId,
        'phoneNumber': cleanPhone,
        'channelDispatched': 'WHATSAPP',
        'resendAvailableAfterSeconds': 42,
        'smsFallbackAvailable': true,
      },
    };
  }

  /// Contract 1: WhatsApp Authentication Verify OTP (`POST /api/v1/auth/whatsapp/otp/verify`)
  Future<Map<String, dynamic>> verifyWhatsAppOtp({
    required String requestId,
    required String phoneNumber,
    required String otpCode,
  }) async {
    final cleanOtp = otpCode.trim();
    if (cleanOtp.length != 4 && cleanOtp.length != 6) {
      throw const ApiException('Invalid OTP code. Expected 4 or 6 digits.',
          code: 'INVALID_OTP_LENGTH', statusCode: 422);
    }

    return {
      'status': 'SUCCESS',
      'data': {
        'authToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.karigaar_mock_token',
        'refreshToken': 'ref_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id':
              'usr_${phoneNumber.replaceAll(RegExp(r'\D'), '').substring(phoneNumber.length > 5 ? phoneNumber.length - 5 : 0)}',
          'phoneNumber': phoneNumber,
          'isKycVerified': true,
        },
      },
    };
  }

  /// Contract 2: Virtual Masked Telephony Bridge (`POST /api/v1/telephony/bridge-call`)
  Future<Map<String, dynamic>> bridgeTelephonyCall({
    required String callerNumber,
    required String calleeId,
    required String role,
    String? bookingId,
  }) async {
    if (callerNumber.isEmpty || calleeId.isEmpty) {
      throw const ApiException('Caller number and Callee ID are required.',
          code: 'MISSING_TELEPHONY_PARAMS', statusCode: 422);
    }

    try {
      final session =
          await KarigaarWhatsAppTelephonyService.instance.bridgeTelephonyCall(
        callerNumber: callerNumber,
        calleeId: calleeId,
        role: role,
        bookingId: bookingId,
      );
      return {
        'status': 'SUCCESS',
        'data': {
          'bridgeSessionId': session.sessionId,
          'bookingId': session.bookingId,
          'callerRole': session.callerRole,
          'virtualProxyNumber': session.virtualProxyNumber,
          'sessionStatus': session.sessionStatus,
          'zeroRawMsisdnLeakageGuaranteed':
              session.zeroRawMsisdnLeakageGuaranteed,
          'expiresInSeconds': session.expiresInSeconds,
        },
      };
    } catch (e) {
      if (e is ArgumentError) {
        throw ApiException(e.message.toString(),
            code: 'INVALID_TELEPHONY_PARAM', statusCode: 422);
      }
      rethrow;
    }
  }

  /// Get status of active telephony bridge session (`GET /api/v1/telephony/sessions/:id`)
  Future<Map<String, dynamic>> getTelephonyBridgeSession(
      {required String sessionId}) async {
    final session = KarigaarWhatsAppTelephonyService.instance
        .getTelephonyBridgeSession(sessionId);
    if (session == null) {
      throw const ApiException('Telephony session not found.',
          code: 'SESSION_NOT_FOUND', statusCode: 404);
    }
    return {
      'status': 'SUCCESS',
      'data': session.toJson(),
    };
  }

  /// Terminate active telephony bridge session (`POST /api/v1/telephony/sessions/:id/terminate`)
  Future<Map<String, dynamic>> terminateTelephonyBridgeSession(
      {required String sessionId}) async {
    try {
      final session = KarigaarWhatsAppTelephonyService.instance
          .terminateTelephonyBridgeSession(sessionId);
      return {
        'status': 'SUCCESS',
        'data': session.toJson(),
      };
    } catch (e) {
      throw const ApiException(
          'Telephony session not found or already terminated.',
          code: 'SESSION_NOT_FOUND',
          statusCode: 404);
    }
  }

  /// Meta WhatsApp Cloud API outbound template dispatch (`POST /api/v1/notifications/whatsapp/template`)
  Future<Map<String, dynamic>> dispatchWhatsAppTemplate({
    required String recipientPhone,
    required String templateName,
    String languageCode = 'en_US',
    List<WhatsAppTemplateComponent> components = const [],
  }) async {
    try {
      return await KarigaarWhatsAppTelephonyService.instance
          .dispatchWhatsAppTemplate(
        recipientPhone: recipientPhone,
        templateName: templateName,
        languageCode: languageCode,
        components: components,
      );
    } catch (e) {
      if (e is ArgumentError) {
        throw ApiException(e.message.toString(),
            code: 'INVALID_WHATSAPP_PARAM', statusCode: 422);
      }
      rethrow;
    }
  }

  /// Dual-Sync Dispatch Payload (`POST /api/v1/dispatch/dual-sync`)
  Future<Map<String, dynamic>> syncDualDispatchPayload({
    required String bookingId,
    required String artisanPhone,
    required String customerAddress,
    required String landmarkOrSocietyCode,
    required double latitude,
    required double longitude,
    String? audioMemoUrl,
    required int guaranteedBasePayout,
    String languageCode = 'en_US',
  }) async {
    try {
      final result = await KarigaarWhatsAppTelephonyService.instance
          .syncDualDispatchPayload(
        bookingId: bookingId,
        artisanPhone: artisanPhone,
        customerAddress: customerAddress,
        landmarkOrSocietyCode: landmarkOrSocietyCode,
        latitude: latitude,
        longitude: longitude,
        audioMemoUrl: audioMemoUrl,
        guaranteedBasePayout: guaranteedBasePayout,
        languageCode: languageCode,
      );
      return {
        'status': 'SUCCESS',
        'data': result.toJson(),
      };
    } catch (e) {
      if (e is ArgumentError) {
        throw ApiException(e.message.toString(),
            code: 'INVALID_DUAL_SYNC_PARAM', statusCode: 422);
      }
      rethrow;
    }
  }

  /// Contract 2: Partner Accept Job Request (`POST /api/v1/dispatch/jobs/:id/accept`)
  Future<Map<String, dynamic>> acceptJob({
    required String bookingId,
    required String broadcastId,
    required String artisanId,
    double? latitude,
    double? longitude,
  }) async {
    if (bookingId.isEmpty || artisanId.isEmpty) {
      throw const ApiException(
          'Booking ID and Artisan ID are required to accept a job.',
          code: 'MISSING_ASSIGNMENT_PARAMS');
    }

    final isGurugram =
        bookingId.contains('8842') || bookingId.startsWith('KG-');
    final destLat = isGurugram ? 28.4722 : 19.1415;
    final destLng = isGurugram ? 77.0381 : 77.3242;
    final address = isGurugram
        ? '42 Green Valley, Sector 4, Gurugram'
        : 'Plot 14, Near Water Tank, Anand Nagar, Nanded';

    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'broadcastId': broadcastId,
        'state': 'ARTISAN_DISPATCHED',
        'assignedArtisanId': artisanId,
        'navigationCoordinates': {
          'destinationLatitude': destLat,
          'destinationLongitude': destLng,
          'addressText': address,
        },
        'startOtpVerificationRequired': true,
        'doorstepStartOtpExpected': '4921',
      },
    };
  }

  /// Contract 3: Verify Security Start Code (`POST /api/v1/bookings/:id/start-job`)
  Future<Map<String, dynamic>> verifyStartSecurityCode({
    required String bookingId,
    required String securityStartCode,
  }) async {
    final cleanCode = securityStartCode.trim();
    if (cleanCode != '4921') {
      throw const ApiException(
          'Incorrect Start Code. Expected 4921 shared by customer.',
          code: 'INVALID_START_CODE',
          statusCode: 403);
    }

    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'state': 'IN_PROGRESS',
        'jobStartedAt': DateTime.now().toUtc().toIso8601String(),
        'stopwatchActive': true,
      },
    };
  }

  /// Contract 3: Doorstep Access Denied / Timeout (`POST /api/v1/bookings/:id/doorstep-access-denied`)
  Future<Map<String, dynamic>> triggerDoorstepAccessDenied({
    required String bookingId,
    required int dwellMinutes,
    String reason = 'CUSTOMER_UNREACHABLE_OR_DOORSTEP_DENIED',
  }) async {
    if (dwellMinutes < 15) {
      throw const ApiException(
        'Doorstep denial requires at least 15 minutes dwell time at destination.',
        code: 'DWELL_TIME_INSUFFICIENT',
        statusCode: 422,
      );
    }

    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'state': 'DOORSTEP_ACCESS_DENIED',
        'transitCompensation': {
          'totalDebitedFromPreAuthMandate': 99.00,
          'creditedToArtisanGuildWallet': 80.00,
          'platformCancellationProcessingFee': 19.00,
        },
        'message':
            'Doorstep access denial verified via GPS dwell time (>15 mins). ₹80 transit fee credited to artisan wallet. Job closed cleanly.',
      },
    };
  }

  /// Contract 4: Decoupled Invoice Submission (`POST /api/v1/bookings/:id/submit-invoice`)
  Future<Map<String, dynamic>> submitDecoupledInvoice({
    required String bookingId,
    required List<BillPartItem> parts,
    required int laborBase,
  }) async {
    final partsTotal = parts.fold<int>(0, (sum, part) => sum + part.total);
    final partsSurcharge = (partsTotal * 0.02).round();
    final subtotal = laborBase + partsTotal + partsSurcharge;
    final gst18 = (subtotal * 0.18).round();
    final grandTotal = subtotal + gst18;

    final invoiceId = 'inv_${DateTime.now().millisecondsSinceEpoch}';
    return {
      'status': 'SUCCESS',
      'data': {
        'invoiceId': invoiceId,
        'bookingId': bookingId,
        'state': 'INVOICE_SUBMITTED',
        'laborBase': laborBase,
        'partsTotal': partsTotal,
        'partsGatewaySurcharge2Percent': partsSurcharge,
        'gst18Percent': gst18,
        'grandTotal': grandTotal,
        'completionOtpExpected': '7294',
        'message':
            'Invoice submitted. Customer must review and release Completion OTP (7294).',
      },
    };
  }

  /// Contract 4: Request Customer 2FA Approval for Spare Part (`POST /api/v1/bookings/:id/invoice/items/2fa-request`)
  Future<Map<String, dynamic>> requestPart2FaApproval({
    required String bookingId,
    required String partName,
    required int price,
  }) async {
    final cleanPartName = partName.trim();
    if (cleanPartName.isEmpty || price <= 0) {
      throw const ApiException(
          'Part name and valid price are required for 2FA approval.',
          code: 'INVALID_PART_DETAILS',
          statusCode: 422);
    }

    final approvalToken = 'appr_2fa_${DateTime.now().millisecondsSinceEpoch}';
    final convenienceFee = (price * 0.02).round();
    return {
      'status': 'SUCCESS',
      'data': {
        'approvalToken': approvalToken,
        'bookingId': bookingId,
        'partName': cleanPartName,
        'price': price,
        'approvalStatus': 'PENDING_CUSTOMER_2FA_APPROVAL',
        'customerApprovalPromptDispatched': true,
        'partsGatewayConvenienceFee': convenienceFee,
        'message':
            'Customer 2FA approval prompt dispatched for ₹$price spare part.',
      },
    };
  }

  /// Contract 4: Decoupled Verification & OTP Release (`POST /api/v1/bookings/:id/verify-completion`)
  Future<Map<String, dynamic>> verifyCustomerCompletion({
    required String bookingId,
    required String completionOtp,
    int customerRating = 5,
    String feedbackNote = '',
    int laborAmountPaise = 24900,
    int platformTakeRatePercent = 12,
  }) async {
    final cleanCode = completionOtp.trim();
    if (cleanCode != '7294') {
      throw const ApiException('Incorrect Completion OTP. Expected 7294.',
          code: 'INVALID_COMPLETION_OTP', statusCode: 403);
    }

    if (customerRating < 1 ||
        customerRating > 5 ||
        laborAmountPaise < 0 ||
        platformTakeRatePercent < 0 ||
        platformTakeRatePercent > 100) {
      throw const ApiException(
          'Completion rating or labor settlement values are invalid.',
          code: 'INVALID_SETTLEMENT_INPUT',
          statusCode: 422);
    }
    final platformTakeRatePaise =
        (laborAmountPaise * platformTakeRatePercent) ~/ 100;
    final warrantyContributionPaise =
        calculateWarrantyReserveContributionPaise(platformTakeRatePaise);

    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'state': 'PAYMENT_RELEASED',
        'escrowSettled': true,
        'customerRating': customerRating,
        'feedbackNote': feedbackNote,
        'platformLaborTakeRatePaise': platformTakeRatePaise,
        'warrantyReserveContributionPaise': warrantyContributionPaise,
        'warrantyReserveRatePercent': warrantyReserveRatePercent,
        'warrantyActiveDays': 30,
        'masterShieldCover': 25000,
        'completedAt': DateTime.now().toUtc().toIso8601String(),
      },
    };
  }

  /// Contract 4: Instant IMPS Payout (`POST /api/v1/wallet/withdraw`)
  Future<Map<String, dynamic>> withdrawWalletImps({
    required String artisanId,
    required num amount,
    required num currentWalletBalance,
    String? upiId,
    String? upiVpa,
    double minReserve = 2000.0,
  }) async {
    final effectiveVpa = (upiId ?? upiVpa ?? '').trim();
    if (effectiveVpa.isEmpty) {
      throw const ApiException('UPI ID / VPA is required for IMPS withdrawal.',
          code: 'MISSING_UPI_ID', statusCode: 422);
    }

    if (!amount.isFinite || amount <= 0) {
      throw const ApiException('Withdrawal amount must be greater than zero.',
          code: 'INVALID_AMOUNT', statusCode: 422);
    }
    if (!currentWalletBalance.isFinite || currentWalletBalance < 0) {
      throw const ApiException(
          'Wallet balance must be a valid finite non-negative amount.',
          code: 'INVALID_BALANCE',
          statusCode: 422);
    }
    if (!minReserve.isFinite || minReserve < 0) {
      throw const ApiException(
          'Security reserve must be a valid finite non-negative amount.',
          code: 'INVALID_RESERVE',
          statusCode: 422);
    }

    final int balancePaise = (currentWalletBalance * 100).round();
    final int reservePaise = (minReserve * 100).round();
    final int amountPaise = (amount * 100).round();
    if (amountPaise <= 0) {
      throw const ApiException('Withdrawal amount must be greater than zero.',
          code: 'INVALID_AMOUNT', statusCode: 422);
    }

    final int availablePaise = balancePaise - reservePaise;
    if (availablePaise < amountPaise) {
      final double availableRupees =
          availablePaise > 0 ? availablePaise / 100.0 : 0.0;
      final String availableStr =
          availablePaise > 0 && availablePaise % 100 != 0
              ? availableRupees.toStringAsFixed(2)
              : (availablePaise > 0 ? (availablePaise ~/ 100).toString() : '0');
      final String reserveStr = reservePaise % 100 == 0
          ? _formatIndianRupeesInt(reservePaise ~/ 100)
          : (reservePaise / 100.0).toStringAsFixed(2);
      throw ApiException(
        'Cannot withdraw ₹$amount. A mandatory ₹$reserveStr security reserve must be maintained. Available for withdrawal: ₹$availableStr.',
        code: 'SECURITY_RESERVE_VIOLATION',
        statusCode: 400,
      );
    }

    final double debitedRupees = amountPaise / 100.0;
    final double remainingBalance = (balancePaise - amountPaise) / 100.0;
    final payoutId = 'payout_${DateTime.now().millisecondsSinceEpoch}';
    return {
      'status': 'SUCCESS',
      'data': {
        'payoutId': payoutId,
        'artisanId': artisanId,
        'amountDebited': debitedRupees,
        'remainingBalance': remainingBalance,
        'upiVpa': effectiveVpa,
        'upiId': effectiveVpa,
        'channel': 'IMPS_INSTANT_24X7',
        'status': 'TRANSFERRED',
        'bankReferenceNumber': 'RRN${DateTime.now().millisecondsSinceEpoch}',
      },
    };
  }

  static String _formatIndianRupeesInt(int value) {
    final s = value.toString();
    if (s.length <= 3) return s;
    final lastThree = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    final formattedRest = rest.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (m) => '${m[1]},',
    );
    return '$formattedRest,$lastThree';
  }

  /// Contract 5: Upfront UPI Pre-Authorization Mandate (`POST /api/v1/payments/mandates/create`)
  Future<Map<String, dynamic>> createUpiPreAuthMandate({
    required String bookingId,
    required String customerId,
    required String upiVpa,
    int amount = 99,
  }) async {
    final cleanVpa = upiVpa.trim();
    final vpaRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
    if (!vpaRegex.hasMatch(cleanVpa)) {
      throw const ApiException(
        'Invalid UPI VPA format. Expected user@bank format.',
        code: 'INVALID_VPA',
        statusCode: 422,
      );
    }

    final mandateId = 'man_${DateTime.now().millisecondsSinceEpoch}';
    return {
      'status': 'SUCCESS',
      'data': {
        'mandateId': mandateId,
        'bookingId': bookingId,
        'customerId': customerId,
        'upiVpa': cleanVpa,
        'amount': amount,
        'currency': 'INR',
        'mandateStatus': 'AUTHORIZED',
        'gateway': 'RAZORPAY_UPI_AUTOPAY_SANDBOX',
        'transitFeeProtected': true,
        'authorizedAt': DateTime.now().toUtc().toIso8601String(),
      },
    };
  }

  /// Contract 5: Capture UPI Pre-Auth Mandate on Doorstep Denial (`POST /api/v1/payments/mandates/:id/capture`)
  Future<Map<String, dynamic>> captureUpiMandate({
    required String bookingId,
    required String mandateId,
    String reason = 'DOORSTEP_ACCESS_DENIED',
  }) async {
    return {
      'status': 'SUCCESS',
      'data': {
        'mandateId': mandateId,
        'bookingId': bookingId,
        'mandateStatus': 'CAPTURED',
        'debitedAmount': 99.0,
        'creditedToArtisan': 80.0,
        'platformFee': 19.0,
        'reason': reason,
        'capturedAt': DateTime.now().toUtc().toIso8601String(),
        'message':
            '₹99 transit fee captured. ₹80 credited to artisan wallet, ₹19 platform fee retained.',
      },
    };
  }

  /// Contract 5: Release UPI Pre-Auth Mandate on Completion (`POST /api/v1/payments/mandates/:id/release`)
  Future<Map<String, dynamic>> releaseUpiMandate({
    required String bookingId,
    required String mandateId,
  }) async {
    return {
      'status': 'SUCCESS',
      'data': {
        'mandateId': mandateId,
        'bookingId': bookingId,
        'mandateStatus': 'RELEASED',
        'holdAmountReleased': 99.0,
        'releasedAt': DateTime.now().toUtc().toIso8601String(),
        'message':
            'Standby ₹99 pre-auth hold released successfully upon job completion.',
      },
    };
  }

  /// Contract 5: Revoke UPI Pre-Auth Mandate (`POST /api/v1/payments/mandates/:id/revoke`)
  Future<Map<String, dynamic>> revokeUpiMandate({
    required String bookingId,
    required String mandateId,
  }) async {
    return {
      'status': 'SUCCESS',
      'data': {
        'mandateId': mandateId,
        'bookingId': bookingId,
        'mandateStatus': 'REVOKED',
        'revokedAt': DateTime.now().toUtc().toIso8601String(),
        'message': 'UPI pre-authorization mandate revoked.',
      },
    };
  }

  /// Feature F-35: Path A Direct Contact Monetization Unlock (`POST /api/v1/monetization/unlock-contact`)
  Future<Map<String, dynamic>> unlockDirectContact({
    required String customerId,
    required String artisanId,
    required String option,
  }) async {
    if (customerId.isEmpty || artisanId.isEmpty) {
      throw const ApiException(
        'Customer ID and Artisan ID are required.',
        code: 'MISSING_UNLOCK_PARAMS',
        statusCode: 422,
      );
    }

    final isPass = option == 'UNLIMITED_DIRECTORY_PASS_499';
    final amountPaid = isPass ? 499 : 49;
    final unlockId = 'unl_${DateTime.now().millisecondsSinceEpoch}';

    return {
      'status': 'SUCCESS',
      'data': {
        'unlockId': unlockId,
        'customerId': customerId,
        'artisanId': artisanId,
        'option': option,
        'amountPaid': amountPaid,
        'virtualProxyNumber':
            KarigaarWhatsAppTelephonyService.defaultVirtualProxyDid,
        'zeroRawMsisdnLeakageGuaranteed': true,
        'unlockedAt': DateTime.now().toUtc().toIso8601String(),
        'message': isPass
            ? 'Unlimited Directory Pass activated for 30 days. Direct contact unlocked across all 10 trades.'
            : 'Direct contact unlocked for artisan. Route through masked proxy +91-11-4084-2190.',
      },
    };
  }

  /// Contract 8: Audio Memo Scoping Upload (`POST /api/v1/media/audio-memo/upload`)
  Future<Map<String, dynamic>> uploadAudioMemo({
    required String bookingId,
    required String tradeId,
    required int durationSeconds,
    String format = 'aac',
    String? audioBase64,
    List<double>? waveform,
  }) async {
    if (durationSeconds > 15) {
      throw const ApiException(
        'Audio memo exceeds maximum 15 seconds limit.',
        code: 'AUDIO_EXCEEDS_MAX_DURATION',
        statusCode: 422,
      );
    }
    if (durationSeconds < 1) {
      throw const ApiException(
        'Audio memo duration must be at least 1 second.',
        code: 'AUDIO_TOO_SHORT',
        statusCode: 422,
      );
    }

    final memoId = 'memo_${DateTime.now().millisecondsSinceEpoch}_audio';
    final computedWaveform = waveform != null && waveform.isNotEmpty
        ? waveform
        : AudioMemoModel.generateSimulatedWaveform(24);

    return {
      'status': 'SUCCESS',
      'data': {
        'memoId': memoId,
        'bookingId': bookingId,
        'audioMemoUrl': 'https://cdn.karigaar.in/audio/$memoId.aac',
        'durationSeconds': durationSeconds,
        'waveform': computedWaveform,
        'fileSizeBytes': durationSeconds * 2560,
        'uploadedAt': DateTime.now().toUtc().toIso8601String(),
        'transcript':
            'Customer voice scoping memo: Defect diagnosed for $tradeId. Urgent repair needed.',
      },
    };
  }

  /// Contract 9: Arrival Slot Query (`GET /api/v1/dispatch/slots`)
  Future<Map<String, dynamic>> getArrivalSlots({
    required String tradeId,
    required String localityId,
    required dynamic date, // DateTime or String YYYY-MM-DD
    DateTime? now,
  }) async {
    if (tradeId.trim().isEmpty) {
      throw const ApiException('tradeId is required.',
          code: 'MISSING_TRADE_ID', statusCode: 422);
    }
    if (localityId.trim().isEmpty) {
      throw const ApiException('localityId is required.',
          code: 'MISSING_LOCALITY_ID', statusCode: 422);
    }

    final DateTime parsedDate;
    if (date is DateTime) {
      parsedDate = date;
    } else if (date is String) {
      parsedDate = DateTime.tryParse(date) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final slots = ArrivalSlotModel.defaultSlotsForDate(parsedDate, now);
    final dateStr =
        '${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';

    return {
      'status': 'SUCCESS',
      'data': {
        'date': dateStr,
        'tradeId': tradeId,
        'localityId': localityId,
        'slots': slots.map((s) => s.toJson()).toList(),
      },
    };
  }

  /// Contract 9: Arrival Slot Reservation (`POST /api/v1/dispatch/slots/reserve`)
  Future<Map<String, dynamic>> reserveArrivalSlot({
    required String bookingId,
    required String tradeId,
    required dynamic date,
    required String slotId,
  }) async {
    if (bookingId.trim().isEmpty) {
      throw const ApiException('bookingId is required.',
          code: 'MISSING_BOOKING_ID', statusCode: 422);
    }
    if (slotId.trim().isEmpty) {
      throw const ApiException('slotId is required.',
          code: 'INVALID_SLOT_ID', statusCode: 422);
    }

    final DateTime parsedDate;
    if (date is DateTime) {
      parsedDate = date;
    } else if (date is String) {
      parsedDate = DateTime.tryParse(date) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final dateStr =
        '${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';

    final category = SlotCategory.fromString(slotId);
    final timeWindow = category.defaultTimeWindow;
    final scheduledSlotLabel = '${category.label} ($timeWindow)';

    final reservationId =
        'res_slot_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    return {
      'status': 'SUCCESS',
      'data': {
        'reservationId': reservationId,
        'bookingId': bookingId,
        'tradeId': tradeId,
        'slotId': slotId,
        'scheduledDate': dateStr,
        'scheduledSlot': scheduledSlotLabel,
        'lockExpiresAt': DateTime.now()
            .add(const Duration(minutes: 10))
            .toUtc()
            .toIso8601String(),
      },
    };
  }
}

/// Riverpod Provider for KarigaarApiService
final apiServiceProvider = Provider<KarigaarApiService>((ref) {
  return const KarigaarApiService();
});
