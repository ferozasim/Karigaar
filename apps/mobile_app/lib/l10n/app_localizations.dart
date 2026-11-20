import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageSetting;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'मराठी'**
  String get marathi;

  /// No description provided for @searchServices.
  ///
  /// In en, this message translates to:
  /// **'Search by job, material, or trade'**
  String get searchServices;

  /// No description provided for @browseServices.
  ///
  /// In en, this message translates to:
  /// **'Browse services'**
  String get browseServices;

  /// No description provided for @allTrades.
  ///
  /// In en, this message translates to:
  /// **'All services'**
  String get allTrades;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @quickServiceSearch.
  ///
  /// In en, this message translates to:
  /// **'Find a service'**
  String get quickServiceSearch;

  /// No description provided for @selectServicePrompt.
  ///
  /// In en, this message translates to:
  /// **'What do you need help with? Search a task like tiles, granite, or plumbing.'**
  String get selectServicePrompt;

  /// No description provided for @inspectionWarranty.
  ///
  /// In en, this message translates to:
  /// **'Inspection ₹{fee} • {days} day warranty'**
  String inspectionWarranty(Object fee, Object days);

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No matching service found. Try another task or trade.'**
  String get noServicesFound;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Master Guildsman Meets Modern Concierge'**
  String get brandTagline;

  /// No description provided for @loginAsHomeowner.
  ///
  /// In en, this message translates to:
  /// **'Login as Homeowner'**
  String get loginAsHomeowner;

  /// No description provided for @artisanGuildPortal.
  ///
  /// In en, this message translates to:
  /// **'Artisan Guild Portal'**
  String get artisanGuildPortal;

  /// No description provided for @homeownerTagline.
  ///
  /// In en, this message translates to:
  /// **'Book verified master Karigaars in 25 mins'**
  String get homeownerTagline;

  /// No description provided for @artisanTagline.
  ///
  /// In en, this message translates to:
  /// **'Claim nearby emergency jobs and check your wallet'**
  String get artisanTagline;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit number'**
  String get enterPhoneNumber;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get invalidPhoneNumber;

  /// No description provided for @continueWithWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Continue with WhatsApp'**
  String get continueWithWhatsApp;

  /// No description provided for @getOtpViaSms.
  ///
  /// In en, this message translates to:
  /// **'Get OTP via SMS'**
  String get getOtpViaSms;

  /// No description provided for @joinGuild.
  ///
  /// In en, this message translates to:
  /// **'New Karigaar? Join the Nanded Guild (0% Fee)'**
  String get joinGuild;

  /// No description provided for @trustFooter.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar and police verified craftspeople • Pilot city: Nanded'**
  String get trustFooter;

  /// No description provided for @homeowner.
  ///
  /// In en, this message translates to:
  /// **'Homeowner'**
  String get homeowner;

  /// No description provided for @homeownerMode.
  ///
  /// In en, this message translates to:
  /// **'Homeowner Mode'**
  String get homeownerMode;

  /// No description provided for @karigaar.
  ///
  /// In en, this message translates to:
  /// **'Karigaar'**
  String get karigaar;

  /// No description provided for @artisanMode.
  ///
  /// In en, this message translates to:
  /// **'Artisan Mode'**
  String get artisanMode;

  /// No description provided for @launchTrades.
  ///
  /// In en, this message translates to:
  /// **'10 Launch Trades'**
  String get launchTrades;

  /// No description provided for @districtGuild.
  ///
  /// In en, this message translates to:
  /// **'{district} Guild'**
  String districtGuild(Object district);

  /// No description provided for @shieldCommitment.
  ///
  /// In en, this message translates to:
  /// **'The Karigaar Shield Commitment'**
  String get shieldCommitment;

  /// No description provided for @topRatedInDistrict.
  ///
  /// In en, this message translates to:
  /// **'Top rated Karigaars in {district}'**
  String topRatedInDistrict(Object district);

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'{years} years experience'**
  String yearsExperience(Object years);

  /// No description provided for @reviewsAndDistance.
  ///
  /// In en, this message translates to:
  /// **'{reviews} reviews • {distance} km away'**
  String reviewsAndDistance(Object reviews, Object distance);

  /// No description provided for @diagnosticInspection.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Inspection'**
  String get diagnosticInspection;

  /// No description provided for @bookArtisan.
  ///
  /// In en, this message translates to:
  /// **'Book Artisan'**
  String get bookArtisan;

  /// No description provided for @servicesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load services. Try again.'**
  String get servicesLoadError;

  /// No description provided for @authOtpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get authOtpVerification;

  /// No description provided for @authVerifyWhatsAppCode.
  ///
  /// In en, this message translates to:
  /// **'Verify WhatsApp Code'**
  String get authVerifyWhatsAppCode;

  /// No description provided for @authCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to\n'**
  String get authCodeSent;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code via WhatsApp'**
  String get authResendCode;

  /// No description provided for @authFallbackSms.
  ///
  /// In en, this message translates to:
  /// **'Fallback SMS sent via DLT gateway.'**
  String get authFallbackSms;

  /// No description provided for @authSmsFallback.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive on WhatsApp? Send via SMS'**
  String get authSmsFallback;

  /// No description provided for @authVerifyContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get authVerifyContinue;

  /// No description provided for @authStepPersonal.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 4: Personal Details'**
  String get authStepPersonal;

  /// No description provided for @authStepTrade.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 4: Trade Selection'**
  String get authStepTrade;

  /// No description provided for @authStepAudit.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 4: KYC & Tools Audit'**
  String get authStepAudit;

  /// No description provided for @authStepPayout.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 4: Payout & Protection'**
  String get authStepPayout;

  /// No description provided for @authLegalNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full Aadhaar name and 10-digit mobile number.'**
  String get authLegalNameError;

  /// No description provided for @authTradeError.
  ///
  /// In en, this message translates to:
  /// **'Please select your primary trade from the 10 launch trades.'**
  String get authTradeError;

  /// No description provided for @authAadhaarError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 12-digit Aadhaar number.'**
  String get authAadhaarError;

  /// No description provided for @authJoinGuild.
  ///
  /// In en, this message translates to:
  /// **'Join the Karigaar Guild'**
  String get authJoinGuild;

  /// No description provided for @authAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already registered in the Guild? Log In here'**
  String get authAlreadyRegistered;

  /// No description provided for @authAccreditation.
  ///
  /// In en, this message translates to:
  /// **'Guild Accreditation'**
  String get authAccreditation;

  /// No description provided for @authCommissionGuarantee.
  ///
  /// In en, this message translates to:
  /// **'5% Commission Floor Guarantee'**
  String get authCommissionGuarantee;

  /// No description provided for @authJoinDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect directly with premium households in your pin code. Transparent daily payouts and guild master insurance cover.'**
  String get authJoinDescription;

  /// No description provided for @authAverageEarnings.
  ///
  /// In en, this message translates to:
  /// **'Over ₹42,000/mo Avg. Earnings'**
  String get authAverageEarnings;

  /// No description provided for @authGuildProfessionals.
  ///
  /// In en, this message translates to:
  /// **'Join 12,400+ verified professionals across Nanded Guild'**
  String get authGuildProfessionals;

  /// No description provided for @authPersonalHeading.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Personal Details & Locality'**
  String get authPersonalHeading;

  /// No description provided for @authPersonalDescription.
  ///
  /// In en, this message translates to:
  /// **'Your legal info for KYC, guild credentials and instant direct deposits'**
  String get authPersonalDescription;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Legal Name'**
  String get authFullName;

  /// No description provided for @authMatchesAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Matches Aadhaar Card'**
  String get authMatchesAadhaar;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ramesh Chandra Sharma'**
  String get authNameHint;

  /// No description provided for @authWhatsAppNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Mobile Number'**
  String get authWhatsAppNumber;

  /// No description provided for @authInstantOtp.
  ///
  /// In en, this message translates to:
  /// **'Instant OTP Dispatch'**
  String get authInstantOtp;

  /// No description provided for @authWhatsAppHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 10-digit WhatsApp number'**
  String get authWhatsAppHint;

  /// No description provided for @authEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact (Next-of-Kin)'**
  String get authEmergencyContact;

  /// No description provided for @authContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get authContactName;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit Phone'**
  String get authPhoneHint;

  /// No description provided for @authWorkingLocality.
  ///
  /// In en, this message translates to:
  /// **'Primary Working Locality'**
  String get authWorkingLocality;

  /// No description provided for @authExperience.
  ///
  /// In en, this message translates to:
  /// **'Trade Experience'**
  String get authExperience;

  /// No description provided for @authPriorityLeads.
  ///
  /// In en, this message translates to:
  /// **'Higher tier gets priority leads'**
  String get authPriorityLeads;

  /// No description provided for @authDispatchAlerts.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Dispatch Alerts'**
  String get authDispatchAlerts;

  /// No description provided for @authDispatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive emergency high-pay calls, daily settlement slips, and guild warranty alerts instantly.'**
  String get authDispatchDescription;

  /// No description provided for @authReferralQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have a Master Craftsman Referral Code?'**
  String get authReferralQuestion;

  /// No description provided for @authReferralHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. GUILD500'**
  String get authReferralHint;

  /// No description provided for @authReferralApplied.
  ///
  /// In en, this message translates to:
  /// **'Referral code GUILD500 applied! ₹500 joining bonus unlocked.'**
  String get authReferralApplied;

  /// No description provided for @authApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get authApply;

  /// No description provided for @authPrimaryTrade.
  ///
  /// In en, this message translates to:
  /// **'Select Primary Trade'**
  String get authPrimaryTrade;

  /// No description provided for @authPrimaryTradeDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap your certified craft from Nanded 10 launch trades'**
  String get authPrimaryTradeDescription;

  /// No description provided for @authOneRequired.
  ///
  /// In en, this message translates to:
  /// **'1 Required'**
  String get authOneRequired;

  /// No description provided for @authRoleType.
  ///
  /// In en, this message translates to:
  /// **'Karigaar Role Type'**
  String get authRoleType;

  /// No description provided for @authKycHeading.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Aadhaar KYC & Tools Audit'**
  String get authKycHeading;

  /// No description provided for @authKycDescription.
  ///
  /// In en, this message translates to:
  /// **'Biometric verification and calibrated equipment checklist for Guild safety rating'**
  String get authKycDescription;

  /// No description provided for @authAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'12-Digit Aadhaar Number'**
  String get authAadhaarNumber;

  /// No description provided for @authEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted & UIDAI Compliant'**
  String get authEncrypted;

  /// No description provided for @authTradeCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar / Trade Card'**
  String get authTradeCard;

  /// No description provided for @authFrontSync.
  ///
  /// In en, this message translates to:
  /// **'Front photo & DigiLocker sync'**
  String get authFrontSync;

  /// No description provided for @authDigilockerSuccess.
  ///
  /// In en, this message translates to:
  /// **'DigiLocker KYC Gateway synced successfully!'**
  String get authDigilockerSuccess;

  /// No description provided for @authFrontCaptured.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Front Scan Captured'**
  String get authFrontCaptured;

  /// No description provided for @authCaptureAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Capture Front of Aadhaar Card'**
  String get authCaptureAadhaar;

  /// No description provided for @authPhotoLimit.
  ///
  /// In en, this message translates to:
  /// **'Clear photo • Max size 10MB (JPG/PNG)'**
  String get authPhotoLimit;

  /// No description provided for @authAutoVerified.
  ///
  /// In en, this message translates to:
  /// **'72% Auto-verified'**
  String get authAutoVerified;

  /// No description provided for @authUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get authUpload;

  /// No description provided for @authToolsAudit.
  ///
  /// In en, this message translates to:
  /// **'Calibrated Tools Audit'**
  String get authToolsAudit;

  /// No description provided for @authSafetyStandard.
  ///
  /// In en, this message translates to:
  /// **'Guild Safety Standard'**
  String get authSafetyStandard;

  /// No description provided for @authMultimeter.
  ///
  /// In en, this message translates to:
  /// **'Digital True-RMS Multimeter & Phase Tester (calibrated)'**
  String get authMultimeter;

  /// No description provided for @authInsulatedTools.
  ///
  /// In en, this message translates to:
  /// **'1000V Insulated Screwdrivers & Pliers Set'**
  String get authInsulatedTools;

  /// No description provided for @authDrillTools.
  ///
  /// In en, this message translates to:
  /// **'Heavy Duty Rotary Hammer Drill & Safety Goggles'**
  String get authDrillTools;

  /// No description provided for @authCleanupTools.
  ///
  /// In en, this message translates to:
  /// **'Canvas Drop-Cloth & Sawdust Cleanup Vacuum Bag'**
  String get authCleanupTools;

  /// No description provided for @authPayoutHeading.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Bank / UPI Payout Verification'**
  String get authPayoutHeading;

  /// No description provided for @authPayoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Link your bank or UPI ID for instant 10-second IMPS payout settlements with zero guild fee'**
  String get authPayoutDescription;

  /// No description provided for @authDirectPayout.
  ///
  /// In en, this message translates to:
  /// **'Instant Guild Direct Payout'**
  String get authDirectPayout;

  /// No description provided for @authBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Number'**
  String get authBankAccount;

  /// No description provided for @authReenterBank.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter Bank Account Number'**
  String get authReenterBank;

  /// No description provided for @authIfsc.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get authIfsc;

  /// No description provided for @authBranchResolved.
  ///
  /// In en, this message translates to:
  /// **'Branch Resolved: HDFC Bank, Vazirabad Branch, Nanded (431601)'**
  String get authBranchResolved;

  /// No description provided for @authUpiPayout.
  ///
  /// In en, this message translates to:
  /// **'UPI Fast Payout VPA'**
  String get authUpiPayout;

  /// No description provided for @authPennyDrop.
  ///
  /// In en, this message translates to:
  /// **'Penny-Drop Verified'**
  String get authPennyDrop;

  /// No description provided for @authVerifiedUpi.
  ///
  /// In en, this message translates to:
  /// **'Verified UPI ID / VPA (₹0 IMPS Fee)'**
  String get authVerifiedUpi;

  /// No description provided for @authPennyDropSimulation.
  ///
  /// In en, this message translates to:
  /// **'Simulated ₹1 IMPS penny-drop test successful. Payout wallet linked.'**
  String get authPennyDropSimulation;

  /// No description provided for @authProtectionActive.
  ///
  /// In en, this message translates to:
  /// **'₹25,000 Guild Protection Shield Active'**
  String get authProtectionActive;

  /// No description provided for @authProtectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Karigaar covers accidental on-site property damage up to ₹25,000. You earn with zero liability and sustainable 5% commission floor guarantee (Guild Elite).'**
  String get authProtectionDescription;

  /// No description provided for @authBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get authBack;

  /// No description provided for @authNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get authNextStep;

  /// No description provided for @authVerifyWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Verify via WhatsApp OTP'**
  String get authVerifyWhatsApp;

  /// No description provided for @jobInvalidStart.
  ///
  /// In en, this message translates to:
  /// **'Invalid code! Ask customer for their 4-digit start code.'**
  String get jobInvalidStart;

  /// No description provided for @jobAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Doorstep Access Denied'**
  String get jobAccessDenied;

  /// No description provided for @jobCloseJob.
  ///
  /// In en, this message translates to:
  /// **'Close Job'**
  String get jobCloseJob;

  /// No description provided for @jobAddPart2fa.
  ///
  /// In en, this message translates to:
  /// **'Add Spare Part with 2FA'**
  String get jobAddPart2fa;

  /// No description provided for @jobPartName.
  ///
  /// In en, this message translates to:
  /// **'Part Name & Specification'**
  String get jobPartName;

  /// No description provided for @jobUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price (₹)'**
  String get jobUnitPrice;

  /// No description provided for @jobStoreName.
  ///
  /// In en, this message translates to:
  /// **'Hardware Store Name'**
  String get jobStoreName;

  /// No description provided for @jobAttachReceipt.
  ///
  /// In en, this message translates to:
  /// **'Attach Hardware Store Receipt Photo'**
  String get jobAttachReceipt;

  /// No description provided for @jobPartsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Pass-through spare parts include a 2% payment gateway surcharge and trigger an in-app customer RBI 2FA approval prompt.'**
  String get jobPartsDisclaimer;

  /// No description provided for @jobCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get jobCancel;

  /// No description provided for @jobAddPartBill.
  ///
  /// In en, this message translates to:
  /// **'Add Part to Bill'**
  String get jobAddPartBill;

  /// No description provided for @jobInvoiceSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Itemized Invoice Submitted! Customer notified to verify bill and release PIN.'**
  String get jobInvoiceSubmitted;

  /// No description provided for @jobActiveBill.
  ///
  /// In en, this message translates to:
  /// **'Active Job & Bill Builder'**
  String get jobActiveBill;

  /// No description provided for @jobStopwatch.
  ///
  /// In en, this message translates to:
  /// **'ON-SITE REPAIR STOPWATCH'**
  String get jobStopwatch;

  /// No description provided for @jobElapsed.
  ///
  /// In en, this message translates to:
  /// **'28m 14s Elapsed'**
  String get jobElapsed;

  /// No description provided for @jobLiveLog.
  ///
  /// In en, this message translates to:
  /// **'Live Log'**
  String get jobLiveLog;

  /// No description provided for @jobGpsStreaming.
  ///
  /// In en, this message translates to:
  /// **'LIVE GPS TELEMETRY STREAMING (CONTRACT 3)'**
  String get jobGpsStreaming;

  /// No description provided for @jobForeground.
  ///
  /// In en, this message translates to:
  /// **'Foreground (3s)'**
  String get jobForeground;

  /// No description provided for @jobBackground.
  ///
  /// In en, this message translates to:
  /// **'Background (15s)'**
  String get jobBackground;

  /// No description provided for @jobSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get jobSpeed;

  /// No description provided for @jobHeading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get jobHeading;

  /// No description provided for @jobBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get jobBattery;

  /// No description provided for @jobRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get jobRemaining;

  /// No description provided for @jobGeofence.
  ///
  /// In en, this message translates to:
  /// **'Doorstep 200m Geofence Triggered! Ready for Start Code.'**
  String get jobGeofence;

  /// No description provided for @jobEnterStart.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Enter Customer Start Code'**
  String get jobEnterStart;

  /// No description provided for @jobStartDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask homeowner for their 4-digit security code (Demo: 4921) to confirm doorstep arrival.'**
  String get jobStartDescription;

  /// No description provided for @jobStartHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit Start Code'**
  String get jobStartHint;

  /// No description provided for @jobVerifyBegin.
  ///
  /// In en, this message translates to:
  /// **'Verify Code & Begin Repair'**
  String get jobVerifyBegin;

  /// No description provided for @jobDeniedTransit.
  ///
  /// In en, this message translates to:
  /// **'Doorstep Access Denied (Claim ₹80 Transit)'**
  String get jobDeniedTransit;

  /// No description provided for @jobStartComplete.
  ///
  /// In en, this message translates to:
  /// **'Start Code 4921 Verified • Doorstep Handshake Complete'**
  String get jobStartComplete;

  /// No description provided for @jobBillBuilder.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Bill Builder'**
  String get jobBillBuilder;

  /// No description provided for @jobCustomPart.
  ///
  /// In en, this message translates to:
  /// **'Custom Part'**
  String get jobCustomPart;

  /// No description provided for @jobAddPart.
  ///
  /// In en, this message translates to:
  /// **'Add Part'**
  String get jobAddPart;

  /// No description provided for @jobLaborDiagnostic.
  ///
  /// In en, this message translates to:
  /// **'Labor & Diagnostic Inspection'**
  String get jobLaborDiagnostic;

  /// No description provided for @jobReceiptAttached.
  ///
  /// In en, this message translates to:
  /// **'Receipt Photo Attached'**
  String get jobReceiptAttached;

  /// No description provided for @jobLaborBase.
  ///
  /// In en, this message translates to:
  /// **'Labor & Inspection Base'**
  String get jobLaborBase;

  /// No description provided for @jobPartsSurcharge.
  ///
  /// In en, this message translates to:
  /// **'2% Parts Gateway Surcharge'**
  String get jobPartsSurcharge;

  /// No description provided for @jobGst.
  ///
  /// In en, this message translates to:
  /// **'18% GST (Labor & Surcharge)'**
  String get jobGst;

  /// No description provided for @jobTotalInvoiced.
  ///
  /// In en, this message translates to:
  /// **'Total Invoiced to Customer'**
  String get jobTotalInvoiced;

  /// No description provided for @jobWaitingPin.
  ///
  /// In en, this message translates to:
  /// **'Itemized Invoice Submitted • Waiting Customer PIN'**
  String get jobWaitingPin;

  /// No description provided for @jobSubmitInvoice.
  ///
  /// In en, this message translates to:
  /// **'Submit Itemized Invoice (Decoupled)'**
  String get jobSubmitInvoice;

  /// No description provided for @jobCompletionHeading.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Collect Completion PIN'**
  String get jobCompletionHeading;

  /// No description provided for @jobCompletionDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask customer for their 4-digit verbal completion PIN (Demo: 7294)'**
  String get jobCompletionDescription;

  /// No description provided for @jobCompletionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit Completion PIN'**
  String get jobCompletionHint;

  /// No description provided for @jobPayoutSettled.
  ///
  /// In en, this message translates to:
  /// **'IMPS Payout Settled!'**
  String get jobPayoutSettled;

  /// No description provided for @jobBackRadar.
  ///
  /// In en, this message translates to:
  /// **'Back to Radar'**
  String get jobBackRadar;

  /// No description provided for @jobInvalidCompletion.
  ///
  /// In en, this message translates to:
  /// **'Invalid completion PIN! Enter 7294 for demo.'**
  String get jobInvalidCompletion;

  /// No description provided for @jobElitePartner.
  ///
  /// In en, this message translates to:
  /// **'Guild Elite Partner'**
  String get jobElitePartner;

  /// No description provided for @jobGoldGuildsman.
  ///
  /// In en, this message translates to:
  /// **'Gold Guildsman'**
  String get jobGoldGuildsman;

  /// No description provided for @jobFloorActive.
  ///
  /// In en, this message translates to:
  /// **'5% Commission Floor Active'**
  String get jobFloorActive;

  /// No description provided for @jobTier4.
  ///
  /// In en, this message translates to:
  /// **'Tier Level 4 Craftsman'**
  String get jobTier4;

  /// No description provided for @jobTakeRate.
  ///
  /// In en, this message translates to:
  /// **'💎 5% Take-Rate'**
  String get jobTakeRate;

  /// No description provided for @jobTopPartner.
  ///
  /// In en, this message translates to:
  /// **'Top 5% Partner'**
  String get jobTopPartner;

  /// No description provided for @jobApprentice.
  ///
  /// In en, this message translates to:
  /// **'Apprentice\n(15%)'**
  String get jobApprentice;

  /// No description provided for @jobPro.
  ///
  /// In en, this message translates to:
  /// **'Pro\n(12%)'**
  String get jobPro;

  /// No description provided for @jobMaster.
  ///
  /// In en, this message translates to:
  /// **'Master\n(8%)'**
  String get jobMaster;

  /// No description provided for @jobElite.
  ///
  /// In en, this message translates to:
  /// **'Elite\n(5% Floor)'**
  String get jobElite;

  /// No description provided for @jobEliteMilestone.
  ///
  /// In en, this message translates to:
  /// **'Guild Elite Milestone: Unlocked'**
  String get jobEliteMilestone;

  /// No description provided for @jobMasterMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone: Master Guildsman (8%)'**
  String get jobMasterMilestone;

  /// No description provided for @jobJobsProgress.
  ///
  /// In en, this message translates to:
  /// **'42 / 50 Jobs'**
  String get jobJobsProgress;

  /// No description provided for @jobEliteDescription.
  ///
  /// In en, this message translates to:
  /// **'Guild Elite active! You keep 95% of job billings with a 5% commission floor.'**
  String get jobEliteDescription;

  /// No description provided for @jobMasterDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete 8 more jobs for 8% Master tier, or subscribe to Guild Elite for the 5% commission floor!'**
  String get jobMasterDescription;

  /// No description provided for @jobKarigaarElite.
  ///
  /// In en, this message translates to:
  /// **'Karigaar Guild Elite Partner'**
  String get jobKarigaarElite;

  /// No description provided for @jobKeep95.
  ///
  /// In en, this message translates to:
  /// **'5% Commission Floor (Keep 95%)'**
  String get jobKeep95;

  /// No description provided for @jobMonthlyDeduction.
  ///
  /// In en, this message translates to:
  /// **'₹999 / month • Instant 1-tap wallet deduction'**
  String get jobMonthlyDeduction;

  /// No description provided for @jobEliteBenefitFees.
  ///
  /// In en, this message translates to:
  /// **'• 5% Commission Floor (Save up to ₹4,500/mo in platform fees)\n'**
  String get jobEliteBenefitFees;

  /// No description provided for @jobEliteBenefitRadar.
  ///
  /// In en, this message translates to:
  /// **'• Priority 10s Radar Dispatch blast before standard partners\n'**
  String get jobEliteBenefitRadar;

  /// No description provided for @jobEliteBenefitImps.
  ///
  /// In en, this message translates to:
  /// **'• ₹0 Instant IMPS Payout Fee (platform covers gateway charges)\n'**
  String get jobEliteBenefitImps;

  /// No description provided for @jobEliteBenefitBadge.
  ///
  /// In en, this message translates to:
  /// **'• Golden Guild Elite badge displayed to customers'**
  String get jobEliteBenefitBadge;

  /// No description provided for @jobUpgradeElite.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Guild Elite (₹999/mo)'**
  String get jobUpgradeElite;

  /// No description provided for @jobEliteLocked.
  ///
  /// In en, this message translates to:
  /// **'💎 Guild Elite Active • 5% Commission Floor Locked • Next billing in 30 days'**
  String get jobEliteLocked;

  /// No description provided for @jobSubscribeElite.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Guild Elite'**
  String get jobSubscribeElite;

  /// No description provided for @jobLockFloor.
  ///
  /// In en, this message translates to:
  /// **'Lock in sustainable 5% commission floor'**
  String get jobLockFloor;

  /// No description provided for @jobSubscriptionFee.
  ///
  /// In en, this message translates to:
  /// **'Monthly Subscription Fee'**
  String get jobSubscriptionFee;

  /// No description provided for @jobWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Wallet Balance'**
  String get jobWalletBalance;

  /// No description provided for @jobPostDeduction.
  ///
  /// In en, this message translates to:
  /// **'Post-Deduction Balance'**
  String get jobPostDeduction;

  /// No description provided for @jobSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to Guild Elite! 5% commission floor active.'**
  String get jobSubscribed;

  /// No description provided for @jobConfirmDeduct.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Deduct ₹999 from Wallet'**
  String get jobConfirmDeduct;

  /// No description provided for @jobGuildWallet.
  ///
  /// In en, this message translates to:
  /// **'Guild Wallet'**
  String get jobGuildWallet;

  /// No description provided for @jobImpsLive.
  ///
  /// In en, this message translates to:
  /// **'Instant IMPS Live'**
  String get jobImpsLive;

  /// No description provided for @jobClearedPayout.
  ///
  /// In en, this message translates to:
  /// **'CLEARED AVAILABLE PAYOUT'**
  String get jobClearedPayout;

  /// No description provided for @jobLockedReserve.
  ///
  /// In en, this message translates to:
  /// **'LOCKED RESERVE'**
  String get jobLockedReserve;

  /// No description provided for @jobAvailablePayout.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE PAYOUT'**
  String get jobAvailablePayout;

  /// No description provided for @jobWithdrawBank.
  ///
  /// In en, this message translates to:
  /// **'Withdraw to Bank via UPI / IMPS (₹0 Fee)'**
  String get jobWithdrawBank;

  /// No description provided for @jobSupport.
  ///
  /// In en, this message translates to:
  /// **'Karigaar Partner Support'**
  String get jobSupport;

  /// No description provided for @jobWeeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Send Weekly Earnings Summary to WhatsApp'**
  String get jobWeeklySummary;

  /// No description provided for @jobVerifiedVault.
  ///
  /// In en, this message translates to:
  /// **'Verified Guild Vault'**
  String get jobVerifiedVault;

  /// No description provided for @jobNoBalance.
  ///
  /// In en, this message translates to:
  /// **'No cleared balance available for withdrawal.'**
  String get jobNoBalance;

  /// No description provided for @jobReserveRequired.
  ///
  /// In en, this message translates to:
  /// **'Cannot withdraw. A mandatory ₹2,000 security reserve must be maintained.'**
  String get jobReserveRequired;

  /// No description provided for @jobInstantPayout.
  ///
  /// In en, this message translates to:
  /// **'Instant IMPS Payout'**
  String get jobInstantPayout;

  /// No description provided for @jobReserveLocked.
  ///
  /// In en, this message translates to:
  /// **'Mandatory ₹2,000 rolling security reserve locked in Guild Vault.'**
  String get jobReserveLocked;

  /// No description provided for @jobBankNanded.
  ///
  /// In en, this message translates to:
  /// **'Bank: HDFC Bank Limited (Nanded Main Branch)'**
  String get jobBankNanded;

  /// No description provided for @jobMaskedAccount.
  ///
  /// In en, this message translates to:
  /// **'Account: •••• •••• 2104'**
  String get jobMaskedAccount;

  /// No description provided for @jobPayoutFee.
  ///
  /// In en, this message translates to:
  /// **'Payout Fee: ₹0.00 (Guild Covered)'**
  String get jobPayoutFee;

  /// No description provided for @jobConfirmPayout.
  ///
  /// In en, this message translates to:
  /// **'Confirm IMPS Payout'**
  String get jobConfirmPayout;

  /// No description provided for @jobRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get jobRecentActivity;

  /// No description provided for @jobViewLedger.
  ///
  /// In en, this message translates to:
  /// **'View Ledger'**
  String get jobViewLedger;

  /// No description provided for @jobWiringRepair.
  ///
  /// In en, this message translates to:
  /// **'MCB & Wiring Repair'**
  String get jobWiringRepair;

  /// No description provided for @jobActivityToday.
  ///
  /// In en, this message translates to:
  /// **'Anand Nagar, Nanded • Today, 11:20 AM'**
  String get jobActivityToday;

  /// No description provided for @jobDailyPayout.
  ///
  /// In en, this message translates to:
  /// **'Daily Payout to HDFC'**
  String get jobDailyPayout;

  /// No description provided for @jobActivityYesterday.
  ///
  /// In en, this message translates to:
  /// **'Ref #IMPS99824 • Yesterday'**
  String get jobActivityYesterday;

  /// No description provided for @jobGuildGuarantee.
  ///
  /// In en, this message translates to:
  /// **'Guild guarantee: Guaranteed immediate IMPS payout processing 24/7 with zero service deduction.'**
  String get jobGuildGuarantee;

  /// No description provided for @jobProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile & rate card updated and synced to district directory!'**
  String get jobProfileUpdated;

  /// No description provided for @jobBioHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your craft expertise & safety gear...'**
  String get jobBioHint;

  /// No description provided for @jobWorkPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 6-Way Distribution Box Setup'**
  String get jobWorkPhotoHint;

  /// No description provided for @jobNandedGuild.
  ///
  /// In en, this message translates to:
  /// **'Nanded Trade Guild'**
  String get jobNandedGuild;

  /// No description provided for @jobJobsRating.
  ///
  /// In en, this message translates to:
  /// **'4.9★ (340 jobs)'**
  String get jobJobsRating;

  /// No description provided for @jobEmergency.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY BREAKDOWN'**
  String get jobEmergency;

  /// No description provided for @jobOnePhoto.
  ///
  /// In en, this message translates to:
  /// **'1 Photo'**
  String get jobOnePhoto;

  /// No description provided for @jobBroadcastTimeout.
  ///
  /// In en, this message translates to:
  /// **'Broadcast timed out without acceptance. Search expanded to regional guild.'**
  String get jobBroadcastTimeout;

  /// No description provided for @jobScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning Nanded for incoming requests...'**
  String get jobScanning;

  /// No description provided for @jobDutyPaused.
  ///
  /// In en, this message translates to:
  /// **'Duty paused. Go online to receive jobs.'**
  String get jobDutyPaused;

  /// No description provided for @jobKeepActive.
  ///
  /// In en, this message translates to:
  /// **'Keep app active to receive 45s priority broadcasts'**
  String get jobKeepActive;

  /// No description provided for @jobVoiceExample.
  ///
  /// In en, this message translates to:
  /// **'Customer Voice Note: \"MCB switch sparking when turning on AC. Need 32A replacement.\"'**
  String get jobVoiceExample;

  /// No description provided for @jobPausePreview.
  ///
  /// In en, this message translates to:
  /// **'Pause Preview'**
  String get jobPausePreview;

  /// No description provided for @jobListenMemo.
  ///
  /// In en, this message translates to:
  /// **'Listen to Customer Audio Memo'**
  String get jobListenMemo;

  /// No description provided for @localitySelect.
  ///
  /// In en, this message translates to:
  /// **'Select Locality'**
  String get localitySelect;

  /// No description provided for @localityPilotDistrict.
  ///
  /// In en, this message translates to:
  /// **'Pilot City: Nanded-Waghala (Maharashtra)'**
  String get localityPilotDistrict;

  /// No description provided for @localityDistrict.
  ///
  /// In en, this message translates to:
  /// **'District: {district}'**
  String localityDistrict(String district);

  /// No description provided for @localitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search locality or PIN code'**
  String get localitySearchHint;

  /// No description provided for @localityEmptyText.
  ///
  /// In en, this message translates to:
  /// **'No locality found in {city}'**
  String localityEmptyText(String city);

  /// No description provided for @localityChanged.
  ///
  /// In en, this message translates to:
  /// **'Switched service hub to {name} ({pincode})'**
  String localityChanged(String name, String pincode);

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'URGENT BREAKDOWN? (25 MINS)'**
  String get emergencyTitle;

  /// No description provided for @emergencyDispatch.
  ///
  /// In en, this message translates to:
  /// **'Immediate Doorstep Dispatch'**
  String get emergencyDispatch;

  /// No description provided for @emergencyCoverage.
  ///
  /// In en, this message translates to:
  /// **'Electricians & Plumbers on stand-by across Nanded'**
  String get emergencyCoverage;

  /// No description provided for @emergencyBookFast.
  ///
  /// In en, this message translates to:
  /// **'Book Fast'**
  String get emergencyBookFast;

  /// No description provided for @skeletonTradesHeading.
  ///
  /// In en, this message translates to:
  /// **'CERTIFIED GUILD TRADES'**
  String get skeletonTradesHeading;

  /// No description provided for @catalogTradeName.
  ///
  /// In en, this message translates to:
  /// **'{id, select, trade_electrician {Electrician} trade_plumber {Plumber} trade_carpenter {Carpenter} trade_mason {Mason / Civil Worker} trade_painter {Painter} trade_ac_refrig {AC & Refrigeration} trade_appliance {Appliance Repair} trade_welder {Welder / Fabricator} trade_pest {Pest Control} trade_deep_cleaning {Deep Cleaning} other {{fallback}}}'**
  String catalogTradeName(String id, String fallback);

  /// No description provided for @catalogTradeTagline.
  ///
  /// In en, this message translates to:
  /// **'{id, select, trade_electrician {Short circuit, MCB, switchboard & heavy appliance wiring} trade_plumber {Pipe leaks, tap replacement, drainage blockages & sanitary fittings} trade_carpenter {Door locks, modular kitchen hinges, veneer repairs & furniture assembly} trade_mason {Tile replacement, wall plastering, concrete drilling & waterproofing} trade_painter {Wall touch-ups, dampness treatment, door polish & full home painting} trade_ac_refrig {Foam jet service, gas refill, compressor diagnosis & cooling issues} trade_appliance {Washing machine, microwave, geyser, mixer grinder & RO purifier} trade_welder {Main gate hinge welding, window safety grill, railing & shed repair} trade_pest {Cockroach gel treatment, termite drill barrier, bed bug eradication} trade_deep_cleaning {Full bathroom descaling, kitchen oil degreasing & sofa shampooing} other {{fallback}}}'**
  String catalogTradeTagline(String id, String fallback);

  /// No description provided for @catalogPackageName.
  ///
  /// In en, this message translates to:
  /// **'{id, select, pkg_elec_mcb {Short Circuit & MCB Tripping} pkg_elec_switchboard {Switchboard & Socket Repair} pkg_elec_fan {Ceiling Fan / Chandelier Fitting} pkg_elec_inverter {Inverter & Battery Wiring} pkg_plumb_leak {Water Pipe Joint Leakage Fix} pkg_plumb_drain {Kitchen Sink & Bathroom Drain Unclog} pkg_plumb_tap {Tap / Mixer / Diverter Replacement} pkg_plumb_tank {Overhead Tank Float Valve & Motor Line} pkg_carp_lock {Main Door Deadbolt / Godrej Lock Repair} pkg_carp_hinge {Hydraulic Cabinet & Wardrobe Hinge Replacement} pkg_carp_door_trim {Door Dragging & Frame Planing} pkg_carp_furniture {Bed / Table Assembly & Structural Tightening} pkg_mason_tile {Broken Floor / Wall Tile Patching (Up to 4 tiles)} pkg_mason_plaster {Wall Crack & Plaster Repair} pkg_mason_waterproof {Bathroom / Balcony Corner Waterproofing} pkg_paint_patch {Single Wall Patch & Touch-up (Putty + Paint)} pkg_paint_damp {Anti-Dampness Chemical Barrier + Topcoat} pkg_paint_wood {Door & Window Enamel / Melamine Polishing} pkg_ac_deep_clean {Split AC Foam Jet Deep Service} pkg_ac_gas_leak {AC Gas Leakage Check & Top-up} pkg_fridge_cooling {Refrigerator Low Cooling / Defrost Fix} pkg_app_geyser {Instant / Storage Geyser Heating Element Fix} pkg_app_washing {Washing Machine Spin / Drain Drum Issue} pkg_app_ro {RO Water Purifier Membrane & Filter Overhaul} pkg_weld_gate {Main Sliding / Swing Gate Heavy Hinge Arc Welding} pkg_weld_grill {Balcony & Window Safety Grill Reinforcement} pkg_weld_sheet {Tin Shed & Polycarbonate Roof Bracket Fix} pkg_pest_cockroach {Kitchen & Bathroom Herbal Gel Treatment} pkg_pest_termite {Wood Termite Drill & Inject Chemical Shield} pkg_pest_bedbug {2-Stage Bed Bug Thermal & Spray Eradication} pkg_clean_bath {Intense Bathroom Hard Water Stain & Tile Descaling} pkg_clean_kitchen {Modular Kitchen Chimney & Slab Degreasing} pkg_clean_sofa {Fabric Sofa 5-Seater Shampoo & Wet Extraction} other {{fallback}}}'**
  String catalogPackageName(String id, String fallback);

  /// No description provided for @catalogPackageDescription.
  ///
  /// In en, this message translates to:
  /// **'{id, select, pkg_elec_mcb {Continuous tripping, spark diagnosis, neutral fault identification & fuse repair} pkg_elec_switchboard {Loose modular switches, burnt contact points, 16A power socket installation} pkg_elec_fan {Anchor rod hanging, speed regulator rewiring, vibration reduction} pkg_elec_inverter {Backup bypass line, heavy load terminal setup, battery water check} pkg_plumb_leak {CPVC/PVC pipe joint soldering, concealed wall seepage diagnosis} pkg_plumb_drain {High pressure mechanical auger drain clearing, trap cleaning} pkg_plumb_tap {Ceramic spindle change, quarter-turn angle valve fitting, teflon sealing} pkg_plumb_tank {Ball cock auto cut-off valve replacement, airlock clearance} pkg_carp_lock {Cylinder replacement, jammed latch alignment, brass strike plate fitting} pkg_carp_hinge {Soft-close hinge tension adjustment, plywood screw anchor grip repair} pkg_carp_door_trim {Precision bottom trimming, monsoon swollen wood clearance} pkg_carp_furniture {Hardware re-bolting, wooden bracket reinforcement, termite inspection} pkg_mason_tile {Adhesive bedding, laser levelling, anti-fungal epoxy grouting} pkg_mason_plaster {Polymer-modified cement slurry, v-groove chasing, smooth trowel finish} pkg_mason_waterproof {Dr. Fixit 2-coat chemical membrane application on skirtings} pkg_paint_patch {Sanding, acrylic wall putty, 2-coat primer and shade matching} pkg_paint_damp {Efflorescence salt removal, silicone damp-lock treatment} pkg_paint_wood {Fine sandpaper smoothing, high-gloss PU coating} pkg_ac_deep_clean {Indoor coil antibacterial foam pressure wash, outdoor unit blower rinse, filter disinfection} pkg_ac_gas_leak {Nitrogen pressure leak testing, flare nut brazing, R32/R410A vacuum charging} pkg_fridge_cooling {Thermostat calibration, bi-metal sensor replacement, capillary flush} pkg_app_geyser {Copper heating coil descaling, safety thermostat auto cut-off calibration} pkg_app_washing {Motor belt tightening, drain pump lint filter unclog, PCB relay check} pkg_app_ro {TDS level calibration, sediment + carbon filter change, booster pump check} pkg_weld_gate {Heavy duty mild steel ball-bearing pivot welding, slag chipping, rust-primer coat} pkg_weld_grill {Loose anchor pin tack welding, angle iron strengthening} pkg_weld_sheet {Wind-damaged purlin joint welding, self-tapping screw gasket replacement} pkg_pest_cockroach {Odorless Fipronil bait dot application in hinges, under-sink crevices (safe for kids & pets)} pkg_pest_termite {Precision 6mm skirt drilling, pressurized Imidacloprid injection, wood-colored seal} pkg_pest_bedbug {Mattress seam steam purge, residual pyrethroid spraying, 15-day free repeat visit} pkg_clean_bath {Single-disc scrubber rotary tile wash, tap chrome buffing, glass divider spot removal} pkg_clean_kitchen {Caustic-free baffle filter ultrasonic cleaning, stainless steel polish, tile grout whitening} pkg_clean_sofa {Deep foam agitation, industrial vacuum suction moisture extraction, citrus deodorizer} other {{fallback}}}'**
  String catalogPackageDescription(String id, String fallback);

  /// No description provided for @catalogBundleTitle.
  ///
  /// In en, this message translates to:
  /// **'{id, select, bundle_monsoon_elec {Monsoon Electrical Shield} bundle_plumb_health {Full Home Plumbing Health Check} bundle_ac_summer {Pre-Summer AC Super Cool} bundle_carpenter_care {Modular Kitchen & Door Alignment} other {{fallback}}}'**
  String catalogBundleTitle(String id, String fallback);

  /// No description provided for @catalogBundleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{id, select, bundle_monsoon_elec {Prevent short circuits, MCB trips & moisture leakage shocks} bundle_plumb_health {Concealed pipe seepage scan, overhead tank valve test & trap unclogging} bundle_ac_summer {Antibacterial foam jet deep wash, cooling test & gas pressure audit} bundle_carpenter_care {Hydraulic soft-close hinge tightening & swollen door planing} other {{fallback}}}'**
  String catalogBundleSubtitle(String id, String fallback);

  /// No description provided for @catalogBundleTask.
  ///
  /// In en, this message translates to:
  /// **'{id, select, bundle_monsoon_elec_0 {MCB trip diagnosis & fuse load calibration} bundle_monsoon_elec_1 {Switchboard moisture & earthing leakage check} bundle_monsoon_elec_2 {Ceiling fan & backup wiring tightening} bundle_plumb_health_0 {Concealed pipe joint acoustic seepage audit} bundle_plumb_health_1 {Kitchen sink & bathroom mechanical drain auger cleaning} bundle_plumb_health_2 {Quarter-turn angle valves & ceramic spindle tune-up} bundle_ac_summer_0 {Indoor cooling coil high-pressure foam jet wash} bundle_ac_summer_1 {Outdoor unit condenser rinse & compressor vibration damping} bundle_ac_summer_2 {R32/R410A gas pressure measurement & filter disinfection} bundle_carpenter_care_0 {Hydraulic cabinet & wardrobe soft-close tension adjustment} bundle_carpenter_care_1 {Swollen door frame planing & bottom clearance trimming} bundle_carpenter_care_2 {Main door deadbolt & Godrej lock cylinder servicing} other {{fallback}}}'**
  String catalogBundleTask(String id, String fallback);

  /// No description provided for @catalogRoleName.
  ///
  /// In en, this message translates to:
  /// **'{id, select, headMistry {Head Mistry / Ustad} skilledKarigaar {Skilled Karigaar} helperAssistant {Helper / Bigari} thekedar {Thekedar / Team Contractor} other {{fallback}}}'**
  String catalogRoleName(String id, String fallback);

  /// No description provided for @catalogRoleBadge.
  ///
  /// In en, this message translates to:
  /// **'{id, select, headMistry {👑 Head Mistry} skilledKarigaar {🔧 Skilled Karigaar} helperAssistant {🤝 Helper} thekedar {👷 Thekedar} other {{fallback}}}'**
  String catalogRoleBadge(String id, String fallback);

  /// No description provided for @flowVerifiedGuild.
  ///
  /// In en, this message translates to:
  /// **'Verified Master Guild'**
  String get flowVerifiedGuild;

  /// No description provided for @flowNandedRating.
  ///
  /// In en, this message translates to:
  /// **'4.9 (1.4k jobs in Nanded)'**
  String get flowNandedRating;

  /// No description provided for @flowInspectionWarranty.
  ///
  /// In en, this message translates to:
  /// **'Includes 45-min diagnostic inspection & 30-day rework warranty'**
  String get flowInspectionWarranty;

  /// No description provided for @flowSelectIssues.
  ///
  /// In en, this message translates to:
  /// **'Select Issues to Resolve'**
  String get flowSelectIssues;

  /// No description provided for @flowSelectIssuesHint.
  ///
  /// In en, this message translates to:
  /// **'Choose all relevant problems for accurate tooling'**
  String get flowSelectIssuesHint;

  /// No description provided for @flowBundleApplied.
  ///
  /// In en, this message translates to:
  /// **'Curated Bundle Applied'**
  String get flowBundleApplied;

  /// No description provided for @flowPhotoVoice.
  ///
  /// In en, this message translates to:
  /// **'Photo & 15-Second Voice Note'**
  String get flowPhotoVoice;

  /// No description provided for @flowSparesHint.
  ///
  /// In en, this message translates to:
  /// **'Help your craftsman bring the exact spares from the hardware store'**
  String get flowSparesHint;

  /// No description provided for @flowPhotoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed attached photo.'**
  String get flowPhotoRemoved;

  /// No description provided for @flowPhotoAttached.
  ///
  /// In en, this message translates to:
  /// **'Defect Photo Attached'**
  String get flowPhotoAttached;

  /// No description provided for @flowAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Issue Photo (Optional)'**
  String get flowAddPhoto;

  /// No description provided for @flowShieldFee.
  ///
  /// In en, this message translates to:
  /// **'+₹29 Shield Fee'**
  String get flowShieldFee;

  /// No description provided for @flowAdjustableBill.
  ///
  /// In en, this message translates to:
  /// **'Adjustable on-site bill'**
  String get flowAdjustableBill;

  /// No description provided for @flowRequestArtisan.
  ///
  /// In en, this message translates to:
  /// **'Request Artisan'**
  String get flowRequestArtisan;

  /// No description provided for @flowSkillTier.
  ///
  /// In en, this message translates to:
  /// **'Craftsperson Skill Tier'**
  String get flowSkillTier;

  /// No description provided for @flowMasterRate.
  ///
  /// In en, this message translates to:
  /// **'1.25x (+25% Master Tier)'**
  String get flowMasterRate;

  /// No description provided for @flowStandardRate.
  ///
  /// In en, this message translates to:
  /// **'1.0x (Standard Rate)'**
  String get flowStandardRate;

  /// No description provided for @flowHelperRate.
  ///
  /// In en, this message translates to:
  /// **'0.65x (-35% Helper Tier)'**
  String get flowHelperRate;

  /// No description provided for @flowContractorRate.
  ///
  /// In en, this message translates to:
  /// **'1.35x (+35% Team Contractor)'**
  String get flowContractorRate;

  /// No description provided for @flowMandateTitle.
  ///
  /// In en, this message translates to:
  /// **'Upfront ₹99 Standby Mandate'**
  String get flowMandateTitle;

  /// No description provided for @flowMandateProvider.
  ///
  /// In en, this message translates to:
  /// **'Razorpay / Cashfree UPI Autopay Protected'**
  String get flowMandateProvider;

  /// No description provided for @flowMandateWhy.
  ///
  /// In en, this message translates to:
  /// **'Why is a ₹99 pre-authorization required?'**
  String get flowMandateWhy;

  /// No description provided for @flowMandateExplanation.
  ///
  /// In en, this message translates to:
  /// **'Secures ₹99 standby transit fee hold to protect artisan fuel and travel. The hold is RELEASED upon job completion and debited ONLY if doorstep access is denied for >15 minutes.'**
  String get flowMandateExplanation;

  /// No description provided for @flowSelectUpi.
  ///
  /// In en, this message translates to:
  /// **'Quick Select UPI App'**
  String get flowSelectUpi;

  /// No description provided for @flowUpiId.
  ///
  /// In en, this message translates to:
  /// **'Enter UPI ID / VPA'**
  String get flowUpiId;

  /// No description provided for @flowUpiHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. mobile@okaxis'**
  String get flowUpiHint;

  /// No description provided for @flowUpiInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid UPI VPA (e.g. name@bank)'**
  String get flowUpiInvalid;

  /// No description provided for @flowAuthorizeMandate.
  ///
  /// In en, this message translates to:
  /// **'Authorize ₹99 Mandate & Request Artisan'**
  String get flowAuthorizeMandate;

  /// No description provided for @flowAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'15s Audio Memo Scoping'**
  String get flowAudioTitle;

  /// No description provided for @flowRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress (Max 15s)...'**
  String get flowRecording;

  /// No description provided for @flowAudioLanguages.
  ///
  /// In en, this message translates to:
  /// **'Explain defect in Hindi, Marathi, or English'**
  String get flowAudioLanguages;

  /// No description provided for @flowAudioHint.
  ///
  /// In en, this message translates to:
  /// **'Record up to 15 seconds of motor hum, water leak sound, or sparking sound for the master artisan.'**
  String get flowAudioHint;

  /// No description provided for @flowRecordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record 15s Audio Memo'**
  String get flowRecordAudio;

  /// No description provided for @flowPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get flowPause;

  /// No description provided for @flowPlayPreview.
  ///
  /// In en, this message translates to:
  /// **'Play Preview'**
  String get flowPlayPreview;

  /// No description provided for @flowRerecord.
  ///
  /// In en, this message translates to:
  /// **'Re-record'**
  String get flowRerecord;

  /// No description provided for @flowDeleteAudio.
  ///
  /// In en, this message translates to:
  /// **'Delete Audio Memo'**
  String get flowDeleteAudio;

  /// No description provided for @flowArrivalDateSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Date & Slot'**
  String get flowArrivalDateSlot;

  /// No description provided for @flowToday.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get flowToday;

  /// No description provided for @flowEmergency.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get flowEmergency;

  /// No description provided for @flowLiveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get flowLiveTracking;

  /// No description provided for @flowNoBooking.
  ///
  /// In en, this message translates to:
  /// **'No active booking found'**
  String get flowNoBooking;

  /// No description provided for @flowDispatchRadar.
  ///
  /// In en, this message translates to:
  /// **'Live Dispatch Radar'**
  String get flowDispatchRadar;

  /// No description provided for @flowYourHome.
  ///
  /// In en, this message translates to:
  /// **'Your Home'**
  String get flowYourHome;

  /// No description provided for @flowArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get flowArrived;

  /// No description provided for @flowArrivedZero.
  ///
  /// In en, this message translates to:
  /// **'Arrived at Doorstep (0 km)'**
  String get flowArrivedZero;

  /// No description provided for @flowStationary.
  ///
  /// In en, this message translates to:
  /// **'Stationary • At Destination'**
  String get flowStationary;

  /// No description provided for @flowArrivalHint.
  ///
  /// In en, this message translates to:
  /// **'Artisan has arrived in your vicinity. Provide code once at your door.'**
  String get flowArrivalHint;

  /// No description provided for @flowDwellExplanation.
  ///
  /// In en, this message translates to:
  /// **'Artisan is waiting outside. Standby ₹99 transit fee applies if doorstep entry is unreachable or denied for >15 mins.'**
  String get flowDwellExplanation;

  /// No description provided for @flowStartCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'DOORSTEP SECURITY START CODE'**
  String get flowStartCodeLabel;

  /// No description provided for @flowStartCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Share this 4-digit code verbally ONLY when your Karigaar arrives at your doorstep.'**
  String get flowStartCodeHint;

  /// No description provided for @flowMaskedWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Masked WhatsApp Channel'**
  String get flowMaskedWhatsapp;

  /// No description provided for @flowMaskedCall.
  ///
  /// In en, this message translates to:
  /// **'Masked Telephony Bridge'**
  String get flowMaskedCall;

  /// No description provided for @flowDirections.
  ///
  /// In en, this message translates to:
  /// **'Quick Doorstep Directions'**
  String get flowDirections;

  /// No description provided for @flowMilestones.
  ///
  /// In en, this message translates to:
  /// **'Booking Milestones'**
  String get flowMilestones;

  /// No description provided for @flowBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed & Escrow Held'**
  String get flowBookingConfirmed;

  /// No description provided for @flowArtisanDispatched.
  ///
  /// In en, this message translates to:
  /// **'Artisan Dispatched from Anand Nagar'**
  String get flowArtisanDispatched;

  /// No description provided for @flowArrivedWithin.
  ///
  /// In en, this message translates to:
  /// **'Arrived at Doorstep (Within 200m)'**
  String get flowArrivedWithin;

  /// No description provided for @flowArrivedDoorstep.
  ///
  /// In en, this message translates to:
  /// **'Arrived at doorstep'**
  String get flowArrivedDoorstep;

  /// No description provided for @flowTrackingActive.
  ///
  /// In en, this message translates to:
  /// **'Live tracking active'**
  String get flowTrackingActive;

  /// No description provided for @flowHandshakeVerified.
  ///
  /// In en, this message translates to:
  /// **'Handshake verified'**
  String get flowHandshakeVerified;

  /// No description provided for @flowPendingArrival.
  ///
  /// In en, this message translates to:
  /// **'Pending arrival'**
  String get flowPendingArrival;

  /// No description provided for @flowWorkCompletion.
  ///
  /// In en, this message translates to:
  /// **'Work Completed & Completion OTP'**
  String get flowWorkCompletion;

  /// No description provided for @flowImpsSettled.
  ///
  /// In en, this message translates to:
  /// **'IMPS payout settled'**
  String get flowImpsSettled;

  /// No description provided for @flowRepairProgress.
  ///
  /// In en, this message translates to:
  /// **'Repair in progress'**
  String get flowRepairProgress;

  /// No description provided for @flowPendingFinish.
  ///
  /// In en, this message translates to:
  /// **'Pending finish'**
  String get flowPendingFinish;

  /// No description provided for @flowInvoiceReview.
  ///
  /// In en, this message translates to:
  /// **'Customer Invoice Review'**
  String get flowInvoiceReview;

  /// No description provided for @flowPaidSettled.
  ///
  /// In en, this message translates to:
  /// **'Paid & Settled'**
  String get flowPaidSettled;

  /// No description provided for @flowPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get flowPendingReview;

  /// No description provided for @flowLaborInspection.
  ///
  /// In en, this message translates to:
  /// **'Labor & Diagnostic Inspection'**
  String get flowLaborInspection;

  /// No description provided for @flowPartsSurcharge.
  ///
  /// In en, this message translates to:
  /// **'2% Parts Gateway Surcharge'**
  String get flowPartsSurcharge;

  /// No description provided for @flowGst.
  ///
  /// In en, this message translates to:
  /// **'18% GST (Labor & Surcharge)'**
  String get flowGst;

  /// No description provided for @flowGrandTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Grand Total Payable'**
  String get flowGrandTotalPayable;

  /// No description provided for @flowCompletionCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR 4-DIGIT COMPLETION OTP'**
  String get flowCompletionCodeLabel;

  /// No description provided for @flowCompletionCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Share verbally with artisan only after satisfactory completion.'**
  String get flowCompletionCodeHint;

  /// No description provided for @flowReviewRelease.
  ///
  /// In en, this message translates to:
  /// **'Review Detailed Invoice & Release OTP'**
  String get flowReviewRelease;

  /// No description provided for @flowItemizedInvoice.
  ///
  /// In en, this message translates to:
  /// **'Itemized Service Invoice'**
  String get flowItemizedInvoice;

  /// No description provided for @flowSpares.
  ///
  /// In en, this message translates to:
  /// **'Spare Parts & Materials'**
  String get flowSpares;

  /// No description provided for @flowGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get flowGrandTotal;

  /// No description provided for @flowReleaseCompletion.
  ///
  /// In en, this message translates to:
  /// **'RELEASE COMPLETION OTP TO ARTISAN'**
  String get flowReleaseCompletion;

  /// No description provided for @flowReleaseConsent.
  ///
  /// In en, this message translates to:
  /// **'By revealing and releasing this OTP, you verify job completion and authorize escrow release.'**
  String get flowReleaseConsent;

  /// No description provided for @flowCompletionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Completion Verified! Standby ₹99 mandate released, escrow settled.'**
  String get flowCompletionSuccess;

  /// No description provided for @accountProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Homeowner Profile & Settings'**
  String get accountProfileTitle;

  /// No description provided for @accountMasterProtection.
  ///
  /// In en, this message translates to:
  /// **'₹25,000 Master Guild Damage Protection Active'**
  String get accountMasterProtection;

  /// No description provided for @accountSavedLocalities.
  ///
  /// In en, this message translates to:
  /// **'Saved Nanded Localities'**
  String get accountSavedLocalities;

  /// No description provided for @accountChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get accountChange;

  /// No description provided for @accountPaymentPreferences.
  ///
  /// In en, this message translates to:
  /// **'Escrow & Payment Preferences'**
  String get accountPaymentPreferences;

  /// No description provided for @accountTransitMandate.
  ///
  /// In en, this message translates to:
  /// **'₹99 Transit Fee Mandate & RBI 2FA Parts Approval'**
  String get accountTransitMandate;

  /// No description provided for @accountPreauthorization.
  ///
  /// In en, this message translates to:
  /// **'UPI Escrow Pre-Authorization'**
  String get accountPreauthorization;

  /// No description provided for @accountCompletionPayout.
  ///
  /// In en, this message translates to:
  /// **'Release payout only after 4-digit Completion OTP'**
  String get accountCompletionPayout;

  /// No description provided for @accountWhatsappAlerts.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Dispatch & Gate Pass Alerts'**
  String get accountWhatsappAlerts;

  /// No description provided for @accountTrackingInvoices.
  ///
  /// In en, this message translates to:
  /// **'Receive live artisan tracking & digital GST invoices'**
  String get accountTrackingInvoices;

  /// No description provided for @accountPortalSecurity.
  ///
  /// In en, this message translates to:
  /// **'Guild Portal & Security'**
  String get accountPortalSecurity;

  /// No description provided for @accountSosContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS Contact'**
  String get accountSosContact;

  /// No description provided for @accountControlDesk.
  ///
  /// In en, this message translates to:
  /// **'+91 9422100100 • Nanded Control Desk (24x7)'**
  String get accountControlDesk;

  /// No description provided for @accountSwitchGuild.
  ///
  /// In en, this message translates to:
  /// **'Switch to Artisan Guild Portal'**
  String get accountSwitchGuild;

  /// No description provided for @accountRadarWallet.
  ///
  /// In en, this message translates to:
  /// **'Open 45s Job Radar & Instant IMPS Wallet'**
  String get accountRadarWallet;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out / Switch Number'**
  String get accountSignOut;

  /// No description provided for @accountChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Guild Masked Chat & WhatsApp'**
  String get accountChatTitle;

  /// No description provided for @accountMaskedCall.
  ///
  /// In en, this message translates to:
  /// **'Masked Call Bridge'**
  String get accountMaskedCall;

  /// No description provided for @accountViewArtisanProfile.
  ///
  /// In en, this message translates to:
  /// **'View Artisan Profile'**
  String get accountViewArtisanProfile;

  /// No description provided for @accountGateApproved.
  ///
  /// In en, this message translates to:
  /// **'Gate Pass Approved'**
  String get accountGateApproved;

  /// No description provided for @accountSharePin.
  ///
  /// In en, this message translates to:
  /// **'Share Live Pin'**
  String get accountSharePin;

  /// No description provided for @accountCallOnArrival.
  ///
  /// In en, this message translates to:
  /// **'Call on Arrival'**
  String get accountCallOnArrival;

  /// No description provided for @accountWhatsappRelay.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Relay'**
  String get accountWhatsappRelay;

  /// No description provided for @accountMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message artisan via Guild Bridge...'**
  String get accountMessageHint;

  /// No description provided for @accountSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get accountSend;

  /// No description provided for @accountBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Service Bookings'**
  String get accountBookingsTitle;

  /// No description provided for @accountActiveDispatch.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE DISPATCH'**
  String get accountActiveDispatch;

  /// No description provided for @accountPastOrders.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING & PAST ORDERS'**
  String get accountPastOrders;

  /// No description provided for @accountShield25.
  ///
  /// In en, this message translates to:
  /// **'₹25,000 Guild Damage Shield Active'**
  String get accountShield25;

  /// No description provided for @accountShield10.
  ///
  /// In en, this message translates to:
  /// **'₹10,000 Guild Damage Shield Active'**
  String get accountShield10;

  /// No description provided for @accountOnsiteLocked.
  ///
  /// In en, this message translates to:
  /// **'ON-SITE ESCROW LOCKED'**
  String get accountOnsiteLocked;

  /// No description provided for @accountScheduledWindow.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Window'**
  String get accountScheduledWindow;

  /// No description provided for @accountTrackLive.
  ///
  /// In en, this message translates to:
  /// **'Track Live'**
  String get accountTrackLive;

  /// No description provided for @accountDirectVisit.
  ///
  /// In en, this message translates to:
  /// **'Direct Visit (Unprotected)'**
  String get accountDirectVisit;

  /// No description provided for @accountOnsiteUpgradeExplanation.
  ///
  /// In en, this message translates to:
  /// **'Artisan present on-site. Upgrade now to activate Start OTP (4921), ₹29 Safety Shield & ₹25k Master Cover.'**
  String get accountOnsiteUpgradeExplanation;

  /// No description provided for @accountUpgradeBooking.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Protected Guild Booking'**
  String get accountUpgradeBooking;

  /// No description provided for @accountViewArtisan.
  ///
  /// In en, this message translates to:
  /// **'View Artisan'**
  String get accountViewArtisan;

  /// No description provided for @accountBookAgain.
  ///
  /// In en, this message translates to:
  /// **'Book Again'**
  String get accountBookAgain;

  /// No description provided for @accountRateService.
  ///
  /// In en, this message translates to:
  /// **'Rate service'**
  String get accountRateService;

  /// No description provided for @accountRaiseClaim.
  ///
  /// In en, this message translates to:
  /// **'Raise warranty claim'**
  String get accountRaiseClaim;

  /// No description provided for @accountServiceQuestion.
  ///
  /// In en, this message translates to:
  /// **'How was the service?'**
  String get accountServiceQuestion;

  /// No description provided for @accountOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get accountOverall;

  /// No description provided for @accountCleanliness.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get accountCleanliness;

  /// No description provided for @accountCareFinish.
  ///
  /// In en, this message translates to:
  /// **'Care & finish'**
  String get accountCareFinish;

  /// No description provided for @accountFeedback.
  ///
  /// In en, this message translates to:
  /// **'Optional feedback'**
  String get accountFeedback;

  /// No description provided for @accountSubmitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get accountSubmitRating;

  /// No description provided for @accountClaimTitle.
  ///
  /// In en, this message translates to:
  /// **'30-day warranty claim'**
  String get accountClaimTitle;

  /// No description provided for @accountDeductibleReview.
  ///
  /// In en, this message translates to:
  /// **'₹250 deductible applies. Claims are reviewed by Karigaar support.'**
  String get accountDeductibleReview;

  /// No description provided for @accountDamageAmount.
  ///
  /// In en, this message translates to:
  /// **'Estimated damage amount (₹)'**
  String get accountDamageAmount;

  /// No description provided for @accountDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get accountDescribeIssue;

  /// No description provided for @accountClaimValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount and claim reason.'**
  String get accountClaimValidation;

  /// No description provided for @accountClaimSent.
  ///
  /// In en, this message translates to:
  /// **'Claim sent for review. We’ll update you in this booking.'**
  String get accountClaimSent;

  /// No description provided for @accountSubmitClaim.
  ///
  /// In en, this message translates to:
  /// **'Submit claim'**
  String get accountSubmitClaim;

  /// No description provided for @accountCraftsmanProfile.
  ///
  /// In en, this message translates to:
  /// **'Craftsman Profile'**
  String get accountCraftsmanProfile;

  /// No description provided for @accountRemovedFavorite.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites.'**
  String get accountRemovedFavorite;

  /// No description provided for @accountPro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get accountPro;

  /// No description provided for @accountAvailableToday.
  ///
  /// In en, this message translates to:
  /// **'Available Today'**
  String get accountAvailableToday;

  /// No description provided for @accountExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get accountExperience;

  /// No description provided for @accountCompletedJobs.
  ///
  /// In en, this message translates to:
  /// **'Completed Jobs'**
  String get accountCompletedJobs;

  /// No description provided for @accountCallArtisan.
  ///
  /// In en, this message translates to:
  /// **'Call Artisan'**
  String get accountCallArtisan;

  /// No description provided for @accountWhatsappArtisan.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Artisan'**
  String get accountWhatsappArtisan;

  /// No description provided for @accountMaskedUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Masked Virtual DID Active (+91-11-4084-2190) • Direct Contact Unlocked'**
  String get accountMaskedUnlocked;

  /// No description provided for @accountMaskedLocked.
  ///
  /// In en, this message translates to:
  /// **'Masked Virtual Telephony (+91-11-4084-2190) • Unlock from ₹49'**
  String get accountMaskedLocked;

  /// No description provided for @accountMasterAmount.
  ///
  /// In en, this message translates to:
  /// **'₹25,000 Master'**
  String get accountMasterAmount;

  /// No description provided for @accountBaseAmount.
  ///
  /// In en, this message translates to:
  /// **'₹10,000 Base'**
  String get accountBaseAmount;

  /// No description provided for @accountOnsiteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Artisan On-Site? Lock Escrow & Warranty'**
  String get accountOnsiteQuestion;

  /// No description provided for @accountMasterShortCover.
  ///
  /// In en, this message translates to:
  /// **'₹25k Master Cover'**
  String get accountMasterShortCover;

  /// No description provided for @accountBaseShortCover.
  ///
  /// In en, this message translates to:
  /// **'₹10k Base Cover'**
  String get accountBaseShortCover;

  /// No description provided for @accountVerifiedGuildsman.
  ///
  /// In en, this message translates to:
  /// **'Karigaar Verified Guildsman'**
  String get accountVerifiedGuildsman;

  /// No description provided for @accountTripleScreened.
  ///
  /// In en, this message translates to:
  /// **'Triple-screened for home safety & master craftsmanship'**
  String get accountTripleScreened;

  /// No description provided for @accountGovtPolice.
  ///
  /// In en, this message translates to:
  /// **'Govt. ID & Police'**
  String get accountGovtPolice;

  /// No description provided for @accountBackgroundCleared.
  ///
  /// In en, this message translates to:
  /// **'Background Cleared'**
  String get accountBackgroundCleared;

  /// No description provided for @accountNsdc.
  ///
  /// In en, this message translates to:
  /// **'NSDC Certified'**
  String get accountNsdc;

  /// No description provided for @accountSkillGrade.
  ///
  /// In en, this message translates to:
  /// **'Skill-Tested Grade A'**
  String get accountSkillGrade;

  /// No description provided for @accountDamageProtection.
  ///
  /// In en, this message translates to:
  /// **'Damage Protection'**
  String get accountDamageProtection;

  /// No description provided for @accountCalibratedTools.
  ///
  /// In en, this message translates to:
  /// **'Calibrated Tools'**
  String get accountCalibratedTools;

  /// No description provided for @accountToolAudit.
  ///
  /// In en, this message translates to:
  /// **'Tool Audit Passed'**
  String get accountToolAudit;

  /// No description provided for @accountWiring.
  ///
  /// In en, this message translates to:
  /// **'3-Phase Wiring'**
  String get accountWiring;

  /// No description provided for @accountInverterSetup.
  ///
  /// In en, this message translates to:
  /// **'Inverter Setup'**
  String get accountInverterSetup;

  /// No description provided for @accountMcbDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'MCB Spark Diagnosis'**
  String get accountMcbDiagnosis;

  /// No description provided for @accountSwitchboards.
  ///
  /// In en, this message translates to:
  /// **'Modular Switchboards'**
  String get accountSwitchboards;

  /// No description provided for @accountEarthing.
  ///
  /// In en, this message translates to:
  /// **'Earthing Verification'**
  String get accountEarthing;

  /// No description provided for @accountLoadAudit.
  ///
  /// In en, this message translates to:
  /// **'Appliance Load Audit'**
  String get accountLoadAudit;

  /// No description provided for @accountSpecializations.
  ///
  /// In en, this message translates to:
  /// **'Specializations & Skills'**
  String get accountSpecializations;

  /// No description provided for @accountShowcase.
  ///
  /// In en, this message translates to:
  /// **'Craftsmanship Showcase'**
  String get accountShowcase;

  /// No description provided for @accountVerifiedPhotos.
  ///
  /// In en, this message translates to:
  /// **'Verified work photos from local homes'**
  String get accountVerifiedPhotos;

  /// No description provided for @accountScorecard.
  ///
  /// In en, this message translates to:
  /// **'Artisan Scorecard'**
  String get accountScorecard;

  /// No description provided for @accountPunctuality.
  ///
  /// In en, this message translates to:
  /// **'Punctuality & Timing'**
  String get accountPunctuality;

  /// No description provided for @accountCraftsmanship.
  ///
  /// In en, this message translates to:
  /// **'Master Craftsmanship'**
  String get accountCraftsmanship;

  /// No description provided for @accountSawdust.
  ///
  /// In en, this message translates to:
  /// **'Sawdust & Cleanliness'**
  String get accountSawdust;

  /// No description provided for @accountRecentFeedback.
  ///
  /// In en, this message translates to:
  /// **'Recent Client Feedback'**
  String get accountRecentFeedback;

  /// No description provided for @accountVerifiedBookings.
  ///
  /// In en, this message translates to:
  /// **'Verified Bookings'**
  String get accountVerifiedBookings;

  /// No description provided for @accountVerifiedMcb.
  ///
  /// In en, this message translates to:
  /// **'Verified MCB Spark Repair Job'**
  String get accountVerifiedMcb;

  /// No description provided for @accountVerifiedInverter.
  ///
  /// In en, this message translates to:
  /// **'Verified Inverter Setup Job'**
  String get accountVerifiedInverter;

  /// No description provided for @accountPerVisit.
  ///
  /// In en, this message translates to:
  /// **'/ visit'**
  String get accountPerVisit;

  /// No description provided for @accountIncludesWarranty.
  ///
  /// In en, this message translates to:
  /// **'Includes ₹25k Guild Warranty'**
  String get accountIncludesWarranty;

  /// No description provided for @accountUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Direct Contact'**
  String get accountUnlockTitle;

  /// No description provided for @accountPrivacyProtected.
  ///
  /// In en, this message translates to:
  /// **'100% Privacy Protected • Zero Raw Phone Leakage'**
  String get accountPrivacyProtected;

  /// No description provided for @accountPayPerLead.
  ///
  /// In en, this message translates to:
  /// **'Pay-Per-Lead'**
  String get accountPayPerLead;

  /// No description provided for @accountOneTime.
  ///
  /// In en, this message translates to:
  /// **'one-time'**
  String get accountOneTime;

  /// No description provided for @accountSingleArtisan.
  ///
  /// In en, this message translates to:
  /// **'Single Artisan'**
  String get accountSingleArtisan;

  /// No description provided for @accountDirectoryPass.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Directory Pass'**
  String get accountDirectoryPass;

  /// No description provided for @accountPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get accountPerMonth;

  /// No description provided for @accountUnlimitedContact.
  ///
  /// In en, this message translates to:
  /// **'Unlimited masked calls & WhatsApp across all 10 trades and 7 districts.'**
  String get accountUnlimitedContact;

  /// No description provided for @accountRecommended.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get accountRecommended;

  /// No description provided for @accountMaskedBenefit.
  ///
  /// In en, this message translates to:
  /// **'Masked Telephony: Zero raw phone number exposure'**
  String get accountMaskedBenefit;

  /// No description provided for @accountMetaBenefit.
  ///
  /// In en, this message translates to:
  /// **'Official Meta WhatsApp Cloud API bridge included'**
  String get accountMetaBenefit;

  /// No description provided for @accountRetroactiveBenefit.
  ///
  /// In en, this message translates to:
  /// **'Retroactive Guild Lock: Activate ₹25k warranty on-site anytime'**
  String get accountRetroactiveBenefit;

  /// No description provided for @accountUnlock49.
  ///
  /// In en, this message translates to:
  /// **'Unlock for ₹49'**
  String get accountUnlock49;

  /// No description provided for @accountActivatePass.
  ///
  /// In en, this message translates to:
  /// **'Activate Directory Pass (₹499/mo)'**
  String get accountActivatePass;

  /// No description provided for @accountPassActivated.
  ///
  /// In en, this message translates to:
  /// **'Directory Pass activated! Unlimited masked contact active across all trades.'**
  String get accountPassActivated;

  /// No description provided for @accountMasterCover.
  ///
  /// In en, this message translates to:
  /// **'₹25,000 Master Cover'**
  String get accountMasterCover;

  /// No description provided for @accountBaseCover.
  ///
  /// In en, this message translates to:
  /// **'₹10,000 Base Cover'**
  String get accountBaseCover;

  /// No description provided for @accountLockVisit.
  ///
  /// In en, this message translates to:
  /// **'Lock on-site visit into formal escrow protection'**
  String get accountLockVisit;

  /// No description provided for @accountDoorstepCode.
  ///
  /// In en, this message translates to:
  /// **'Doorstep Handshake Code'**
  String get accountDoorstepCode;

  /// No description provided for @accountStartCode4921.
  ///
  /// In en, this message translates to:
  /// **'Start Handshake OTP: 4921'**
  String get accountStartCode4921;

  /// No description provided for @accountActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get accountActive;

  /// No description provided for @accountUnderwriting.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive property damage underwriting during job execution. ₹250 customer deductible applies to eliminate frivolous claims.'**
  String get accountUnderwriting;

  /// No description provided for @accountEscrowBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Upfront Escrow Breakdown'**
  String get accountEscrowBreakdown;

  /// No description provided for @accountInspectionTravel.
  ///
  /// In en, this message translates to:
  /// **'Base Inspection & Travel'**
  String get accountInspectionTravel;

  /// No description provided for @accountSafetyWarranty.
  ///
  /// In en, this message translates to:
  /// **'Platform Safety Shield & Warranty'**
  String get accountSafetyWarranty;

  /// No description provided for @accountStandbyHold.
  ///
  /// In en, this message translates to:
  /// **'Total Standby Escrow Hold'**
  String get accountStandbyHold;

  /// No description provided for @accountConfirmLock.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Lock Escrow (₹29 Shield)'**
  String get accountConfirmLock;

  /// No description provided for @accountVerifiedPhone.
  ///
  /// In en, this message translates to:
  /// **'+91 9822199882 • Verified Homeowner'**
  String get accountVerifiedPhone;

  /// No description provided for @accountPrimaryLocality.
  ///
  /// In en, this message translates to:
  /// **'Primary: {name}, Nanded ({pincode})'**
  String accountPrimaryLocality(Object name, Object pincode);

  /// No description provided for @accountSavedAddress.
  ///
  /// In en, this message translates to:
  /// **'{name} • Plot 14, Near Guru Gobind Singh Ji Marg'**
  String accountSavedAddress(Object name);

  /// No description provided for @accountPrivacyConnection.
  ///
  /// In en, this message translates to:
  /// **'Number Masking Active • Zero Raw MSISDN Leakage • Connected with {name} ({trade})'**
  String accountPrivacyConnection(Object name, Object trade);

  /// No description provided for @accountWhatsappGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaskar {name}, connecting via WhatsApp Cloud Relay.'**
  String accountWhatsappGreeting(Object name);

  /// No description provided for @accountEmptyBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings in {tab} tab.'**
  String accountEmptyBookings(Object tab);

  /// No description provided for @accountBookingReference.
  ///
  /// In en, this message translates to:
  /// **'Booking #{id}'**
  String accountBookingReference(Object id);

  /// No description provided for @accountVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s Voice Note'**
  String accountVoiceNote(Object seconds);

  /// No description provided for @accountStartOtp.
  ///
  /// In en, this message translates to:
  /// **'Start Handshake OTP: {otp}'**
  String accountStartOtp(Object otp);

  /// No description provided for @accountTotalEstimate.
  ///
  /// In en, this message translates to:
  /// **'Total Estimate: ₹{amount}'**
  String accountTotalEstimate(Object amount);

  /// No description provided for @accountDirectLead.
  ///
  /// In en, this message translates to:
  /// **'DIRECT ON-SITE LEAD • {trade}'**
  String accountDirectLead(Object trade);

  /// No description provided for @accountOnsiteName.
  ///
  /// In en, this message translates to:
  /// **'{name} (On-Site Diagnostic)'**
  String accountOnsiteName(Object name);

  /// No description provided for @accountCoverLimit.
  ///
  /// In en, this message translates to:
  /// **'Cover limit: ₹{amount}'**
  String accountCoverLimit(Object amount);

  /// No description provided for @accountFavoriteSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {name} to favorites!'**
  String accountFavoriteSaved(Object name);

  /// No description provided for @accountSharingProfile.
  ///
  /// In en, this message translates to:
  /// **'Sharing {name}\'s profile link...'**
  String accountSharingProfile(Object name);

  /// No description provided for @accountWithinDistance.
  ///
  /// In en, this message translates to:
  /// **'{locality} • Within {distance} km'**
  String accountWithinDistance(Object locality, Object distance);

  /// No description provided for @accountReviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Reviews'**
  String accountReviewCount(Object count);

  /// No description provided for @accountExperienceYears.
  ///
  /// In en, this message translates to:
  /// **'{years}+ Yrs'**
  String accountExperienceYears(Object years);

  /// No description provided for @accountArtisanGreeting.
  ///
  /// In en, this message translates to:
  /// **'Namaste {name} Ji, I found your profile on Karigaar for {trade}. Are you available for a visit in Nanded?'**
  String accountArtisanGreeting(Object name, Object trade);

  /// No description provided for @accountActivateCover.
  ///
  /// In en, this message translates to:
  /// **'Activate {cover} Cover & ₹29 Safety Shield with 1 tap'**
  String accountActivateCover(Object cover);

  /// No description provided for @accountCertifiedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Certified'**
  String accountCertifiedCount(Object count);

  /// No description provided for @accountViewAllCount.
  ///
  /// In en, this message translates to:
  /// **'View All ({count})'**
  String accountViewAllCount(Object count);

  /// No description provided for @accountBookName.
  ///
  /// In en, this message translates to:
  /// **'Book {name} Now'**
  String accountBookName(Object name);

  /// No description provided for @accountConnectName.
  ///
  /// In en, this message translates to:
  /// **'Connect with {name} ({trade})'**
  String accountConnectName(Object name, Object trade);

  /// No description provided for @accountProxyDescription.
  ///
  /// In en, this message translates to:
  /// **'Calls & WhatsApp bridged via Virtual Proxy: {number}'**
  String accountProxyDescription(Object number);

  /// No description provided for @accountUnlockDays.
  ///
  /// In en, this message translates to:
  /// **'Unlock direct masked calls and WhatsApp with {name} for 30 days.'**
  String accountUnlockDays(Object name);

  /// No description provided for @accountContactUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Direct contact unlocked! Calling enabled via {number}.'**
  String accountContactUnlocked(Object number);

  /// No description provided for @accountUnlockFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to unlock contact: {error}'**
  String accountUnlockFailed(Object error);

  /// No description provided for @accountArrivalInstructions.
  ///
  /// In en, this message translates to:
  /// **'Share this 4-digit code with {name} on-site to verify arrival and activate the stopwatch.'**
  String accountArrivalInstructions(Object name);

  /// No description provided for @accountCoverActive.
  ///
  /// In en, this message translates to:
  /// **'{cover} Active'**
  String accountCoverActive(Object cover);

  /// No description provided for @accountLockedBooking.
  ///
  /// In en, this message translates to:
  /// **'On-site booking locked! Share Start OTP 4921 with {name}.'**
  String accountLockedBooking(Object name);

  /// No description provided for @accountClaimError.
  ///
  /// In en, this message translates to:
  /// **'Claim could not be submitted. Check the amount, warranty eligibility, and try again.'**
  String get accountClaimError;

  /// No description provided for @sharedSavePercent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String sharedSavePercent(int percent);

  /// No description provided for @accountStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get accountStatusAll;

  /// No description provided for @accountStatusEnRoute.
  ///
  /// In en, this message translates to:
  /// **'En-Route'**
  String get accountStatusEnRoute;

  /// No description provided for @accountStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get accountStatusUpcoming;

  /// No description provided for @accountStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get accountStatusCompleted;

  /// No description provided for @accountStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get accountStatusInProgress;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
