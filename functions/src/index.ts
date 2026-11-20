import {initializeApp} from "firebase-admin/app";
import {getAuth} from "firebase-admin/auth";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
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

const onboardingDb = getFirestore();
const applicationFields = new Set([
  "userId",
  "artisanId",
  "phone",
  "name",
  "tradeId",
  "cityId",
  "localityId",
  "step",
  "status",
  "updatedAt",
]);

/** Saves a phone-verified artisan application without accepting KYC or payout secrets. */
export const submitArtisanApplication = onCall({
  region: "asia-south1",
}, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Sign-in is required.");
  const phone = request.auth?.token.phone_number;
  if (typeof phone !== "string" || request.auth?.token.firebase?.sign_in_provider !== "phone") {
    throw new HttpsError("failed-precondition", "A verified phone number is required.");
  }
  const input = request.data ?? {};
  const {name, tradeId, cityId, localityId, step} = input;
  if (typeof name !== "string" || name.trim().length < 2 || name.length > 100 ||
      typeof tradeId !== "string" || !/^trade_[a-z0-9_]{2,60}$/.test(tradeId) ||
      typeof cityId !== "string" || !/^city_[a-z0-9_]{2,60}$/.test(cityId) ||
      typeof localityId !== "string" || !/^loc_[a-z0-9_]{2,60}$/.test(localityId) ||
      !Number.isInteger(step) || step < 1 || step > 4) {
    throw new HttpsError("invalid-argument", "Application fields are invalid.");
  }
  const suppliedKeys = Object.keys(input);
  if (suppliedKeys.some((key) => !["name", "tradeId", "cityId", "localityId", "step"].includes(key))) {
    throw new HttpsError("invalid-argument", "Application contains unsupported fields.");
  }

  const artisanId = `art_${uid}`;
  const applicationRef = onboardingDb.collection("artisan_applications").doc(uid);
  const userRef = onboardingDb.collection("users").doc(uid);
  const eventRef = applicationRef.collection("review_events").doc();
  await onboardingDb.runTransaction(async (transaction) => {
    const existing = await transaction.get(applicationRef);
    const currentStatus = existing.get("status");
    if (currentStatus === "approved") {
      throw new HttpsError("failed-precondition", "This application is already approved.");
    }
    if (currentStatus === "rejected") {
      throw new HttpsError("failed-precondition", "Contact support before reapplying.");
    }
    const status = "submitted" as const;
    const record = {
      userId: uid,
      artisanId,
      phone,
      name: name.trim(),
      tradeId,
      cityId,
      localityId,
      step,
      status,
      updatedAt: FieldValue.serverTimestamp(),
    };
    if (Object.keys(record).some((key) => !applicationFields.has(key))) {
      throw new HttpsError("internal", "Application contract contains an unsupported field.");
    }
    transaction.set(applicationRef, record, {merge: true});
    transaction.set(userRef, {
      userId: uid,
      artisanId,
      phone,
      displayName: name.trim(),
      activeRole: "artisan",
      cityId,
      updatedAt: FieldValue.serverTimestamp(),
    }, {merge: true});
    transaction.set(eventRef, {
      actorId: uid,
      action: "submitted",
      reason: null,
      createdAt: FieldValue.serverTimestamp(),
    });
  });
  return {userId: uid, artisanId, status: "submitted" as const};
});

/** Admin-only review transition; only this trusted path can grant artisan claims. */
export const reviewArtisanApplication = onCall({
  region: "asia-south1",
}, async (request) => {
  const adminId = request.auth?.uid;
  const claims = request.auth?.token;
  if (!adminId) throw new HttpsError("unauthenticated", "Sign-in is required.");
  if (claims?.admin !== true && claims?.role !== "ROLE_ADMIN") {
    throw new HttpsError("permission-denied", "Admin access is required.");
  }
  const {userId, status, reason} = request.data ?? {};
  if (typeof userId !== "string" || !userId ||
      !["needs_action", "approved", "rejected"].includes(status) ||
      typeof reason !== "string" || reason.trim().length < 3 || reason.length > 500) {
    throw new HttpsError("invalid-argument", "A valid application, decision, and reason are required.");
  }
  const appRef = onboardingDb.collection("artisan_applications").doc(userId);
  const eventRef = appRef.collection("review_events").doc();
  let artisanId: string | undefined;
  await onboardingDb.runTransaction(async (transaction) => {
    const application = await transaction.get(appRef);
    if (!application.exists) throw new HttpsError("not-found", "Application was not found.");
    const currentStatus = application.get("status");
    const alreadyApproved = currentStatus === "approved" && status === "approved";
    const allowed = currentStatus === "submitted" || currentStatus === "needs_action" || alreadyApproved;
    if (!allowed) throw new HttpsError("failed-precondition", "Application cannot transition from its current state.");
    artisanId = application.get("artisanId") as string;
    if (!alreadyApproved) {
      transaction.update(appRef, {
        status,
        reviewReason: reason.trim(),
        reviewedBy: adminId,
        updatedAt: FieldValue.serverTimestamp(),
      });
      transaction.set(eventRef, {
        actorId: adminId,
        action: status,
        reason: reason.trim(),
        createdAt: FieldValue.serverTimestamp(),
      });
    }
  });

  const target = await getAuth().getUser(userId);
  const nextClaims = {...target.customClaims};
  if (status === "approved") {
    nextClaims.artisanApproved = true;
    nextClaims.artisanId = artisanId;
    const application = (await appRef.get()).data()!;
    await onboardingDb.collection("artisans").doc(artisanId!).set({
      artisanId,
      userId,
      name: application.name,
      phone: application.phone,
      primaryTradeId: application.tradeId,
      tradeTitle: application.tradeId,
      cityId: application.cityId,
      localityId: application.localityId,
      yearsExperience: 0,
      rating: 0,
      reviewCount: 0,
      distanceKm: 0,
      policeVerified: false,
      toolAuditPassed: false,
      tier: "registered",
      bio: "",
      inspectionFee: 0,
      isOnline: false,
      totalJobsCompleted: 0,
      roleType: "skilledKarigaar",
      isGuildElite: false,
      guildId: "",
      kycBadgeLabel: "Application approved; verification details pending",
      aadhaarVerified: false,
      experienceTierLabel: "",
      dailyDihadiRate: 0,
      workMode: "",
      serviceLocalityIds: [application.localityId],
      specialties: [],
      verifiedTools: [],
      portfolioItems: [],
      cleanlinessScore: 0,
      onTimeArrivalPercent: 0,
      bankName: "",
      maskedAccountNumber: "",
      ifscCode: "",
      upiId: "",
      securityReserveAmount: 0,
    }, {merge: true});
  } else {
    delete nextClaims.artisanApproved;
    delete nextClaims.artisanId;
  }
  await getAuth().setCustomUserClaims(userId, nextClaims);
  return {userId, artisanId, status};
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
