---
name: Karigaar Artisan Trust
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#45464d'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#904d00'
  on-secondary: '#ffffff'
  secondary-container: '#fe932c'
  on-secondary-container: '#663500'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#002114'
  on-tertiary-container: '#069669'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#ffdcc3'
  secondary-fixed-dim: '#ffb77d'
  on-secondary-fixed: '#2f1500'
  on-secondary-fixed-variant: '#6e3900'
  tertiary-fixed: '#85f8c4'
  tertiary-fixed-dim: '#68dba9'
  on-tertiary-fixed: '#002114'
  on-tertiary-fixed-variant: '#005137'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.04em
  numeric-price:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system serves an on-demand marketplace connecting households with verified, skilled craftsmen (carpenters, electricians, plumbers, masons, and painters). The core brand archetype is the "Master Guildsman Meets Modern Concierge." 

### Personality & Emotional Tenor
- **Trustworthy & Authoritative:** High assurance of safety, background verification, transparent pricing, and craft mastery.
- **Warm & Artisanal:** Respect for trade skills, tangible craftsmanship, and human warmth rather than cold gig-economy utility.
- **Modern & Kinetic:** Fast dispatch, live tracking, unambiguous booking flows, and friction-free micro-interactions.

### Visual Style
The design blends **Tactile Modernism** with crisp **Tonal Layering**:
- Rich, solid base slates anchored by saturated, warm amber accents evoke the warmth of polished timber, brass fittings, and ambient workshop glow.
- Tactile, rounded card surfaces convey approachable safety, while hairline precision borders maintain structured engineering discipline.
- Touch-first ergonomic consideration: thumb-zone optimized interfaces, massive interactive hit areas (minimum 48px), and persistent sticky action anchors.

## Colors

The palette establishes rock-solid reliability through slate foundations, balanced by energetic artisanal ochre and trust-affirming emerald.

### Palette Architecture
- **Primary (`#0F172A` / `#1E293B` - Deep Guild Slate):** Used for authoritative headers, primary button states, active navigation states, and high-emphasis typography. Establishes structural stability and safety.
- **Secondary (`#D97706` / `#F59E0B` - Artisan Amber):** The focal signature. Used for ratings, promotional cues, prime call-to-actions, skill badges, and active booking progress milestones.
- **Tertiary (`#059669` / `#10B981` - Verified Emerald):** Dedicated to trust indicators, background check confirmations, warranty badges, and successful transaction states.
- **Neutral Palette:**
  - `Surface Base`: `#F8FAFC` (Canvas background, soft slate tint prevents glare)
  - `Surface Raised`: `#FFFFFF` (Cards, bottom sheets, sticky bars)
  - `Surface Subtle`: `#F1F5F9` (Dividers, unselected chips, input fields)
  - `Text Muted`: `#64748B` (Secondary descriptions, metadata)
  - `Text Subtle`: `#94A3B8` (Placeholder text, inactive icons)
  - `Border Subtle`: `#E2E8F0` (Card outlines, table separations)

## Typography

The type system balances friendly geometry with utilitarian clarity.

- **Plus Jakarta Sans** provides rounded, approachable warmth for titles, section headings, and customer-facing service names. It softens technical jargon while retaining clear letter differentiation.
- **Inter** handles data-dense UI parts: rates, tabular job breakdowns, status badges, timestamps, and button copy. Its tabular numeric figures prevent layout jitter during dynamic price and time updates.
- **Specialized Numeric Role (`numeric-price`):** Specifically tuned with tighter letter spacing and bold weighting for upfront, transparent pricing clarity on cards and sticky payment bars.

## Layout & Spacing

The layout is built mobile-first, engineered strictly around a baseline 390px viewport width with flexible scaling for compact and larger mobile devices.

