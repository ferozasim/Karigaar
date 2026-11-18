# Implementation Plan: Cloud Functions & Webhook Gateways

**Track ID**: `cloud-webhooks_20261117`  
**Created**: 2026-11-18  
**Status**: pushed — awaiting PR merge  
**Branch**: `feat/T-12-cloud-functions-webhooks`

## Scope

Add Firebase Functions v2 endpoints for Meta WhatsApp template delivery and signed status callbacks, idempotent Razorpay webhook intake, and signed masked-telephony session callbacks. Keep provider secrets out of source control and preserve server-only payout authorization.

## Tasks

- [x] Add Functions source configuration and TypeScript project scaffold.
- [x] Add Meta webhook verification and signed delivery-status processing.
- [x] Add allow-listed authenticated WhatsApp template sender.
- [x] Add Razorpay signature verification and event idempotency.
- [x] Add signed telephony status callback handling.
- [x] Document required secrets and provider setup boundary.
- [x] Install dependencies and run TypeScript build/lint and focused webhook tests (3/3 passed).
- [x] Update ticket and project status records after verification.
- [x] Synchronize with `origin/main`, rerun required checks, and push the feature branch.

## Provider setup required for live traffic

Meta, Razorpay, and telephony credentials must be configured in Firebase Secret Manager and callback URLs registered with the respective provider consoles. No provider credentials are present in this repository, so live provider calls and deployment remain unverified locally.
