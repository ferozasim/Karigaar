// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get languageSetting => 'App language';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get searchServices => 'Search by job, material, or trade';

  @override
  String get browseServices => 'Browse services';

  @override
  String get allTrades => 'All services';

  @override
  String get explore => 'Explore';

  @override
  String get bookings => 'Bookings';

  @override
  String get messages => 'Messages';

  @override
  String get profile => 'Profile';

  @override
  String get quickServiceSearch => 'Find a service';

  @override
  String get selectServicePrompt =>
      'What do you need help with? Search a task like tiles, granite, or plumbing.';

  @override
  String inspectionWarranty(Object fee, Object days) {
    return 'Inspection ₹$fee • $days day warranty';
  }

  @override
  String get noServicesFound =>
      'No matching service found. Try another task or trade.';

  @override
  String get brandTagline => 'Master Guildsman Meets Modern Concierge';

  @override
  String get loginAsHomeowner => 'Login as Homeowner';

  @override
  String get artisanGuildPortal => 'Artisan Guild Portal';

  @override
  String get homeownerTagline => 'Book verified master Karigaars in 25 mins';

  @override
  String get artisanTagline =>
      'Claim nearby emergency jobs and check your wallet';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get enterPhoneNumber => 'Enter 10-digit number';

  @override
  String get invalidPhoneNumber =>
      'Please enter a valid 10-digit mobile number';

  @override
  String get continueWithWhatsApp => 'Continue with WhatsApp';

  @override
  String get getOtpViaSms => 'Get OTP via SMS';

  @override
  String get joinGuild => 'New Karigaar? Join the Nanded Guild (0% Fee)';

  @override
  String get trustFooter =>
      'Aadhaar and police verified craftspeople • Pilot city: Nanded';

  @override
  String get homeowner => 'Homeowner';

  @override
  String get homeownerMode => 'Homeowner Mode';

  @override
  String get karigaar => 'Karigaar';

  @override
  String get artisanMode => 'Artisan Mode';

  @override
  String get launchTrades => '10 Launch Trades';

  @override
  String districtGuild(Object district) {
    return '$district Guild';
  }

  @override
  String get shieldCommitment => 'The Karigaar Shield Commitment';

  @override
  String topRatedInDistrict(Object district) {
    return 'Top rated Karigaars in $district';
  }

  @override
  String yearsExperience(Object years) {
    return '$years years experience';
  }

  @override
  String reviewsAndDistance(Object reviews, Object distance) {
    return '$reviews reviews • $distance km away';
  }

  @override
  String get diagnosticInspection => 'Diagnostic Inspection';

  @override
  String get bookArtisan => 'Book Artisan';

  @override
  String get servicesLoadError => 'Could not load services. Try again.';

  @override
  String get authOtpVerification => 'OTP Verification';

  @override
  String get authVerifyWhatsAppCode => 'Verify WhatsApp Code';

  @override
  String get authCodeSent => 'We sent a 6-digit verification code to\n';

  @override
  String get authResendCode => 'Resend Code via WhatsApp';

  @override
  String get authFallbackSms => 'Fallback SMS sent via DLT gateway.';

  @override
  String get authSmsFallback => 'Didn\'t receive on WhatsApp? Send via SMS';

  @override
  String get authVerifyContinue => 'Verify & Continue';

  @override
  String get authStepPersonal => 'Step 1 of 4: Personal Details';

  @override
  String get authStepTrade => 'Step 2 of 4: Trade Selection';

  @override
  String get authStepAudit => 'Step 3 of 4: KYC & Tools Audit';

  @override
  String get authStepPayout => 'Step 4 of 4: Payout & Protection';

  @override
  String get authLegalNameError =>
      'Please enter your full Aadhaar name and 10-digit mobile number.';

  @override
  String get authTradeError =>
      'Please select your primary trade from the 10 launch trades.';

  @override
  String get authAadhaarError =>
      'Please enter a valid 12-digit Aadhaar number.';

  @override
  String get authJoinGuild => 'Join the Karigaar Guild';

  @override
  String get authAlreadyRegistered =>
      'Already registered in the Guild? Log In here';

  @override
  String get authAccreditation => 'Guild Accreditation';

  @override
  String get authCommissionGuarantee => '5% Commission Floor Guarantee';

  @override
  String get authJoinDescription =>
      'Connect directly with premium households in your pin code. Transparent daily payouts and guild master insurance cover.';

  @override
  String get authAverageEarnings => 'Over ₹42,000/mo Avg. Earnings';

  @override
  String get authGuildProfessionals =>
      'Join 12,400+ verified professionals across Nanded Guild';

  @override
  String get authPersonalHeading => 'Step 1: Personal Details & Locality';

  @override
  String get authPersonalDescription =>
      'Your legal info for KYC, guild credentials and instant direct deposits';

  @override
  String get authFullName => 'Full Legal Name';

  @override
  String get authMatchesAadhaar => 'Matches Aadhaar Card';

  @override
  String get authNameHint => 'e.g. Ramesh Chandra Sharma';

  @override
  String get authWhatsAppNumber => 'WhatsApp Mobile Number';

  @override
  String get authInstantOtp => 'Instant OTP Dispatch';

  @override
  String get authWhatsAppHint => 'Enter 10-digit WhatsApp number';

  @override
  String get authEmergencyContact => 'Emergency Contact (Next-of-Kin)';

  @override
  String get authContactName => 'Contact Name';

  @override
  String get authPhoneHint => '10-digit Phone';

  @override
  String get authWorkingLocality => 'Primary Working Locality';

  @override
  String get authExperience => 'Trade Experience';

  @override
  String get authPriorityLeads => 'Higher tier gets priority leads';

  @override
  String get authDispatchAlerts => 'WhatsApp Dispatch Alerts';

  @override
  String get authDispatchDescription =>
      'Receive emergency high-pay calls, daily settlement slips, and guild warranty alerts instantly.';

  @override
  String get authReferralQuestion => 'Have a Master Craftsman Referral Code?';

  @override
  String get authReferralHint => 'e.g. GUILD500';

  @override
  String get authReferralApplied =>
      'Referral code GUILD500 applied! ₹500 joining bonus unlocked.';

  @override
  String get authApply => 'Apply';

  @override
  String get authPrimaryTrade => 'Select Primary Trade';

  @override
  String get authPrimaryTradeDescription =>
      'Tap your certified craft from Nanded 10 launch trades';

  @override
  String get authOneRequired => '1 Required';

  @override
  String get authRoleType => 'Karigaar Role Type';

  @override
  String get authKycHeading => 'Step 3: Aadhaar KYC & Tools Audit';

  @override
  String get authKycDescription =>
      'Biometric verification and calibrated equipment checklist for Guild safety rating';

  @override
  String get authAadhaarNumber => '12-Digit Aadhaar Number';

  @override
  String get authEncrypted => 'Encrypted & UIDAI Compliant';

  @override
  String get authTradeCard => 'Aadhaar / Trade Card';

  @override
  String get authFrontSync => 'Front photo & DigiLocker sync';

  @override
  String get authDigilockerSuccess =>
      'DigiLocker KYC Gateway synced successfully!';

  @override
  String get authFrontCaptured => 'Aadhaar Front Scan Captured';

  @override
  String get authCaptureAadhaar => 'Capture Front of Aadhaar Card';

  @override
  String get authPhotoLimit => 'Clear photo • Max size 10MB (JPG/PNG)';

  @override
  String get authAutoVerified => '72% Auto-verified';

  @override
  String get authUpload => 'Tap to upload';

  @override
  String get authToolsAudit => 'Calibrated Tools Audit';

  @override
  String get authSafetyStandard => 'Guild Safety Standard';

  @override
  String get authMultimeter =>
      'Digital True-RMS Multimeter & Phase Tester (calibrated)';

  @override
  String get authInsulatedTools => '1000V Insulated Screwdrivers & Pliers Set';

  @override
  String get authDrillTools =>
      'Heavy Duty Rotary Hammer Drill & Safety Goggles';

  @override
  String get authCleanupTools =>
      'Canvas Drop-Cloth & Sawdust Cleanup Vacuum Bag';

  @override
  String get authPayoutHeading => 'Step 4: Bank / UPI Payout Verification';

  @override
  String get authPayoutDescription =>
      'Link your bank or UPI ID for instant 10-second IMPS payout settlements with zero guild fee';

  @override
  String get authDirectPayout => 'Instant Guild Direct Payout';

  @override
  String get authBankAccount => 'Bank Account Number';

  @override
  String get authReenterBank => 'Re-Enter Bank Account Number';

  @override
  String get authIfsc => 'IFSC Code';

  @override
  String get authBranchResolved =>
      'Branch Resolved: HDFC Bank, Vazirabad Branch, Nanded (431601)';

  @override
  String get authUpiPayout => 'UPI Fast Payout VPA';

  @override
  String get authPennyDrop => 'Penny-Drop Verified';

  @override
  String get authVerifiedUpi => 'Verified UPI ID / VPA (₹0 IMPS Fee)';

  @override
  String get authPennyDropSimulation =>
      'Simulated ₹1 IMPS penny-drop test successful. Payout wallet linked.';

  @override
  String get authProtectionActive => '₹25,000 Guild Protection Shield Active';

  @override
  String get authProtectionDescription =>
      'Karigaar covers accidental on-site property damage up to ₹25,000. You earn with zero liability and sustainable 5% commission floor guarantee (Guild Elite).';

  @override
  String get authBack => 'Back';

  @override
  String get authNextStep => 'Next Step';

  @override
  String get authVerifyWhatsApp => 'Verify via WhatsApp OTP';

  @override
  String get jobInvalidStart =>
      'Invalid code! Ask customer for their 4-digit start code.';

  @override
  String get jobAccessDenied => 'Doorstep Access Denied';

  @override
  String get jobCloseJob => 'Close Job';

  @override
  String get jobAddPart2fa => 'Add Spare Part with 2FA';

  @override
  String get jobPartName => 'Part Name & Specification';

  @override
  String get jobUnitPrice => 'Unit Price (₹)';

  @override
  String get jobStoreName => 'Hardware Store Name';

  @override
  String get jobAttachReceipt => 'Attach Hardware Store Receipt Photo';

  @override
  String get jobPartsDisclaimer =>
      'Pass-through spare parts include a 2% payment gateway surcharge and trigger an in-app customer RBI 2FA approval prompt.';

  @override
  String get jobCancel => 'Cancel';

  @override
  String get jobAddPartBill => 'Add Part to Bill';

  @override
  String get jobInvoiceSubmitted =>
      'Itemized Invoice Submitted! Customer notified to verify bill and release PIN.';

  @override
  String get jobActiveBill => 'Active Job & Bill Builder';

  @override
  String get jobStopwatch => 'ON-SITE REPAIR STOPWATCH';

  @override
  String get jobElapsed => '28m 14s Elapsed';

  @override
  String get jobLiveLog => 'Live Log';

  @override
  String get jobGpsStreaming => 'LIVE GPS TELEMETRY STREAMING (CONTRACT 3)';

  @override
  String get jobForeground => 'Foreground (3s)';

  @override
  String get jobBackground => 'Background (15s)';

  @override
  String get jobSpeed => 'Speed';

  @override
  String get jobHeading => 'Heading';

  @override
  String get jobBattery => 'Battery';

  @override
  String get jobRemaining => 'Remaining';

  @override
  String get jobGeofence =>
      'Doorstep 200m Geofence Triggered! Ready for Start Code.';

  @override
  String get jobEnterStart => 'Step 1: Enter Customer Start Code';

  @override
  String get jobStartDescription =>
      'Ask homeowner for their 4-digit security code (Demo: 4921) to confirm doorstep arrival.';

  @override
  String get jobStartHint => 'Enter 4-digit Start Code';

  @override
  String get jobVerifyBegin => 'Verify Code & Begin Repair';

  @override
  String get jobDeniedTransit => 'Doorstep Access Denied (Claim ₹80 Transit)';

  @override
  String get jobStartComplete =>
      'Start Code 4921 Verified • Doorstep Handshake Complete';

  @override
  String get jobBillBuilder => 'Dynamic Bill Builder';

  @override
  String get jobCustomPart => 'Custom Part';

  @override
  String get jobAddPart => 'Add Part';

  @override
  String get jobLaborDiagnostic => 'Labor & Diagnostic Inspection';

  @override
  String get jobReceiptAttached => 'Receipt Photo Attached';

  @override
  String get jobLaborBase => 'Labor & Inspection Base';

  @override
  String get jobPartsSurcharge => '2% Parts Gateway Surcharge';

  @override
  String get jobGst => '18% GST (Labor & Surcharge)';

  @override
  String get jobTotalInvoiced => 'Total Invoiced to Customer';

  @override
  String get jobWaitingPin =>
      'Itemized Invoice Submitted • Waiting Customer PIN';

  @override
  String get jobSubmitInvoice => 'Submit Itemized Invoice (Decoupled)';

  @override
  String get jobCompletionHeading => 'Step 3: Collect Completion PIN';

  @override
  String get jobCompletionDescription =>
      'Ask customer for their 4-digit verbal completion PIN (Demo: 7294)';

  @override
  String get jobCompletionHint => 'Enter 4-digit Completion PIN';

  @override
  String get jobPayoutSettled => 'IMPS Payout Settled!';

  @override
  String get jobBackRadar => 'Back to Radar';

  @override
  String get jobInvalidCompletion =>
      'Invalid completion PIN! Enter 7294 for demo.';

  @override
  String get jobElitePartner => 'Guild Elite Partner';

  @override
  String get jobGoldGuildsman => 'Gold Guildsman';

  @override
  String get jobFloorActive => '5% Commission Floor Active';

  @override
  String get jobTier4 => 'Tier Level 4 Craftsman';

  @override
  String get jobTakeRate => '💎 5% Take-Rate';

  @override
  String get jobTopPartner => 'Top 5% Partner';

  @override
  String get jobApprentice => 'Apprentice\n(15%)';

  @override
  String get jobPro => 'Pro\n(12%)';

  @override
  String get jobMaster => 'Master\n(8%)';

  @override
  String get jobElite => 'Elite\n(5% Floor)';

  @override
  String get jobEliteMilestone => 'Guild Elite Milestone: Unlocked';

  @override
  String get jobMasterMilestone => 'Milestone: Master Guildsman (8%)';

  @override
  String get jobJobsProgress => '42 / 50 Jobs';

  @override
  String get jobEliteDescription =>
      'Guild Elite active! You keep 95% of job billings with a 5% commission floor.';

  @override
  String get jobMasterDescription =>
      'Complete 8 more jobs for 8% Master tier, or subscribe to Guild Elite for the 5% commission floor!';

  @override
  String get jobKarigaarElite => 'Karigaar Guild Elite Partner';

  @override
  String get jobKeep95 => '5% Commission Floor (Keep 95%)';

  @override
  String get jobMonthlyDeduction =>
      '₹999 / month • Instant 1-tap wallet deduction';

  @override
  String get jobEliteBenefitFees =>
      '• 5% Commission Floor (Save up to ₹4,500/mo in platform fees)\n';

  @override
  String get jobEliteBenefitRadar =>
      '• Priority 10s Radar Dispatch blast before standard partners\n';

  @override
  String get jobEliteBenefitImps =>
      '• ₹0 Instant IMPS Payout Fee (platform covers gateway charges)\n';

  @override
  String get jobEliteBenefitBadge =>
      '• Golden Guild Elite badge displayed to customers';

  @override
  String get jobUpgradeElite => 'Upgrade to Guild Elite (₹999/mo)';

  @override
  String get jobEliteLocked =>
      '💎 Guild Elite Active • 5% Commission Floor Locked • Next billing in 30 days';

  @override
  String get jobSubscribeElite => 'Subscribe to Guild Elite';

  @override
  String get jobLockFloor => 'Lock in sustainable 5% commission floor';

  @override
  String get jobSubscriptionFee => 'Monthly Subscription Fee';

  @override
  String get jobWalletBalance => 'Current Wallet Balance';

  @override
  String get jobPostDeduction => 'Post-Deduction Balance';

  @override
  String get jobSubscribed =>
      'Subscribed to Guild Elite! 5% commission floor active.';

  @override
  String get jobConfirmDeduct => 'Confirm & Deduct ₹999 from Wallet';

  @override
  String get jobGuildWallet => 'Guild Wallet';

  @override
  String get jobImpsLive => 'Instant IMPS Live';

  @override
  String get jobClearedPayout => 'CLEARED AVAILABLE PAYOUT';

  @override
  String get jobLockedReserve => 'LOCKED RESERVE';

  @override
  String get jobAvailablePayout => 'AVAILABLE PAYOUT';

  @override
  String get jobWithdrawBank => 'Withdraw to Bank via UPI / IMPS (₹0 Fee)';

  @override
  String get jobSupport => 'Karigaar Partner Support';

  @override
  String get jobWeeklySummary => 'Send Weekly Earnings Summary to WhatsApp';

  @override
  String get jobVerifiedVault => 'Verified Guild Vault';

  @override
  String get jobNoBalance => 'No cleared balance available for withdrawal.';

  @override
  String get jobReserveRequired =>
      'Cannot withdraw. A mandatory ₹2,000 security reserve must be maintained.';

  @override
  String get jobInstantPayout => 'Instant IMPS Payout';

  @override
  String get jobReserveLocked =>
      'Mandatory ₹2,000 rolling security reserve locked in Guild Vault.';

  @override
  String get jobBankNanded => 'Bank: HDFC Bank Limited (Nanded Main Branch)';

  @override
  String get jobMaskedAccount => 'Account: •••• •••• 2104';

  @override
  String get jobPayoutFee => 'Payout Fee: ₹0.00 (Guild Covered)';

  @override
  String get jobConfirmPayout => 'Confirm IMPS Payout';

  @override
  String get jobRecentActivity => 'Recent Activity';

  @override
  String get jobViewLedger => 'View Ledger';

  @override
  String get jobWiringRepair => 'MCB & Wiring Repair';

  @override
  String get jobActivityToday => 'Anand Nagar, Nanded • Today, 11:20 AM';

  @override
  String get jobDailyPayout => 'Daily Payout to HDFC';

  @override
  String get jobActivityYesterday => 'Ref #IMPS99824 • Yesterday';

  @override
  String get jobGuildGuarantee =>
      'Guild guarantee: Guaranteed immediate IMPS payout processing 24/7 with zero service deduction.';

  @override
  String get jobProfileUpdated =>
      'Profile & rate card updated and synced to district directory!';

  @override
  String get jobBioHint => 'Describe your craft expertise & safety gear...';

  @override
  String get jobWorkPhotoHint => 'e.g. 6-Way Distribution Box Setup';

  @override
  String get jobNandedGuild => 'Nanded Trade Guild';

  @override
  String get jobJobsRating => '4.9★ (340 jobs)';

  @override
  String get jobEmergency => 'EMERGENCY BREAKDOWN';

  @override
  String get jobOnePhoto => '1 Photo';

  @override
  String get jobBroadcastTimeout =>
      'Broadcast timed out without acceptance. Search expanded to regional guild.';

  @override
  String get jobScanning => 'Scanning Nanded for incoming requests...';

  @override
  String get jobDutyPaused => 'Duty paused. Go online to receive jobs.';

  @override
  String get jobKeepActive =>
      'Keep app active to receive 45s priority broadcasts';

  @override
  String get jobVoiceExample =>
      'Customer Voice Note: \"MCB switch sparking when turning on AC. Need 32A replacement.\"';

  @override
  String get jobPausePreview => 'Pause Preview';

  @override
  String get jobListenMemo => 'Listen to Customer Audio Memo';

  @override
  String get localitySelect => 'Select Locality';

  @override
  String get localityPilotDistrict =>
      'Pilot City: Nanded-Waghala (Maharashtra)';

  @override
  String localityDistrict(String district) {
    return 'District: $district';
  }

  @override
  String get localitySearchHint => 'Search locality or PIN code';

  @override
  String localityEmptyText(String city) {
    return 'No locality found in $city';
  }

  @override
  String localityChanged(String name, String pincode) {
    return 'Switched service hub to $name ($pincode)';
  }

  @override
  String get emergencyTitle => 'URGENT BREAKDOWN? (25 MINS)';

  @override
  String get emergencyDispatch => 'Immediate Doorstep Dispatch';

  @override
  String get emergencyCoverage =>
      'Electricians & Plumbers on stand-by across Nanded';

  @override
  String get emergencyBookFast => 'Book Fast';

  @override
  String get skeletonTradesHeading => 'CERTIFIED GUILD TRADES';

  @override
  String catalogTradeName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'trade_electrician': 'Electrician',
        'trade_plumber': 'Plumber',
        'trade_carpenter': 'Carpenter',
        'trade_mason': 'Mason / Civil Worker',
        'trade_painter': 'Painter',
        'trade_ac_refrig': 'AC & Refrigeration',
        'trade_appliance': 'Appliance Repair',
        'trade_welder': 'Welder / Fabricator',
        'trade_pest': 'Pest Control',
        'trade_deep_cleaning': 'Deep Cleaning',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogTradeTagline(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'trade_electrician':
            'Short circuit, MCB, switchboard & heavy appliance wiring',
        'trade_plumber':
            'Pipe leaks, tap replacement, drainage blockages & sanitary fittings',
        'trade_carpenter':
            'Door locks, modular kitchen hinges, veneer repairs & furniture assembly',
        'trade_mason':
            'Tile replacement, wall plastering, concrete drilling & waterproofing',
        'trade_painter':
            'Wall touch-ups, dampness treatment, door polish & full home painting',
        'trade_ac_refrig':
            'Foam jet service, gas refill, compressor diagnosis & cooling issues',
        'trade_appliance':
            'Washing machine, microwave, geyser, mixer grinder & RO purifier',
        'trade_welder':
            'Main gate hinge welding, window safety grill, railing & shed repair',
        'trade_pest':
            'Cockroach gel treatment, termite drill barrier, bed bug eradication',
        'trade_deep_cleaning':
            'Full bathroom descaling, kitchen oil degreasing & sofa shampooing',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogPackageName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'pkg_elec_mcb': 'Short Circuit & MCB Tripping',
        'pkg_elec_switchboard': 'Switchboard & Socket Repair',
        'pkg_elec_fan': 'Ceiling Fan / Chandelier Fitting',
        'pkg_elec_inverter': 'Inverter & Battery Wiring',
        'pkg_plumb_leak': 'Water Pipe Joint Leakage Fix',
        'pkg_plumb_drain': 'Kitchen Sink & Bathroom Drain Unclog',
        'pkg_plumb_tap': 'Tap / Mixer / Diverter Replacement',
        'pkg_plumb_tank': 'Overhead Tank Float Valve & Motor Line',
        'pkg_carp_lock': 'Main Door Deadbolt / Godrej Lock Repair',
        'pkg_carp_hinge': 'Hydraulic Cabinet & Wardrobe Hinge Replacement',
        'pkg_carp_door_trim': 'Door Dragging & Frame Planing',
        'pkg_carp_furniture': 'Bed / Table Assembly & Structural Tightening',
        'pkg_mason_tile': 'Broken Floor / Wall Tile Patching (Up to 4 tiles)',
        'pkg_mason_plaster': 'Wall Crack & Plaster Repair',
        'pkg_mason_waterproof': 'Bathroom / Balcony Corner Waterproofing',
        'pkg_paint_patch': 'Single Wall Patch & Touch-up (Putty + Paint)',
        'pkg_paint_damp': 'Anti-Dampness Chemical Barrier + Topcoat',
        'pkg_paint_wood': 'Door & Window Enamel / Melamine Polishing',
        'pkg_ac_deep_clean': 'Split AC Foam Jet Deep Service',
        'pkg_ac_gas_leak': 'AC Gas Leakage Check & Top-up',
        'pkg_fridge_cooling': 'Refrigerator Low Cooling / Defrost Fix',
        'pkg_app_geyser': 'Instant / Storage Geyser Heating Element Fix',
        'pkg_app_washing': 'Washing Machine Spin / Drain Drum Issue',
        'pkg_app_ro': 'RO Water Purifier Membrane & Filter Overhaul',
        'pkg_weld_gate': 'Main Sliding / Swing Gate Heavy Hinge Arc Welding',
        'pkg_weld_grill': 'Balcony & Window Safety Grill Reinforcement',
        'pkg_weld_sheet': 'Tin Shed & Polycarbonate Roof Bracket Fix',
        'pkg_pest_cockroach': 'Kitchen & Bathroom Herbal Gel Treatment',
        'pkg_pest_termite': 'Wood Termite Drill & Inject Chemical Shield',
        'pkg_pest_bedbug': '2-Stage Bed Bug Thermal & Spray Eradication',
        'pkg_clean_bath': 'Intense Bathroom Hard Water Stain & Tile Descaling',
        'pkg_clean_kitchen': 'Modular Kitchen Chimney & Slab Degreasing',
        'pkg_clean_sofa': 'Fabric Sofa 5-Seater Shampoo & Wet Extraction',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogPackageDescription(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'pkg_elec_mcb':
            'Continuous tripping, spark diagnosis, neutral fault identification & fuse repair',
        'pkg_elec_switchboard':
            'Loose modular switches, burnt contact points, 16A power socket installation',
        'pkg_elec_fan':
            'Anchor rod hanging, speed regulator rewiring, vibration reduction',
        'pkg_elec_inverter':
            'Backup bypass line, heavy load terminal setup, battery water check',
        'pkg_plumb_leak':
            'CPVC/PVC pipe joint soldering, concealed wall seepage diagnosis',
        'pkg_plumb_drain':
            'High pressure mechanical auger drain clearing, trap cleaning',
        'pkg_plumb_tap':
            'Ceramic spindle change, quarter-turn angle valve fitting, teflon sealing',
        'pkg_plumb_tank':
            'Ball cock auto cut-off valve replacement, airlock clearance',
        'pkg_carp_lock':
            'Cylinder replacement, jammed latch alignment, brass strike plate fitting',
        'pkg_carp_hinge':
            'Soft-close hinge tension adjustment, plywood screw anchor grip repair',
        'pkg_carp_door_trim':
            'Precision bottom trimming, monsoon swollen wood clearance',
        'pkg_carp_furniture':
            'Hardware re-bolting, wooden bracket reinforcement, termite inspection',
        'pkg_mason_tile':
            'Adhesive bedding, laser levelling, anti-fungal epoxy grouting',
        'pkg_mason_plaster':
            'Polymer-modified cement slurry, v-groove chasing, smooth trowel finish',
        'pkg_mason_waterproof':
            'Dr. Fixit 2-coat chemical membrane application on skirtings',
        'pkg_paint_patch':
            'Sanding, acrylic wall putty, 2-coat primer and shade matching',
        'pkg_paint_damp':
            'Efflorescence salt removal, silicone damp-lock treatment',
        'pkg_paint_wood': 'Fine sandpaper smoothing, high-gloss PU coating',
        'pkg_ac_deep_clean':
            'Indoor coil antibacterial foam pressure wash, outdoor unit blower rinse, filter disinfection',
        'pkg_ac_gas_leak':
            'Nitrogen pressure leak testing, flare nut brazing, R32/R410A vacuum charging',
        'pkg_fridge_cooling':
            'Thermostat calibration, bi-metal sensor replacement, capillary flush',
        'pkg_app_geyser':
            'Copper heating coil descaling, safety thermostat auto cut-off calibration',
        'pkg_app_washing':
            'Motor belt tightening, drain pump lint filter unclog, PCB relay check',
        'pkg_app_ro':
            'TDS level calibration, sediment + carbon filter change, booster pump check',
        'pkg_weld_gate':
            'Heavy duty mild steel ball-bearing pivot welding, slag chipping, rust-primer coat',
        'pkg_weld_grill':
            'Loose anchor pin tack welding, angle iron strengthening',
        'pkg_weld_sheet':
            'Wind-damaged purlin joint welding, self-tapping screw gasket replacement',
        'pkg_pest_cockroach':
            'Odorless Fipronil bait dot application in hinges, under-sink crevices (safe for kids & pets)',
        'pkg_pest_termite':
            'Precision 6mm skirt drilling, pressurized Imidacloprid injection, wood-colored seal',
        'pkg_pest_bedbug':
            'Mattress seam steam purge, residual pyrethroid spraying, 15-day free repeat visit',
        'pkg_clean_bath':
            'Single-disc scrubber rotary tile wash, tap chrome buffing, glass divider spot removal',
        'pkg_clean_kitchen':
            'Caustic-free baffle filter ultrasonic cleaning, stainless steel polish, tile grout whitening',
        'pkg_clean_sofa':
            'Deep foam agitation, industrial vacuum suction moisture extraction, citrus deodorizer',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogBundleTitle(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'bundle_monsoon_elec': 'Monsoon Electrical Shield',
        'bundle_plumb_health': 'Full Home Plumbing Health Check',
        'bundle_ac_summer': 'Pre-Summer AC Super Cool',
        'bundle_carpenter_care': 'Modular Kitchen & Door Alignment',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogBundleSubtitle(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'bundle_monsoon_elec':
            'Prevent short circuits, MCB trips & moisture leakage shocks',
        'bundle_plumb_health':
            'Concealed pipe seepage scan, overhead tank valve test & trap unclogging',
        'bundle_ac_summer':
            'Antibacterial foam jet deep wash, cooling test & gas pressure audit',
        'bundle_carpenter_care':
            'Hydraulic soft-close hinge tightening & swollen door planing',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogBundleTask(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'bundle_monsoon_elec_0': 'MCB trip diagnosis & fuse load calibration',
        'bundle_monsoon_elec_1':
            'Switchboard moisture & earthing leakage check',
        'bundle_monsoon_elec_2': 'Ceiling fan & backup wiring tightening',
        'bundle_plumb_health_0': 'Concealed pipe joint acoustic seepage audit',
        'bundle_plumb_health_1':
            'Kitchen sink & bathroom mechanical drain auger cleaning',
        'bundle_plumb_health_2':
            'Quarter-turn angle valves & ceramic spindle tune-up',
        'bundle_ac_summer_0': 'Indoor cooling coil high-pressure foam jet wash',
        'bundle_ac_summer_1':
            'Outdoor unit condenser rinse & compressor vibration damping',
        'bundle_ac_summer_2':
            'R32/R410A gas pressure measurement & filter disinfection',
        'bundle_carpenter_care_0':
            'Hydraulic cabinet & wardrobe soft-close tension adjustment',
        'bundle_carpenter_care_1':
            'Swollen door frame planing & bottom clearance trimming',
        'bundle_carpenter_care_2':
            'Main door deadbolt & Godrej lock cylinder servicing',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogRoleName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'headMistry': 'Head Mistry / Ustad',
        'skilledKarigaar': 'Skilled Karigaar',
        'helperAssistant': 'Helper / Bigari',
        'thekedar': 'Thekedar / Team Contractor',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String catalogRoleBadge(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'headMistry': '👑 Head Mistry',
        'skilledKarigaar': '🔧 Skilled Karigaar',
        'helperAssistant': '🤝 Helper',
        'thekedar': '👷 Thekedar',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String get flowVerifiedGuild => 'Verified Master Guild';

  @override
  String get flowNandedRating => '4.9 (1.4k jobs in Nanded)';

  @override
  String get flowInspectionWarranty =>
      'Includes 45-min diagnostic inspection & 30-day rework warranty';

  @override
  String get flowSelectIssues => 'Select Issues to Resolve';

  @override
  String get flowSelectIssuesHint =>
      'Choose all relevant problems for accurate tooling';

  @override
  String get flowBundleApplied => 'Curated Bundle Applied';

  @override
  String get flowPhotoVoice => 'Photo & 15-Second Voice Note';

  @override
  String get flowSparesHint =>
      'Help your craftsman bring the exact spares from the hardware store';

  @override
  String get flowPhotoRemoved => 'Removed attached photo.';

  @override
  String get flowPhotoAttached => 'Defect Photo Attached';

  @override
  String get flowAddPhoto => 'Add Issue Photo (Optional)';

  @override
  String get flowShieldFee => '+₹29 Shield Fee';

  @override
  String get flowAdjustableBill => 'Adjustable on-site bill';

  @override
  String get flowRequestArtisan => 'Request Artisan';

  @override
  String get flowSkillTier => 'Craftsperson Skill Tier';

  @override
  String get flowMasterRate => '1.25x (+25% Master Tier)';

  @override
  String get flowStandardRate => '1.0x (Standard Rate)';

  @override
  String get flowHelperRate => '0.65x (-35% Helper Tier)';

  @override
  String get flowContractorRate => '1.35x (+35% Team Contractor)';

  @override
  String get flowMandateTitle => 'Upfront ₹99 Standby Mandate';

  @override
  String get flowMandateProvider => 'Razorpay / Cashfree UPI Autopay Protected';

  @override
  String get flowMandateWhy => 'Why is a ₹99 pre-authorization required?';

  @override
  String get flowMandateExplanation =>
      'Secures ₹99 standby transit fee hold to protect artisan fuel and travel. The hold is RELEASED upon job completion and debited ONLY if doorstep access is denied for >15 minutes.';

  @override
  String get flowSelectUpi => 'Quick Select UPI App';

  @override
  String get flowUpiId => 'Enter UPI ID / VPA';

  @override
  String get flowUpiHint => 'e.g. mobile@okaxis';

  @override
  String get flowUpiInvalid => 'Please enter a valid UPI VPA (e.g. name@bank)';

  @override
  String get flowAuthorizeMandate => 'Authorize ₹99 Mandate & Request Artisan';

  @override
  String get flowAudioTitle => '15s Audio Memo Scoping';

  @override
  String get flowRecording => 'Recording in progress (Max 15s)...';

  @override
  String get flowAudioLanguages =>
      'Explain defect in Hindi, Marathi, or English';

  @override
  String get flowAudioHint =>
      'Record up to 15 seconds of motor hum, water leak sound, or sparking sound for the master artisan.';

  @override
  String get flowRecordAudio => 'Record 15s Audio Memo';

  @override
  String get flowPause => 'Pause';

  @override
  String get flowPlayPreview => 'Play Preview';

  @override
  String get flowRerecord => 'Re-record';

  @override
  String get flowDeleteAudio => 'Delete Audio Memo';

  @override
  String get flowArrivalDateSlot => 'Select Arrival Date & Slot';

  @override
  String get flowToday => 'TODAY';

  @override
  String get flowEmergency => 'EMERGENCY';

  @override
  String get flowLiveTracking => 'Live Tracking';

  @override
  String get flowNoBooking => 'No active booking found';

  @override
  String get flowDispatchRadar => 'Live Dispatch Radar';

  @override
  String get flowYourHome => 'Your Home';

  @override
  String get flowArrived => 'Arrived';

  @override
  String get flowArrivedZero => 'Arrived at Doorstep (0 km)';

  @override
  String get flowStationary => 'Stationary • At Destination';

  @override
  String get flowArrivalHint =>
      'Artisan has arrived in your vicinity. Provide code once at your door.';

  @override
  String get flowDwellExplanation =>
      'Artisan is waiting outside. Standby ₹99 transit fee applies if doorstep entry is unreachable or denied for >15 mins.';

  @override
  String get flowStartCodeLabel => 'DOORSTEP SECURITY START CODE';

  @override
  String get flowStartCodeHint =>
      'Share this 4-digit code verbally ONLY when your Karigaar arrives at your doorstep.';

  @override
  String get flowMaskedWhatsapp => 'Masked WhatsApp Channel';

  @override
  String get flowMaskedCall => 'Masked Telephony Bridge';

  @override
  String get flowDirections => 'Quick Doorstep Directions';

  @override
  String get flowMilestones => 'Booking Milestones';

  @override
  String get flowBookingConfirmed => 'Booking Confirmed & Escrow Held';

  @override
  String get flowArtisanDispatched => 'Artisan Dispatched from Anand Nagar';

  @override
  String get flowArrivedWithin => 'Arrived at Doorstep (Within 200m)';

  @override
  String get flowArrivedDoorstep => 'Arrived at doorstep';

  @override
  String get flowTrackingActive => 'Live tracking active';

  @override
  String get flowHandshakeVerified => 'Handshake verified';

  @override
  String get flowPendingArrival => 'Pending arrival';

  @override
  String get flowWorkCompletion => 'Work Completed & Completion OTP';

  @override
  String get flowImpsSettled => 'IMPS payout settled';

  @override
  String get flowRepairProgress => 'Repair in progress';

  @override
  String get flowPendingFinish => 'Pending finish';

  @override
  String get flowInvoiceReview => 'Customer Invoice Review';

  @override
  String get flowPaidSettled => 'Paid & Settled';

  @override
  String get flowPendingReview => 'Pending Review';

  @override
  String get flowLaborInspection => 'Labor & Diagnostic Inspection';

  @override
  String get flowPartsSurcharge => '2% Parts Gateway Surcharge';

  @override
  String get flowGst => '18% GST (Labor & Surcharge)';

  @override
  String get flowGrandTotalPayable => 'Grand Total Payable';

  @override
  String get flowCompletionCodeLabel => 'YOUR 4-DIGIT COMPLETION OTP';

  @override
  String get flowCompletionCodeHint =>
      'Share verbally with artisan only after satisfactory completion.';

  @override
  String get flowReviewRelease => 'Review Detailed Invoice & Release OTP';

  @override
  String get flowItemizedInvoice => 'Itemized Service Invoice';

  @override
  String get flowSpares => 'Spare Parts & Materials';

  @override
  String get flowGrandTotal => 'Grand Total';

  @override
  String get flowReleaseCompletion => 'RELEASE COMPLETION OTP TO ARTISAN';

  @override
  String get flowReleaseConsent =>
      'By revealing and releasing this OTP, you verify job completion and authorize escrow release.';

  @override
  String get flowCompletionSuccess =>
      'Completion Verified! Standby ₹99 mandate released, escrow settled.';

  @override
  String get accountProfileTitle => 'Homeowner Profile & Settings';

  @override
  String get accountMasterProtection =>
      '₹25,000 Master Guild Damage Protection Active';

  @override
  String get accountSavedLocalities => 'Saved Nanded Localities';

  @override
  String get accountChange => 'Change';

  @override
  String get accountPaymentPreferences => 'Escrow & Payment Preferences';

  @override
  String get accountTransitMandate =>
      '₹99 Transit Fee Mandate & RBI 2FA Parts Approval';

  @override
  String get accountPreauthorization => 'UPI Escrow Pre-Authorization';

  @override
  String get accountCompletionPayout =>
      'Release payout only after 4-digit Completion OTP';

  @override
  String get accountWhatsappAlerts => 'WhatsApp Dispatch & Gate Pass Alerts';

  @override
  String get accountTrackingInvoices =>
      'Receive live artisan tracking & digital GST invoices';

  @override
  String get accountPortalSecurity => 'Guild Portal & Security';

  @override
  String get accountSosContact => 'Emergency SOS Contact';

  @override
  String get accountControlDesk =>
      '+91 9422100100 • Nanded Control Desk (24x7)';

  @override
  String get accountSwitchGuild => 'Switch to Artisan Guild Portal';

  @override
  String get accountRadarWallet => 'Open 45s Job Radar & Instant IMPS Wallet';

  @override
  String get accountSignOut => 'Sign Out / Switch Number';

  @override
  String get accountChatTitle => 'Guild Masked Chat & WhatsApp';

  @override
  String get accountMaskedCall => 'Masked Call Bridge';

  @override
  String get accountViewArtisanProfile => 'View Artisan Profile';

  @override
  String get accountGateApproved => 'Gate Pass Approved';

  @override
  String get accountSharePin => 'Share Live Pin';

  @override
  String get accountCallOnArrival => 'Call on Arrival';

  @override
  String get accountWhatsappRelay => 'WhatsApp Relay';

  @override
  String get accountMessageHint => 'Message artisan via Guild Bridge...';

  @override
  String get accountSend => 'Send';

  @override
  String get accountBookingsTitle => 'My Service Bookings';

  @override
  String get accountActiveDispatch => 'ACTIVE DISPATCH';

  @override
  String get accountPastOrders => 'UPCOMING & PAST ORDERS';

  @override
  String get accountShield25 => '₹25,000 Guild Damage Shield Active';

  @override
  String get accountShield10 => '₹10,000 Guild Damage Shield Active';

  @override
  String get accountOnsiteLocked => 'ON-SITE ESCROW LOCKED';

  @override
  String get accountScheduledWindow => 'Scheduled Window';

  @override
  String get accountTrackLive => 'Track Live';

  @override
  String get accountDirectVisit => 'Direct Visit (Unprotected)';

  @override
  String get accountOnsiteUpgradeExplanation =>
      'Artisan present on-site. Upgrade now to activate Start OTP (4921), ₹29 Safety Shield & ₹25k Master Cover.';

  @override
  String get accountUpgradeBooking => 'Upgrade to Protected Guild Booking';

  @override
  String get accountViewArtisan => 'View Artisan';

  @override
  String get accountBookAgain => 'Book Again';

  @override
  String get accountRateService => 'Rate service';

  @override
  String get accountRaiseClaim => 'Raise warranty claim';

  @override
  String get accountServiceQuestion => 'How was the service?';

  @override
  String get accountOverall => 'Overall';

  @override
  String get accountCleanliness => 'Cleanliness';

  @override
  String get accountCareFinish => 'Care & finish';

  @override
  String get accountFeedback => 'Optional feedback';

  @override
  String get accountSubmitRating => 'Submit rating';

  @override
  String get accountClaimTitle => '30-day warranty claim';

  @override
  String get accountDeductibleReview =>
      '₹250 deductible applies. Claims are reviewed by Karigaar support.';

  @override
  String get accountDamageAmount => 'Estimated damage amount (₹)';

  @override
  String get accountDescribeIssue => 'Describe the issue';

  @override
  String get accountClaimValidation => 'Enter a valid amount and claim reason.';

  @override
  String get accountClaimSent =>
      'Claim sent for review. We’ll update you in this booking.';

  @override
  String get accountSubmitClaim => 'Submit claim';

  @override
  String get accountCraftsmanProfile => 'Craftsman Profile';

  @override
  String get accountRemovedFavorite => 'Removed from favorites.';

  @override
  String get accountPro => 'PRO';

  @override
  String get accountAvailableToday => 'Available Today';

  @override
  String get accountExperience => 'Experience';

  @override
  String get accountCompletedJobs => 'Completed Jobs';

  @override
  String get accountCallArtisan => 'Call Artisan';

  @override
  String get accountWhatsappArtisan => 'WhatsApp Artisan';

  @override
  String get accountMaskedUnlocked =>
      'Masked Virtual DID Active (+91-11-4084-2190) • Direct Contact Unlocked';

  @override
  String get accountMaskedLocked =>
      'Masked Virtual Telephony (+91-11-4084-2190) • Unlock from ₹49';

  @override
  String get accountMasterAmount => '₹25,000 Master';

  @override
  String get accountBaseAmount => '₹10,000 Base';

  @override
  String get accountOnsiteQuestion => 'Artisan On-Site? Lock Escrow & Warranty';

  @override
  String get accountMasterShortCover => '₹25k Master Cover';

  @override
  String get accountBaseShortCover => '₹10k Base Cover';

  @override
  String get accountVerifiedGuildsman => 'Karigaar Verified Guildsman';

  @override
  String get accountTripleScreened =>
      'Triple-screened for home safety & master craftsmanship';

  @override
  String get accountGovtPolice => 'Govt. ID & Police';

  @override
  String get accountBackgroundCleared => 'Background Cleared';

  @override
  String get accountNsdc => 'NSDC Certified';

  @override
  String get accountSkillGrade => 'Skill-Tested Grade A';

  @override
  String get accountDamageProtection => 'Damage Protection';

  @override
  String get accountCalibratedTools => 'Calibrated Tools';

  @override
  String get accountToolAudit => 'Tool Audit Passed';

  @override
  String get accountWiring => '3-Phase Wiring';

  @override
  String get accountInverterSetup => 'Inverter Setup';

  @override
  String get accountMcbDiagnosis => 'MCB Spark Diagnosis';

  @override
  String get accountSwitchboards => 'Modular Switchboards';

  @override
  String get accountEarthing => 'Earthing Verification';

  @override
  String get accountLoadAudit => 'Appliance Load Audit';

  @override
  String get accountSpecializations => 'Specializations & Skills';

  @override
  String get accountShowcase => 'Craftsmanship Showcase';

  @override
  String get accountVerifiedPhotos => 'Verified work photos from local homes';

  @override
  String get accountScorecard => 'Artisan Scorecard';

  @override
  String get accountPunctuality => 'Punctuality & Timing';

  @override
  String get accountCraftsmanship => 'Master Craftsmanship';

  @override
  String get accountSawdust => 'Sawdust & Cleanliness';

  @override
  String get accountRecentFeedback => 'Recent Client Feedback';

  @override
  String get accountVerifiedBookings => 'Verified Bookings';

  @override
  String get accountVerifiedMcb => 'Verified MCB Spark Repair Job';

  @override
  String get accountVerifiedInverter => 'Verified Inverter Setup Job';

  @override
  String get accountPerVisit => '/ visit';

  @override
  String get accountIncludesWarranty => 'Includes ₹25k Guild Warranty';

  @override
  String get accountUnlockTitle => 'Unlock Direct Contact';

  @override
  String get accountPrivacyProtected =>
      '100% Privacy Protected • Zero Raw Phone Leakage';

  @override
  String get accountPayPerLead => 'Pay-Per-Lead';

  @override
  String get accountOneTime => 'one-time';

  @override
  String get accountSingleArtisan => 'Single Artisan';

  @override
  String get accountDirectoryPass => 'Unlimited Directory Pass';

  @override
  String get accountPerMonth => '/ month';

  @override
  String get accountUnlimitedContact =>
      'Unlimited masked calls & WhatsApp across all 10 trades and 7 districts.';

  @override
  String get accountRecommended => 'RECOMMENDED';

  @override
  String get accountMaskedBenefit =>
      'Masked Telephony: Zero raw phone number exposure';

  @override
  String get accountMetaBenefit =>
      'Official Meta WhatsApp Cloud API bridge included';

  @override
  String get accountRetroactiveBenefit =>
      'Retroactive Guild Lock: Activate ₹25k warranty on-site anytime';

  @override
  String get accountUnlock49 => 'Unlock for ₹49';

  @override
  String get accountActivatePass => 'Activate Directory Pass (₹499/mo)';

  @override
  String get accountPassActivated =>
      'Directory Pass activated! Unlimited masked contact active across all trades.';

  @override
  String get accountMasterCover => '₹25,000 Master Cover';

  @override
  String get accountBaseCover => '₹10,000 Base Cover';

  @override
  String get accountLockVisit =>
      'Lock on-site visit into formal escrow protection';

  @override
  String get accountDoorstepCode => 'Doorstep Handshake Code';

  @override
  String get accountStartCode4921 => 'Start Handshake OTP: 4921';

  @override
  String get accountActive => 'Active';

  @override
  String get accountUnderwriting =>
      'Comprehensive property damage underwriting during job execution. ₹250 customer deductible applies to eliminate frivolous claims.';

  @override
  String get accountEscrowBreakdown => 'Upfront Escrow Breakdown';

  @override
  String get accountInspectionTravel => 'Base Inspection & Travel';

  @override
  String get accountSafetyWarranty => 'Platform Safety Shield & Warranty';

  @override
  String get accountStandbyHold => 'Total Standby Escrow Hold';

  @override
  String get accountConfirmLock => 'Confirm & Lock Escrow (₹29 Shield)';

  @override
  String get accountVerifiedPhone => '+91 9822199882 • Verified Homeowner';

  @override
  String accountPrimaryLocality(Object name, Object pincode) {
    return 'Primary: $name, Nanded ($pincode)';
  }

  @override
  String accountSavedAddress(Object name) {
    return '$name • Plot 14, Near Guru Gobind Singh Ji Marg';
  }

  @override
  String accountPrivacyConnection(Object name, Object trade) {
    return 'Number Masking Active • Zero Raw MSISDN Leakage • Connected with $name ($trade)';
  }

  @override
  String accountWhatsappGreeting(Object name) {
    return 'Namaskar $name, connecting via WhatsApp Cloud Relay.';
  }

  @override
  String accountEmptyBookings(Object tab) {
    return 'No bookings in $tab tab.';
  }

  @override
  String accountBookingReference(Object id) {
    return 'Booking #$id';
  }

  @override
  String accountVoiceNote(Object seconds) {
    return '${seconds}s Voice Note';
  }

  @override
  String accountStartOtp(Object otp) {
    return 'Start Handshake OTP: $otp';
  }

  @override
  String accountTotalEstimate(Object amount) {
    return 'Total Estimate: ₹$amount';
  }

  @override
  String accountDirectLead(Object trade) {
    return 'DIRECT ON-SITE LEAD • $trade';
  }

  @override
  String accountOnsiteName(Object name) {
    return '$name (On-Site Diagnostic)';
  }

  @override
  String accountCoverLimit(Object amount) {
    return 'Cover limit: ₹$amount';
  }

  @override
  String accountFavoriteSaved(Object name) {
    return 'Saved $name to favorites!';
  }

  @override
  String accountSharingProfile(Object name) {
    return 'Sharing $name\'s profile link...';
  }

  @override
  String accountWithinDistance(Object locality, Object distance) {
    return '$locality • Within $distance km';
  }

  @override
  String accountReviewCount(Object count) {
    return '$count Reviews';
  }

  @override
  String accountExperienceYears(Object years) {
    return '$years+ Yrs';
  }

  @override
  String accountArtisanGreeting(Object name, Object trade) {
    return 'Namaste $name Ji, I found your profile on Karigaar for $trade. Are you available for a visit in Nanded?';
  }

  @override
  String accountActivateCover(Object cover) {
    return 'Activate $cover Cover & ₹29 Safety Shield with 1 tap';
  }

  @override
  String accountCertifiedCount(Object count) {
    return '$count Certified';
  }

  @override
  String accountViewAllCount(Object count) {
    return 'View All ($count)';
  }

  @override
  String accountBookName(Object name) {
    return 'Book $name Now';
  }

  @override
  String accountConnectName(Object name, Object trade) {
    return 'Connect with $name ($trade)';
  }

  @override
  String accountProxyDescription(Object number) {
    return 'Calls & WhatsApp bridged via Virtual Proxy: $number';
  }

  @override
  String accountUnlockDays(Object name) {
    return 'Unlock direct masked calls and WhatsApp with $name for 30 days.';
  }

  @override
  String accountContactUnlocked(Object number) {
    return 'Direct contact unlocked! Calling enabled via $number.';
  }

  @override
  String accountUnlockFailed(Object error) {
    return 'Failed to unlock contact: $error';
  }

  @override
  String accountArrivalInstructions(Object name) {
    return 'Share this 4-digit code with $name on-site to verify arrival and activate the stopwatch.';
  }

  @override
  String accountCoverActive(Object cover) {
    return '$cover Active';
  }

  @override
  String accountLockedBooking(Object name) {
    return 'On-site booking locked! Share Start OTP 4921 with $name.';
  }

  @override
  String get accountClaimError =>
      'Claim could not be submitted. Check the amount, warranty eligibility, and try again.';

  @override
  String sharedSavePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get accountStatusAll => 'All';

  @override
  String get accountStatusEnRoute => 'En-Route';

  @override
  String get accountStatusUpcoming => 'Upcoming';

  @override
  String get accountStatusCompleted => 'Completed';

  @override
  String get accountStatusInProgress => 'In Progress';
}
