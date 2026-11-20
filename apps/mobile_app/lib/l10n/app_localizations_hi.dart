// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languageName => 'हिन्दी';

  @override
  String get languageSetting => 'ऐप की भाषा';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get searchServices => 'काम, सामग्री या कारीगर खोजें';

  @override
  String get browseServices => 'सेवाएँ देखें';

  @override
  String get allTrades => 'सभी सेवाएँ';

  @override
  String get explore => 'खोजें';

  @override
  String get bookings => 'बुकिंग';

  @override
  String get messages => 'संदेश';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get quickServiceSearch => 'सेवा खोजें';

  @override
  String get selectServicePrompt =>
      'आपको किस काम में मदद चाहिए? टाइल, ग्रेनाइट या प्लंबिंग खोजें।';

  @override
  String inspectionWarranty(Object fee, Object days) {
    return 'जांच ₹$fee • $days दिन की वारंटी';
  }

  @override
  String get noServicesFound =>
      'कोई सेवा नहीं मिली। दूसरा काम या कारीगर खोजें।';

  @override
  String get brandTagline => 'उस्ताद कारीगर, आधुनिक सेवा';

  @override
  String get loginAsHomeowner => 'घर के मालिक के रूप में लॉग इन करें';

  @override
  String get artisanGuildPortal => 'कारीगर गिल्ड पोर्टल';

  @override
  String get homeownerTagline => '25 मिनट में सत्यापित कारीगर बुक करें';

  @override
  String get artisanTagline => 'पास के काम लें और अपना वॉलेट देखें';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get enterPhoneNumber => '10 अंकों का नंबर दर्ज करें';

  @override
  String get invalidPhoneNumber =>
      'कृपया सही 10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get continueWithWhatsApp => 'WhatsApp से आगे बढ़ें';

  @override
  String get getOtpViaSms => 'SMS से OTP प्राप्त करें';

  @override
  String get joinGuild => 'नए कारीगर? नांदेड़ गिल्ड से जुड़ें (0% शुल्क)';

  @override
  String get trustFooter =>
      'आधार और पुलिस सत्यापित कारीगर • पायलट शहर: नांदेड़';

  @override
  String get homeowner => 'घर के मालिक';

  @override
  String get homeownerMode => 'घर के मालिक का मोड';

  @override
  String get karigaar => 'कारीगर';

  @override
  String get artisanMode => 'कारीगर मोड';

  @override
  String get launchTrades => '10 प्रमुख सेवाएँ';

  @override
  String districtGuild(Object district) {
    return '$district गिल्ड';
  }

  @override
  String get shieldCommitment => 'कारीगर सुरक्षा का वादा';

  @override
  String topRatedInDistrict(Object district) {
    return '$district के शीर्ष कारीगर';
  }

  @override
  String yearsExperience(Object years) {
    return '$years साल का अनुभव';
  }

  @override
  String reviewsAndDistance(Object reviews, Object distance) {
    return '$reviews समीक्षाएँ • $distance किमी दूर';
  }

  @override
  String get diagnosticInspection => 'जाँच शुल्क';

  @override
  String get bookArtisan => 'कारीगर बुक करें';

  @override
  String get servicesLoadError => 'सेवाएँ लोड नहीं हुईं। फिर कोशिश करें।';

  @override
  String get authOtpVerification => 'OTP सत्यापन';

  @override
  String get authVerifyWhatsAppCode => 'WhatsApp कोड सत्यापित करें';

  @override
  String get authCodeSent => 'हमने 6 अंकों का सत्यापन कोड भेजा है\n';

  @override
  String get authResendCode => 'WhatsApp से कोड फिर भेजें';

  @override
  String get authFallbackSms => 'DLT गेटवे से SMS भेजा गया।';

  @override
  String get authSmsFallback => 'WhatsApp पर नहीं मिला? SMS से भेजें';

  @override
  String get authVerifyContinue => 'सत्यापित करें और आगे बढ़ें';

  @override
  String get authStepPersonal => 'चरण 1/4: व्यक्तिगत विवरण';

  @override
  String get authStepTrade => 'चरण 2/4: काम चुनें';

  @override
  String get authStepAudit => 'चरण 3/4: KYC और औज़ार जाँच';

  @override
  String get authStepPayout => 'चरण 4/4: भुगतान और सुरक्षा';

  @override
  String get authLegalNameError =>
      'कृपया आधार वाला पूरा नाम और 10 अंकों का मोबाइल नंबर दर्ज करें।';

  @override
  String get authTradeError => 'कृपया 10 सेवाओं में से अपना मुख्य काम चुनें।';

  @override
  String get authAadhaarError => 'कृपया सही 12 अंकों का आधार नंबर दर्ज करें।';

  @override
  String get authJoinGuild => 'कारीगर गिल्ड से जुड़ें';

  @override
  String get authAlreadyRegistered =>
      'गिल्ड में पहले से पंजीकृत हैं? यहाँ लॉग इन करें';

  @override
  String get authAccreditation => 'गिल्ड मान्यता';

  @override
  String get authCommissionGuarantee => 'न्यूनतम 5% कमीशन की गारंटी';

  @override
  String get authJoinDescription =>
      'अपने पिन कोड के ग्राहकों से सीधे जुड़ें। पारदर्शी दैनिक भुगतान और गिल्ड मास्टर बीमा सुरक्षा।';

  @override
  String get authAverageEarnings => 'औसत कमाई ₹42,000/माह से अधिक';

  @override
  String get authGuildProfessionals =>
      'नांदेड़ गिल्ड के 12,400+ सत्यापित पेशेवरों से जुड़ें';

  @override
  String get authPersonalHeading => 'चरण 1: व्यक्तिगत विवरण और इलाका';

  @override
  String get authPersonalDescription =>
      'KYC, गिल्ड पहचान और सीधे भुगतान के लिए आपकी कानूनी जानकारी';

  @override
  String get authFullName => 'पूरा कानूनी नाम';

  @override
  String get authMatchesAadhaar => 'आधार कार्ड के अनुसार';

  @override
  String get authNameHint => 'जैसे रमेश चंद्र शर्मा';

  @override
  String get authWhatsAppNumber => 'WhatsApp मोबाइल नंबर';

  @override
  String get authInstantOtp => 'तुरंत OTP भेजें';

  @override
  String get authWhatsAppHint => '10 अंकों का WhatsApp नंबर दर्ज करें';

  @override
  String get authEmergencyContact => 'आपातकालीन संपर्क (परिजन)';

  @override
  String get authContactName => 'संपर्क का नाम';

  @override
  String get authPhoneHint => '10 अंकों का फ़ोन नंबर';

  @override
  String get authWorkingLocality => 'मुख्य कार्य क्षेत्र';

  @override
  String get authExperience => 'काम का अनुभव';

  @override
  String get authPriorityLeads => 'ऊँचे स्तर को प्राथमिकता से काम मिलता है';

  @override
  String get authDispatchAlerts => 'WhatsApp काम के अलर्ट';

  @override
  String get authDispatchDescription =>
      'आपातकालीन काम, दैनिक भुगतान पर्चियाँ और गिल्ड वारंटी अलर्ट तुरंत पाएँ।';

  @override
  String get authReferralQuestion =>
      'क्या आपके पास मास्टर कारीगर का रेफ़रल कोड है?';

  @override
  String get authReferralHint => 'जैसे GUILD500';

  @override
  String get authReferralApplied =>
      'रेफ़रल कोड GUILD500 लागू हुआ! ₹500 जॉइनिंग बोनस मिला।';

  @override
  String get authApply => 'लागू करें';

  @override
  String get authPrimaryTrade => 'मुख्य काम चुनें';

  @override
  String get authPrimaryTradeDescription =>
      'नांदेड़ की 10 सेवाओं में अपना प्रमाणित काम चुनें';

  @override
  String get authOneRequired => '1 आवश्यक';

  @override
  String get authRoleType => 'कारीगर की भूमिका';

  @override
  String get authKycHeading => 'चरण 3: आधार KYC और औज़ार जाँच';

  @override
  String get authKycDescription =>
      'गिल्ड सुरक्षा रेटिंग के लिए बायोमेट्रिक सत्यापन और औज़ारों की जाँच सूची';

  @override
  String get authAadhaarNumber => '12 अंकों का आधार नंबर';

  @override
  String get authEncrypted => 'एन्क्रिप्टेड और UIDAI अनुरूप';

  @override
  String get authTradeCard => 'आधार / व्यवसाय कार्ड';

  @override
  String get authFrontSync => 'सामने की फ़ोटो और DigiLocker सिंक';

  @override
  String get authDigilockerSuccess =>
      'DigiLocker KYC गेटवे सफलतापूर्वक सिंक हुआ!';

  @override
  String get authFrontCaptured => 'आधार के सामने का स्कैन लिया गया';

  @override
  String get authCaptureAadhaar => 'आधार कार्ड के सामने की फ़ोटो लें';

  @override
  String get authPhotoLimit => 'साफ़ फ़ोटो • अधिकतम 10MB (JPG/PNG)';

  @override
  String get authAutoVerified => '72% स्वतः सत्यापित';

  @override
  String get authUpload => 'अपलोड करने के लिए टैप करें';

  @override
  String get authToolsAudit => 'कैलिब्रेटेड औज़ारों की जाँच';

  @override
  String get authSafetyStandard => 'गिल्ड सुरक्षा मानक';

  @override
  String get authMultimeter =>
      'डिजिटल True-RMS मल्टीमीटर और फ़ेज़ टेस्टर (कैलिब्रेटेड)';

  @override
  String get authInsulatedTools => '1000V इंसुलेटेड पेचकस और प्लायर सेट';

  @override
  String get authDrillTools => 'हैवी ड्यूटी रोटरी हैमर ड्रिल और सुरक्षा चश्मा';

  @override
  String get authCleanupTools =>
      'कैनवास ड्रॉप-क्लॉथ और बुरादा सफ़ाई वैक्यूम बैग';

  @override
  String get authPayoutHeading => 'चरण 4: बैंक / UPI भुगतान सत्यापन';

  @override
  String get authPayoutDescription =>
      'बिना गिल्ड शुल्क 10 सेकंड में IMPS भुगतान के लिए बैंक या UPI ID जोड़ें';

  @override
  String get authDirectPayout => 'तुरंत गिल्ड सीधा भुगतान';

  @override
  String get authBankAccount => 'बैंक खाता नंबर';

  @override
  String get authReenterBank => 'बैंक खाता नंबर फिर दर्ज करें';

  @override
  String get authIfsc => 'IFSC कोड';

  @override
  String get authBranchResolved =>
      'शाखा मिली: HDFC बैंक, वज़ीराबाद शाखा, नांदेड़ (431601)';

  @override
  String get authUpiPayout => 'UPI तेज़ भुगतान VPA';

  @override
  String get authPennyDrop => 'पेनी-ड्रॉप सत्यापित';

  @override
  String get authVerifiedUpi => 'सत्यापित UPI ID / VPA (₹0 IMPS शुल्क)';

  @override
  String get authPennyDropSimulation =>
      'डेमो ₹1 IMPS पेनी-ड्रॉप परीक्षण सफल। भुगतान वॉलेट जुड़ा।';

  @override
  String get authProtectionActive => '₹25,000 गिल्ड सुरक्षा कवच सक्रिय';

  @override
  String get authProtectionDescription =>
      'कारीगर साइट पर आकस्मिक संपत्ति क्षति को ₹25,000 तक कवर करता है। शून्य देयता और न्यूनतम 5% कमीशन गारंटी (गिल्ड एलीट) के साथ कमाएँ।';

  @override
  String get authBack => 'वापस';

  @override
  String get authNextStep => 'अगला चरण';

  @override
  String get authVerifyWhatsApp => 'WhatsApp OTP से सत्यापित करें';

  @override
  String get jobInvalidStart =>
      'गलत कोड! ग्राहक से उनका 4 अंकों का स्टार्ट कोड पूछें।';

  @override
  String get jobAccessDenied => 'दरवाज़े पर प्रवेश नहीं मिला';

  @override
  String get jobCloseJob => 'काम बंद करें';

  @override
  String get jobAddPart2fa => '2FA के साथ पुर्ज़ा जोड़ें';

  @override
  String get jobPartName => 'पुर्ज़े का नाम और विवरण';

  @override
  String get jobUnitPrice => 'प्रति इकाई मूल्य (₹)';

  @override
  String get jobStoreName => 'हार्डवेयर दुकान का नाम';

  @override
  String get jobAttachReceipt => 'हार्डवेयर दुकान की रसीद फ़ोटो जोड़ें';

  @override
  String get jobPartsDisclaimer =>
      'पुर्ज़ों में 2% भुगतान गेटवे शुल्क शामिल है और ऐप में ग्राहक की RBI 2FA मंज़ूरी माँगी जाती है।';

  @override
  String get jobCancel => 'रद्द करें';

  @override
  String get jobAddPartBill => 'बिल में पुर्ज़ा जोड़ें';

  @override
  String get jobInvoiceSubmitted =>
      'विस्तृत बिल भेजा गया! ग्राहक को बिल जाँचकर PIN देने की सूचना मिली।';

  @override
  String get jobActiveBill => 'सक्रिय काम और बिल बनाएँ';

  @override
  String get jobStopwatch => 'साइट पर मरम्मत का समय';

  @override
  String get jobElapsed => '28 मिनट 14 सेकंड बीते';

  @override
  String get jobLiveLog => 'लाइव लॉग';

  @override
  String get jobGpsStreaming => 'लाइव GPS टेलीमेट्री स्ट्रीमिंग (अनुबंध 3)';

  @override
  String get jobForeground => 'अग्रभूमि (3 सेकंड)';

  @override
  String get jobBackground => 'पृष्ठभूमि (15 सेकंड)';

  @override
  String get jobSpeed => 'गति';

  @override
  String get jobHeading => 'दिशा';

  @override
  String get jobBattery => 'बैटरी';

  @override
  String get jobRemaining => 'बाकी';

  @override
  String get jobGeofence =>
      '200 मीटर का जियोफ़ेंस सक्रिय! स्टार्ट कोड के लिए तैयार।';

  @override
  String get jobEnterStart => 'चरण 1: ग्राहक का स्टार्ट कोड दर्ज करें';

  @override
  String get jobStartDescription =>
      'पहुँचने की पुष्टि के लिए घर के मालिक से 4 अंकों का सुरक्षा कोड पूछें (डेमो: 4921)।';

  @override
  String get jobStartHint => '4 अंकों का स्टार्ट कोड दर्ज करें';

  @override
  String get jobVerifyBegin => 'कोड सत्यापित कर मरम्मत शुरू करें';

  @override
  String get jobDeniedTransit => 'प्रवेश नहीं मिला (₹80 यात्रा शुल्क माँगें)';

  @override
  String get jobStartComplete =>
      'स्टार्ट कोड 4921 सत्यापित • आगमन की पुष्टि पूरी';

  @override
  String get jobBillBuilder => 'बिल बनाएँ';

  @override
  String get jobCustomPart => 'कस्टम पुर्ज़ा';

  @override
  String get jobAddPart => 'पुर्ज़ा जोड़ें';

  @override
  String get jobLaborDiagnostic => 'मज़दूरी और जाँच';

  @override
  String get jobReceiptAttached => 'रसीद की फ़ोटो जुड़ी है';

  @override
  String get jobLaborBase => 'मज़दूरी और जाँच का मूल शुल्क';

  @override
  String get jobPartsSurcharge => 'पुर्ज़ों पर 2% गेटवे शुल्क';

  @override
  String get jobGst => '18% GST (मज़दूरी और अधिभार)';

  @override
  String get jobTotalInvoiced => 'ग्राहक का कुल बिल';

  @override
  String get jobWaitingPin => 'विस्तृत बिल भेजा • ग्राहक के PIN का इंतज़ार';

  @override
  String get jobSubmitInvoice => 'विस्तृत बिल जमा करें (अलग चरण)';

  @override
  String get jobCompletionHeading => 'चरण 3: काम पूरा होने का PIN लें';

  @override
  String get jobCompletionDescription =>
      'ग्राहक से 4 अंकों का पूर्णता PIN पूछें (डेमो: 7294)';

  @override
  String get jobCompletionHint => '4 अंकों का पूर्णता PIN दर्ज करें';

  @override
  String get jobPayoutSettled => 'IMPS भुगतान पूरा!';

  @override
  String get jobBackRadar => 'रडार पर वापस';

  @override
  String get jobInvalidCompletion =>
      'गलत पूर्णता PIN! डेमो के लिए 7294 दर्ज करें।';

  @override
  String get jobElitePartner => 'गिल्ड एलीट पार्टनर';

  @override
  String get jobGoldGuildsman => 'गोल्ड गिल्ड कारीगर';

  @override
  String get jobFloorActive => 'न्यूनतम 5% कमीशन सक्रिय';

  @override
  String get jobTier4 => 'स्तर 4 कारीगर';

  @override
  String get jobTakeRate => '💎 5% कमीशन';

  @override
  String get jobTopPartner => 'शीर्ष 5% पार्टनर';

  @override
  String get jobApprentice => 'प्रशिक्षु\n(15%)';

  @override
  String get jobPro => 'प्रो\n(12%)';

  @override
  String get jobMaster => 'मास्टर\n(8%)';

  @override
  String get jobElite => 'एलीट\n(न्यूनतम 5%)';

  @override
  String get jobEliteMilestone => 'गिल्ड एलीट उपलब्धि: अनलॉक';

  @override
  String get jobMasterMilestone => 'उपलब्धि: मास्टर कारीगर (8%)';

  @override
  String get jobJobsProgress => '42 / 50 काम';

  @override
  String get jobEliteDescription =>
      'गिल्ड एलीट सक्रिय! 5% कमीशन के साथ बिल का 95% आपको मिलता है।';

  @override
  String get jobMasterDescription =>
      '8% मास्टर स्तर के लिए 8 और काम पूरे करें, या 5% कमीशन के लिए गिल्ड एलीट लें!';

  @override
  String get jobKarigaarElite => 'कारीगर गिल्ड एलीट पार्टनर';

  @override
  String get jobKeep95 => 'न्यूनतम 5% कमीशन (95% रखें)';

  @override
  String get jobMonthlyDeduction => '₹999 / माह • एक टैप में वॉलेट से कटौती';

  @override
  String get jobEliteBenefitFees =>
      '• न्यूनतम 5% कमीशन (प्लैटफ़ॉर्म शुल्क में ₹4,500/माह तक बचाएँ)\n';

  @override
  String get jobEliteBenefitRadar =>
      '• सामान्य पार्टनर से 10 सेकंड पहले प्राथमिकता रडार सूचना\n';

  @override
  String get jobEliteBenefitImps =>
      '• ₹0 तत्काल IMPS भुगतान शुल्क (गेटवे शुल्क प्लैटफ़ॉर्म देगा)\n';

  @override
  String get jobEliteBenefitBadge =>
      '• ग्राहकों को गोल्डन गिल्ड एलीट बैज दिखता है';

  @override
  String get jobUpgradeElite => 'गिल्ड एलीट में अपग्रेड करें (₹999/माह)';

  @override
  String get jobEliteLocked =>
      '💎 गिल्ड एलीट सक्रिय • 5% कमीशन तय • अगला बिल 30 दिन में';

  @override
  String get jobSubscribeElite => 'गिल्ड एलीट की सदस्यता लें';

  @override
  String get jobLockFloor => 'स्थायी न्यूनतम 5% कमीशन तय करें';

  @override
  String get jobSubscriptionFee => 'मासिक सदस्यता शुल्क';

  @override
  String get jobWalletBalance => 'मौजूदा वॉलेट शेष';

  @override
  String get jobPostDeduction => 'कटौती के बाद शेष';

  @override
  String get jobSubscribed => 'गिल्ड एलीट सदस्यता ली! न्यूनतम 5% कमीशन सक्रिय।';

  @override
  String get jobConfirmDeduct => 'पुष्टि करें और वॉलेट से ₹999 काटें';

  @override
  String get jobGuildWallet => 'गिल्ड वॉलेट';

  @override
  String get jobImpsLive => 'तत्काल IMPS सक्रिय';

  @override
  String get jobClearedPayout => 'उपलब्ध भुगतान राशि';

  @override
  String get jobLockedReserve => 'आरक्षित राशि';

  @override
  String get jobAvailablePayout => 'उपलब्ध भुगतान';

  @override
  String get jobWithdrawBank => 'UPI / IMPS से बैंक में निकालें (₹0 शुल्क)';

  @override
  String get jobSupport => 'कारीगर पार्टनर सहायता';

  @override
  String get jobWeeklySummary => 'साप्ताहिक कमाई का सारांश WhatsApp पर भेजें';

  @override
  String get jobVerifiedVault => 'सत्यापित गिल्ड वॉल्ट';

  @override
  String get jobNoBalance => 'निकासी के लिए कोई उपलब्ध राशि नहीं है।';

  @override
  String get jobReserveRequired =>
      'निकासी नहीं हो सकती। अनिवार्य ₹2,000 सुरक्षा राशि रखना आवश्यक है।';

  @override
  String get jobInstantPayout => 'तत्काल IMPS भुगतान';

  @override
  String get jobReserveLocked =>
      'अनिवार्य ₹2,000 सुरक्षा राशि गिल्ड वॉल्ट में आरक्षित है।';

  @override
  String get jobBankNanded => 'बैंक: HDFC बैंक लिमिटेड (नांदेड़ मुख्य शाखा)';

  @override
  String get jobMaskedAccount => 'खाता: •••• •••• 2104';

  @override
  String get jobPayoutFee => 'भुगतान शुल्क: ₹0.00 (गिल्ड देगा)';

  @override
  String get jobConfirmPayout => 'IMPS भुगतान की पुष्टि करें';

  @override
  String get jobRecentActivity => 'हाल की गतिविधि';

  @override
  String get jobViewLedger => 'खाता-बही देखें';

  @override
  String get jobWiringRepair => 'MCB और वायरिंग मरम्मत';

  @override
  String get jobActivityToday => 'आनंद नगर, नांदेड़ • आज, सुबह 11:20';

  @override
  String get jobDailyPayout => 'HDFC में दैनिक भुगतान';

  @override
  String get jobActivityYesterday => 'संदर्भ #IMPS99824 • कल';

  @override
  String get jobGuildGuarantee =>
      'गिल्ड गारंटी: बिना सेवा कटौती 24/7 तत्काल IMPS भुगतान प्रक्रिया की गारंटी।';

  @override
  String get jobProfileUpdated =>
      'प्रोफ़ाइल और दर सूची अपडेट होकर जिला निर्देशिका से सिंक हुई!';

  @override
  String get jobBioHint => 'अपने काम की विशेषज्ञता और सुरक्षा उपकरण बताएँ...';

  @override
  String get jobWorkPhotoHint => 'जैसे 6-वे डिस्ट्रीब्यूशन बॉक्स लगाना';

  @override
  String get jobNandedGuild => 'नांदेड़ व्यवसाय गिल्ड';

  @override
  String get jobJobsRating => '4.9★ (340 काम)';

  @override
  String get jobEmergency => 'आपातकालीन खराबी';

  @override
  String get jobOnePhoto => '1 फ़ोटो';

  @override
  String get jobBroadcastTimeout =>
      'समय सीमा में काम नहीं लिया गया। खोज क्षेत्रीय गिल्ड तक बढ़ाई गई।';

  @override
  String get jobScanning => 'नांदेड़ में नए काम खोज रहे हैं...';

  @override
  String get jobDutyPaused => 'ड्यूटी रुकी है। काम पाने के लिए ऑनलाइन जाएँ।';

  @override
  String get jobKeepActive =>
      '45 सेकंड के प्राथमिकता अलर्ट के लिए ऐप चालू रखें';

  @override
  String get jobVoiceExample =>
      'ग्राहक की आवाज़: \"AC चालू करने पर MCB में चिंगारी आती है। 32A बदलना है।\"';

  @override
  String get jobPausePreview => 'पूर्वावलोकन रोकें';

  @override
  String get jobListenMemo => 'ग्राहक का ऑडियो सुनें';

  @override
  String get localitySelect => 'इलाका चुनें';

  @override
  String get localityPilotDistrict => 'पायलट शहर: नांदेड़-वाघाला (महाराष्ट्र)';

  @override
  String localityDistrict(String district) {
    return 'ज़िला: $district';
  }

  @override
  String get localitySearchHint => 'इलाका या PIN कोड खोजें';

  @override
  String localityEmptyText(String city) {
    return '$city में कोई इलाका नहीं मिला';
  }

  @override
  String localityChanged(String name, String pincode) {
    return 'सेवा केंद्र $name ($pincode) पर बदल गया';
  }

  @override
  String get emergencyTitle => 'ज़रूरी मरम्मत? (25 मिनट)';

  @override
  String get emergencyDispatch => 'तुरंत दरवाज़े तक सेवा';

  @override
  String get emergencyCoverage =>
      'नांदेड़ में इलेक्ट्रीशियन और प्लंबर तैयार हैं';

  @override
  String get emergencyBookFast => 'जल्दी बुक करें';

  @override
  String get skeletonTradesHeading => 'प्रमाणित गिल्ड सेवाएँ';

  @override
  String catalogTradeName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'trade_electrician': 'इलेक्ट्रीशियन',
        'trade_plumber': 'प्लंबर',
        'trade_carpenter': 'बढ़ई',
        'trade_mason': 'राजमिस्त्री / सिविल कारीगर',
        'trade_painter': 'पेंटर',
        'trade_ac_refrig': 'एसी और फ्रिज मैकेनिक',
        'trade_appliance': 'घरेलू उपकरण मरम्मत',
        'trade_welder': 'वेल्डर / फैब्रिकेटर',
        'trade_pest': 'कीट नियंत्रण',
        'trade_deep_cleaning': 'गहन सफाई',
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
            'शॉर्ट सर्किट, MCB, स्विचबोर्ड और भारी उपकरणों की वायरिंग',
        'trade_plumber':
            'पाइप रिसाव, नल बदलना, नाली की रुकावट और सैनिटरी फिटिंग',
        'trade_carpenter':
            'दरवाजे के ताले, किचन के कब्जे, लकड़ी की मरम्मत और फर्नीचर जोड़ना',
        'trade_mason':
            'टाइल बदलना, दीवार का प्लास्टर, कंक्रीट ड्रिलिंग और जलरोधक काम',
        'trade_painter':
            'दीवार की रंगाई, सीलन का उपचार, दरवाजे की पॉलिश और घर की रंगाई',
        'trade_ac_refrig':
            'फोम जेट सफाई, गैस भरना, कंप्रेसर की जाँच और ठंडक की समस्या',
        'trade_appliance':
            'वॉशिंग मशीन, माइक्रोवेव, गीजर, मिक्सर ग्राइंडर और RO प्यूरीफायर',
        'trade_welder':
            'गेट के कब्जे की वेल्डिंग, सुरक्षा जाली, रेलिंग और शेड की मरम्मत',
        'trade_pest':
            'तिलचट्टे का जेल उपचार, दीमक रोधक ड्रिलिंग और खटमल नियंत्रण',
        'trade_deep_cleaning':
            'बाथरूम की मैल सफाई, किचन की चिकनाई हटाना और सोफे की धुलाई',
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
        'pkg_elec_mcb': 'शॉर्ट सर्किट और MCB ट्रिपिंग',
        'pkg_elec_switchboard': 'स्विचबोर्ड और सॉकेट मरम्मत',
        'pkg_elec_fan': 'सीलिंग फैन / झूमर लगाना',
        'pkg_elec_inverter': 'इन्वर्टर और बैटरी वायरिंग',
        'pkg_plumb_leak': 'पानी के पाइप जोड़ का रिसाव ठीक करना',
        'pkg_plumb_drain': 'किचन सिंक और बाथरूम की नाली खोलना',
        'pkg_plumb_tap': 'नल / मिक्सर / डायवर्टर बदलना',
        'pkg_plumb_tank': 'ऊपरी टंकी का फ्लोट वाल्व और मोटर लाइन',
        'pkg_carp_lock': 'मुख्य दरवाजे के डेडबोल्ट / गोदरेज ताले की मरम्मत',
        'pkg_carp_hinge': 'कैबिनेट और अलमारी के हाइड्रोलिक कब्जे बदलना',
        'pkg_carp_door_trim': 'घिसटते दरवाजे और चौखट की छिलाई',
        'pkg_carp_furniture': 'बिस्तर / मेज जोड़ना और मजबूती देना',
        'pkg_mason_tile': 'टूटी फर्श / दीवार टाइल की मरम्मत (4 तक)',
        'pkg_mason_plaster': 'दीवार की दरार और प्लास्टर मरम्मत',
        'pkg_mason_waterproof': 'बाथरूम / बालकनी के कोनों का जलरोधक काम',
        'pkg_paint_patch': 'एक दीवार की मरम्मत और रंगाई (पुट्टी + पेंट)',
        'pkg_paint_damp': 'सीलन रोधक रासायनिक परत और टॉपकोट',
        'pkg_paint_wood': 'दरवाजे और खिड़की की इनैमल / मेलामाइन पॉलिश',
        'pkg_ac_deep_clean': 'स्प्लिट AC फोम जेट गहन सर्विस',
        'pkg_ac_gas_leak': 'AC गैस रिसाव जाँच और भराई',
        'pkg_fridge_cooling': 'फ्रिज में कम ठंडक / डीफ्रॉस्ट मरम्मत',
        'pkg_app_geyser': 'इंस्टेंट / स्टोरेज गीजर हीटिंग एलिमेंट मरम्मत',
        'pkg_app_washing': 'वॉशिंग मशीन स्पिन / ड्रेन ड्रम की समस्या',
        'pkg_app_ro': 'RO प्यूरीफायर मेम्ब्रेन और फिल्टर सर्विस',
        'pkg_weld_gate': 'मुख्य स्लाइडिंग / स्विंग गेट कब्जे की आर्क वेल्डिंग',
        'pkg_weld_grill': 'बालकनी और खिड़की की सुरक्षा जाली मजबूत करना',
        'pkg_weld_sheet': 'टिन शेड और पॉलीकार्बोनेट छत ब्रैकेट मरम्मत',
        'pkg_pest_cockroach': 'किचन और बाथरूम हर्बल जेल उपचार',
        'pkg_pest_termite': 'लकड़ी की दीमक के लिए ड्रिल और रासायनिक सुरक्षा',
        'pkg_pest_bedbug': 'खटमल का 2-चरण ताप और स्प्रे उपचार',
        'pkg_clean_bath': 'बाथरूम के कठोर पानी के दाग और टाइल मैल सफाई',
        'pkg_clean_kitchen': 'मॉड्यूलर किचन चिमनी और स्लैब की चिकनाई सफाई',
        'pkg_clean_sofa': '5-सीट कपड़े के सोफे की शैम्पू और गीली सफाई',
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
            'बार-बार ट्रिपिंग, चिंगारी और न्यूट्रल दोष की जाँच व फ्यूज मरम्मत',
        'pkg_elec_switchboard':
            'ढीले स्विच, जले संपर्क बिंदु और 16A पावर सॉकेट लगाना',
        'pkg_elec_fan': 'एंकर रॉड लगाना, रेगुलेटर की वायरिंग और कंपन कम करना',
        'pkg_elec_inverter':
            'बैकअप बायपास लाइन, भारी लोड टर्मिनल और बैटरी पानी की जाँच',
        'pkg_plumb_leak':
            'CPVC/PVC पाइप जोड़ की सोल्डरिंग और दीवार के भीतर रिसाव की जाँच',
        'pkg_plumb_drain':
            'उच्च दबाव वाले यांत्रिक ऑगर से नाली और ट्रैप की सफाई',
        'pkg_plumb_tap':
            'सिरेमिक स्पिंडल बदलना, क्वार्टर-टर्न वाल्व लगाना और टेफ्लॉन सीलिंग',
        'pkg_plumb_tank': 'बॉल कॉक ऑटो कट-ऑफ वाल्व बदलना और एयरलॉक हटाना',
        'pkg_carp_lock':
            'सिलेंडर बदलना, अटकी कुंडी सीधी करना और पीतल स्ट्राइक प्लेट लगाना',
        'pkg_carp_hinge':
            'सॉफ्ट-क्लोज कब्जे का तनाव और प्लाईवुड स्क्रू की पकड़ ठीक करना',
        'pkg_carp_door_trim':
            'नीचे का हिस्सा सटीक काटना और बारिश में फूली लकड़ी ठीक करना',
        'pkg_carp_furniture':
            'बोल्ट कसना, लकड़ी के ब्रैकेट मजबूत करना और दीमक की जाँच',
        'pkg_mason_tile':
            'चिपकाने का आधार, लेजर समतलीकरण और फफूंदरोधी एपॉक्सी ग्राउटिंग',
        'pkg_mason_plaster':
            'पॉलिमर मिश्रित सीमेंट, V-ग्रूव कटाई और चिकनी फिनिश',
        'pkg_mason_waterproof':
            'स्कर्टिंग पर Dr. Fixit रासायनिक झिल्ली की 2 परतें',
        'pkg_paint_patch':
            'घिसाई, ऐक्रेलिक पुट्टी, प्राइमर की 2 परतें और रंग मिलाना',
        'pkg_paint_damp': 'नमक की परत हटाना और सिलिकॉन डैम्प-लॉक उपचार',
        'pkg_paint_wood': 'बारीक सैंडपेपर से घिसाई और चमकीली PU कोटिंग',
        'pkg_ac_deep_clean':
            'भीतरी कॉइल की जीवाणुरोधी फोम धुलाई, बाहरी ब्लोअर और फिल्टर की सफाई',
        'pkg_ac_gas_leak':
            'नाइट्रोजन दबाव से रिसाव जाँच, फ्लेयर नट ब्रेजिंग और R32/R410A वैक्यूम चार्जिंग',
        'pkg_fridge_cooling':
            'थर्मोस्टैट कैलिब्रेशन, बाइमेटल सेंसर बदलना और कैपिलरी फ्लश',
        'pkg_app_geyser':
            'तांबे की हीटिंग कॉइल का मैल हटाना और सुरक्षा थर्मोस्टैट जाँचना',
        'pkg_app_washing':
            'मोटर बेल्ट कसना, ड्रेन पंप फिल्टर खोलना और PCB रिले की जाँच',
        'pkg_app_ro':
            'TDS कैलिब्रेशन, सेडिमेंट व कार्बन फिल्टर बदलना और बूस्टर पंप जाँच',
        'pkg_weld_gate':
            'माइल्ड स्टील बॉल-बेयरिंग पिवट वेल्डिंग, स्लैग हटाना और जंगरोधी प्राइमर',
        'pkg_weld_grill':
            'ढीले एंकर पिन की टैक वेल्डिंग और एंगल आयरन मजबूत करना',
        'pkg_weld_sheet':
            'हवा से टूटे पर्लिन जोड़ की वेल्डिंग और सेल्फ-टैपिंग स्क्रू गैस्केट बदलना',
        'pkg_pest_cockroach':
            'कब्जों और सिंक के नीचे दरारों में गंधरहित Fipronil जेल (बच्चों और पालतू जानवरों के लिए सुरक्षित)',
        'pkg_pest_termite':
            '6 मिमी ड्रिलिंग, दबाव से Imidacloprid इंजेक्शन और लकड़ी के रंग की सील',
        'pkg_pest_bedbug':
            'गद्दे की सिलाई पर भाप, पाइरेथ्रॉइड स्प्रे और 15 दिनों में मुफ्त दोबारा मुलाकात',
        'pkg_clean_bath':
            'रोटरी स्क्रबर से टाइल धुलाई, नल पॉलिश और काँच के दाग हटाना',
        'pkg_clean_kitchen':
            'बिना कॉस्टिक बैफल फिल्टर की अल्ट्रासोनिक सफाई, स्टील पॉलिश और ग्राउट सफाई',
        'pkg_clean_sofa':
            'गहरी फोम सफाई, औद्योगिक वैक्यूम से नमी निकालना और साइट्रस सुगंध',
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
        'bundle_monsoon_elec': 'बरसात में विद्युत सुरक्षा',
        'bundle_plumb_health': 'पूरे घर की प्लंबिंग जाँच',
        'bundle_ac_summer': 'गर्मी से पहले AC सुपर कूल',
        'bundle_carpenter_care': 'मॉड्यूलर किचन और दरवाजा संरेखण',
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
            'शॉर्ट सर्किट, MCB ट्रिप और नमी से करंट लगने से बचाव',
        'bundle_plumb_health':
            'दीवार के भीतर रिसाव की जाँच, ऊपरी टंकी वाल्व की जाँच और ट्रैप सफाई',
        'bundle_ac_summer': 'जीवाणुरोधी फोम जेट सफाई, ठंडक और गैस दबाव की जाँच',
        'bundle_carpenter_care':
            'हाइड्रोलिक सॉफ्ट-क्लोज कब्जे कसना और फूले दरवाजे की छिलाई',
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
        'bundle_monsoon_elec_0': 'MCB ट्रिप जाँच और फ्यूज लोड कैलिब्रेशन',
        'bundle_monsoon_elec_1': 'स्विचबोर्ड की नमी और अर्थिंग रिसाव जाँच',
        'bundle_monsoon_elec_2': 'सीलिंग फैन और बैकअप वायरिंग कसना',
        'bundle_plumb_health_0': 'ध्वनि से छिपे पाइप जोड़ के रिसाव की जाँच',
        'bundle_plumb_health_1':
            'किचन सिंक और बाथरूम नाली की यांत्रिक ऑगर सफाई',
        'bundle_plumb_health_2':
            'क्वार्टर-टर्न एंगल वाल्व और सिरेमिक स्पिंडल की सर्विस',
        'bundle_ac_summer_0': 'भीतरी कूलिंग कॉइल की उच्च दबाव फोम जेट धुलाई',
        'bundle_ac_summer_1': 'बाहरी कंडेंसर की सफाई और कंप्रेसर कंपन कम करना',
        'bundle_ac_summer_2':
            'R32/R410A गैस दबाव मापना और फिल्टर कीटाणुरहित करना',
        'bundle_carpenter_care_0':
            'कैबिनेट और अलमारी के हाइड्रोलिक सॉफ्ट-क्लोज तनाव का समायोजन',
        'bundle_carpenter_care_1':
            'फूली चौखट की छिलाई और नीचे की दूरी ठीक करना',
        'bundle_carpenter_care_2':
            'मुख्य दरवाजे के डेडबोल्ट और गोदरेज लॉक सिलेंडर की सर्विस',
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
        'headMistry': 'मुख्य मिस्त्री / उस्ताद',
        'skilledKarigaar': 'कुशल कारीगर',
        'helperAssistant': 'सहायक / मजदूर',
        'thekedar': 'ठेकेदार / टीम प्रमुख',
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
        'headMistry': '👑 मुख्य मिस्त्री / उस्ताद',
        'skilledKarigaar': '🔧 कुशल कारीगर',
        'helperAssistant': '🤝 सहायक / मजदूर',
        'thekedar': '👷 ठेकेदार / टीम प्रमुख',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String get flowVerifiedGuild => 'सत्यापित मास्टर गिल्ड';

  @override
  String get flowNandedRating => '4.9 (नांदेड़ में 1.4 हज़ार काम)';

  @override
  String get flowInspectionWarranty =>
      '45 मिनट की जाँच और 30 दिन की दोबारा काम की वारंटी शामिल';

  @override
  String get flowSelectIssues => 'ठीक करने वाली समस्याएँ चुनें';

  @override
  String get flowSelectIssuesHint =>
      'सही औज़ारों के लिए सभी संबंधित समस्याएँ चुनें';

  @override
  String get flowBundleApplied => 'चुना हुआ पैकेज लागू हुआ';

  @override
  String get flowPhotoVoice => 'फ़ोटो और 15 सेकंड का वॉइस नोट';

  @override
  String get flowSparesHint =>
      'कारीगर को दुकान से सही पुर्ज़े लाने में मदद करें';

  @override
  String get flowPhotoRemoved => 'संलग्न फ़ोटो हटाया गया।';

  @override
  String get flowPhotoAttached => 'समस्या का फ़ोटो जुड़ा है';

  @override
  String get flowAddPhoto => 'समस्या का फ़ोटो जोड़ें (वैकल्पिक)';

  @override
  String get flowShieldFee => '+₹29 सुरक्षा शुल्क';

  @override
  String get flowAdjustableBill => 'मौके पर बिल में बदलाव संभव';

  @override
  String get flowRequestArtisan => 'कारीगर बुलाएँ';

  @override
  String get flowSkillTier => 'कारीगर का कौशल स्तर';

  @override
  String get flowMasterRate => '1.25x (+25% मास्टर स्तर)';

  @override
  String get flowStandardRate => '1.0x (मानक दर)';

  @override
  String get flowHelperRate => '0.65x (-35% सहायक स्तर)';

  @override
  String get flowContractorRate => '1.35x (+35% टीम ठेकेदार)';

  @override
  String get flowMandateTitle => 'पहले से ₹99 स्टैंडबाय अनुमति';

  @override
  String get flowMandateProvider => 'Razorpay / Cashfree UPI ऑटोपे से सुरक्षित';

  @override
  String get flowMandateWhy => '₹99 की अग्रिम अनुमति क्यों ज़रूरी है?';

  @override
  String get flowMandateExplanation =>
      'कारीगर के ईंधन और यात्रा के लिए ₹99 स्टैंडबाय राशि रोकी जाती है। काम पूरा होने पर राशि मुक्त होती है; केवल 15 मिनट से ज़्यादा प्रवेश न मिलने पर काटी जाती है।';

  @override
  String get flowSelectUpi => 'UPI ऐप चुनें';

  @override
  String get flowUpiId => 'UPI ID / VPA दर्ज करें';

  @override
  String get flowUpiHint => 'जैसे mobile@okaxis';

  @override
  String get flowUpiInvalid => 'कृपया सही UPI VPA दर्ज करें (जैसे name@bank)';

  @override
  String get flowAuthorizeMandate => '₹99 की अनुमति दें और कारीगर बुलाएँ';

  @override
  String get flowAudioTitle => '15 सेकंड का ऑडियो विवरण';

  @override
  String get flowRecording => 'रिकॉर्डिंग जारी है (अधिकतम 15 सेकंड)...';

  @override
  String get flowAudioLanguages => 'समस्या हिंदी, मराठी या अंग्रेज़ी में बताएँ';

  @override
  String get flowAudioHint =>
      'कारीगर के लिए मोटर, पानी के रिसाव या चिंगारी की आवाज़ अधिकतम 15 सेकंड तक रिकॉर्ड करें।';

  @override
  String get flowRecordAudio => '15 सेकंड का ऑडियो रिकॉर्ड करें';

  @override
  String get flowPause => 'रोकें';

  @override
  String get flowPlayPreview => 'रिकॉर्डिंग सुनें';

  @override
  String get flowRerecord => 'फिर रिकॉर्ड करें';

  @override
  String get flowDeleteAudio => 'ऑडियो हटाएँ';

  @override
  String get flowArrivalDateSlot => 'आने की तारीख और समय चुनें';

  @override
  String get flowToday => 'आज';

  @override
  String get flowEmergency => 'आपातकालीन';

  @override
  String get flowLiveTracking => 'लाइव ट्रैकिंग';

  @override
  String get flowNoBooking => 'कोई सक्रिय बुकिंग नहीं मिली';

  @override
  String get flowDispatchRadar => 'लाइव डिस्पैच रडार';

  @override
  String get flowYourHome => 'आपका घर';

  @override
  String get flowArrived => 'पहुँच गए';

  @override
  String get flowArrivedZero => 'दरवाज़े पर पहुँच गए (0 किमी)';

  @override
  String get flowStationary => 'स्थिर • गंतव्य पर';

  @override
  String get flowArrivalHint =>
      'कारीगर आपके पास पहुँच गए हैं। दरवाज़े पर आने के बाद ही कोड दें।';

  @override
  String get flowDwellExplanation =>
      'कारीगर बाहर इंतज़ार कर रहे हैं। 15 मिनट से ज़्यादा प्रवेश न मिलने पर ₹99 स्टैंडबाय यात्रा शुल्क लागू होगा।';

  @override
  String get flowStartCodeLabel => 'दरवाज़े पर सुरक्षा आरंभ कोड';

  @override
  String get flowStartCodeHint =>
      'यह 4 अंकों का कोड कारीगर के दरवाज़े पर पहुँचने पर ही बोलकर बताएँ।';

  @override
  String get flowMaskedWhatsapp => 'नंबर छिपाने वाला WhatsApp चैनल';

  @override
  String get flowMaskedCall => 'नंबर छिपाने वाला कॉल';

  @override
  String get flowDirections => 'दरवाज़े तक पहुँचने के निर्देश';

  @override
  String get flowMilestones => 'बुकिंग के चरण';

  @override
  String get flowBookingConfirmed => 'बुकिंग पक्की और एस्क्रो सुरक्षित';

  @override
  String get flowArtisanDispatched => 'कारीगर आनंद नगर से रवाना';

  @override
  String get flowArrivedWithin => 'दरवाज़े के पास पहुँचे (200 मीटर के भीतर)';

  @override
  String get flowArrivedDoorstep => 'दरवाज़े पर पहुँचे';

  @override
  String get flowTrackingActive => 'लाइव ट्रैकिंग चालू';

  @override
  String get flowHandshakeVerified => 'आरंभ सत्यापित';

  @override
  String get flowPendingArrival => 'आने का इंतज़ार';

  @override
  String get flowWorkCompletion => 'काम पूरा और पूर्णता OTP';

  @override
  String get flowImpsSettled => 'IMPS भुगतान पूरा';

  @override
  String get flowRepairProgress => 'मरम्मत जारी है';

  @override
  String get flowPendingFinish => 'काम पूरा होना बाकी';

  @override
  String get flowInvoiceReview => 'ग्राहक बिल की समीक्षा';

  @override
  String get flowPaidSettled => 'भुगतान पूरा';

  @override
  String get flowPendingReview => 'समीक्षा बाकी';

  @override
  String get flowLaborInspection => 'मज़दूरी और जाँच';

  @override
  String get flowPartsSurcharge => 'पुर्ज़ों पर 2% गेटवे अधिभार';

  @override
  String get flowGst => '18% GST (मज़दूरी और अधिभार)';

  @override
  String get flowGrandTotalPayable => 'कुल देय राशि';

  @override
  String get flowCompletionCodeLabel => 'आपका 4 अंकों का पूर्णता OTP';

  @override
  String get flowCompletionCodeHint =>
      'संतोषजनक काम पूरा होने के बाद ही कारीगर को बोलकर बताएँ।';

  @override
  String get flowReviewRelease => 'पूरा बिल देखें और OTP दें';

  @override
  String get flowItemizedInvoice => 'सेवा का मदवार बिल';

  @override
  String get flowSpares => 'सुटे पुर्ज़े और सामग्री';

  @override
  String get flowGrandTotal => 'कुल राशि';

  @override
  String get flowReleaseCompletion => 'कारीगर को पूर्णता OTP दें';

  @override
  String get flowReleaseConsent =>
      'यह OTP बताकर आप काम पूरा होने की पुष्टि करते हैं और एस्क्रो भुगतान की अनुमति देते हैं।';

  @override
  String get flowCompletionSuccess =>
      'काम पूरा होना सत्यापित! ₹99 स्टैंडबाय राशि मुक्त, एस्क्रो भुगतान पूरा।';

  @override
  String get accountProfileTitle => 'घरमालक प्रोफ़ाइल और सेटिंग्स';

  @override
  String get accountMasterProtection =>
      '₹25,000 मास्टर गिल्ड क्षति सुरक्षा सक्रिय';

  @override
  String get accountSavedLocalities => 'सहेजे गए नांदेड़ इलाके';

  @override
  String get accountChange => 'बदलें';

  @override
  String get accountPaymentPreferences => 'एस्क्रो और भुगतान प्राथमिकताएँ';

  @override
  String get accountTransitMandate =>
      '₹99 यात्रा शुल्क मैंडेट और पुर्जों के लिए RBI 2FA मंज़ूरी';

  @override
  String get accountPreauthorization => 'UPI एस्क्रो पूर्व-अनुमति';

  @override
  String get accountCompletionPayout =>
      '4 अंकों के समापन OTP के बाद ही भुगतान जारी करें';

  @override
  String get accountWhatsappAlerts => 'WhatsApp डिस्पैच और गेट पास सूचनाएँ';

  @override
  String get accountTrackingInvoices =>
      'कारीगर की लाइव स्थिति और डिजिटल GST बिल पाएँ';

  @override
  String get accountPortalSecurity => 'गिल्ड पोर्टल और सुरक्षा';

  @override
  String get accountSosContact => 'आपातकालीन SOS संपर्क';

  @override
  String get accountControlDesk =>
      '+91 9422100100 • नांदेड़ नियंत्रण कक्ष (24x7)';

  @override
  String get accountSwitchGuild => 'कारीगर गिल्ड पोर्टल खोलें';

  @override
  String get accountRadarWallet =>
      '45 सेकंड जॉब रडार और त्वरित IMPS वॉलेट खोलें';

  @override
  String get accountSignOut => 'साइन आउट / नंबर बदलें';

  @override
  String get accountChatTitle => 'गिल्ड सुरक्षित चैट और WhatsApp';

  @override
  String get accountMaskedCall => 'नंबर छिपाकर कॉल';

  @override
  String get accountViewArtisanProfile => 'कारीगर की प्रोफ़ाइल देखें';

  @override
  String get accountGateApproved => 'गेट पास मंज़ूर';

  @override
  String get accountSharePin => 'लाइव लोकेशन भेजें';

  @override
  String get accountCallOnArrival => 'पहुँचने पर कॉल करें';

  @override
  String get accountWhatsappRelay => 'WhatsApp रिले';

  @override
  String get accountMessageHint => 'गिल्ड ब्रिज से कारीगर को संदेश भेजें...';

  @override
  String get accountSend => 'भेजें';

  @override
  String get accountBookingsTitle => 'मेरी सेवा बुकिंग';

  @override
  String get accountActiveDispatch => 'सक्रिय डिस्पैच';

  @override
  String get accountPastOrders => 'आगामी और पिछले ऑर्डर';

  @override
  String get accountShield25 => '₹25,000 गिल्ड क्षति सुरक्षा सक्रिय';

  @override
  String get accountShield10 => '₹10,000 गिल्ड क्षति सुरक्षा सक्रिय';

  @override
  String get accountOnsiteLocked => 'मौके पर एस्क्रो लॉक किया गया';

  @override
  String get accountScheduledWindow => 'निर्धारित समय';

  @override
  String get accountTrackLive => 'लाइव स्थिति देखें';

  @override
  String get accountDirectVisit => 'सीधी विज़िट (सुरक्षा के बिना)';

  @override
  String get accountOnsiteUpgradeExplanation =>
      'कारीगर मौके पर हैं। स्टार्ट OTP (4921), ₹29 सुरक्षा शील्ड और ₹25 हज़ार मास्टर कवर सक्रिय करने के लिए अपग्रेड करें।';

  @override
  String get accountUpgradeBooking => 'सुरक्षित गिल्ड बुकिंग में अपग्रेड करें';

  @override
  String get accountViewArtisan => 'कारीगर देखें';

  @override
  String get accountBookAgain => 'फिर बुक करें';

  @override
  String get accountRateService => 'सेवा को रेटिंग दें';

  @override
  String get accountRaiseClaim => 'वारंटी दावा करें';

  @override
  String get accountServiceQuestion => 'सेवा कैसी थी?';

  @override
  String get accountOverall => 'कुल मिलाकर';

  @override
  String get accountCleanliness => 'साफ़-सफ़ाई';

  @override
  String get accountCareFinish => 'सावधानी और फिनिशिंग';

  @override
  String get accountFeedback => 'वैकल्पिक प्रतिक्रिया';

  @override
  String get accountSubmitRating => 'रेटिंग भेजें';

  @override
  String get accountClaimTitle => '30 दिन की वारंटी का दावा';

  @override
  String get accountDeductibleReview =>
      '₹250 कटौती लागू है। कारीगर सहायता टीम दावों की समीक्षा करती है।';

  @override
  String get accountDamageAmount => 'अनुमानित नुकसान की राशि (₹)';

  @override
  String get accountDescribeIssue => 'समस्या का विवरण दें';

  @override
  String get accountClaimValidation => 'सही राशि और दावे का कारण दर्ज करें।';

  @override
  String get accountClaimSent =>
      'दावा समीक्षा के लिए भेजा गया। अपडेट इसी बुकिंग में मिलेगा।';

  @override
  String get accountSubmitClaim => 'दावा भेजें';

  @override
  String get accountCraftsmanProfile => 'कारीगर की प्रोफ़ाइल';

  @override
  String get accountRemovedFavorite => 'पसंदीदा सूची से हटाया गया।';

  @override
  String get accountPro => 'प्रो';

  @override
  String get accountAvailableToday => 'आज उपलब्ध';

  @override
  String get accountExperience => 'अनुभव';

  @override
  String get accountCompletedJobs => 'पूरे किए गए काम';

  @override
  String get accountCallArtisan => 'कारीगर को कॉल करें';

  @override
  String get accountWhatsappArtisan => 'कारीगर को WhatsApp करें';

  @override
  String get accountMaskedUnlocked =>
      'सुरक्षित वर्चुअल DID सक्रिय (+91-11-4084-2190) • सीधा संपर्क खुला';

  @override
  String get accountMaskedLocked =>
      'सुरक्षित वर्चुअल कॉल (+91-11-4084-2190) • ₹49 से संपर्क खोलें';

  @override
  String get accountMasterAmount => '₹25,000 मास्टर';

  @override
  String get accountBaseAmount => '₹10,000 बेस';

  @override
  String get accountOnsiteQuestion =>
      'कारीगर मौके पर हैं? एस्क्रो और वारंटी लॉक करें';

  @override
  String get accountMasterShortCover => '₹25 हज़ार मास्टर कवर';

  @override
  String get accountBaseShortCover => '₹10 हज़ार बेस कवर';

  @override
  String get accountVerifiedGuildsman => 'कारीगर सत्यापित गिल्ड सदस्य';

  @override
  String get accountTripleScreened =>
      'घर की सुरक्षा और कुशल काम के लिए तीन स्तर की जाँच';

  @override
  String get accountGovtPolice => 'सरकारी पहचान और पुलिस';

  @override
  String get accountBackgroundCleared => 'पृष्ठभूमि जाँच पूरी';

  @override
  String get accountNsdc => 'NSDC प्रमाणित';

  @override
  String get accountSkillGrade => 'कौशल परीक्षित ग्रेड A';

  @override
  String get accountDamageProtection => 'नुकसान से सुरक्षा';

  @override
  String get accountCalibratedTools => 'कैलिब्रेटेड औज़ार';

  @override
  String get accountToolAudit => 'औज़ार जाँच सफल';

  @override
  String get accountWiring => '3-फेज़ वायरिंग';

  @override
  String get accountInverterSetup => 'इन्वर्टर सेटअप';

  @override
  String get accountMcbDiagnosis => 'MCB स्पार्क की जाँच';

  @override
  String get accountSwitchboards => 'मॉड्यूलर स्विचबोर्ड';

  @override
  String get accountEarthing => 'अर्थिंग की जाँच';

  @override
  String get accountLoadAudit => 'उपकरण लोड की जाँच';

  @override
  String get accountSpecializations => 'विशेषताएँ और कौशल';

  @override
  String get accountShowcase => 'कारीगरी के नमूने';

  @override
  String get accountVerifiedPhotos =>
      'स्थानीय घरों के काम की सत्यापित तस्वीरें';

  @override
  String get accountScorecard => 'कारीगर का स्कोरकार्ड';

  @override
  String get accountPunctuality => 'समय की पाबंदी';

  @override
  String get accountCraftsmanship => 'उत्कृष्ट कारीगरी';

  @override
  String get accountSawdust => 'बुरादा और साफ़-सफ़ाई';

  @override
  String get accountRecentFeedback => 'हाल की ग्राहक प्रतिक्रियाएँ';

  @override
  String get accountVerifiedBookings => 'सत्यापित बुकिंग';

  @override
  String get accountVerifiedMcb => 'सत्यापित MCB स्पार्क मरम्मत';

  @override
  String get accountVerifiedInverter => 'सत्यापित इन्वर्टर सेटअप';

  @override
  String get accountPerVisit => '/ विज़िट';

  @override
  String get accountIncludesWarranty => '₹25 हज़ार गिल्ड वारंटी शामिल';

  @override
  String get accountUnlockTitle => 'सीधा संपर्क खोलें';

  @override
  String get accountPrivacyProtected =>
      '100% गोपनीयता सुरक्षित • असली फ़ोन नंबर छिपा रहता है';

  @override
  String get accountPayPerLead => 'हर संपर्क का भुगतान';

  @override
  String get accountOneTime => 'एक बार';

  @override
  String get accountSingleArtisan => 'एक कारीगर';

  @override
  String get accountDirectoryPass => 'असीमित डायरेक्टरी पास';

  @override
  String get accountPerMonth => '/ महीना';

  @override
  String get accountUnlimitedContact =>
      'सभी 10 सेवाओं और 7 जिलों में असीमित सुरक्षित कॉल और WhatsApp।';

  @override
  String get accountRecommended => 'सुझाया गया';

  @override
  String get accountMaskedBenefit =>
      'सुरक्षित कॉल: असली फ़ोन नंबर छिपा रहता है';

  @override
  String get accountMetaBenefit =>
      'आधिकारिक Meta WhatsApp Cloud API ब्रिज शामिल';

  @override
  String get accountRetroactiveBenefit =>
      'गिल्ड लॉक: मौके पर कभी भी ₹25 हज़ार वारंटी सक्रिय करें';

  @override
  String get accountUnlock49 => '₹49 में खोलें';

  @override
  String get accountActivatePass => 'डायरेक्टरी पास सक्रिय करें (₹499/माह)';

  @override
  String get accountPassActivated =>
      'डायरेक्टरी पास सक्रिय! सभी सेवाओं में असीमित सुरक्षित संपर्क उपलब्ध।';

  @override
  String get accountMasterCover => '₹25,000 मास्टर कवर';

  @override
  String get accountBaseCover => '₹10,000 बेस कवर';

  @override
  String get accountLockVisit =>
      'मौके की विज़िट को औपचारिक एस्क्रो सुरक्षा दें';

  @override
  String get accountDoorstepCode => 'आगमन सत्यापन कोड';

  @override
  String get accountStartCode4921 => 'शुरुआती सत्यापन OTP: 4921';

  @override
  String get accountActive => 'सक्रिय';

  @override
  String get accountUnderwriting =>
      'काम के दौरान संपत्ति के नुकसान के लिए व्यापक सुरक्षा। प्रत्येक दावे पर ग्राहक की ₹250 कटौती लागू है।';

  @override
  String get accountEscrowBreakdown => 'अग्रिम एस्क्रो का विवरण';

  @override
  String get accountInspectionTravel => 'मूल जाँच और यात्रा';

  @override
  String get accountSafetyWarranty => 'प्लैटफ़ॉर्म सुरक्षा शील्ड और वारंटी';

  @override
  String get accountStandbyHold => 'कुल आरक्षित एस्क्रो राशि';

  @override
  String get accountConfirmLock =>
      'पुष्टि करें और एस्क्रो लॉक करें (₹29 शील्ड)';

  @override
  String get accountVerifiedPhone => '+91 9822199882 • सत्यापित घरमालक';

  @override
  String accountPrimaryLocality(Object name, Object pincode) {
    return 'मुख्य: $name, नांदेड़ ($pincode)';
  }

  @override
  String accountSavedAddress(Object name) {
    return '$name • प्लॉट 14, गुरु गोबिंद सिंह जी मार्ग के पास';
  }

  @override
  String accountPrivacyConnection(Object name, Object trade) {
    return 'नंबर छिपाना सक्रिय • असली नंबर निजी • $name ($trade) से जुड़े';
  }

  @override
  String accountWhatsappGreeting(Object name) {
    return 'नमस्कार $name, WhatsApp Cloud Relay से संपर्क कर रहा हूँ।';
  }

  @override
  String accountEmptyBookings(Object tab) {
    return '$tab टैब में कोई बुकिंग नहीं।';
  }

  @override
  String accountBookingReference(Object id) {
    return 'बुकिंग #$id';
  }

  @override
  String accountVoiceNote(Object seconds) {
    return '$seconds सेकंड का वॉइस नोट';
  }

  @override
  String accountStartOtp(Object otp) {
    return 'शुरुआती सत्यापन OTP: $otp';
  }

  @override
  String accountTotalEstimate(Object amount) {
    return 'कुल अनुमान: ₹$amount';
  }

  @override
  String accountDirectLead(Object trade) {
    return 'सीधा ऑन-साइट संपर्क • $trade';
  }

  @override
  String accountOnsiteName(Object name) {
    return '$name (मौके पर जाँच)';
  }

  @override
  String accountCoverLimit(Object amount) {
    return 'कवर सीमा: ₹$amount';
  }

  @override
  String accountFavoriteSaved(Object name) {
    return '$name को पसंदीदा में सहेजा!';
  }

  @override
  String accountSharingProfile(Object name) {
    return '$name की प्रोफ़ाइल लिंक साझा कर रहे हैं...';
  }

  @override
  String accountWithinDistance(Object locality, Object distance) {
    return '$locality • $distance किमी के भीतर';
  }

  @override
  String accountReviewCount(Object count) {
    return '$count समीक्षाएँ';
  }

  @override
  String accountExperienceYears(Object years) {
    return '$years+ वर्ष';
  }

  @override
  String accountArtisanGreeting(Object name, Object trade) {
    return 'नमस्ते $name जी, मुझे कारीगर पर $trade के लिए आपकी प्रोफ़ाइल मिली। क्या आप नांदेड़ में विज़िट के लिए उपलब्ध हैं?';
  }

  @override
  String accountActivateCover(Object cover) {
    return 'एक टैप से $cover कवर और ₹29 सुरक्षा शील्ड सक्रिय करें';
  }

  @override
  String accountCertifiedCount(Object count) {
    return '$count प्रमाणित';
  }

  @override
  String accountViewAllCount(Object count) {
    return 'सभी देखें ($count)';
  }

  @override
  String accountBookName(Object name) {
    return 'अभी $name को बुक करें';
  }

  @override
  String accountConnectName(Object name, Object trade) {
    return '$name ($trade) से संपर्क करें';
  }

  @override
  String accountProxyDescription(Object number) {
    return 'वर्चुअल प्रॉक्सी से कॉल और WhatsApp: $number';
  }

  @override
  String accountUnlockDays(Object name) {
    return '$name से 30 दिन के लिए सुरक्षित कॉल और WhatsApp संपर्क खोलें।';
  }

  @override
  String accountContactUnlocked(Object number) {
    return 'सीधा संपर्क खुला! $number से कॉल उपलब्ध।';
  }

  @override
  String accountUnlockFailed(Object error) {
    return 'संपर्क खोलने में विफल: $error';
  }

  @override
  String accountArrivalInstructions(Object name) {
    return 'आगमन सत्यापित करने और टाइमर शुरू करने के लिए मौके पर $name को यह 4 अंकों का कोड दें।';
  }

  @override
  String accountCoverActive(Object cover) {
    return '$cover सक्रिय';
  }

  @override
  String accountLockedBooking(Object name) {
    return 'मौके की बुकिंग लॉक हुई! $name को स्टार्ट OTP 4921 दें।';
  }

  @override
  String get accountClaimError =>
      'दावा भेजा नहीं जा सका। राशि और वारंटी पात्रता जाँचकर फिर कोशिश करें।';

  @override
  String sharedSavePercent(int percent) {
    return '$percent% की बचत';
  }

  @override
  String get accountStatusAll => 'सभी';

  @override
  String get accountStatusEnRoute => 'रास्ते में';

  @override
  String get accountStatusUpcoming => 'आगामी';

  @override
  String get accountStatusCompleted => 'पूरे हुए';

  @override
  String get accountStatusInProgress => 'काम जारी है';
}
