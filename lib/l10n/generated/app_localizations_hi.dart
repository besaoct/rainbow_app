// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Rainbow';

  @override
  String get appTagline => 'गेट और डिस्पैच संचालन';

  @override
  String get appDescription =>
      'वाहन का गेट-इन दर्ज करें, बिक्री ऑर्डर के अनुसार लोडिंग रिकॉर्ड करें और वाहन को बाहर जाने की मंज़ूरी दें।';

  @override
  String get actionRetry => 'पुनः प्रयास करें';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionConfirm => 'पुष्टि करें';

  @override
  String get actionClose => 'बंद करें';

  @override
  String get actionSubmit => 'जमा करें';

  @override
  String get actionNext => 'आगे';

  @override
  String get actionBack => 'पीछे';

  @override
  String get actionSkip => 'छोड़ें';

  @override
  String get actionDone => 'हो गया';

  @override
  String get actionSearch => 'खोजें';

  @override
  String get actionRefresh => 'रिफ़्रेश करें';

  @override
  String get actionClear => 'साफ़ करें';

  @override
  String get actionContinue => 'जारी रखें';

  @override
  String get actionGetStarted => 'शुरू करें';

  @override
  String get actionSignIn => 'साइन इन करें';

  @override
  String get actionSignOut => 'साइन आउट करें';

  @override
  String get actionViewAll => 'सभी देखें';

  @override
  String get actionSelect => 'चुनें';

  @override
  String get actionChange => 'बदलें';

  @override
  String get labelOptional => 'वैकल्पिक';

  @override
  String get labelRequired => 'आवश्यक';

  @override
  String get labelLoading => 'लोड हो रहा है…';

  @override
  String get labelNotAvailable => '—';

  @override
  String get errorTitle => 'कुछ ग़लत हो गया';

  @override
  String get errorGeneric => 'कुछ ग़लत हो गया। कृपया फिर से प्रयास करें।';

  @override
  String get errorNoInternet =>
      'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जाँचें और फिर प्रयास करें।';

  @override
  String get errorTimeout =>
      'सर्वर ने जवाब देने में बहुत समय लिया। कृपया फिर से प्रयास करें।';

  @override
  String get errorServer =>
      'सर्वर अनुरोध पूरा नहीं कर सका। कृपया बाद में प्रयास करें।';

  @override
  String get errorUnauthorized =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get errorForbidden => 'आपको यह कार्य करने की अनुमति नहीं है।';

  @override
  String get errorNotFound => 'जो आप खोज रहे थे वह नहीं मिला।';

  @override
  String get errorRequestCancelled => 'अनुरोध रद्द कर दिया गया।';

  @override
  String get errorBadCertificate =>
      'कनेक्शन सुरक्षित नहीं है, इसलिए रोक दिया गया।';

  @override
  String get errorStorageUnavailable =>
      'स्थानीय स्टोरेज उपलब्ध नहीं है। कुछ प्राथमिकताएँ सहेजी नहीं जाएँगी।';

  @override
  String get errorTitleNoConnection => 'आप ऑफ़लाइन हैं';

  @override
  String get errorTitleSession => 'सत्र समाप्त';

  @override
  String get emptyTitle => 'यहाँ अभी कुछ नहीं है';

  @override
  String get emptyReadyOrdersTitle => 'डिस्पैच के लिए कोई ऑर्डर तैयार नहीं';

  @override
  String get emptyReadyOrdersMessage =>
      'पुष्ट किए गए और लंबित मात्रा वाले बिक्री ऑर्डर यहाँ दिखाई देंगे।';

  @override
  String get emptyVehiclesTitle => 'कोई वाहन दर्ज नहीं';

  @override
  String get emptyVehiclesMessage =>
      'गेट-इन दर्ज होने के बाद वाहन यहाँ दिखाई देंगे।';

  @override
  String get emptyVehiclesFilteredMessage =>
      'इस फ़िल्टर से कोई वाहन मेल नहीं खाता।';

  @override
  String get emptyEnteredVehiclesTitle => 'कोई वाहन प्रतीक्षा में नहीं';

  @override
  String get emptyEnteredVehiclesMessage =>
      'सुरक्षा द्वारा गेट-इन दर्ज करने के बाद वाहन यहाँ दिखाई देंगे।';

  @override
  String get emptyOrderItemsTitle => 'कोई लंबित वस्तु नहीं';

  @override
  String get emptyOrderItemsMessage =>
      'इस ऑर्डर की हर पंक्ति पहले ही डिस्पैच हो चुकी है।';

  @override
  String get emptyInspectionItemsTitle => 'अभी तक कुछ लोड नहीं हुआ';

  @override
  String get emptyInspectionItemsMessage =>
      'स्टोर टीम ने इस वाहन के लिए कोई लोडिंग दर्ज नहीं की है।';

  @override
  String get emptySearchTitle => 'कोई मेल नहीं';

  @override
  String get emptySearchMessage =>
      'दूसरा वाहन नंबर, गेट पास या ग्राहक नाम आज़माएँ।';

  @override
  String get onboardingTitle1 => 'हर वाहन को गेट पर दर्ज करें';

  @override
  String get onboardingBody1 =>
      'पुष्ट बिक्री ऑर्डर के विरुद्ध वाहन, चालक और ट्रांसपोर्टर दर्ज करें और कुछ ही सेकंड में गेट पास जारी करें।';

  @override
  String get onboardingTitle2 => 'लोडिंग को होते हुए देखें';

  @override
  String get onboardingBody2 =>
      'स्टोर टीम हर पंक्ति की लोड की गई मात्रा दर्ज करती है, लंबित मात्रा और मौजूदा स्टॉक हमेशा सामने रहता है।';

  @override
  String get onboardingTitle3 => 'भरोसे के साथ निकास मंज़ूरी दें';

  @override
  String get onboardingBody3 =>
      'गेट पर दस्तावेज़ और लोड की गई वस्तुएँ जाँचें, फिर निकास को मंज़ूरी दें या कारण दर्ज करके वाहन रोक दें।';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get loginTitle => 'साइन इन करें';

  @override
  String get loginSubtitle =>
      'जारी रखने के लिए अपने Rainbow ERP खाते का उपयोग करें।';

  @override
  String get loginEmailLabel => 'ईमेल पता';

  @override
  String get loginEmailHint => 'you@company.com';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get loginShowPassword => 'पासवर्ड दिखाएँ';

  @override
  String get loginHidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get loginSubmitting => 'साइन इन हो रहा है…';

  @override
  String get loginFailedTitle => 'साइन इन विफल';

  @override
  String get loginNoRoleTitle => 'कोई संचालन भूमिका नहीं';

  @override
  String get loginNoRoleMessage =>
      'यह खाता गेट या स्टोर संचालन के लिए सेट नहीं है। अपने प्रशासक से संपर्क करें।';

  @override
  String get validationRequired => 'यह फ़ील्ड आवश्यक है।';

  @override
  String get validationEmailRequired => 'अपना ईमेल पता दर्ज करें।';

  @override
  String get validationEmailInvalid => 'मान्य ईमेल पता दर्ज करें।';

  @override
  String get validationPasswordRequired => 'अपना पासवर्ड दर्ज करें।';

  @override
  String validationMinLength(int min) {
    return 'कम से कम $min अक्षर होने चाहिए।';
  }

  @override
  String validationMaxLength(int max) {
    return '$max अक्षर या उससे कम होने चाहिए।';
  }

  @override
  String get validationVehicleNumberRequired => 'वाहन नंबर दर्ज करें।';

  @override
  String get validationVehicleNumberInvalid =>
      'मान्य वाहन नंबर दर्ज करें, जैसे KA 01 ZZ 7777।';

  @override
  String get validationDriverNameRequired => 'चालक का नाम दर्ज करें।';

  @override
  String get validationPhoneInvalid => 'मान्य फ़ोन नंबर दर्ज करें।';

  @override
  String get validationOrderRequired => 'एक बिक्री ऑर्डर चुनें।';

  @override
  String get validationLocationRequired => 'एक स्थान चुनें।';

  @override
  String get validationReasonRequired => 'वाहन रोकने का कारण दर्ज करें।';

  @override
  String get validationNumberInvalid => 'मान्य संख्या दर्ज करें।';

  @override
  String get validationQuantityNegative => 'मात्रा ऋणात्मक नहीं हो सकती।';

  @override
  String validationQuantityExceedsPending(int pending) {
    return 'इस पंक्ति पर केवल $pending नग लंबित हैं।';
  }

  @override
  String validationQuantityExceedsStock(int stock) {
    return 'स्टॉक में केवल $stock नग हैं।';
  }

  @override
  String get validationSelectAtLeastOneItem =>
      'कम से कम एक वस्तु के लिए मात्रा दर्ज करें।';

  @override
  String get greetingMorning => 'सुप्रभात';

  @override
  String get greetingAfternoon => 'नमस्कार';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String get homeTitle => 'होम';

  @override
  String get homeQuickActions => 'त्वरित कार्य';

  @override
  String get quickActionGateIn => 'गेट-इन';

  @override
  String get quickActionReadyOrders => 'ऑर्डर';

  @override
  String get quickActionVehicles => 'वाहन';

  @override
  String get quickActionInsideGate => 'लोडिंग';

  @override
  String get homeTodayAtAGlance => 'आज एक नज़र में';

  @override
  String get homeAssignedLocations => 'निर्धारित स्थान';

  @override
  String get homeNoAssignedLocations =>
      'आपके खाते को कोई स्थान नहीं सौंपा गया है।';

  @override
  String get homeRecentVehicles => 'हाल के वाहन';

  @override
  String get homeSignOutTitle => 'साइन आउट करें?';

  @override
  String get homeSignOutMessage =>
      'गेट संचालन जारी रखने के लिए आपको फिर से साइन इन करना होगा।';

  @override
  String get roleGuard => 'सुरक्षा गार्ड';

  @override
  String get roleStoreManager => 'स्टोर प्रबंधक';

  @override
  String get roleAdmin => 'प्रशासक';

  @override
  String get roleSales => 'बिक्री';

  @override
  String get roleMember => 'टीम सदस्य';

  @override
  String get navHome => 'होम';

  @override
  String get navVehicles => 'वाहन';

  @override
  String get navLoading => 'लोडिंग';

  @override
  String get navSettings => 'सेटिंग';

  @override
  String get guardSectionTitle => 'गेट संचालन';

  @override
  String get guardReadyOrdersTitle => 'डिस्पैच के लिए तैयार ऑर्डर';

  @override
  String get guardReadyOrdersSubtitle =>
      'लंबित मात्रा वाले पुष्ट बिक्री ऑर्डर।';

  @override
  String get guardGateInTitle => 'गेट-इन दर्ज करें';

  @override
  String get guardGateInSubtitle =>
      'बिक्री ऑर्डर के विरुद्ध आने वाला वाहन दर्ज करें।';

  @override
  String get guardVehiclesTitle => 'वाहन';

  @override
  String get guardVehiclesSubtitle => 'इस गेट पर दर्ज हर वाहन।';

  @override
  String get guardInspectionTitle => 'निकास मंज़ूरी';

  @override
  String get guardInspectionSubtitle =>
      'वाहन के जाने से पहले लोड और दस्तावेज़ जाँचें।';

  @override
  String get orderNumberLabel => 'ऑर्डर नं.';

  @override
  String get orderDateLabel => 'ऑर्डर तिथि';

  @override
  String get orderExpectedDateLabel => 'अपेक्षित';

  @override
  String get orderCustomerLabel => 'ग्राहक';

  @override
  String get orderCustomerCodeLabel => 'ग्राहक कोड';

  @override
  String get orderLocationLabel => 'स्थान';

  @override
  String get orderStatusLabel => 'स्थिति';

  @override
  String get orderLinesLabel => 'पंक्तियाँ';

  @override
  String get orderPendingLabel => 'लंबित';

  @override
  String get vehicleNumberLabel => 'वाहन नंबर';

  @override
  String get vehicleNumberHint => 'KA 01 ZZ 7777';

  @override
  String get gatePassLabel => 'गेट पास';

  @override
  String get driverNameLabel => 'चालक का नाम';

  @override
  String get driverNameHint => 'लाइसेंस के अनुसार पूरा नाम';

  @override
  String get driverPhoneLabel => 'चालक का फ़ोन';

  @override
  String get driverPhoneHint => '+91 91234 56789';

  @override
  String get contactPhoneLabel => 'फ़ोन';

  @override
  String get transporterLabel => 'ट्रांसपोर्टर';

  @override
  String get transporterHint => 'परिवहन कंपनी का नाम';

  @override
  String get transporterSuggestionsLabel => 'या एक चुनें';

  @override
  String get remarksLabel => 'टिप्पणी';

  @override
  String get remarksHint => 'अगले व्यक्ति को जो जानना चाहिए';

  @override
  String get locationLabel => 'स्थान';

  @override
  String get locationHint => 'एक स्थान चुनें';

  @override
  String get salesOrderLabel => 'बिक्री ऑर्डर';

  @override
  String get salesOrderHint => 'एक बिक्री ऑर्डर चुनें';

  @override
  String get enteredAtLabel => 'गेट-इन';

  @override
  String get loadedAtLabel => 'लोड हुआ';

  @override
  String get clearedAtLabel => 'मंज़ूर';

  @override
  String get enteredByLabel => 'दर्ज किया';

  @override
  String get loadedByLabel => 'लोड किया';

  @override
  String get rejectionReasonLabel => 'रोकने का कारण';

  @override
  String get guardGateInSubmit => 'गेट-इन दर्ज करें';

  @override
  String get guardGateInSuccessTitle => 'गेट पास जारी';

  @override
  String guardGateInSuccessMessage(String gatePassNo, String vehicleNo) {
    return '$vehicleNo के लिए $gatePassNo जारी किया गया।';
  }

  @override
  String get guardSelectOrderTitle => 'बिक्री ऑर्डर चुनें';

  @override
  String get guardSelectLocationTitle => 'स्थान चुनें';

  @override
  String get statusEntered => 'प्रवेश';

  @override
  String get statusLoaded => 'लोड';

  @override
  String get statusCleared => 'मंज़ूर';

  @override
  String get statusRejected => 'रोका गया';

  @override
  String get statusOpen => 'खुला';

  @override
  String get statusPending => 'लंबित';

  @override
  String get statusUnknown => 'अज्ञात';

  @override
  String get markEnteredLabel => 'नारंगी चिह्न · गेट-इन';

  @override
  String get markLoadedLabel => 'लाल चिह्न · मंज़ूरी प्रतीक्षित';

  @override
  String get markClearedLabel => 'हरा चिह्न · निकास मंज़ूर';

  @override
  String get markRejectedLabel => 'रोका गया · समस्या दर्ज';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterLabel => 'फ़िल्टर';

  @override
  String get searchVehiclesHint => 'वाहन, गेट पास या ग्राहक';

  @override
  String get searchOrdersHint => 'ऑर्डर नंबर या ग्राहक';

  @override
  String get inspectionDocumentsTitle => 'दस्तावेज़';

  @override
  String get inspectionItemsTitle => 'जाँचने योग्य वस्तुएँ';

  @override
  String get inspectionNotLoadedTitle => 'अभी लोड नहीं हुआ';

  @override
  String get inspectionNotLoadedMessage =>
      'स्टोर टीम द्वारा लोडिंग दर्ज करने के बाद ही यह वाहन मंज़ूर हो सकता है।';

  @override
  String get challanNumberLabel => 'चालान नं.';

  @override
  String get challanNumberHint => 'CH-2026-901';

  @override
  String get ewayBillNumberLabel => 'ई-वे बिल नं.';

  @override
  String get ewayBillNumberHint => 'EWB-8877665544';

  @override
  String get invoiceNumberLabel => 'इनवॉइस नं.';

  @override
  String get invoiceNumberHint => 'INV-2026-102';

  @override
  String get loadingRemarksLabel => 'लोडिंग टिप्पणी';

  @override
  String get productLabel => 'उत्पाद';

  @override
  String get skuLabel => 'SKU';

  @override
  String get rateLabel => 'दर';

  @override
  String get lineTotalLabel => 'पंक्ति कुल';

  @override
  String get quantityPiecesLabel => 'नग';

  @override
  String get quantityBoxesLabel => 'बॉक्स';

  @override
  String get quantityOrderedLabel => 'ऑर्डर';

  @override
  String get quantityDispatchedLabel => 'डिस्पैच';

  @override
  String get quantityPendingLabel => 'लंबित';

  @override
  String get quantityToLoadLabel => 'लोड करना है';

  @override
  String get currentStockLabel => 'स्टॉक में';

  @override
  String get piecesPerBoxLabel => 'नग / बॉक्स';

  @override
  String get totalPiecesLabel => 'कुल नग';

  @override
  String get totalBoxesLabel => 'कुल बॉक्स';

  @override
  String get totalValueLabel => 'कुल मूल्य';

  @override
  String piecesShort(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString नग';
  }

  @override
  String boxesShort(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString बॉक्स';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वस्तुएँ',
      one: '1 वस्तु',
      zero: 'कोई वस्तु नहीं',
    );
    return '$_temp0';
  }

  @override
  String lineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पंक्तियाँ',
      one: '1 पंक्ति',
      zero: 'कोई पंक्ति नहीं',
    );
    return '$_temp0';
  }

  @override
  String vehicleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वाहन',
      one: '1 वाहन',
      zero: 'कोई वाहन नहीं',
    );
    return '$_temp0';
  }

  @override
  String get guardApproveExit => 'निकास मंज़ूर करें';

  @override
  String get guardRejectExit => 'वाहन रोकें';

  @override
  String get guardApproveTitle => 'निकास मंज़ूर करें?';

  @override
  String guardApproveMessage(String vehicleNo) {
    return '$vehicleNo को जाने की मंज़ूरी मिलेगी और हरा चिह्न लगेगा।';
  }

  @override
  String get guardRejectTitle => 'इस वाहन को रोकें?';

  @override
  String get guardRejectMessage =>
      'वाहन गेट पर रोका जाएगा और कारण दर्ज किया जाएगा।';

  @override
  String guardApproveSuccess(String vehicleNo) {
    return '$vehicleNo को निकास की मंज़ूरी दी गई।';
  }

  @override
  String guardRejectSuccess(String vehicleNo) {
    return '$vehicleNo को गेट पर रोका गया।';
  }

  @override
  String get guardHoldReasonLabel => 'कारण';

  @override
  String get guardHoldReasonHint => 'वाहन क्यों रोका जा रहा है?';

  @override
  String get storeSectionTitle => 'स्टोर संचालन';

  @override
  String get storeEnteredVehiclesTitle => 'गेट के अंदर वाहन';

  @override
  String get storeEnteredVehiclesSubtitle => 'लोडिंग की प्रतीक्षा कर रहे वाहन।';

  @override
  String get storeLoadingTitle => 'लोडिंग दर्ज करें';

  @override
  String get storeLoadingSubtitle =>
      'वाहन में वास्तव में लोड की गई मात्रा दर्ज करें।';

  @override
  String get storeStartLoading => 'लोडिंग शुरू करें';

  @override
  String get storeSubmitLoading => 'लोडिंग जमा करें';

  @override
  String get storeLoadingSuccessTitle => 'लोडिंग दर्ज हुई';

  @override
  String storeLoadingSuccessMessage(String vehicleNo) {
    return '$vehicleNo अब सुरक्षा मंज़ूरी की प्रतीक्षा में है।';
  }

  @override
  String get storePendingLinesLabel => 'लंबित पंक्तियाँ';

  @override
  String get storeLoadFullPending => 'सभी लोड करें';

  @override
  String storeItemsSummary(int loaded, int total) {
    return '$total में से $loaded पंक्तियों में मात्रा है';
  }

  @override
  String get settingsTitle => 'सेटिंग';

  @override
  String get settingsAppearance => 'रूप';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsThemeSystem => 'सिस्टम के अनुसार';

  @override
  String get settingsThemeLight => 'लाइट';

  @override
  String get settingsThemeDark => 'डार्क';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsAccount => 'खाता';

  @override
  String get settingsAbout => 'ऐप के बारे में';

  @override
  String get settingsVersion => 'संस्करण';

  @override
  String settingsVersionValue(String version, String build) {
    return '$version ($build)';
  }

  @override
  String get settingsServer => 'सर्वर';

  @override
  String get settingsReplayOnboarding => 'परिचय फिर से देखें';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageAssamese => 'অসমীয়া';

  @override
  String get a11yBack => 'पीछे';

  @override
  String get a11yAppLogo => 'Rainbow लोगो';

  @override
  String get a11yLoading => 'लोड हो रहा है';

  @override
  String a11yStatusMark(String status) {
    return 'स्थिति: $status';
  }
}
