// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get languageName => 'मराठी';

  @override
  String get languageSetting => 'अॅपची भाषा';

  @override
  String get chooseLanguage => 'तुमची भाषा निवडा';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get searchServices => 'काम, साहित्य किंवा कारागीर शोधा';

  @override
  String get browseServices => 'सेवा पाहा';

  @override
  String get allTrades => 'सर्व सेवा';

  @override
  String get explore => 'शोधा';

  @override
  String get bookings => 'बुकिंग्ज';

  @override
  String get messages => 'संदेश';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get quickServiceSearch => 'सेवा शोधा';

  @override
  String get selectServicePrompt =>
      'तुम्हाला कोणत्या कामासाठी मदत हवी आहे? टाइल, ग्रॅनाइट किंवा प्लंबिंग शोधा.';

  @override
  String inspectionWarranty(Object fee, Object days) {
    return 'तपासणी ₹$fee • $days दिवसांची वॉरंटी';
  }

  @override
  String get noServicesFound =>
      'जुळणारी सेवा सापडली नाही. दुसरे काम किंवा व्यवसाय शोधा.';

  @override
  String get brandTagline => 'कुशल कारागीर, आधुनिक सेवा';

  @override
  String get loginAsHomeowner => 'घरमालक म्हणून लॉग इन करा';

  @override
  String get artisanGuildPortal => 'कारागीर गिल्ड पोर्टल';

  @override
  String get homeownerTagline => '25 मिनिटांत पडताळलेले कारागीर बुक करा';

  @override
  String get artisanTagline => 'जवळची कामे घ्या आणि तुमचे वॉलेट पाहा';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get enterPhoneNumber => '10 अंकी नंबर टाका';

  @override
  String get invalidPhoneNumber => 'कृपया योग्य 10 अंकी मोबाइल नंबर टाका';

  @override
  String get continueWithWhatsApp => 'WhatsApp वरून पुढे जा';

  @override
  String get getOtpViaSms => 'SMS वरून OTP मिळवा';

  @override
  String get joinGuild =>
      'नवीन कारागीर? नांदेड गिल्डमध्ये सामील व्हा (0% शुल्क)';

  @override
  String get trustFooter =>
      'आधार आणि पोलिस पडताळलेले कारागीर • पायलट शहर: नांदेड';

  @override
  String get homeowner => 'घरमालक';

  @override
  String get homeownerMode => 'घरमालक मोड';

  @override
  String get karigaar => 'कारागीर';

  @override
  String get artisanMode => 'कारागीर मोड';

  @override
  String get launchTrades => '10 प्रमुख सेवा';

  @override
  String districtGuild(Object district) {
    return '$district गिल्ड';
  }

  @override
  String get shieldCommitment => 'कारागीर सुरक्षा वचन';

  @override
  String topRatedInDistrict(Object district) {
    return '$district मधील उत्तम कारागीर';
  }

  @override
  String yearsExperience(Object years) {
    return '$years वर्षांचा अनुभव';
  }

  @override
  String reviewsAndDistance(Object reviews, Object distance) {
    return '$reviews अभिप्राय • $distance किमी दूर';
  }

  @override
  String get diagnosticInspection => 'तपासणी शुल्क';

  @override
  String get bookArtisan => 'कारागीर बुक करा';

  @override
  String get servicesLoadError => 'सेवा लोड झाल्या नाहीत. पुन्हा प्रयत्न करा.';

  @override
  String get authOtpVerification => 'OTP पडताळणी';

  @override
  String get authVerifyWhatsAppCode => 'WhatsApp कोड पडताळा';

  @override
  String get authCodeSent => 'आम्ही 6 अंकी पडताळणी कोड पाठवला आहे\n';

  @override
  String get authResendCode => 'WhatsApp वरून कोड पुन्हा पाठवा';

  @override
  String get authFallbackSms => 'DLT गेटवेद्वारे SMS पाठवला.';

  @override
  String get authSmsFallback => 'WhatsApp वर मिळाला नाही? SMS ने पाठवा';

  @override
  String get authVerifyContinue => 'पडताळा आणि पुढे जा';

  @override
  String get authStepPersonal => 'टप्पा 1/4: वैयक्तिक माहिती';

  @override
  String get authStepTrade => 'टप्पा 2/4: व्यवसाय निवडा';

  @override
  String get authStepAudit => 'टप्पा 3/4: KYC व साधन तपासणी';

  @override
  String get authStepPayout => 'टप्पा 4/4: पेआउट व संरक्षण';

  @override
  String get authLegalNameError =>
      'कृपया आधारवरील पूर्ण नाव आणि 10 अंकी मोबाइल नंबर टाका.';

  @override
  String get authTradeError => 'कृपया 10 सेवांमधून तुमचा मुख्य व्यवसाय निवडा.';

  @override
  String get authAadhaarError => 'कृपया योग्य 12 अंकी आधार नंबर टाका.';

  @override
  String get authJoinGuild => 'कारागीर गिल्डमध्ये सामील व्हा';

  @override
  String get authAlreadyRegistered =>
      'गिल्डमध्ये आधीच नोंदणी केली आहे? येथे लॉग इन करा';

  @override
  String get authAccreditation => 'गिल्ड मान्यता';

  @override
  String get authCommissionGuarantee => 'किमान 5% कमिशनची हमी';

  @override
  String get authJoinDescription =>
      'तुमच्या पिनकोडमधील ग्राहकांशी थेट संपर्क साधा. पारदर्शक दैनिक पेआउट आणि गिल्ड मास्टर विमा संरक्षण.';

  @override
  String get authAverageEarnings => 'सरासरी कमाई ₹42,000/महिन्यापेक्षा अधिक';

  @override
  String get authGuildProfessionals =>
      'नांदेड गिल्डमधील 12,400+ पडताळलेल्या व्यावसायिकांमध्ये सामील व्हा';

  @override
  String get authPersonalHeading => 'टप्पा 1: वैयक्तिक माहिती व परिसर';

  @override
  String get authPersonalDescription =>
      'KYC, गिल्ड ओळख आणि थेट पेआउटसाठी तुमची कायदेशीर माहिती';

  @override
  String get authFullName => 'पूर्ण कायदेशीर नाव';

  @override
  String get authMatchesAadhaar => 'आधार कार्डप्रमाणे';

  @override
  String get authNameHint => 'उदा. रमेश चंद्र शर्मा';

  @override
  String get authWhatsAppNumber => 'WhatsApp मोबाइल नंबर';

  @override
  String get authInstantOtp => 'त्वरित OTP पाठवा';

  @override
  String get authWhatsAppHint => '10 अंकी WhatsApp नंबर टाका';

  @override
  String get authEmergencyContact => 'आपत्कालीन संपर्क (जवळचे नातेवाईक)';

  @override
  String get authContactName => 'संपर्काचे नाव';

  @override
  String get authPhoneHint => '10 अंकी फोन नंबर';

  @override
  String get authWorkingLocality => 'मुख्य कामाचा परिसर';

  @override
  String get authExperience => 'कामाचा अनुभव';

  @override
  String get authPriorityLeads => 'उच्च स्तराला कामात प्राधान्य मिळते';

  @override
  String get authDispatchAlerts => 'WhatsApp कामाच्या सूचना';

  @override
  String get authDispatchDescription =>
      'आपत्कालीन कामे, दैनिक पेआउट पावत्या आणि गिल्ड वॉरंटी सूचना त्वरित मिळवा.';

  @override
  String get authReferralQuestion => 'मास्टर कारागिराचा रेफरल कोड आहे का?';

  @override
  String get authReferralHint => 'उदा. GUILD500';

  @override
  String get authReferralApplied =>
      'रेफरल कोड GUILD500 लागू झाला! ₹500 प्रवेश बोनस मिळाला.';

  @override
  String get authApply => 'लागू करा';

  @override
  String get authPrimaryTrade => 'मुख्य व्यवसाय निवडा';

  @override
  String get authPrimaryTradeDescription =>
      'नांदेडच्या 10 सेवांमधून तुमचा प्रमाणित व्यवसाय निवडा';

  @override
  String get authOneRequired => '1 आवश्यक';

  @override
  String get authRoleType => 'कारागिराची भूमिका';

  @override
  String get authKycHeading => 'टप्पा 3: आधार KYC व साधन तपासणी';

  @override
  String get authKycDescription =>
      'गिल्ड सुरक्षा गुणांकनासाठी बायोमेट्रिक पडताळणी आणि साधनांची तपासणी यादी';

  @override
  String get authAadhaarNumber => '12 अंकी आधार नंबर';

  @override
  String get authEncrypted => 'एन्क्रिप्टेड व UIDAI अनुरूप';

  @override
  String get authTradeCard => 'आधार / व्यवसाय कार्ड';

  @override
  String get authFrontSync => 'पुढील बाजूचा फोटो व DigiLocker सिंक';

  @override
  String get authDigilockerSuccess =>
      'DigiLocker KYC गेटवे यशस्वीपणे सिंक झाला!';

  @override
  String get authFrontCaptured => 'आधारच्या पुढील बाजूचे स्कॅन घेतले';

  @override
  String get authCaptureAadhaar => 'आधार कार्डच्या पुढील बाजूचा फोटो घ्या';

  @override
  String get authPhotoLimit => 'स्पष्ट फोटो • कमाल 10MB (JPG/PNG)';

  @override
  String get authAutoVerified => '72% स्वयंचलित पडताळणी';

  @override
  String get authUpload => 'अपलोड करण्यासाठी टॅप करा';

  @override
  String get authToolsAudit => 'कॅलिब्रेट केलेल्या साधनांची तपासणी';

  @override
  String get authSafetyStandard => 'गिल्ड सुरक्षा मानक';

  @override
  String get authMultimeter =>
      'डिजिटल True-RMS मल्टीमीटर व फेज टेस्टर (कॅलिब्रेट केलेले)';

  @override
  String get authInsulatedTools =>
      '1000V इन्सुलेटेड स्क्रूड्रायव्हर व प्लायर संच';

  @override
  String get authDrillTools => 'हेवी ड्युटी रोटरी हॅमर ड्रिल व सुरक्षा चष्मा';

  @override
  String get authCleanupTools =>
      'कॅनव्हास ड्रॉप-क्लॉथ व भुसा सफाई व्हॅक्यूम बॅग';

  @override
  String get authPayoutHeading => 'टप्पा 4: बँक / UPI पेआउट पडताळणी';

  @override
  String get authPayoutDescription =>
      'शून्य गिल्ड शुल्कासह 10 सेकंदांत IMPS पेआउटसाठी बँक किंवा UPI ID जोडा';

  @override
  String get authDirectPayout => 'त्वरित गिल्ड थेट पेआउट';

  @override
  String get authBankAccount => 'बँक खाते क्रमांक';

  @override
  String get authReenterBank => 'बँक खाते क्रमांक पुन्हा टाका';

  @override
  String get authIfsc => 'IFSC कोड';

  @override
  String get authBranchResolved =>
      'शाखा सापडली: HDFC बँक, वजीराबाद शाखा, नांदेड (431601)';

  @override
  String get authUpiPayout => 'UPI जलद पेआउट VPA';

  @override
  String get authPennyDrop => 'पेनी-ड्रॉप पडताळलेले';

  @override
  String get authVerifiedUpi => 'पडताळलेले UPI ID / VPA (₹0 IMPS शुल्क)';

  @override
  String get authPennyDropSimulation =>
      'डेमो ₹1 IMPS पेनी-ड्रॉप चाचणी यशस्वी. पेआउट वॉलेट जोडले.';

  @override
  String get authProtectionActive => '₹25,000 गिल्ड संरक्षण कवच सक्रिय';

  @override
  String get authProtectionDescription =>
      'कारागीर साइटवरील अपघाती मालमत्ता नुकसानीसाठी ₹25,000 पर्यंत संरक्षण देतो. शून्य दायित्व आणि किमान 5% कमिशन हमीसह (गिल्ड एलिट) कमवा.';

  @override
  String get authBack => 'मागे';

  @override
  String get authNextStep => 'पुढील टप्पा';

  @override
  String get authVerifyWhatsApp => 'WhatsApp OTP ने पडताळा';

  @override
  String get jobInvalidStart =>
      'चुकीचा कोड! ग्राहकाला त्यांचा 4 अंकी प्रारंभ कोड विचारा.';

  @override
  String get jobAccessDenied => 'दाराशी प्रवेश नाकारला';

  @override
  String get jobCloseJob => 'काम बंद करा';

  @override
  String get jobAddPart2fa => '2FA सह सुटा भाग जोडा';

  @override
  String get jobPartName => 'भागाचे नाव व तपशील';

  @override
  String get jobUnitPrice => 'प्रति नग किंमत (₹)';

  @override
  String get jobStoreName => 'हार्डवेअर दुकानाचे नाव';

  @override
  String get jobAttachReceipt => 'हार्डवेअर दुकानाच्या पावतीचा फोटो जोडा';

  @override
  String get jobPartsDisclaimer =>
      'सुट्या भागांवर 2% पेमेंट गेटवे अधिभार लागतो आणि अॅपमध्ये ग्राहकाची RBI 2FA मंजुरी मागितली जाते.';

  @override
  String get jobCancel => 'रद्द करा';

  @override
  String get jobAddPartBill => 'बिलात भाग जोडा';

  @override
  String get jobInvoiceSubmitted =>
      'तपशीलवार बिल पाठवले! ग्राहकाला बिल तपासून PIN देण्याची सूचना मिळाली.';

  @override
  String get jobActiveBill => 'सक्रिय काम व बिल तयार करा';

  @override
  String get jobStopwatch => 'साइटवरील दुरुस्तीचा वेळ';

  @override
  String get jobElapsed => '28 मि. 14 से. झाले';

  @override
  String get jobLiveLog => 'थेट नोंद';

  @override
  String get jobGpsStreaming => 'थेट GPS टेलीमेट्री स्ट्रीमिंग (करार 3)';

  @override
  String get jobForeground => 'अग्रभाग (3 से.)';

  @override
  String get jobBackground => 'पार्श्वभूमी (15 से.)';

  @override
  String get jobSpeed => 'वेग';

  @override
  String get jobHeading => 'दिशा';

  @override
  String get jobBattery => 'बॅटरी';

  @override
  String get jobRemaining => 'उर्वरित';

  @override
  String get jobGeofence => '200 मीटर जिओफेन्स सक्रिय! प्रारंभ कोडसाठी तयार.';

  @override
  String get jobEnterStart => 'टप्पा 1: ग्राहकाचा प्रारंभ कोड टाका';

  @override
  String get jobStartDescription =>
      'पोहोचल्याची पुष्टी करण्यासाठी घरमालकाला 4 अंकी सुरक्षा कोड विचारा (डेमो: 4921).';

  @override
  String get jobStartHint => '4 अंकी प्रारंभ कोड टाका';

  @override
  String get jobVerifyBegin => 'कोड पडताळून दुरुस्ती सुरू करा';

  @override
  String get jobDeniedTransit => 'प्रवेश नाकारला (₹80 प्रवास शुल्क मागा)';

  @override
  String get jobStartComplete =>
      'प्रारंभ कोड 4921 पडताळला • आगमनाची पुष्टी पूर्ण';

  @override
  String get jobBillBuilder => 'बिल तयार करा';

  @override
  String get jobCustomPart => 'कस्टम भाग';

  @override
  String get jobAddPart => 'भाग जोडा';

  @override
  String get jobLaborDiagnostic => 'मजुरी व निदान तपासणी';

  @override
  String get jobReceiptAttached => 'पावतीचा फोटो जोडला';

  @override
  String get jobLaborBase => 'मजुरी व तपासणीचे मूळ शुल्क';

  @override
  String get jobPartsSurcharge => 'भागांवर 2% गेटवे अधिभार';

  @override
  String get jobGst => '18% GST (मजुरी व अधिभार)';

  @override
  String get jobTotalInvoiced => 'ग्राहकाचे एकूण बिल';

  @override
  String get jobWaitingPin =>
      'तपशीलवार बिल पाठवले • ग्राहकाच्या PIN ची प्रतीक्षा';

  @override
  String get jobSubmitInvoice => 'तपशीलवार बिल सादर करा (स्वतंत्र टप्पा)';

  @override
  String get jobCompletionHeading => 'टप्पा 3: काम पूर्ण झाल्याचा PIN घ्या';

  @override
  String get jobCompletionDescription =>
      'ग्राहकाला 4 अंकी पूर्णता PIN विचारा (डेमो: 7294)';

  @override
  String get jobCompletionHint => '4 अंकी पूर्णता PIN टाका';

  @override
  String get jobPayoutSettled => 'IMPS पेआउट पूर्ण!';

  @override
  String get jobBackRadar => 'रडारकडे परत';

  @override
  String get jobInvalidCompletion => 'चुकीचा पूर्णता PIN! डेमोसाठी 7294 टाका.';

  @override
  String get jobElitePartner => 'गिल्ड एलिट भागीदार';

  @override
  String get jobGoldGuildsman => 'गोल्ड गिल्ड कारागीर';

  @override
  String get jobFloorActive => 'किमान 5% कमिशन सक्रिय';

  @override
  String get jobTier4 => 'स्तर 4 कारागीर';

  @override
  String get jobTakeRate => '💎 5% कमिशन';

  @override
  String get jobTopPartner => 'अव्वल 5% भागीदार';

  @override
  String get jobApprentice => 'शिकाऊ\n(15%)';

  @override
  String get jobPro => 'प्रो\n(12%)';

  @override
  String get jobMaster => 'मास्टर\n(8%)';

  @override
  String get jobElite => 'एलिट\n(किमान 5%)';

  @override
  String get jobEliteMilestone => 'गिल्ड एलिट टप्पा: अनलॉक';

  @override
  String get jobMasterMilestone => 'टप्पा: मास्टर कारागीर (8%)';

  @override
  String get jobJobsProgress => '42 / 50 कामे';

  @override
  String get jobEliteDescription =>
      'गिल्ड एलिट सक्रिय! 5% कमिशनसह बिलातील 95% तुम्हाला मिळतात.';

  @override
  String get jobMasterDescription =>
      '8% मास्टर स्तरासाठी आणखी 8 कामे पूर्ण करा, किंवा 5% कमिशनसाठी गिल्ड एलिट घ्या!';

  @override
  String get jobKarigaarElite => 'कारागीर गिल्ड एलिट भागीदार';

  @override
  String get jobKeep95 => 'किमान 5% कमिशन (95% ठेवा)';

  @override
  String get jobMonthlyDeduction =>
      '₹999 / महिना • एका टॅपमध्ये वॉलेटमधून कपात';

  @override
  String get jobEliteBenefitFees =>
      '• किमान 5% कमिशन (प्लॅटफॉर्म शुल्कात ₹4,500/महिना पर्यंत बचत)\n';

  @override
  String get jobEliteBenefitRadar =>
      '• सामान्य भागीदारांपूर्वी 10 सेकंद आधी प्राधान्य रडार सूचना\n';

  @override
  String get jobEliteBenefitImps =>
      '• ₹0 त्वरित IMPS पेआउट शुल्क (गेटवे शुल्क प्लॅटफॉर्म देतो)\n';

  @override
  String get jobEliteBenefitBadge => '• ग्राहकांना गोल्डन गिल्ड एलिट बॅज दिसतो';

  @override
  String get jobUpgradeElite => 'गिल्ड एलिटमध्ये अपग्रेड करा (₹999/महिना)';

  @override
  String get jobEliteLocked =>
      '💎 गिल्ड एलिट सक्रिय • 5% कमिशन निश्चित • पुढील बिल 30 दिवसांत';

  @override
  String get jobSubscribeElite => 'गिल्ड एलिटची सदस्यता घ्या';

  @override
  String get jobLockFloor => 'टिकाऊ किमान 5% कमिशन निश्चित करा';

  @override
  String get jobSubscriptionFee => 'मासिक सदस्यता शुल्क';

  @override
  String get jobWalletBalance => 'सध्याची वॉलेट शिल्लक';

  @override
  String get jobPostDeduction => 'कपातीनंतरची शिल्लक';

  @override
  String get jobSubscribed =>
      'गिल्ड एलिट सदस्यता घेतली! किमान 5% कमिशन सक्रिय.';

  @override
  String get jobConfirmDeduct => 'पुष्टी करा आणि वॉलेटमधून ₹999 कापा';

  @override
  String get jobGuildWallet => 'गिल्ड वॉलेट';

  @override
  String get jobImpsLive => 'त्वरित IMPS सक्रिय';

  @override
  String get jobClearedPayout => 'उपलब्ध पेआउट रक्कम';

  @override
  String get jobLockedReserve => 'राखीव रक्कम';

  @override
  String get jobAvailablePayout => 'उपलब्ध पेआउट';

  @override
  String get jobWithdrawBank => 'UPI / IMPS ने बँकेत काढा (₹0 शुल्क)';

  @override
  String get jobSupport => 'कारागीर भागीदार सहाय्य';

  @override
  String get jobWeeklySummary => 'साप्ताहिक कमाईचा सारांश WhatsApp वर पाठवा';

  @override
  String get jobVerifiedVault => 'पडताळलेले गिल्ड व्हॉल्ट';

  @override
  String get jobNoBalance => 'काढण्यासाठी उपलब्ध शिल्लक नाही.';

  @override
  String get jobReserveRequired =>
      'रक्कम काढता येत नाही. अनिवार्य ₹2,000 सुरक्षा राखीव ठेवणे आवश्यक आहे.';

  @override
  String get jobInstantPayout => 'त्वरित IMPS पेआउट';

  @override
  String get jobReserveLocked =>
      'अनिवार्य ₹2,000 सुरक्षा रक्कम गिल्ड व्हॉल्टमध्ये राखीव आहे.';

  @override
  String get jobBankNanded => 'बँक: HDFC बँक लिमिटेड (नांदेड मुख्य शाखा)';

  @override
  String get jobMaskedAccount => 'खाते: •••• •••• 2104';

  @override
  String get jobPayoutFee => 'पेआउट शुल्क: ₹0.00 (गिल्ड भरेल)';

  @override
  String get jobConfirmPayout => 'IMPS पेआउटची पुष्टी करा';

  @override
  String get jobRecentActivity => 'अलीकडील व्यवहार';

  @override
  String get jobViewLedger => 'खातेवही पाहा';

  @override
  String get jobWiringRepair => 'MCB व वायरिंग दुरुस्ती';

  @override
  String get jobActivityToday => 'आनंद नगर, नांदेड • आज, सकाळी 11:20';

  @override
  String get jobDailyPayout => 'HDFC ला दैनिक पेआउट';

  @override
  String get jobActivityYesterday => 'संदर्भ #IMPS99824 • काल';

  @override
  String get jobGuildGuarantee =>
      'गिल्ड हमी: सेवा कपातीशिवाय 24/7 त्वरित IMPS पेआउट प्रक्रियेची हमी.';

  @override
  String get jobProfileUpdated =>
      'प्रोफाइल व दरपत्रक अद्ययावत करून जिल्हा निर्देशिकेशी सिंक केले!';

  @override
  String get jobBioHint => 'तुमचे कौशल्य व सुरक्षा साधने सांगा...';

  @override
  String get jobWorkPhotoHint => 'उदा. 6-वे डिस्ट्रिब्युशन बॉक्स उभारणी';

  @override
  String get jobNandedGuild => 'नांदेड व्यवसाय गिल्ड';

  @override
  String get jobJobsRating => '4.9★ (340 कामे)';

  @override
  String get jobEmergency => 'आपत्कालीन बिघाड';

  @override
  String get jobOnePhoto => '1 फोटो';

  @override
  String get jobBroadcastTimeout =>
      'वेळेत काम स्वीकारले नाही. शोध प्रादेशिक गिल्डपर्यंत वाढवला.';

  @override
  String get jobScanning => 'नांदेडमध्ये नवीन कामे शोधत आहोत...';

  @override
  String get jobDutyPaused => 'ड्युटी थांबली आहे. कामासाठी ऑनलाइन व्हा.';

  @override
  String get jobKeepActive =>
      '45 सेकंदांच्या प्राधान्य सूचनांसाठी अॅप सक्रिय ठेवा';

  @override
  String get jobVoiceExample =>
      'ग्राहकाची ध्वनिनोंद: \"AC सुरू केल्यावर MCB मध्ये ठिणग्या येतात. 32A बदलणे आवश्यक आहे.\"';

  @override
  String get jobPausePreview => 'पूर्वावलोकन थांबवा';

  @override
  String get jobListenMemo => 'ग्राहकाची ध्वनिनोंद ऐका';

  @override
  String get localitySelect => 'परिसर निवडा';

  @override
  String get localityPilotDistrict => 'पायलट शहर: नांदेड-वाघाळा (महाराष्ट्र)';

  @override
  String localityDistrict(String district) {
    return 'जिल्हा: $district';
  }

  @override
  String get localitySearchHint => 'परिसर किंवा PIN कोड शोधा';

  @override
  String localityEmptyText(String city) {
    return '$city मध्ये परिसर सापडला नाही';
  }

  @override
  String localityChanged(String name, String pincode) {
    return 'सेवा केंद्र $name ($pincode) येथे बदलले';
  }

  @override
  String get emergencyTitle => 'तातडीची दुरुस्ती? (२५ मिनिटे)';

  @override
  String get emergencyDispatch => 'तात्काळ घरपोच सेवा';

  @override
  String get emergencyCoverage =>
      'नांदेडमध्ये इलेक्ट्रीशियन आणि प्लंबर तयार आहेत';

  @override
  String get emergencyBookFast => 'लवकर बुक करा';

  @override
  String get skeletonTradesHeading => 'प्रमाणित गिल्ड सेवा';

  @override
  String catalogTradeName(String id, String fallback) {
    String _temp0 = intl.Intl.selectLogic(
      id,
      {
        'trade_electrician': 'इलेक्ट्रिशियन',
        'trade_plumber': 'प्लंबर (नळ कारागीर)',
        'trade_carpenter': 'सुतार (कारपेंटर)',
        'trade_mason': 'गवंडी / सिव्हिल कामगार',
        'trade_painter': 'रंगारी (पेंटर)',
        'trade_ac_refrig': 'एसी आणि फ्रीज मेकॅनिक',
        'trade_appliance': 'घरगुती उपकरणे दुरुस्ती',
        'trade_welder': 'वेल्डर / लोहार कामगार',
        'trade_pest': 'कीटक नियंत्रण (पेस्ट कंट्रोल)',
        'trade_deep_cleaning': 'डीप क्लीनिंग (स्वच्छता सेवा)',
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
            'शॉर्ट सर्किट, MCB, स्विचबोर्ड आणि मोठ्या उपकरणांची वायरिंग',
        'trade_plumber':
            'पाइप गळती, नळ बदलणे, तुंबलेली गटारे आणि सॅनिटरी फिटिंग',
        'trade_carpenter':
            'दरवाजाचे कुलूप, किचनची बिजागरी, लाकडी दुरुस्ती आणि फर्निचर जोडणी',
        'trade_mason':
            'फरशी बदलणे, भिंतीचे प्लास्टर, काँक्रीट ड्रिलिंग आणि जलरोधक काम',
        'trade_painter':
            'भिंतीचे रंगकाम, ओलाव्याचा उपचार, दरवाजाची पॉलिश आणि घराची रंगरंगोटी',
        'trade_ac_refrig':
            'फोम जेट स्वच्छता, गॅस भरणे, कंप्रेसर तपासणी आणि कूलिंग समस्या',
        'trade_appliance':
            'वॉशिंग मशीन, मायक्रोवेव्ह, गिझर, मिक्सर ग्राइंडर आणि RO प्युरिफायर',
        'trade_welder':
            'गेटच्या बिजागरीचे वेल्डिंग, सुरक्षा जाळी, रेलिंग आणि शेडची दुरुस्ती',
        'trade_pest':
            'झुरळांवरील जेल उपचार, वाळवीरोधक ड्रिलिंग आणि ढेकूण नियंत्रण',
        'trade_deep_cleaning':
            'बाथरूमचा थर काढणे, किचनची चरबी साफ करणे आणि सोफा धुलाई',
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
        'pkg_elec_mcb': 'शॉर्ट सर्किट आणि MCB ट्रिपिंग',
        'pkg_elec_switchboard': 'स्विचबोर्ड आणि सॉकेट दुरुस्ती',
        'pkg_elec_fan': 'छताचा पंखा / झुंबर बसवणे',
        'pkg_elec_inverter': 'इन्व्हर्टर आणि बॅटरी वायरिंग',
        'pkg_plumb_leak': 'पाण्याच्या पाइप जोडाची गळती दुरुस्ती',
        'pkg_plumb_drain': 'किचन सिंक आणि बाथरूमचे तुंबलेले गटार मोकळे करणे',
        'pkg_plumb_tap': 'नळ / मिक्सर / डायव्हर्टर बदलणे',
        'pkg_plumb_tank': 'वरच्या टाकीचा फ्लोट व्हॉल्व्ह आणि मोटर लाइन',
        'pkg_carp_lock': 'मुख्य दरवाजाचा डेडबोल्ट / गोदरेज कुलूप दुरुस्ती',
        'pkg_carp_hinge': 'कॅबिनेट आणि कपाटाची हायड्रॉलिक बिजागरी बदलणे',
        'pkg_carp_door_trim': 'घासणारा दरवाजा आणि चौकट रंधणे',
        'pkg_carp_furniture': 'पलंग / टेबल जोडणी आणि मजबुतीकरण',
        'pkg_mason_tile': 'तुटलेली फरशी / भिंतीची टाइल दुरुस्ती (4 पर्यंत)',
        'pkg_mason_plaster': 'भिंतीच्या भेगा आणि प्लास्टर दुरुस्ती',
        'pkg_mason_waterproof': 'बाथरूम / बाल्कनी कोपऱ्यांचे जलरोधक काम',
        'pkg_paint_patch': 'एका भिंतीची दुरुस्ती आणि रंगकाम (पुट्टी + रंग)',
        'pkg_paint_damp': 'ओलावारोधक रासायनिक थर आणि टॉपकोट',
        'pkg_paint_wood': 'दरवाजा आणि खिडकीची इनॅमल / मेलामाइन पॉलिश',
        'pkg_ac_deep_clean': 'स्प्लिट AC फोम जेट सखोल सर्व्हिस',
        'pkg_ac_gas_leak': 'AC गॅस गळती तपासणी आणि भराई',
        'pkg_fridge_cooling': 'फ्रिजचे कमी कूलिंग / डीफ्रॉस्ट दुरुस्ती',
        'pkg_app_geyser': 'इन्स्टंट / स्टोरेज गिझर हीटिंग एलिमेंट दुरुस्ती',
        'pkg_app_washing': 'वॉशिंग मशीन स्पिन / ड्रेन ड्रम समस्या',
        'pkg_app_ro': 'RO प्युरिफायर मेम्ब्रेन आणि फिल्टर सर्व्हिस',
        'pkg_weld_gate': 'मुख्य स्लायडिंग / स्विंग गेट बिजागरीचे आर्क वेल्डिंग',
        'pkg_weld_grill': 'बाल्कनी आणि खिडकीची सुरक्षा जाळी मजबूत करणे',
        'pkg_weld_sheet': 'टिन शेड आणि पॉलीकार्बोनेट छत ब्रॅकेट दुरुस्ती',
        'pkg_pest_cockroach': 'किचन आणि बाथरूम हर्बल जेल उपचार',
        'pkg_pest_termite': 'लाकडातील वाळवीसाठी ड्रिल आणि रासायनिक संरक्षण',
        'pkg_pest_bedbug': 'ढेकणांचा 2-टप्पे उष्णता आणि स्प्रे उपचार',
        'pkg_clean_bath': 'बाथरूममधील कडक पाण्याचे डाग आणि टाइल थर स्वच्छता',
        'pkg_clean_kitchen': 'मॉड्युलर किचन चिमणी आणि ओट्याची चरबी स्वच्छता',
        'pkg_clean_sofa': '5-आसनी कापडी सोफ्याची शॅम्पू आणि ओली स्वच्छता',
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
            'वारंवार ट्रिपिंग, ठिणगी व न्यूट्रल दोष तपासणी आणि फ्यूज दुरुस्ती',
        'pkg_elec_switchboard':
            'सैल स्विच, जळलेले संपर्क आणि 16A पावर सॉकेट बसवणे',
        'pkg_elec_fan': 'अँकर रॉड बसवणे, रेग्युलेटर वायरिंग आणि कंपन कमी करणे',
        'pkg_elec_inverter':
            'बॅकअप बायपास लाइन, जड लोड टर्मिनल आणि बॅटरी पाण्याची तपासणी',
        'pkg_plumb_leak':
            'CPVC/PVC पाइप जोडाचे सोल्डरिंग आणि भिंतीतील गळती तपासणी',
        'pkg_plumb_drain':
            'उच्च दाबाच्या यांत्रिक ऑगरने गटार आणि ट्रॅप स्वच्छता',
        'pkg_plumb_tap':
            'सिरेमिक स्पिंडल बदलणे, क्वार्टर-टर्न व्हॉल्व्ह बसवणे आणि टेफ्लॉन सीलिंग',
        'pkg_plumb_tank': 'बॉल कॉक ऑटो कट-ऑफ व्हॉल्व्ह बदलणे आणि एअर लॉक काढणे',
        'pkg_carp_lock':
            'सिलिंडर बदलणे, अडकलेली कडी सरळ करणे आणि पितळी स्ट्राइक प्लेट बसवणे',
        'pkg_carp_hinge':
            'सॉफ्ट-क्लोज बिजागरीचा ताण आणि प्लायवूड स्क्रूची पकड दुरुस्ती',
        'pkg_carp_door_trim':
            'खालचा भाग अचूक कापणे आणि पावसात फुगलेले लाकूड दुरुस्त करणे',
        'pkg_carp_furniture':
            'बोल्ट घट्ट करणे, लाकडी ब्रॅकेट मजबूत करणे आणि वाळवी तपासणी',
        'pkg_mason_tile':
            'चिकटवण्याचा थर, लेझर समतलीकरण आणि बुरशीरोधक एपॉक्सी ग्राउटिंग',
        'pkg_mason_plaster':
            'पॉलिमर मिश्रित सिमेंट, V-ग्रूव्ह कटिंग आणि गुळगुळीत फिनिश',
        'pkg_mason_waterproof': 'स्कर्टिंगवर Dr. Fixit रासायनिक आवरणाचे 2 थर',
        'pkg_paint_patch':
            'घासणे, ॲक्रेलिक पुट्टी, प्राइमरचे 2 थर आणि रंग जुळवणे',
        'pkg_paint_damp': 'क्षारांचा थर काढणे आणि सिलिकॉन डॅम्प-लॉक उपचार',
        'pkg_paint_wood': 'बारीक सँडपेपरने घासणे आणि चमकदार PU कोटिंग',
        'pkg_ac_deep_clean':
            'आतील कॉइलची जीवाणुरोधक फोम धुलाई, बाहेरील ब्लोअर आणि फिल्टर निर्जंतुकीकरण',
        'pkg_ac_gas_leak':
            'नायट्रोजन दाबाने गळती तपासणी, फ्लेअर नट ब्रेझिंग आणि R32/R410A व्हॅक्यूम चार्जिंग',
        'pkg_fridge_cooling':
            'थर्मोस्टॅट कॅलिब्रेशन, बायमेटल सेन्सर बदलणे आणि कॅपिलरी फ्लश',
        'pkg_app_geyser':
            'तांब्याच्या हीटिंग कॉइलचा थर काढणे आणि सुरक्षा थर्मोस्टॅट तपासणी',
        'pkg_app_washing':
            'मोटर बेल्ट घट्ट करणे, ड्रेन पंप फिल्टर मोकळा करणे आणि PCB रिले तपासणी',
        'pkg_app_ro':
            'TDS कॅलिब्रेशन, सेडिमेंट व कार्बन फिल्टर बदलणे आणि बूस्टर पंप तपासणी',
        'pkg_weld_gate':
            'माइल्ड स्टील बॉल-बेअरिंग पिव्हट वेल्डिंग, स्लॅग काढणे आणि गंजरोधक प्राइमर',
        'pkg_weld_grill':
            'सैल अँकर पिनचे टॅक वेल्डिंग आणि अँगल आयर्न मजबुतीकरण',
        'pkg_weld_sheet':
            'वाऱ्याने तुटलेले पर्लिन जोड वेल्डिंग आणि सेल्फ-टॅपिंग स्क्रू गॅस्केट बदलणे',
        'pkg_pest_cockroach':
            'बिजागरी व सिंकखालील फटींत गंधरहित Fipronil जेल (मुले व पाळीव प्राण्यांसाठी सुरक्षित)',
        'pkg_pest_termite':
            '6 मिमी ड्रिलिंग, दाबाने Imidacloprid इंजेक्शन आणि लाकडी रंगाचे सील',
        'pkg_pest_bedbug':
            'गादीच्या शिवणीवर वाफ, पायरेथ्रॉइड स्प्रे आणि 15 दिवसांत मोफत पुनर्भेट',
        'pkg_clean_bath':
            'रोटरी स्क्रबरने टाइल धुलाई, नळ पॉलिश आणि काचेचे डाग काढणे',
        'pkg_clean_kitchen':
            'कॉस्टिकविना बॅफल फिल्टरची अल्ट्रासोनिक स्वच्छता, स्टील पॉलिश आणि ग्राउट सफाई',
        'pkg_clean_sofa':
            'सखोल फोम स्वच्छता, औद्योगिक व्हॅक्यूमने ओलावा काढणे आणि सिट्रस सुगंध',
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
        'bundle_monsoon_elec': 'पावसाळी विद्युत सुरक्षा',
        'bundle_plumb_health': 'घरगुती प्लंबिंग आरोग्य तपासणी',
        'bundle_ac_summer': 'उन्हाळापूर्व एसी सुपर कुल सर्व्हिसिंग',
        'bundle_carpenter_care': 'मॉड्यूलर किचन व दरवाजा अलाइनमेंट',
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
            'शॉर्ट सर्किट, MCB ट्रिप आणि ओलाव्यामुळे शॉक टाळा',
        'bundle_plumb_health':
            'भिंतीतील गळती तपासणी, वरच्या टाकीचा व्हॉल्व्ह तपासणे आणि ट्रॅप स्वच्छता',
        'bundle_ac_summer':
            'जीवाणुरोधक फोम जेट धुलाई, कूलिंग आणि गॅस दाब तपासणी',
        'bundle_carpenter_care':
            'हायड्रॉलिक सॉफ्ट-क्लोज बिजागरी घट्ट करणे आणि फुगलेला दरवाजा रंधणे',
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
        'bundle_monsoon_elec_0': 'MCB ट्रिप तपासणी आणि फ्यूज लोड कॅलिब्रेशन',
        'bundle_monsoon_elec_1': 'स्विचबोर्ड ओलावा आणि अर्थिंग गळती तपासणी',
        'bundle_monsoon_elec_2': 'छताचा पंखा आणि बॅकअप वायरिंग घट्ट करणे',
        'bundle_plumb_health_0': 'आवाजाद्वारे लपलेल्या पाइप जोडाची गळती तपासणी',
        'bundle_plumb_health_1':
            'किचन सिंक आणि बाथरूम गटाराची यांत्रिक ऑगर स्वच्छता',
        'bundle_plumb_health_2':
            'क्वार्टर-टर्न अँगल व्हॉल्व्ह आणि सिरेमिक स्पिंडल सर्व्हिस',
        'bundle_ac_summer_0': 'आतील कूलिंग कॉइलची उच्च दाबाने फोम जेट धुलाई',
        'bundle_ac_summer_1':
            'बाहेरील कंडेन्सर धुलाई आणि कंप्रेसर कंपन कमी करणे',
        'bundle_ac_summer_2':
            'R32/R410A गॅस दाब मोजणे आणि फिल्टर निर्जंतुकीकरण',
        'bundle_carpenter_care_0':
            'कॅबिनेट आणि कपाटाच्या हायड्रॉलिक सॉफ्ट-क्लोज ताणाचे समायोजन',
        'bundle_carpenter_care_1':
            'फुगलेली चौकट रंधणे आणि खालची मोकळी जागा योग्य करणे',
        'bundle_carpenter_care_2':
            'मुख्य दरवाजाचा डेडबोल्ट आणि गोदरेज कुलूप सिलिंडर सर्व्हिस',
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
        'skilledKarigaar': 'कुशल कारागीर',
        'helperAssistant': 'मदतनीस / बिगारी',
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
        'skilledKarigaar': '🔧 कुशल कारागीर',
        'helperAssistant': '🤝 मदतनीस / बिगारी',
        'thekedar': '👷 ठेकेदार / टीम प्रमुख',
        'other': '$fallback',
      },
    );
    return '$_temp0';
  }

  @override
  String get flowVerifiedGuild => 'पडताळलेले मास्टर गिल्ड';

  @override
  String get flowNandedRating => '4.9 (नांदेडमध्ये 1.4 हजार कामे)';

  @override
  String get flowInspectionWarranty =>
      '45 मिनिटांची तपासणी आणि 30 दिवसांची पुनर्काम वॉरंटी समाविष्ट';

  @override
  String get flowSelectIssues => 'सोडवायच्या समस्या निवडा';

  @override
  String get flowSelectIssuesHint =>
      'योग्य साधनांसाठी सर्व संबंधित समस्या निवडा';

  @override
  String get flowBundleApplied => 'निवडलेले पॅकेज लागू झाले';

  @override
  String get flowPhotoVoice => 'फोटो आणि 15 सेकंदांची ध्वनिटिप्पणी';

  @override
  String get flowSparesHint =>
      'कारागिराला दुकानातून योग्य सुटे भाग आणण्यास मदत करा';

  @override
  String get flowPhotoRemoved => 'जोडलेला फोटो काढला.';

  @override
  String get flowPhotoAttached => 'दोषाचा फोटो जोडला';

  @override
  String get flowAddPhoto => 'समस्येचा फोटो जोडा (ऐच्छिक)';

  @override
  String get flowShieldFee => '+₹29 सुरक्षा शुल्क';

  @override
  String get flowAdjustableBill => 'प्रत्यक्ष पाहणीनंतर बिलात बदल शक्य';

  @override
  String get flowRequestArtisan => 'कारागिराची मागणी करा';

  @override
  String get flowSkillTier => 'कारागिराची कौशल्य पातळी';

  @override
  String get flowMasterRate => '1.25x (+25% मास्टर पातळी)';

  @override
  String get flowStandardRate => '1.0x (प्रमाणित दर)';

  @override
  String get flowHelperRate => '0.65x (-35% मदतनीस पातळी)';

  @override
  String get flowContractorRate => '1.35x (+35% टीम ठेकेदार)';

  @override
  String get flowMandateTitle => 'आगाऊ ₹99 राखीव रकमेची परवानगी';

  @override
  String get flowMandateProvider => 'Razorpay / Cashfree UPI ऑटोपेने सुरक्षित';

  @override
  String get flowMandateWhy => '₹99 ची आगाऊ परवानगी का आवश्यक आहे?';

  @override
  String get flowMandateExplanation =>
      'कारागिराच्या इंधन व प्रवासासाठी ₹99 राखीव ठेवले जातात. काम पूर्ण झाल्यावर रक्कम मोकळी होते; 15 मिनिटांपेक्षा जास्त प्रवेश न मिळाल्यासच ती कापली जाते.';

  @override
  String get flowSelectUpi => 'UPI अॅप निवडा';

  @override
  String get flowUpiId => 'UPI ID / VPA टाका';

  @override
  String get flowUpiHint => 'उदा. mobile@okaxis';

  @override
  String get flowUpiInvalid => 'कृपया योग्य UPI VPA टाका (उदा. name@bank)';

  @override
  String get flowAuthorizeMandate => '₹99 ची परवानगी द्या व कारागीर बोलवा';

  @override
  String get flowAudioTitle => '15 सेकंदांचा ध्वनी तपशील';

  @override
  String get flowRecording => 'रेकॉर्डिंग सुरू आहे (कमाल 15 सेकंद)...';

  @override
  String get flowAudioLanguages => 'दोष हिंदी, मराठी किंवा इंग्रजीत सांगा';

  @override
  String get flowAudioHint =>
      'कारागिरासाठी मोटर, पाणी गळती किंवा ठिणग्यांचा आवाज जास्तीत जास्त 15 सेकंद रेकॉर्ड करा.';

  @override
  String get flowRecordAudio => '15 सेकंदांचा आवाज रेकॉर्ड करा';

  @override
  String get flowPause => 'थांबवा';

  @override
  String get flowPlayPreview => 'रेकॉर्डिंग ऐका';

  @override
  String get flowRerecord => 'पुन्हा रेकॉर्ड करा';

  @override
  String get flowDeleteAudio => 'ध्वनिटिप्पणी काढा';

  @override
  String get flowArrivalDateSlot => 'येण्याची तारीख व वेळ निवडा';

  @override
  String get flowToday => 'आज';

  @override
  String get flowEmergency => 'तातडीचे';

  @override
  String get flowLiveTracking => 'थेट मागोवा';

  @override
  String get flowNoBooking => 'सक्रिय बुकिंग सापडली नाही';

  @override
  String get flowDispatchRadar => 'थेट रवाना रडार';

  @override
  String get flowYourHome => 'तुमचे घर';

  @override
  String get flowArrived => 'पोहोचले';

  @override
  String get flowArrivedZero => 'दाराशी पोहोचले (0 किमी)';

  @override
  String get flowStationary => 'स्थिर • गंतव्यस्थानी';

  @override
  String get flowArrivalHint =>
      'कारागीर तुमच्या परिसरात पोहोचले आहेत. दाराशी आल्यावरच कोड द्या.';

  @override
  String get flowDwellExplanation =>
      'कारागीर बाहेर वाट पाहत आहेत. 15 मिनिटांपेक्षा जास्त प्रवेश न मिळाल्यास ₹99 राखीव प्रवास शुल्क लागू होईल.';

  @override
  String get flowStartCodeLabel => 'दारावरील सुरक्षा प्रारंभ कोड';

  @override
  String get flowStartCodeHint =>
      'कारागीर दाराशी पोहोचल्यावरच हा 4 अंकी कोड तोंडी सांगा.';

  @override
  String get flowMaskedWhatsapp => 'नंबर लपवणारे WhatsApp चॅनेल';

  @override
  String get flowMaskedCall => 'नंबर लपवणारा कॉल';

  @override
  String get flowDirections => 'दारापर्यंत येण्याच्या सूचना';

  @override
  String get flowMilestones => 'बुकिंगचे टप्पे';

  @override
  String get flowBookingConfirmed => 'बुकिंग निश्चित व एस्क्रो राखीव';

  @override
  String get flowArtisanDispatched => 'कारागीर आनंद नगरहून रवाना';

  @override
  String get flowArrivedWithin => 'दाराजवळ पोहोचले (200 मीटरच्या आत)';

  @override
  String get flowArrivedDoorstep => 'दाराशी पोहोचले';

  @override
  String get flowTrackingActive => 'थेट मागोवा सुरू';

  @override
  String get flowHandshakeVerified => 'प्रारंभ पडताळला';

  @override
  String get flowPendingArrival => 'येण्याची प्रतीक्षा';

  @override
  String get flowWorkCompletion => 'काम पूर्ण व पूर्णत्व OTP';

  @override
  String get flowImpsSettled => 'IMPS देयक पूर्ण';

  @override
  String get flowRepairProgress => 'दुरुस्ती सुरू आहे';

  @override
  String get flowPendingFinish => 'काम पूर्ण होणे बाकी';

  @override
  String get flowInvoiceReview => 'ग्राहक बिल तपासणी';

  @override
  String get flowPaidSettled => 'देयक पूर्ण';

  @override
  String get flowPendingReview => 'तपासणी बाकी';

  @override
  String get flowLaborInspection => 'मजुरी व तपासणी';

  @override
  String get flowPartsSurcharge => 'सुट्या भागांवर 2% गेटवे अधिभार';

  @override
  String get flowGst => '18% GST (मजुरी व अधिभार)';

  @override
  String get flowGrandTotalPayable => 'एकूण देय रक्कम';

  @override
  String get flowCompletionCodeLabel => 'तुमचा 4 अंकी पूर्णत्व OTP';

  @override
  String get flowCompletionCodeHint =>
      'समाधानकारक काम पूर्ण झाल्यावरच कारागिराला तोंडी सांगा.';

  @override
  String get flowReviewRelease => 'तपशीलवार बिल पाहा व OTP द्या';

  @override
  String get flowItemizedInvoice => 'सेवेचे तपशीलवार बिल';

  @override
  String get flowSpares => 'सुटे भाग व साहित्य';

  @override
  String get flowGrandTotal => 'एकूण रक्कम';

  @override
  String get flowReleaseCompletion => 'कारागिराला पूर्णत्व OTP द्या';

  @override
  String get flowReleaseConsent =>
      'हा OTP सांगून तुम्ही काम पूर्ण झाल्याची पुष्टी व एस्क्रो रक्कम देण्याची परवानगी देता.';

  @override
  String get flowCompletionSuccess =>
      'पूर्णत्व पडताळले! ₹99 राखीव रक्कम मोकळी, एस्क्रो देयक पूर्ण.';

  @override
  String get accountProfileTitle => 'घरमालक प्रोफाइल आणि सेटिंग्ज';

  @override
  String get accountMasterProtection =>
      '₹25,000 मास्टर गिल्ड नुकसान संरक्षण सक्रिय';

  @override
  String get accountSavedLocalities => 'जतन केलेले नांदेड परिसर';

  @override
  String get accountChange => 'बदला';

  @override
  String get accountPaymentPreferences => 'एस्क्रो आणि पेमेंट प्राधान्ये';

  @override
  String get accountTransitMandate =>
      '₹99 प्रवास शुल्क मँडेट आणि सुट्या भागांसाठी RBI 2FA मंजुरी';

  @override
  String get accountPreauthorization => 'UPI एस्क्रो पूर्व-परवानगी';

  @override
  String get accountCompletionPayout => '4 अंकी पूर्णता OTP नंतरच पेमेंट द्या';

  @override
  String get accountWhatsappAlerts => 'WhatsApp काम वाटप आणि गेट पास सूचना';

  @override
  String get accountTrackingInvoices =>
      'कारागिराचे थेट ट्रॅकिंग आणि डिजिटल GST बिले मिळवा';

  @override
  String get accountPortalSecurity => 'गिल्ड पोर्टल आणि सुरक्षा';

  @override
  String get accountSosContact => 'आपत्कालीन SOS संपर्क';

  @override
  String get accountControlDesk =>
      '+91 9422100100 • नांदेड नियंत्रण कक्ष (24x7)';

  @override
  String get accountSwitchGuild => 'कारागीर गिल्ड पोर्टल उघडा';

  @override
  String get accountRadarWallet =>
      '45 सेकंद जॉब रडार आणि त्वरित IMPS वॉलेट उघडा';

  @override
  String get accountSignOut => 'साइन आउट / नंबर बदला';

  @override
  String get accountChatTitle => 'गिल्ड सुरक्षित चॅट आणि WhatsApp';

  @override
  String get accountMaskedCall => 'क्रमांक लपवून कॉल';

  @override
  String get accountViewArtisanProfile => 'कारागिराची प्रोफाइल पाहा';

  @override
  String get accountGateApproved => 'गेट पास मंजूर';

  @override
  String get accountSharePin => 'थेट लोकेशन पाठवा';

  @override
  String get accountCallOnArrival => 'पोहोचल्यावर कॉल करा';

  @override
  String get accountWhatsappRelay => 'WhatsApp रिले';

  @override
  String get accountMessageHint =>
      'गिल्ड ब्रिजद्वारे कारागिराला संदेश पाठवा...';

  @override
  String get accountSend => 'पाठवा';

  @override
  String get accountBookingsTitle => 'माझ्या सेवा बुकिंग्ज';

  @override
  String get accountActiveDispatch => 'सक्रिय काम वाटप';

  @override
  String get accountPastOrders => 'आगामी आणि मागील ऑर्डर';

  @override
  String get accountShield25 => '₹25,000 गिल्ड नुकसान संरक्षण सक्रिय';

  @override
  String get accountShield10 => '₹10,000 गिल्ड नुकसान संरक्षण सक्रिय';

  @override
  String get accountOnsiteLocked => 'कामाच्या ठिकाणी एस्क्रो लॉक केले';

  @override
  String get accountScheduledWindow => 'नियोजित वेळ';

  @override
  String get accountTrackLive => 'थेट स्थिती पाहा';

  @override
  String get accountDirectVisit => 'थेट भेट (संरक्षणाशिवाय)';

  @override
  String get accountOnsiteUpgradeExplanation =>
      'कारागीर कामाच्या ठिकाणी आहेत. स्टार्ट OTP (4921), ₹29 सुरक्षा शील्ड आणि ₹25 हजार मास्टर कव्हर सक्रिय करण्यासाठी अपग्रेड करा.';

  @override
  String get accountUpgradeBooking => 'संरक्षित गिल्ड बुकिंगमध्ये अपग्रेड करा';

  @override
  String get accountViewArtisan => 'कारागीर पाहा';

  @override
  String get accountBookAgain => 'पुन्हा बुक करा';

  @override
  String get accountRateService => 'सेवेला गुण द्या';

  @override
  String get accountRaiseClaim => 'वॉरंटी दावा करा';

  @override
  String get accountServiceQuestion => 'सेवा कशी होती?';

  @override
  String get accountOverall => 'एकूण';

  @override
  String get accountCleanliness => 'स्वच्छता';

  @override
  String get accountCareFinish => 'काळजी आणि फिनिशिंग';

  @override
  String get accountFeedback => 'ऐच्छिक अभिप्राय';

  @override
  String get accountSubmitRating => 'गुणांकन पाठवा';

  @override
  String get accountClaimTitle => '30 दिवसांचा वॉरंटी दावा';

  @override
  String get accountDeductibleReview =>
      '₹250 वजावट लागू आहे. कारागीर मदत पथक दाव्यांचे पुनरावलोकन करते.';

  @override
  String get accountDamageAmount => 'अंदाजित नुकसानीची रक्कम (₹)';

  @override
  String get accountDescribeIssue => 'समस्येचे वर्णन करा';

  @override
  String get accountClaimValidation => 'योग्य रक्कम आणि दाव्याचे कारण टाका.';

  @override
  String get accountClaimSent =>
      'दावा पुनरावलोकनासाठी पाठवला. याच बुकिंगमध्ये पुढील माहिती मिळेल.';

  @override
  String get accountSubmitClaim => 'दावा पाठवा';

  @override
  String get accountCraftsmanProfile => 'कारागिराची प्रोफाइल';

  @override
  String get accountRemovedFavorite => 'आवडत्या यादीतून काढले.';

  @override
  String get accountPro => 'प्रो';

  @override
  String get accountAvailableToday => 'आज उपलब्ध';

  @override
  String get accountExperience => 'अनुभव';

  @override
  String get accountCompletedJobs => 'पूर्ण केलेली कामे';

  @override
  String get accountCallArtisan => 'कारागिराला कॉल करा';

  @override
  String get accountWhatsappArtisan => 'कारागिराला WhatsApp करा';

  @override
  String get accountMaskedUnlocked =>
      'सुरक्षित व्हर्च्युअल DID सक्रिय (+91-11-4084-2190) • थेट संपर्क खुला';

  @override
  String get accountMaskedLocked =>
      'सुरक्षित व्हर्च्युअल कॉल (+91-11-4084-2190) • ₹49 पासून संपर्क उघडा';

  @override
  String get accountMasterAmount => '₹25,000 मास्टर';

  @override
  String get accountBaseAmount => '₹10,000 बेस';

  @override
  String get accountOnsiteQuestion =>
      'कारागीर ठिकाणी आहेत? एस्क्रो आणि वॉरंटी लॉक करा';

  @override
  String get accountMasterShortCover => '₹25 हजार मास्टर कव्हर';

  @override
  String get accountBaseShortCover => '₹10 हजार बेस कव्हर';

  @override
  String get accountVerifiedGuildsman => 'कारागीर पडताळलेला गिल्ड सदस्य';

  @override
  String get accountTripleScreened =>
      'घराच्या सुरक्षिततेसाठी आणि कुशल कामासाठी तिहेरी पडताळणी';

  @override
  String get accountGovtPolice => 'सरकारी ओळखपत्र आणि पोलिस';

  @override
  String get accountBackgroundCleared => 'पार्श्वभूमी तपासणी पूर्ण';

  @override
  String get accountNsdc => 'NSDC प्रमाणित';

  @override
  String get accountSkillGrade => 'कौशल्य चाचणी ग्रेड A';

  @override
  String get accountDamageProtection => 'नुकसान संरक्षण';

  @override
  String get accountCalibratedTools => 'अंशांकित साधने';

  @override
  String get accountToolAudit => 'साधन तपासणी उत्तीर्ण';

  @override
  String get accountWiring => '3-फेज वायरिंग';

  @override
  String get accountInverterSetup => 'इन्व्हर्टर सेटअप';

  @override
  String get accountMcbDiagnosis => 'MCB स्पार्क तपासणी';

  @override
  String get accountSwitchboards => 'मॉड्युलर स्विचबोर्ड';

  @override
  String get accountEarthing => 'अर्थिंग पडताळणी';

  @override
  String get accountLoadAudit => 'उपकरण भार तपासणी';

  @override
  String get accountSpecializations => 'विशेषज्ञता आणि कौशल्ये';

  @override
  String get accountShowcase => 'कारागिरीचे नमुने';

  @override
  String get accountVerifiedPhotos => 'स्थानिक घरांतील कामाचे पडताळलेले फोटो';

  @override
  String get accountScorecard => 'कारागिराचे गुणपत्रक';

  @override
  String get accountPunctuality => 'वेळेचे पालन';

  @override
  String get accountCraftsmanship => 'उत्कृष्ट कारागिरी';

  @override
  String get accountSawdust => 'भुसा आणि स्वच्छता';

  @override
  String get accountRecentFeedback => 'अलीकडील ग्राहक अभिप्राय';

  @override
  String get accountVerifiedBookings => 'पडताळलेल्या बुकिंग्ज';

  @override
  String get accountVerifiedMcb => 'पडताळलेली MCB स्पार्क दुरुस्ती';

  @override
  String get accountVerifiedInverter => 'पडताळलेले इन्व्हर्टर सेटअप';

  @override
  String get accountPerVisit => '/ भेट';

  @override
  String get accountIncludesWarranty => '₹25 हजार गिल्ड वॉरंटी समाविष्ट';

  @override
  String get accountUnlockTitle => 'थेट संपर्क उघडा';

  @override
  String get accountPrivacyProtected =>
      '100% गोपनीयता सुरक्षित • खरा फोन क्रमांक लपवला जातो';

  @override
  String get accountPayPerLead => 'प्रत्येक संपर्कासाठी शुल्क';

  @override
  String get accountOneTime => 'एकदा';

  @override
  String get accountSingleArtisan => 'एक कारागीर';

  @override
  String get accountDirectoryPass => 'अमर्यादित डायरेक्टरी पास';

  @override
  String get accountPerMonth => '/ महिना';

  @override
  String get accountUnlimitedContact =>
      'सर्व 10 सेवा आणि 7 जिल्ह्यांमध्ये अमर्यादित सुरक्षित कॉल आणि WhatsApp.';

  @override
  String get accountRecommended => 'शिफारस केलेला';

  @override
  String get accountMaskedBenefit => 'सुरक्षित कॉल: खरा फोन क्रमांक लपवला जातो';

  @override
  String get accountMetaBenefit =>
      'अधिकृत Meta WhatsApp Cloud API ब्रिज समाविष्ट';

  @override
  String get accountRetroactiveBenefit =>
      'गिल्ड लॉक: ठिकाणी कधीही ₹25 हजार वॉरंटी सक्रिय करा';

  @override
  String get accountUnlock49 => '₹49 मध्ये उघडा';

  @override
  String get accountActivatePass => 'डायरेक्टरी पास सक्रिय करा (₹499/महिना)';

  @override
  String get accountPassActivated =>
      'डायरेक्टरी पास सक्रिय! सर्व सेवांसाठी अमर्यादित सुरक्षित संपर्क उपलब्ध.';

  @override
  String get accountMasterCover => '₹25,000 मास्टर कव्हर';

  @override
  String get accountBaseCover => '₹10,000 बेस कव्हर';

  @override
  String get accountLockVisit =>
      'ठिकाणच्या भेटीला औपचारिक एस्क्रो संरक्षण द्या';

  @override
  String get accountDoorstepCode => 'आगमन पडताळणी कोड';

  @override
  String get accountStartCode4921 => 'सुरुवातीचा पडताळणी OTP: 4921';

  @override
  String get accountActive => 'सक्रिय';

  @override
  String get accountUnderwriting =>
      'कामादरम्यान मालमत्तेच्या नुकसानीसाठी व्यापक संरक्षण. प्रत्येक दाव्यावर ग्राहकाची ₹250 वजावट लागू आहे.';

  @override
  String get accountEscrowBreakdown => 'आगाऊ एस्क्रोचा तपशील';

  @override
  String get accountInspectionTravel => 'मूळ तपासणी आणि प्रवास';

  @override
  String get accountSafetyWarranty => 'प्लॅटफॉर्म सुरक्षा शील्ड आणि वॉरंटी';

  @override
  String get accountStandbyHold => 'एकूण राखीव एस्क्रो रक्कम';

  @override
  String get accountConfirmLock => 'पुष्टी करून एस्क्रो लॉक करा (₹29 शील्ड)';

  @override
  String get accountVerifiedPhone => '+91 9822199882 • पडताळलेले घरमालक';

  @override
  String accountPrimaryLocality(Object name, Object pincode) {
    return 'मुख्य: $name, नांदेड ($pincode)';
  }

  @override
  String accountSavedAddress(Object name) {
    return '$name • प्लॉट 14, गुरु गोबिंद सिंह जी मार्गाजवळ';
  }

  @override
  String accountPrivacyConnection(Object name, Object trade) {
    return 'क्रमांक लपवणे सक्रिय • खरा क्रमांक खाजगी • $name ($trade) शी जोडले';
  }

  @override
  String accountWhatsappGreeting(Object name) {
    return 'नमस्कार $name, WhatsApp Cloud Relay द्वारे संपर्क करत आहे.';
  }

  @override
  String accountEmptyBookings(Object tab) {
    return '$tab टॅबमध्ये बुकिंग नाहीत.';
  }

  @override
  String accountBookingReference(Object id) {
    return 'बुकिंग #$id';
  }

  @override
  String accountVoiceNote(Object seconds) {
    return '$seconds सेकंदांची व्हॉइस नोट';
  }

  @override
  String accountStartOtp(Object otp) {
    return 'सुरुवातीचा पडताळणी OTP: $otp';
  }

  @override
  String accountTotalEstimate(Object amount) {
    return 'एकूण अंदाज: ₹$amount';
  }

  @override
  String accountDirectLead(Object trade) {
    return 'थेट ऑन-साइट संपर्क • $trade';
  }

  @override
  String accountOnsiteName(Object name) {
    return '$name (ठिकाणी तपासणी)';
  }

  @override
  String accountCoverLimit(Object amount) {
    return 'संरक्षण मर्यादा: ₹$amount';
  }

  @override
  String accountFavoriteSaved(Object name) {
    return '$name आवडत्या यादीत जतन केले!';
  }

  @override
  String accountSharingProfile(Object name) {
    return '$name यांची प्रोफाइल लिंक शेअर करत आहोत...';
  }

  @override
  String accountWithinDistance(Object locality, Object distance) {
    return '$locality • $distance किमीच्या आत';
  }

  @override
  String accountReviewCount(Object count) {
    return '$count अभिप्राय';
  }

  @override
  String accountExperienceYears(Object years) {
    return '$years+ वर्षे';
  }

  @override
  String accountArtisanGreeting(Object name, Object trade) {
    return 'नमस्कार $name जी, मला कारागीरवर $trade साठी तुमची प्रोफाइल मिळाली. नांदेडमध्ये भेटीसाठी उपलब्ध आहात का?';
  }

  @override
  String accountActivateCover(Object cover) {
    return 'एका टॅपने $cover कव्हर आणि ₹29 सुरक्षा शील्ड सक्रिय करा';
  }

  @override
  String accountCertifiedCount(Object count) {
    return '$count प्रमाणित';
  }

  @override
  String accountViewAllCount(Object count) {
    return 'सर्व पाहा ($count)';
  }

  @override
  String accountBookName(Object name) {
    return 'आता $name यांना बुक करा';
  }

  @override
  String accountConnectName(Object name, Object trade) {
    return '$name ($trade) शी संपर्क करा';
  }

  @override
  String accountProxyDescription(Object number) {
    return 'व्हर्च्युअल प्रॉक्सीद्वारे कॉल आणि WhatsApp: $number';
  }

  @override
  String accountUnlockDays(Object name) {
    return '$name यांच्याशी 30 दिवसांसाठी सुरक्षित कॉल आणि WhatsApp संपर्क उघडा.';
  }

  @override
  String accountContactUnlocked(Object number) {
    return 'थेट संपर्क खुला! $number द्वारे कॉल उपलब्ध.';
  }

  @override
  String accountUnlockFailed(Object error) {
    return 'संपर्क उघडण्यात अयशस्वी: $error';
  }

  @override
  String accountArrivalInstructions(Object name) {
    return 'आगमन पडताळण्यासाठी आणि टाइमर सुरू करण्यासाठी ठिकाणी $name यांना हा 4 अंकी कोड द्या.';
  }

  @override
  String accountCoverActive(Object cover) {
    return '$cover सक्रिय';
  }

  @override
  String accountLockedBooking(Object name) {
    return 'ठिकाणची बुकिंग लॉक झाली! $name यांना स्टार्ट OTP 4921 द्या.';
  }

  @override
  String get accountClaimError =>
      'दावा पाठवता आला नाही. रक्कम आणि वॉरंटी पात्रता तपासून पुन्हा प्रयत्न करा.';

  @override
  String sharedSavePercent(int percent) {
    return '$percent% बचत';
  }

  @override
  String get accountStatusAll => 'सर्व';

  @override
  String get accountStatusEnRoute => 'मार्गावर';

  @override
  String get accountStatusUpcoming => 'आगामी';

  @override
  String get accountStatusCompleted => 'पूर्ण';

  @override
  String get accountStatusInProgress => 'काम सुरू आहे';
}
