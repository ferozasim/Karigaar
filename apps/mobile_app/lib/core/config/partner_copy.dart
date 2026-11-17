/// Centralized bilingual copy (`en` / `hi` / `mr`) for all Karigaar Partner Portal screens:
/// - `ArtisanPartnerProfileScreen` (`/artisan/profile`)
/// - `ArtisanWalletHistoryScreen` (`/artisan/wallet`)
/// - `ArtisanJobRadarScreen` (`/artisan/radar`)
/// - `ArtisanBottomNav`
class PartnerCopy {
  final String lang;

  // Navigation
  final String navRadar;
  final String navWallet;
  final String navProfile;

  // Partner Profile Screen
  final String portalTitle;
  final String guildIdPrefix;
  final String elitePassActive;
  final String elitePassEligible;
  final String floorActiveChip;
  final String activatePassChip;
  final String professionalRateCard;
  final String editRateCard;
  final String visitFeeHeader;
  final String dailyDihadiHeader;
  final String primaryTradeLabel;
  final String experienceTierLabel;
  final String workModeLabel;
  final String activeDistrictLabel;
  final String serviceLocalitiesLabel;
  final String workBioLabel;
  final String certifiedSpecialtiesLabel;
  final String scorecardTitle;
  final String overallRatingLabel;
  final String cleanlinessLabel;
  final String onTimeArrivalLabel;
  final String completedJobsLabel;
  final String toolkitTitle;
  final String auditedBadge;
  final String portfolioTitle;
  final String addWorkPhoto;
  final String emptyPortfolioText;
  final String payoutSecurityTitle;
  final String linkedBankLabel;
  final String upiIdLabel;
  final String openWalletBtn;
  final String signOutBtn;

  // Edit Rate Card & Add Work Photo Modals
  final String guildRoleTypeLabel;
  final String visitFeeFieldLabel;
  final String dihadiFieldLabel;
  final String activeDistrictLocalitiesLabel;
  final String saveSyncBtn;
  final String visitFeeError;
  final String dihadiRateError;
  final String bioError;
  final String workTitleLabel;
  final String workTitleError;
  final String localityLabel;
  final String qualityBadgeLabel;
  final String durationLabel;
  final String cancelBtn;
  final String addPhotoBtn;

  // Wallet Screen
  final String walletTitle;
  final String clearedAvailableBalance;
  final String lockedSecurityReserve;
  final String instantWithdrawable;
  final String withdrawImpsBtn;
  final String todaysEarnings;
  final String clearedImpsReady;
  final String weeklyEarnings;
  final String eliteFloorBadge;
  final String masterRateBadge;
  final String proRateBadge;
  final String eliteCommissionLabel;
  final String standardRateLabel;
  final String ledgerTitle;
  final String ledgerSubtitle;
  final String filterAll;
  final String filterCredits;
  final String filterPayouts;
  final String emptyLedgerText;
  final String laborEarned;
  final String partsPassThrough;
  final String guildCommission;
  final String netPayoutCredited;
  final String impsDialogTitle;
  final String withdrawalAmountLabel;
  final String confirmWithdrawBtn;
  final String invalidAmountError;

  // Job Radar Screen
  final String radarActive;
  final String dutyPaused;
  final String acceptingJobs;
  final String goOnlinePrompt;
  final String todaysPayout;
  final String masterGuildTier;
  final String estimatedEarnings;
  final String askCustomer;
  final String claimJobNow;
  final String claimingJob;
  final String noActiveBroadcasts;
  final String refreshRadar;
  final String simulateBroadcast;

