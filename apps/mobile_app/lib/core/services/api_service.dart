import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/booking_model.dart';

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
  const KarigaarApiService();

  /// Contract 1: WhatsApp Authentication Request OTP (`POST /api/v1/auth/whatsapp/otp/request`)
  Future<Map<String, dynamic>> requestWhatsAppOtp({
    required String phoneNumber,
    required String role,
    String language = 'hi_IN',
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleanPhone.isEmpty || cleanPhone.length < 10) {
      throw const ApiException('Invalid Indian phone number. Expected 10 digits.', code: 'INVALID_PHONE', statusCode: 422);
    }

    final reqId = 'req_auth_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
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
      throw const ApiException('Invalid OTP code. Expected 4 or 6 digits.', code: 'INVALID_OTP_LENGTH', statusCode: 422);
    }

    return {
      'status': 'SUCCESS',
      'data': {
        'authToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.karigaar_mock_token',
        'refreshToken': 'ref_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'usr_${phoneNumber.replaceAll(RegExp(r'\D'), '').substring(phoneNumber.length > 5 ? phoneNumber.length - 5 : 0)}',
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
      throw const ApiException('Caller number and Callee ID are required.', code: 'MISSING_TELEPHONY_PARAMS', statusCode: 422);
    }

    final sessionId = 'tel_${DateTime.now().millisecondsSinceEpoch}';
    return {
      'status': 'SUCCESS',
      'data': {
        'bridgeSessionId': sessionId,
        'bookingId': bookingId,
        'callerRole': role,
        'virtualProxyNumber': '+91-11-4084-2190',
        'sessionStatus': 'BRIDGED',
        'zeroRawMsisdnLeakageGuaranteed': true,
        'expiresInSeconds': 600,
      },
    };
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
      throw const ApiException('Booking ID and Artisan ID are required to accept a job.', code: 'MISSING_ASSIGNMENT_PARAMS');
    }

    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'broadcastId': broadcastId,
        'state': 'ARTISAN_DISPATCHED',
        'assignedArtisanId': artisanId,
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
      throw const ApiException('Incorrect Start Code. Expected 4921 shared by customer.', code: 'INVALID_START_CODE', statusCode: 403);
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
        'message': 'Doorstep access denial verified via GPS dwell time (>15 mins). ₹80 transit fee credited to artisan wallet. Job closed cleanly.',
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
        'message': 'Invoice submitted. Customer must review and release Completion OTP (7294).',
      },
    };
  }

  /// Contract 4: Decoupled Verification & OTP Release (`POST /api/v1/bookings/:id/verify-completion`)
  Future<Map<String, dynamic>> verifyCustomerCompletion({
    required String bookingId,
    required String completionOtp,
  }) async {
    final cleanCode = completionOtp.trim();
    if (cleanCode != '7294') {
      throw const ApiException('Incorrect Completion OTP. Expected 7294.', code: 'INVALID_COMPLETION_OTP', statusCode: 403);
    }

    return {
      'status': 'SUCCESS',
      'data': {
        'bookingId': bookingId,
        'state': 'PAYMENT_RELEASED',
        'escrowSettled': true,
        'warrantyActiveDays': 30,
        'masterShieldCover': 25000,
        'completedAt': DateTime.now().toUtc().toIso8601String(),
      },
    };
  }

  /// Contract 4: Instant IMPS Payout (`POST /api/v1/wallet/withdraw`)
  Future<Map<String, dynamic>> withdrawWalletImps({
    required String artisanId,
    required int amount,
    required int currentWalletBalance,
    required String upiVpa,
  }) async {
    const minReserve = 2000;
    if (amount <= 0) {
      throw const ApiException('Withdrawal amount must be greater than zero.', code: 'INVALID_AMOUNT', statusCode: 422);
    }

    final availableForWithdrawal = currentWalletBalance - minReserve;
    if (availableForWithdrawal < amount) {
      throw ApiException(
        'Cannot withdraw ₹$amount. A mandatory ₹2,000 security reserve must be maintained. Available for withdrawal: ₹${availableForWithdrawal > 0 ? availableForWithdrawal : 0}.',
        code: 'SECURITY_RESERVE_VIOLATION',
        statusCode: 400,
      );
    }

    final payoutId = 'payout_${DateTime.now().millisecondsSinceEpoch}';
    return {
      'status': 'SUCCESS',
      'data': {
        'payoutId': payoutId,
        'artisanId': artisanId,
        'amountDebited': amount,
        'remainingBalance': currentWalletBalance - amount,
        'upiVpa': upiVpa,
        'channel': 'IMPS_INSTANT_24X7',
        'status': 'TRANSFERRED',
        'bankReferenceNumber': 'RRN${DateTime.now().millisecondsSinceEpoch}',
      },
    };
  }
}

/// Riverpod Provider for KarigaarApiService
final apiServiceProvider = Provider<KarigaarApiService>((ref) {
  return const KarigaarApiService();
});