### Grid & Canvas
- **Fluid Single/Dual Column:** Layout utilizes a fluid column structure with an outer canvas padding (`margin`) of `1.25rem` (20px), ensuring components do not hit the curved bezel edge of contemporary phones.
- **Touch Ergonomics:** Interactive targets maintain a minimum vertical height of 48px, padded internally using `space-md` (12px) and `space-lg` (16px).
- **Vertical Rhythm:** Content clusters adhere to multiples of 4px. Structural separation between distinct service groups uses `space-xl` (24px); intra-card padding strictly uses `space-lg` (16px).
- **Reflow Rules:** Horizontal carousels (e.g., categories, verified experts) bleed through the right margin to signal scrollability with a trailing preview of 32px.

## Elevation & Depth

Visual hierarchy uses **Soft Amber/Slate Ambient Shadows** combined with crisp structural outlines, discarding muddy, pure-black drop shadows in favor of tinted dimension.

### Elevation Hierarchy
- **Level 0 (Flat Canvas - `#F8FAFC`):** Default viewport background.
- **Level 1 (Cards & Service Modules - `#FFFFFF`):** 
  - Shadow: `0 1px 3px rgba(15, 23, 42, 0.05), 0 1px 2px rgba(15, 23, 42, 0.03)`
  - Border: 1px solid `#E2E8F0`
- **Level 2 (Floating Micro-elements & Filter Chips):** 
  - Shadow: `0 4px 6px -1px rgba(15, 23, 42, 0.07), 0 2px 4px -2px rgba(15, 23, 42, 0.05)`
  - Used for category pills when toggled and craftsman review highlights.
- **Level 3 (Modal Sheets & Floating Bottom Nav):** 
  - Shadow: `0 10px 25px -5px rgba(15, 23, 42, 0.12), 0 8px 10px -6px rgba(15, 23, 42, 0.08)`
  - Backed by an ultra-light glass backdrop blur (`backdrop-filter: blur(12px)` with 85% opacity background) for sticky bottom action bars.

## Shapes

The geometric signature uses friendly, generous rounding (`roundedness: 2` with explicit 16px/24px card treatments) to offset technical anxiety associated with home maintenance emergencies.

- **Cards & Bottom Sheets:** Standardized on `rounded-2xl` (16px/1rem). Modals and drawer pullouts use 24px top radiuses.
- **Buttons & Search Inputs:** Scaled at 12px (`rounded-xl`) to feel tactile, clickable, and soft in the hand.
- **Badges & Chips:** Full pill radius (9999px) for status indicators, ratings, and trade tags to clearly delineate them from actionable rectangular cards.
- **Craftsman Avatar Containers:** Squircle geometry with a 14px radius and 2px emerald verification border accents.

## Components

### Buttons
- **Primary CTA:** Deep Slate (`#0F172A`) base, white text, bold label typography, height 52px, full-width on mobile. Subtle scale active-state (`scale-98`).
- **Artisan / Urgent CTA:** Amber Ochre (`#D97706`) base, white text, for immediate booking or dispatch.
- **Secondary / Ghost:** `#F1F5F9` surface with `#0F172A` text, 1px border `#E2E8F0`.

### Verification Badges & Chips
- **"Karigaar Verified" Badge:** Pill-shaped, emerald background tint (`#ECFDF5`), bold emerald text (`#059669`), paired with a checkmark shield icon.
- **Status Chips:** Inactive in `#F1F5F9` with neutral slate text. Selected chips flip to `#0F172A` with pure white text, 0.5s fluid width transition.

### Cards (Craftsman & Service Listing)
- Pure white background, `rounded-2xl`, subtle slate border.
- Layout: Left avatar (56x56px rounded squircle), center info stack (name, trade category, experience pill, rating star in amber), right side pricing and instant-hire CTA button.
- Embedded trust tags: "Police Verified", "5+ Yrs Exp", "Insured".

### Form Fields & Search Bar
- Height 48px, background `#FFFFFF`, border 1.5px `#E2E8F0`, interior left-aligned trade search icon.
- Focused state: Border transitions to `#0F172A` with a 3px ambient amber tint glow (`rgba(217, 119, 6, 0.15)`).

### Sticky Bottom Action Bar
- Docked fixed to bottom with safe-area inset accommodation.
- Frosted `#FFFFFF` (90% opacity with 16px backdrop blur).
- Split layout: Left column showcases dynamic booking total and warranty badge; right column hosts full-height primary booking CTA button.