  const PartnerCopy({
    required this.lang,
    required this.navRadar,
    required this.navWallet,
    required this.navProfile,
    required this.portalTitle,
    required this.guildIdPrefix,
    required this.elitePassActive,
    required this.elitePassEligible,
    required this.floorActiveChip,
    required this.activatePassChip,
    required this.professionalRateCard,
    required this.editRateCard,
    required this.visitFeeHeader,
    required this.dailyDihadiHeader,
    required this.primaryTradeLabel,
    required this.experienceTierLabel,
    required this.workModeLabel,
    required this.activeDistrictLabel,
    required this.serviceLocalitiesLabel,
    required this.workBioLabel,
    required this.certifiedSpecialtiesLabel,
    required this.scorecardTitle,
    required this.overallRatingLabel,
    required this.cleanlinessLabel,
    required this.onTimeArrivalLabel,
    required this.completedJobsLabel,
    required this.toolkitTitle,
    required this.auditedBadge,
    required this.portfolioTitle,
    required this.addWorkPhoto,
    required this.emptyPortfolioText,
    required this.payoutSecurityTitle,
    required this.linkedBankLabel,
    required this.upiIdLabel,
    required this.openWalletBtn,
    required this.signOutBtn,
    required this.guildRoleTypeLabel,
    required this.visitFeeFieldLabel,
    required this.dihadiFieldLabel,
    required this.activeDistrictLocalitiesLabel,
    required this.saveSyncBtn,
    required this.visitFeeError,
    required this.dihadiRateError,
    required this.bioError,
    required this.workTitleLabel,
    required this.workTitleError,
    required this.localityLabel,
    required this.qualityBadgeLabel,
    required this.durationLabel,
    required this.cancelBtn,
    required this.addPhotoBtn,
    required this.walletTitle,
    required this.clearedAvailableBalance,
    required this.lockedSecurityReserve,
    required this.instantWithdrawable,
    required this.withdrawImpsBtn,
    required this.todaysEarnings,
    required this.clearedImpsReady,
    required this.weeklyEarnings,
    required this.eliteFloorBadge,
    required this.masterRateBadge,
    required this.proRateBadge,
    required this.eliteCommissionLabel,
    required this.standardRateLabel,
    required this.ledgerTitle,
    required this.ledgerSubtitle,
    required this.filterAll,
    required this.filterCredits,
    required this.filterPayouts,
    required this.emptyLedgerText,
    required this.laborEarned,
    required this.partsPassThrough,
    required this.guildCommission,
    required this.netPayoutCredited,
    required this.impsDialogTitle,
    required this.withdrawalAmountLabel,
    required this.confirmWithdrawBtn,
    required this.invalidAmountError,
    required this.radarActive,
    required this.dutyPaused,
    required this.acceptingJobs,
    required this.goOnlinePrompt,
    required this.todaysPayout,
    required this.masterGuildTier,
    required this.estimatedEarnings,
    required this.askCustomer,
    required this.claimJobNow,
    required this.claimingJob,
    required this.noActiveBroadcasts,
    required this.refreshRadar,
    required this.simulateBroadcast,
  });

