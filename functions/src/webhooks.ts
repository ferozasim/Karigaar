import {getFirestore, FieldValue} from "firebase-admin/firestore";
import type {Request, Response} from "express";
import {hmacHex, verifyHmac} from "./security.js";

const db = getFirestore();
type RawBodyRequest = Request & {rawBody: Buffer};

function rejectMethod(request: Request, response: Response): boolean {
  if (request.method === "POST") return false;
  response.set("Allow", "POST").sendStatus(405);
  return true;
}

/** Meta sends X-Hub-Signature-256 over the exact raw request bytes. */
export async function handleMetaWebhook(request: RawBodyRequest, response: Response, secret: string) {
  if (rejectMethod(request, response)) return;
  const signature = request.header("x-hub-signature-256") ?? "";
  const provided = signature.startsWith("sha256=") ? signature.slice(7) : "";
  if (!provided || !verifyHmac(secret, request.rawBody, provided, "sha256")) {
    response.sendStatus(401);
    return;
  }

  const entries = request.body?.entry ?? [];
  const batch = db.batch();
  let count = 0;
  for (const entry of entries) {
    for (const change of entry.changes ?? []) {
      for (const status of change.value?.statuses ?? []) {
        if (!status.id || !status.status) continue;
        const ref = db.collection("whatsapp_message_receipts").doc(String(status.id));
        batch.set(ref, {
          messageId: String(status.id),
          status: String(status.status).toUpperCase(),
          recipientPhone: status.recipient_id ?? null,
          timestamp: status.timestamp ? new Date(Number(status.timestamp) * 1000) : FieldValue.serverTimestamp(),
          webhookReceivedAt: FieldValue.serverTimestamp(),
        }, {merge: true});
        count++;
      }
    }
  }
  if (count > 0) await batch.commit();
  response.status(200).json({received: true});
}

/** Razorpay delivery is idempotent by event ID and authenticated by HMAC-SHA256. */
export async function handleRazorpayWebhook(request: RawBodyRequest, response: Response, secret: string) {
  if (rejectMethod(request, response)) return;
  const signature = request.header("x-razorpay-signature") ?? "";
  if (!signature || !verifyHmac(secret, request.rawBody, signature, "sha256")) {
    response.sendStatus(401);
    return;
  }
  const eventId = request.header("x-razorpay-event-id");
  if (!eventId) {
    response.status(400).json({error: "missing_event_id"});
    return;
  }
  const eventRef = db.collection("payment_webhook_events").doc(eventId);
  const event = request.body?.event;
  const paymentEntity = request.body?.payload?.payment?.entity;
  const subscriptionEntity = request.body?.payload?.subscription?.entity;
  const mandateId = subscriptionEntity?.id ?? paymentEntity?.notes?.mandateId;

  await db.runTransaction(async (transaction) => {
    const previous = await transaction.get(eventRef);
    if (previous.exists) return;
    transaction.create(eventRef, {
      provider: "razorpay",
      event: event ?? "unknown",
      receivedAt: FieldValue.serverTimestamp(),
      payloadDigest: hmacHex(secret, request.rawBody, "sha256"),
    });
    if (mandateId && ["subscription.activated", "subscription.halted", "subscription.cancelled", "payment.captured", "payment.failed"].includes(event)) {
      transaction.set(db.collection("mandates").doc(String(mandateId)), {
        gatewayEvent: event,
        gatewayStatus: subscriptionEntity?.status ?? paymentEntity?.status ?? null,
        gatewayUpdatedAt: FieldValue.serverTimestamp(),
      }, {merge: true});
    }
  });
  response.status(200).json({received: true});
}

/** Telephony providers must be configured to sign callbacks with a shared secret. */
export async function handleTelephonyWebhook(request: RawBodyRequest, response: Response, secret: string) {
  if (rejectMethod(request, response)) return;
  const provided = request.header("x-karigaar-signature") ?? "";
  if (!provided || !verifyHmac(secret, request.rawBody, provided, "sha256")) {
    response.sendStatus(401);
    return;
  }
  const sessionId = request.body?.sessionId;
  const status = request.body?.status;
  if (typeof sessionId !== "string" || typeof status !== "string") {
    response.status(400).json({error: "invalid_callback"});
    return;
  }
  const allowed = new Set(["BRIDGED", "COMPLETED", "FAILED", "EXPIRED", "TERMINATED"]);
  if (!allowed.has(status.toUpperCase())) {
    response.status(422).json({error: "unsupported_status"});
    return;
  }
  await db.collection("telephony_bridge_sessions").doc(sessionId).set({
    sessionStatus: status.toUpperCase(),
    providerCallId: request.body?.callId ?? null,
    updatedAt: FieldValue.serverTimestamp(),
  }, {merge: true});
  response.status(200).json({received: true});
}
