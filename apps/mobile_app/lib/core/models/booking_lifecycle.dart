import 'booking_model.dart';
import 'user_role.dart';

class BookingStatusEvent {
  const BookingStatusEvent({
    required this.from,
    required this.to,
    required this.actorId,
    required this.actorRole,
    required this.eventKey,
    required this.occurredAt,
    this.reason,
  });

  final BookingStatus from;
  final BookingStatus to;
  final String actorId;
  final UserRole actorRole;
  final String eventKey;
  final DateTime occurredAt;
  final String? reason;

  Map<String, dynamic> toJson() => {
        'from': from.name,
        'to': to.name,
        'actorId': actorId,
        'actorRole': actorRole.name,
        'eventKey': eventKey,
        'occurredAt': occurredAt.toIso8601String(),
        if (reason != null) 'reason': reason,
      };

  factory BookingStatusEvent.fromJson(Map<String, dynamic> json) =>
      BookingStatusEvent(
        from: BookingStatus.values.byName(json['from'] as String),
        to: BookingStatus.values.byName(json['to'] as String),
        actorId: json['actorId'] as String,
        actorRole: UserRole.values.byName(json['actorRole'] as String),
        eventKey: json['eventKey'] as String,
        occurredAt: DateTime.parse(json['occurredAt'] as String),
        reason: json['reason'] as String?,
      );
}

/// One transition contract shared by local repositories and Firestore rules.
class BookingLifecycle {
  static const Map<BookingStatus, Set<BookingStatus>> transitions = {
    BookingStatus.draft: {
      BookingStatus.broadcasting,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.broadcasting: {
      BookingStatus.claimed,
      BookingStatus.dispatchFailed,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.claimed: {
      BookingStatus.assigned,
      BookingStatus.dispatchFailed,
      BookingStatus.cancelledByArtisan,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.assigned: {
      BookingStatus.artisanEnRoute,
      BookingStatus.dispatchFailed,
      BookingStatus.cancelledByArtisan,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.artisanEnRoute: {
      BookingStatus.artisanArrived,
      BookingStatus.dispatchFailed,
      BookingStatus.cancelledByArtisan,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.artisanArrived: {
      BookingStatus.workInProgress,
      BookingStatus.dispatchFailed,
      BookingStatus.cancelledByArtisan,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.workInProgress: {
      BookingStatus.partsPendingApproval,
      BookingStatus.completionPendingOtp,
      BookingStatus.cancelledByArtisan,
      BookingStatus.cancelledByCustomer,
      BookingStatus.dispatchFailed,
    },
    BookingStatus.partsPendingApproval: {
      BookingStatus.workInProgress,
      BookingStatus.completionPendingOtp,
    },
    BookingStatus.completionPendingOtp: {BookingStatus.completed},
    BookingStatus.completed: {BookingStatus.settled, BookingStatus.disputed},
    BookingStatus.disputed: {BookingStatus.settled},
    BookingStatus.dispatchFailed: {
      BookingStatus.broadcasting,
      BookingStatus.cancelledByCustomer,
    },
    BookingStatus.cancelledByCustomer: {},
    BookingStatus.cancelledByArtisan: {BookingStatus.dispatchFailed},
    BookingStatus.settled: {},
  };

  static bool canTransition(
    BookingStatus from,
    BookingStatus to, {
    required UserRole actorRole,
  }) {
    if (!(transitions[from]?.contains(to) ?? false)) return false;
    if (actorRole == UserRole.admin) return true;
    if (to == BookingStatus.cancelledByCustomer) {
      return actorRole == UserRole.customer;
    }
    if (to == BookingStatus.cancelledByArtisan) {
      return actorRole == UserRole.artisan;
    }
    if (to == BookingStatus.dispatchFailed) {
      return actorRole == UserRole.artisan || actorRole == UserRole.admin;
    }
    if (from == BookingStatus.draft && to == BookingStatus.broadcasting) {
      return actorRole == UserRole.customer;
    }
    if (from == BookingStatus.dispatchFailed &&
        to == BookingStatus.broadcasting) {
      return actorRole == UserRole.customer || actorRole == UserRole.admin;
    }
    if (from == BookingStatus.completionPendingOtp &&
        to == BookingStatus.completed) {
      return actorRole == UserRole.customer || actorRole == UserRole.artisan;
    }
    if (from == BookingStatus.broadcasting &&
        (to == BookingStatus.claimed || to == BookingStatus.dispatchFailed)) {
      return actorRole == UserRole.artisan;
    }
    if (to == BookingStatus.disputed || to == BookingStatus.settled) {
      return false;
    }
    if (to == BookingStatus.workInProgress &&
        from == BookingStatus.partsPendingApproval) {
      return actorRole == UserRole.customer;
    }
    return actorRole == UserRole.artisan;
  }

  static bool canAssign({
    required BookingStatus to,
    required String actorId,
    String? assignedArtisanId,
  }) =>
      to == BookingStatus.claimed &&
      assignedArtisanId != null &&
      (assignedArtisanId == actorId || assignedArtisanId == 'art_$actorId');
}