  factory PartnerCopy.of(String lang) {
    switch (lang) {
      case 'hi':
        return const PartnerCopy(
          lang: 'hi',
          navRadar: 'जॉब रडार',
          navWallet: 'वॉलेट और काम',
          navProfile: 'मेरी प्रोफ़ाइल',
          portalTitle: 'कारीगर गिल्ड पोर्टल',
          guildIdPrefix: 'आईडी',
          elitePassActive: '₹999/माह गिल्ड एलीट पास • सक्रिय',
          elitePassEligible: '₹999/माह गिल्ड एलीट पास • पात्र',
          floorActiveChip: '5% फ्लोर सक्रिय',
          activatePassChip: 'पास सक्रिय करें',
          professionalRateCard: 'पेशेवर प्रोफ़ाइल और रेट कार्ड',
          editRateCard: 'प्रोफ़ाइल और रेट कार्ड बदलें',
          visitFeeHeader: 'विज़िट / जांच शुल्क',
          dailyDihadiHeader: 'दैनिक दिहाड़ी दर',
          primaryTradeLabel: 'मुख्य कार्य',
          experienceTierLabel: 'अनुभव स्तर',
          workModeLabel: 'काम का तरीका',
          activeDistrictLabel: 'सक्रिय ज़िला',
          serviceLocalitiesLabel: 'सेवा क्षेत्र',
          workBioLabel: 'कार्य परिचय',
          certifiedSpecialtiesLabel: 'प्रमाणित विशेषताएं',
          scorecardTitle: 'कारीगरी और स्वच्छता स्कोरकार्ड',
          overallRatingLabel: 'कुल रेटिंग',
          cleanlinessLabel: 'स्वच्छता और सफाई',
          onTimeArrivalLabel: 'समय पर आगमन',
          completedJobsLabel: 'पूर्ण कार्य',
          toolkitTitle: 'सत्यापित टूल किट',
          auditedBadge: 'सत्यापित',
          portfolioTitle: 'काम का पोर्टफोलियो गैलरी',
          addWorkPhoto: 'नया काम फोटो जोड़ें',
          emptyPortfolioText:
              'अभी तक कोई कार्य फोटो नहीं जोड़ा गया है। अपनी कारीगरी दिखाने के लिए "नया काम फोटो जोड़ें" पर टैप करें।',
          payoutSecurityTitle: 'बैंक भुगतान और सुरक्षा रिजर्व',
          linkedBankLabel: 'लिंक बैंक',
          upiIdLabel: 'यूपीआई आईडी',
          openWalletBtn: 'वॉलेट और कमाई देखें',
          signOutBtn: 'गिल्ड पोर्टल से साइन आउट करें',
          guildRoleTypeLabel: 'गिल्ड भूमिका प्रकार',
          visitFeeFieldLabel: 'विज़िट जांच शुल्क (₹)',
          dihadiFieldLabel: 'दैनिक दिहाड़ी दर (₹/दिन)',
          activeDistrictLocalitiesLabel: 'सक्रिय ज़िला और सेवा क्षेत्र',
          saveSyncBtn: 'सहेजें और डायरेक्टरी से सिंक करें',
          visitFeeError: 'मान्य विज़िट शुल्क दर्ज करें (न्यूनतम ₹50)',
          dihadiRateError: 'मान्य दैनिक दिहाड़ी दर दर्ज करें (न्यूनतम ₹100)',
          bioError: 'कार्य परिचय खाली नहीं हो सकता',
          workTitleLabel: 'काम का शीर्षक',
          workTitleError: 'कृपया काम का शीर्षक दर्ज करें',
          localityLabel: 'इलाका / क्षेत्र',
          qualityBadgeLabel: 'गुणवत्ता बैज',
          durationLabel: 'समय अवधि',
          cancelBtn: 'रद्द करें',
          addPhotoBtn: 'फोटो जोड़ें',
          walletTitle: 'गिल्ड वॉलेट और कमाई',
          clearedAvailableBalance: 'उपलब्ध क्लियर बैलेंस',
          lockedSecurityReserve: 'लॉक सुरक्षा रिजर्व',
          instantWithdrawable: 'तुरंत निकासी योग्य',
          withdrawImpsBtn: 'तुरंत IMPS बैंक निकासी (₹0 शुल्क)',
          todaysEarnings: 'आज की कमाई',
          clearedImpsReady: 'क्लियर और IMPS तैयार',
          weeklyEarnings: 'साप्ताहिक कमाई',
          eliteFloorBadge: '5% एलीट फ्लोर',
          masterRateBadge: '8% मास्टर दर',
          proRateBadge: '12% प्रो दर',
          eliteCommissionLabel: '5% एलीट कमीशन फ्लोर',
          standardRateLabel: 'मानक गिल्ड दर',
          ledgerTitle: 'पूर्ण कार्य भुगतान खाता',
          ledgerSubtitle:
              'मेहनताना, 0% शुल्क पुर्जे पास-थ्रू, गिल्ड कमीशन और शुद्ध IMPS भुगतान',
          filterAll: 'सभी',
          filterCredits: 'काम आय',
          filterPayouts: 'IMPS निकासी',
          emptyLedgerText: 'इस फ़िल्टर के लिए कोई प्रविष्टि नहीं मिली।',
          laborEarned: 'मेहनताना कमाई',
          partsPassThrough: 'पुर्जे पास-थ्रू (0% शुल्क)',
          guildCommission: 'गिल्ड कमीशन',
          netPayoutCredited: 'शुद्ध जमा भुगतान',
          impsDialogTitle: 'तुरंत IMPS बैंक निकासी',
          withdrawalAmountLabel: 'निकासी राशि',
          confirmWithdrawBtn: 'निकासी की पुष्टि करें',
          invalidAmountError: '₹0 से अधिक मान्य राशि दर्ज करें',
          radarActive: 'रडार सक्रिय',
          dutyPaused: 'ड्यूटी रुकी है',
          acceptingJobs: 'पास के काम स्वीकार कर रहे हैं',
          goOnlinePrompt: 'काम पाने के लिए ऑनलाइन हों',
          todaysPayout: 'आज का भुगतान',
          masterGuildTier: 'मास्टर गिल्ड स्तर',
          estimatedEarnings: 'अनुमानित कमाई',
          askCustomer: 'ग्राहक से पूछें',
          claimJobNow: 'अभी काम लें',
          claimingJob: 'काम बुक हो रहा है...',
          noActiveBroadcasts: 'आपके 6 किमी क्षेत्र में कोई सक्रिय काम नहीं है',
          refreshRadar: 'रडार रीफ्रेश करें',
          simulateBroadcast: 'नया काम अलर्ट दिखाएं',
        );
      case 'mr':
        return const PartnerCopy(
          lang: 'mr',
          navRadar: 'जॉब रडार',
          navWallet: 'वॉलेट आणि कामे',
          navProfile: 'माझी प्रोफाइल',
          portalTitle: 'कारागीर गिल्ड पोर्टल',
          guildIdPrefix: 'आयडी',
          elitePassActive: '₹999/महिना गिल्ड एलिट पास • सक्रिय',
          elitePassEligible: '₹999/महिना गिल्ड एलिट पास • पात्र',
          floorActiveChip: '5% फ्लोअर सक्रिय',
          activatePassChip: 'पास सक्रिय करा',
          professionalRateCard: 'व्यावसायिक प्रोफाइल आणि दरपत्रक',
          editRateCard: 'प्रोफाइल आणि दर बदला',
          visitFeeHeader: 'भेट / तपासणी शुल्क',
          dailyDihadiHeader: 'दैनिक रोजंदारी दर',
          primaryTradeLabel: 'मुख्य व्यवसाय',
          experienceTierLabel: 'अनुभव श्रेणी',
          workModeLabel: 'कामाची पद्धत',
          activeDistrictLabel: 'सक्रिय जिल्हा',
          serviceLocalitiesLabel: 'सेवा परिसर',
          workBioLabel: 'कामाचा परिचय',
          certifiedSpecialtiesLabel: 'प्रमाणित कौशल्ये',
          scorecardTitle: 'कौशल्य आणि स्वच्छता स्कोअरकार्ड',
          overallRatingLabel: 'एकूण रेटिंग',
          cleanlinessLabel: 'स्वच्छता आणि निगा',
          onTimeArrivalLabel: 'वेळेवर आगमन',
          completedJobsLabel: 'पूर्ण झालेली कामे',
          toolkitTitle: 'पडताळलेले टूल्स किट',
          auditedBadge: 'तपासलेले',
          portfolioTitle: 'कामाचा पोर्टफोलिओ गॅलरी',
          addWorkPhoto: 'नवीन कामाचा फोटो जोडा',
          emptyPortfolioText:
              'अद्याप कामाचे फोटो जोडलेले नाहीत. तुमचे कौशल्य दाखवण्यासाठी "नवीन कामाचा फोटो जोडा" वर टॅप करा.',
          payoutSecurityTitle: 'बँक पेआउट आणि सुरक्षा राखीव',
          linkedBankLabel: 'जोडलेली बँक',
          upiIdLabel: 'यूपीआय आयडी',
          openWalletBtn: 'वॉलेट आणि कमाई पहा',
          signOutBtn: 'गिल्ड पोर्टलमधून साइन आउट करा',
          guildRoleTypeLabel: 'गिल्ड भूमिका प्रकार',
          visitFeeFieldLabel: 'भेट तपासणी शुल्क (₹)',
          dihadiFieldLabel: 'दैनिक रोजंदारी दर (₹/दिवस)',
          activeDistrictLocalitiesLabel: 'सक्रिय जिल्हा आणि सेवा परिसर',
          saveSyncBtn: 'जतन करा आणि डिरेक्टरीशी सिंक करा',
          visitFeeError: 'वैध भेट शुल्क प्रविष्ट करा (किमान ₹50)',
          dihadiRateError: 'वैध दैनिक दर प्रविष्ट करा (किमान ₹100)',
          bioError: 'कामाचा परिचय रिकामा ठेवता येणार नाही',
          workTitleLabel: 'कामाचे शीर्षक',
          workTitleError: 'कृपया कामाचे शीर्षक प्रविष्ट करा',
          localityLabel: 'परिसर / भाग',
          qualityBadgeLabel: 'गुणवत्ता बॅज',
          durationLabel: 'कालावधी',
          cancelBtn: 'रद्द करा',
          addPhotoBtn: 'फोटो जोडा',
          walletTitle: 'गिल्ड वॉलेट आणि कमाई',
          clearedAvailableBalance: 'उपलब्ध क्लिअर शिल्लक',
          lockedSecurityReserve: 'लॉक केलेला सुरक्षा निधी',
          instantWithdrawable: 'त्वरित काढता येणारी रक्कम',
          withdrawImpsBtn: 'त्वरित IMPS बँक निकासी (₹0 शुल्क)',
          todaysEarnings: 'आजची कमाई',
          clearedImpsReady: 'क्लिअर आणि IMPS तयार',
          weeklyEarnings: 'साप्ताहिक कमाई',
          eliteFloorBadge: '5% एलिट फ्लोअर',
          masterRateBadge: '8% मास्टर दर',
          proRateBadge: '12% प्रो दर',
          eliteCommissionLabel: '5% एलिट कमिशन फ्लोअर',
          standardRateLabel: 'मानक गिल्ड दर',
          ledgerTitle: 'पूर्ण कामांचा हिशोब तक्ता',
          ledgerSubtitle:
              'मजुरी, 0% शुल्क सुटे भाग, गिल्ड कमिशन आणि निव्वळ IMPS पेआउट',
          filterAll: 'सर्व',
          filterCredits: 'कामाची आवक',
          filterPayouts: 'IMPS पेआउट',
          emptyLedgerText: 'या फिल्टरसाठी कोणतीही नोंद आढळली नाही.',
          laborEarned: 'मजुरी कमाई',
          partsPassThrough: 'सुटे भाग (0% शुल्क)',
          guildCommission: 'गिल्ड कमिशन',
          netPayoutCredited: 'निव्वळ जमा रक्कम',
          impsDialogTitle: 'त्वरित IMPS बँक निकासी',
          withdrawalAmountLabel: 'काढायची रक्कम',
          confirmWithdrawBtn: 'निकासी निश्चित करा',
          invalidAmountError: '₹0 पेक्षा जास्त वैध रक्कम प्रविष्ट करा',
          radarActive: 'रडार सक्रिय',
          dutyPaused: 'ड्युटी थांबली आहे',
          acceptingJobs: 'जवळची कामे स्वीकारत आहे',
          goOnlinePrompt: 'कामे मिळवण्यासाठी ऑनलाइन व्हा',
          todaysPayout: 'आजचे पेआउट',
          masterGuildTier: 'मास्टर गिल्ड श्रेणी',
          estimatedEarnings: 'अंदाजित कमाई',
          askCustomer: 'ग्राहकाला विचारा',
          claimJobNow: 'आता काम स्वीकारा',
          claimingJob: 'काम निश्चित होत आहे...',
          noActiveBroadcasts: 'तुमच्या 6 किमी परिसरात सध्या कोणतेही काम नाही',
          refreshRadar: 'रडार रिफ्रेश करा',
          simulateBroadcast: 'नवीन काम सूचना दाखवा',
        );
      case 'en':
      default:
        return const PartnerCopy(
          lang: 'en',
          navRadar: 'Job Radar',
          navWallet: 'Wallet & Jobs',
          navProfile: 'My Profile',
          portalTitle: 'Karigaar Guild Portal',
          guildIdPrefix: 'ID',
          elitePassActive: '₹999/mo Guild Elite Pass • Active',
          elitePassEligible: 'Upgrade to ₹999/mo Guild Elite Pass • Eligible',
          floorActiveChip: '5% Floor Active',
          activatePassChip: 'Activate Pass',
          professionalRateCard: 'Professional & Rate Card',
          editRateCard: 'Edit Profile & Rate Card',
          visitFeeHeader: 'VISIT / INSPECTION FEE',
          dailyDihadiHeader: 'DAILY DIHADI RATE',
          primaryTradeLabel: 'Primary Trade',
          experienceTierLabel: 'Experience Tier',
          workModeLabel: 'Work Mode',
          activeDistrictLabel: 'Active District',
          serviceLocalitiesLabel: 'Service Localities',
          workBioLabel: 'Work Bio',
          certifiedSpecialtiesLabel: 'Certified Specialties',
          scorecardTitle: 'Craftsmanship & Cleanliness Scorecard',
          overallRatingLabel: 'Overall Rating',
          cleanlinessLabel: 'Cleanliness & Sawdust',
          onTimeArrivalLabel: 'On-Time Arrival',
          completedJobsLabel: 'Completed Jobs',
          toolkitTitle: 'Verified Tool Kit',
          auditedBadge: 'Audited',
          portfolioTitle: 'Work Portfolio Gallery',
          addWorkPhoto: 'Add New Work Photo',
          emptyPortfolioText:
              'No work photos added yet. Tap "Add New Work Photo" to showcase your craftsmanship.',
          payoutSecurityTitle: 'Payout Bank & Security Reserve',
          linkedBankLabel: 'Linked Bank',
          upiIdLabel: 'UPI ID',
          openWalletBtn: 'Open Guild Wallet & Ledger',
          signOutBtn: 'Sign Out of Guild Portal',
          guildRoleTypeLabel: 'Guild Role Type',
          visitFeeFieldLabel: 'Visit Inspection Fee',
          dihadiFieldLabel: 'Daily Dihadi Rate',
          activeDistrictLocalitiesLabel: 'Active District & Service Localities',
          saveSyncBtn: 'Save & Sync to Directory',
          visitFeeError: 'Enter a valid visit fee (minimum ₹50)',
          dihadiRateError: 'Enter a valid daily dihadi rate (minimum ₹100)',
          bioError: 'Work bio cannot be empty',
          workTitleLabel: 'Work Title',
          workTitleError: 'Please enter a work title',
          localityLabel: 'Locality',
          qualityBadgeLabel: 'Quality Badge',
          durationLabel: 'Duration',
          cancelBtn: 'Cancel',
          addPhotoBtn: 'Add Photo',
          walletTitle: 'Guild Wallet & Earnings',
          clearedAvailableBalance: 'CLEARED AVAILABLE BALANCE',
          lockedSecurityReserve: 'LOCKED SECURITY RESERVE',
          instantWithdrawable: 'INSTANT WITHDRAWABLE',
          withdrawImpsBtn: 'Instant IMPS Bank Withdrawal (₹0 Fee)',
          todaysEarnings: "Today's Earnings",
          clearedImpsReady: 'Cleared & IMPS Ready',
          weeklyEarnings: 'Weekly Earnings',
          eliteFloorBadge: '5% Elite Floor',
          masterRateBadge: '8% Master Rate',
          proRateBadge: '12% Pro Rate',
          eliteCommissionLabel: '5% Elite Commission Floor',
          standardRateLabel: '8% Master / 12% Standard Rate',
          ledgerTitle: 'Completed Job Settlement Ledger',
          ledgerSubtitle:
              'Itemized labor, 0% fee parts pass-through, guild commission & net IMPS payouts',
          filterAll: 'All',
          filterCredits: 'Job Credits',
          filterPayouts: 'IMPS Payouts',
          emptyLedgerText: 'No ledger entries found for this filter.',
          laborEarned: 'Labor Earned',
          partsPassThrough: 'Parts Pass-Through (0% fee)',
          guildCommission: 'Guild Commission',
          netPayoutCredited: 'Net Payout Credited',
          impsDialogTitle: 'Instant IMPS Bank Withdrawal',
          withdrawalAmountLabel: 'Withdrawal Amount',
          confirmWithdrawBtn: 'Confirm IMPS Transfer',
          invalidAmountError: 'Enter a valid withdrawal amount greater than ₹0',
          radarActive: 'RADAR ACTIVE',
          dutyPaused: 'DUTY PAUSED',
          acceptingJobs: 'Accepting Nearby Jobs',
          goOnlinePrompt: 'Go Online to Receive Jobs',
          todaysPayout: "Today's Payout",
          masterGuildTier: 'Master Guild Tier',
          estimatedEarnings: 'Estimated Earnings',
          askCustomer: 'Ask Customer',
          claimJobNow: 'CLAIM JOB NOW',
          claimingJob: 'CLAIMING JOB...',
          noActiveBroadcasts: 'No active broadcasts in your 6 km corridor',
          refreshRadar: 'Refresh Radar',
          simulateBroadcast: 'Simulate Incoming Broadcast',
        );
    }
  }
}
