# Spec Miner - Founder Requirements & Open Decisions
Task assignment and working directory for analyzing open founder decisions, architectural trade-offs, and business rules.

## 2026-11-06T12:32:30Z
From: 3d3e2c66-2a06-4e67-9deb-5bda74c8c14f
Priority: HIGH

You are teamwork_spec_miner. Your working directory is c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_founder.
Read c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\ORIGINAL_REQUEST.md.
Analyze the reference material in c:\Users\asimf\Downloads\stitch_karigaar_app_ui\stitch_karigaar_app_ui.
Your mission:
Identify and present a detailed, comprehensive breakdown of all decisions, inputs, and business rules required from the founder before implementation begins.
Specifically analyze and detail:
1. Pilot City Selection:
   - Target tier, demographics, artisan supply density, geographical bounds
   - Local language requirements (Hindi, regional dialects vs English)
   - Operational considerations (hyperlocal clustering vs citywide)
2. Initial Launch Categories:
   - Service taxonomy (e.g., Carpentry, Plumbing, Electrical, Painting, Masonry/Civil, Fabrication)
   - Scope per category (fixed-rate minor tasks vs custom-quote major projects)
   - Supply-side onboarding barriers and verification requirements per trade
3. Single vs Separate Mobile Applications:
   - Option 1: Unified App with role switcher (Customer mode / Partner mode)
   - Option 2: Distinct Apps (Karigaar Customer App vs Karigaar Partner App)
   - Exhaustive comparison across: Store discovery & ASO, App binary size & dependencies (maps/background location for artisans), App Store review risks, UX complexity for non-tech-savvy artisans, Codebase architecture (shared design system vs split repos).
4. Direct Contact Disclosure Policies:
   - Full open disclosure vs masked/virtual numbers vs lead unlock monetization
   - Disintermediation risk analysis and retention levers (insurance, escrow guarantee, dispute resolution, loyalty rewards)
   - Privacy and compliance (Do Not Disturb, phone number privacy, harassment mitigation)
5. Booking State Machine Rules:
   - Detailed state transition table (Draft, Quote Requested, Quotes Received, Quote Accepted, Deposit Escrowed, Artisan Dispatched, Artisan Arrived, In Progress, Work Completed, Verification / Customer Acceptance, Payment Released, Closed, Disputed, Cancelled)
   - Timeout rules (e.g. quote expiry, response SLA, arrival grace period)
   - Cancellation and refund policies (cancellation fees, who pays for artisan transit time)
   - Dispute resolution flow and escrow hold release rules
6. Additional Core Business Rules:
   - Artisan KYC / Verification tiers (Aadhaar, Police clearance, Trade certificate)
   - Monetization & commission models (take-rate on Path B, lead pack/subscription on Path A, platform fees)
   - WhatsApp Business API integration cost considerations and fallback SMS

For every open decision, provide clear options, pros & cons, architectural implications, and a recommended default.

Write your complete detailed analysis to c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_founder\analysis.md.
Also create c:\Users\asimf\OneDrive\Desktop\Karigaar_app\.agents\teamwork\spec_miner_founder\handoff.md.
Update your progress.md regularly.
CRITICAL CONSTRAINT: Do NOT write or create any application code or prototypes.
When finished, send a message to caller (id: 3d3e2c66-2a06-4e67-9deb-5bda74c8c14f).
