import {initializeApp} from "firebase-admin/app";
import {onRequest} from "firebase-functions/v2/https";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {handleMetaWebhook, handleRazorpayWebhook, handleTelephonyWebhook} from "./webhooks.js";

initializeApp();

const metaAppSecret = defineSecret("META_APP_SECRET");
const metaVerifyToken = defineSecret("META_VERIFY_TOKEN");
const metaAccessToken = defineSecret("META_ACCESS_TOKEN");
const metaPhoneNumberId = defineSecret("META_PHONE_NUMBER_ID");
const razorpayWebhookSecret = defineSecret("RAZORPAY_WEBHOOK_SECRET");
const telephonyWebhookSecret = defineSecret("TELEPHONY_WEBHOOK_SECRET");

export const metaWebhook = onRequest({
  region: "asia-south1",
  secrets: [metaAppSecret, metaVerifyToken],
}, async (request, response) => {
  if (request.method === "GET") {
    const mode = request.query["hub.mode"];
    const token = request.query["hub.verify_token"];
    const challenge = request.query["hub.challenge"];
    if (mode === "subscribe" && token && token === metaVerifyToken.value()) {
      response.status(200).send(challenge);
      return;
    }
    response.sendStatus(403);
    return;
  }
  await handleMetaWebhook(request, response, metaAppSecret.value());
});

/** Authenticated, allow-listed sender for approved Meta WhatsApp templates. */
export const sendWhatsAppTemplate = onCall({
  region: "asia-south1",
  secrets: [metaAccessToken, metaPhoneNumberId],
}, async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "Sign-in is required.");
  const {recipient, templateName, languageCode = "en_US", components = []} = request.data ?? {};
  if (typeof recipient !== "string" || !/^\+?[1-9]\d{9,14}$/.test(recipient.replace(/\s/g, ""))) {
    throw new HttpsError("invalid-argument", "Recipient must be an E.164 phone number.");
  }
  const approvedTemplates = new Set(["auth_otp", "dispatch_alert", "milestone_update", "voice_memo_relay", "daily_settlement_slip"]);
  if (typeof templateName !== "string" || !approvedTemplates.has(templateName)) {
    throw new HttpsError("invalid-argument", "Template is not allow-listed.");
  }
  const normalizedRecipient = recipient.replace(/\s/g, "").replace(/^\+/, "");
  const ownPhone = String(request.auth.token.phone_number ?? "").replace(/\D/g, "");
  const isAdmin = request.auth.token.admin === true || request.auth.token.role === "ROLE_ADMIN";
  const isDispatchService = request.auth.token.dispatchService === true;
  if (templateName === "auth_otp") {
    if (!ownPhone || ownPhone !== normalizedRecipient) {
      throw new HttpsError("permission-denied", "OTP can only be sent to the signed-in user's verified phone.");
    }
  } else if (!isAdmin && !isDispatchService) {
    throw new HttpsError("permission-denied", "This template requires an approved dispatch service.");
  }
  const response = await fetch(`https://graph.facebook.com/v21.0/${metaPhoneNumberId.value()}/messages`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${metaAccessToken.value()}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      messaging_product: "whatsapp",
      to: normalizedRecipient,
      type: "template",
      template: {name: templateName, language: {code: languageCode}, components},
    }),
  });
  const body = await response.json();
  if (!response.ok) {
    throw new HttpsError("internal", "WhatsApp provider rejected the request.", {providerStatus: response.status});
  }
  return body;
});

export const razorpayWebhook = onRequest({
  region: "asia-south1",
  secrets: [razorpayWebhookSecret],
}, async (request, response) => {
  await handleRazorpayWebhook(request, response, razorpayWebhookSecret.value());
});

export const telephonyWebhook = onRequest({
  region: "asia-south1",
  secrets: [telephonyWebhookSecret],
}, async (request, response) => {
  await handleTelephonyWebhook(request, response, telephonyWebhookSecret.value());
});
