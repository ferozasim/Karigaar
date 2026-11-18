# Karigaar Cloud Functions

Firebase Functions v2 entry points for provider webhooks and WhatsApp template delivery. Deploy with the Firebase CLI from the repository root after configuring the required Secret Manager values.

## Functions

- `metaWebhook`: Meta Graph API v21 webhook verification and signed delivery status callbacks.
- `sendWhatsAppTemplate`: authenticated sender restricted to the approved Karigaar template names.
- `razorpayWebhook`: HMAC-verified, event-ID idempotent payment and mandate callbacks.
- `telephonyWebhook`: signed virtual-DID provider callbacks that update masked bridge session state.

## Required secrets

- `META_APP_SECRET`, `META_VERIFY_TOKEN`, `META_ACCESS_TOKEN`, `META_PHONE_NUMBER_ID`
- `RAZORPAY_WEBHOOK_SECRET`
- `TELEPHONY_WEBHOOK_SECRET`

Provider credentials are never stored in source control. Configure Meta, Razorpay, and telephony provider callback URLs to the deployed HTTPS function URLs. Telephony callbacks must include `X-Karigaar-Signature`, an HMAC-SHA256 of the raw request body using the configured shared secret.

## Integration boundary

This first gateway slice validates and records signed provider callbacks. It does not create live payment mandates, submit IMPS transfers, provision phone numbers, or deploy resources to Firebase. Those operations require provider account credentials and sandbox or production account configuration; the webhook layer only records provider-confirmed state. Live payouts must preserve the T-11 wallet reserve rule and should be enabled only through an authenticated server-side payout workflow.
