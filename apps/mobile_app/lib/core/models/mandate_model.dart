import 'booking_model.dart';

/// A provider-agnostic UPI AutoPay record. Provider-specific tokens must stay
/// in the payment gateway/webhook service, never in the client repository.
class MandateModel {
  final String mandateId;
  final String bookingId;
  final String customerId;
  final String upiVpa;
  final int amountPaise;
  final UpiMandateStatus status;
  final String idempotencyKey;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MandateModel({
    required this.mandateId,
    required this.bookingId,
    required this.customerId,
    required this.upiVpa,
    required this.amountPaise,
    required this.status,
    required this.idempotencyKey,
    required this.createdAt,
    required this.updatedAt,
  });

  MandateModel copyWith({
    UpiMandateStatus? status,
    DateTime? updatedAt,
  }) {
    return MandateModel(
      mandateId: mandateId,
      bookingId: bookingId,
      customerId: customerId,
      upiVpa: upiVpa,
      amountPaise: amountPaise,
      status: status ?? this.status,
      idempotencyKey: idempotencyKey,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'mandateId': mandateId,
        'bookingId': bookingId,
        'customerId': customerId,
        'upiVpa': upiVpa,
        'amountPaise': amountPaise,
        'status': status.name,
        'idempotencyKey': idempotencyKey,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory MandateModel.fromJson(Map<String, dynamic> json) => MandateModel(
        mandateId: json['mandateId'] as String,
        bookingId: json['bookingId'] as String,
        customerId: json['customerId'] as String,
        upiVpa: json['upiVpa'] as String,
        amountPaise: (json['amountPaise'] as num).toInt(),
        status: UpiMandateStatus.values.firstWhere(
          (value) => value.name == json['status'],
          orElse: () => UpiMandateStatus.created,
        ),
        idempotencyKey: json['idempotencyKey'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
