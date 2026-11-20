enum SupportCaseCategory {
  noShow,
  propertyDamage,
  safetyConcern,
  serviceQuality,
  warranty,
  cancellation,
  payment,
  other;

  String get label => switch (this) {
        SupportCaseCategory.noShow => 'No-show or late arrival',
        SupportCaseCategory.propertyDamage => 'Property damage',
        SupportCaseCategory.safetyConcern => 'Safety concern',
        SupportCaseCategory.serviceQuality => 'Service quality',
        SupportCaseCategory.warranty => 'Warranty or rework',
        SupportCaseCategory.cancellation => 'Cancellation',
        SupportCaseCategory.payment => 'Payment question',
        SupportCaseCategory.other => 'Other issue',
      };
}

enum SupportCaseStatus { submitted, underReview, awaitingInformation, resolved }

class SupportCaseEvent {
  const SupportCaseEvent({
    required this.eventId,
    required this.actorId,
    required this.actorRole,
    required this.action,
    required this.occurredAt,
    this.note,
  });

  final String eventId;
  final String actorId;
  final String actorRole;
  final String action;
  final DateTime occurredAt;
  final String? note;

  factory SupportCaseEvent.fromJson(Map<String, dynamic> json) =>
      SupportCaseEvent(
        eventId: json['eventId'] as String,
        actorId: json['actorId'] as String,
        actorRole: json['actorRole'] as String,
        action: json['action'] as String,
        occurredAt: DateTime.parse(json['occurredAt'] as String),
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'actorId': actorId,
        'actorRole': actorRole,
        'action': action,
        'occurredAt': occurredAt.toUtc().toIso8601String(),
        if (note != null) 'note': note,
      };
}

class SupportCase {
  const SupportCase({
    required this.caseId,
    required this.idempotencyKey,
    required this.bookingId,
    required this.reporterId,
    required this.reporterRole,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.status,
    required this.events,
    this.evidenceReferences = const [],
  });

  final String caseId;
  final String idempotencyKey;
  final String bookingId;
  final String reporterId;
  final String reporterRole;
  final SupportCaseCategory category;
  final String description;
  final List<String> evidenceReferences;
  final DateTime createdAt;
  final SupportCaseStatus status;
  final List<SupportCaseEvent> events;

  factory SupportCase.create({
    required String caseId,
    required String idempotencyKey,
    required String bookingId,
    required String reporterId,
    required String reporterRole,
    required SupportCaseCategory category,
    required String description,
    required DateTime createdAt,
    List<String> evidenceReferences = const [],
  }) {
    final event = SupportCaseEvent(
      eventId: '${caseId}_submitted',
      actorId: reporterId,
      actorRole: reporterRole,
      action: 'submitted',
      occurredAt: createdAt,
    );
    return SupportCase(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      bookingId: bookingId,
      reporterId: reporterId,
      reporterRole: reporterRole,
      category: category,
      description: description.trim(),
      evidenceReferences: List.unmodifiable(evidenceReferences),
      createdAt: createdAt,
      status: SupportCaseStatus.submitted,
      events: List.unmodifiable([event]),
    );
  }

  factory SupportCase.fromJson(Map<String, dynamic> json) => SupportCase(
        caseId: json['caseId'] as String,
        idempotencyKey: json['idempotencyKey'] as String,
        bookingId: json['bookingId'] as String,
        reporterId: json['reporterId'] as String,
        reporterRole: json['reporterRole'] as String,
        category: SupportCaseCategory.values.byName(json['category'] as String),
        description: json['description'] as String,
        evidenceReferences: List<String>.from(
          json['evidenceReferences'] as List? ?? const [],
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: SupportCaseStatus.values.byName(json['status'] as String),
        events: List.unmodifiable(
          (json['events'] as List? ?? const []).map(
            (event) => SupportCaseEvent.fromJson(
              Map<String, dynamic>.from(event as Map),
            ),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'caseId': caseId,
        'idempotencyKey': idempotencyKey,
        'bookingId': bookingId,
        'reporterId': reporterId,
        'reporterRole': reporterRole,
        'category': category.name,
        'description': description,
        'evidenceReferences': evidenceReferences,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'status': status.name,
        'events': events.map((event) => event.toJson()).toList(growable: false),
      };
}
