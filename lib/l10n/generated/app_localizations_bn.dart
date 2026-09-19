// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Rainbow';

  @override
  String get appTagline => 'গেট ও ডিসপ্যাচ পরিচালনা';

  @override
  String get appDescription =>
      'গাড়ির গেট-ইন নথিভুক্ত করুন, বিক্রয় আদেশ অনুযায়ী লোডিং রেকর্ড করুন এবং গাড়িকে বেরোনোর ছাড়পত্র দিন।';

  @override
  String get actionRetry => 'আবার চেষ্টা করুন';

  @override
  String get actionCancel => 'বাতিল';

  @override
  String get actionConfirm => 'নিশ্চিত করুন';

  @override
  String get actionClose => 'বন্ধ করুন';

  @override
  String get actionSubmit => 'জমা দিন';

  @override
  String get actionNext => 'পরবর্তী';

  @override
  String get actionBack => 'পিছনে';

  @override
  String get actionSkip => 'এড়িয়ে যান';

  @override
  String get actionDone => 'সম্পন্ন';

  @override
  String get actionSearch => 'খুঁজুন';

  @override
  String get actionRefresh => 'রিফ্রেশ';

  @override
  String get actionClear => 'মুছুন';

  @override
  String get actionContinue => 'চালিয়ে যান';

  @override
  String get actionGetStarted => 'শুরু করুন';

  @override
  String get actionSignIn => 'সাইন ইন';

  @override
  String get actionSignOut => 'সাইন আউট';

  @override
  String get actionViewAll => 'সব দেখুন';

  @override
  String get actionSelect => 'নির্বাচন করুন';

  @override
  String get actionChange => 'পরিবর্তন';

  @override
  String get labelOptional => 'ঐচ্ছিক';

  @override
  String get labelRequired => 'আবশ্যক';

  @override
  String get labelLoading => 'লোড হচ্ছে…';

  @override
  String get labelNotAvailable => '—';

  @override
  String get errorTitle => 'কিছু একটা ভুল হয়েছে';

  @override
  String get errorGeneric => 'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get errorNoInternet =>
      'ইন্টারনেট সংযোগ নেই। নেটওয়ার্ক দেখে আবার চেষ্টা করুন।';

  @override
  String get errorTimeout =>
      'সার্ভার সাড়া দিতে অনেক সময় নিয়েছে। আবার চেষ্টা করুন।';

  @override
  String get errorServer =>
      'সার্ভার অনুরোধটি সম্পূর্ণ করতে পারেনি। পরে আবার চেষ্টা করুন।';

  @override
  String get errorUnauthorized =>
      'আপনার সেশন শেষ হয়ে গেছে। আবার সাইন ইন করুন।';

  @override
  String get errorForbidden => 'এই কাজটি করার অনুমতি আপনার নেই।';

  @override
  String get errorNotFound => 'আপনি যা খুঁজছিলেন তা পাওয়া যায়নি।';

  @override
  String get errorRequestCancelled => 'অনুরোধটি বাতিল করা হয়েছে।';

  @override
  String get errorBadCertificate => 'সংযোগটি নিরাপদ নয়, তাই বন্ধ করা হয়েছে।';

  @override
  String get errorStorageUnavailable =>
      'স্থানীয় স্টোরেজ পাওয়া যাচ্ছে না। কিছু পছন্দ সংরক্ষিত হবে না।';

  @override
  String get errorTitleNoConnection => 'আপনি অফলাইন';

  @override
  String get errorTitleSession => 'সেশন শেষ';

  @override
  String get emptyTitle => 'এখানে এখনও কিছু নেই';

  @override
  String get emptyReadyOrdersTitle => 'ডিসপ্যাচের জন্য কোনও আদেশ প্রস্তুত নেই';

  @override
  String get emptyReadyOrdersMessage =>
      'নিশ্চিত হওয়া এবং বকেয়া পরিমাণ থাকা বিক্রয় আদেশ এখানে দেখা যাবে।';

  @override
  String get emptyVehiclesTitle => 'কোনও গাড়ি নথিভুক্ত নেই';

  @override
  String get emptyVehiclesMessage =>
      'গেট-ইন নথিভুক্ত হওয়ার পরে গাড়ি এখানে দেখা যাবে।';

  @override
  String get emptyVehiclesFilteredMessage =>
      'এই ফিল্টারের সঙ্গে কোনও গাড়ি মেলেনি।';

  @override
  String get emptyEnteredVehiclesTitle => 'কোনও গাড়ি অপেক্ষায় নেই';

  @override
  String get emptyEnteredVehiclesMessage =>
      'নিরাপত্তারক্ষী গেট-ইন নথিভুক্ত করার পরে গাড়ি এখানে দেখা যাবে।';

  @override
  String get emptyOrderItemsTitle => 'কোনও বকেয়া সামগ্রী নেই';

  @override
  String get emptyOrderItemsMessage =>
      'এই আদেশের প্রতিটি লাইন ইতিমধ্যেই পাঠানো হয়েছে।';

  @override
  String get emptyInspectionItemsTitle => 'এখনও কিছু লোড হয়নি';

  @override
  String get emptyInspectionItemsMessage =>
      'স্টোর দল এই গাড়ির জন্য কোনও লোডিং নথিভুক্ত করেনি।';

  @override
  String get emptySearchTitle => 'কিছু মেলেনি';

  @override
  String get emptySearchMessage =>
      'অন্য গাড়ির নম্বর, গেট পাস বা গ্রাহকের নাম দিয়ে দেখুন।';

  @override
  String get onboardingTitle1 => 'গেটে প্রতিটি গাড়ি নথিভুক্ত করুন';

  @override
  String get onboardingBody1 =>
      'নিশ্চিত বিক্রয় আদেশের বিপরীতে গাড়ি, চালক ও পরিবহণকারীর তথ্য নিন এবং কয়েক সেকেন্ডে গেট পাস দিন।';

  @override
  String get onboardingTitle2 => 'লোডিং যখন হচ্ছে তখনই দেখুন';

  @override
  String get onboardingBody2 =>
      'স্টোর দল লাইন ধরে লোড করা পরিমাণ লেখে, বকেয়া পরিমাণ ও বর্তমান মজুত সব সময় চোখের সামনে থাকে।';

  @override
  String get onboardingTitle3 => 'নিশ্চিন্তে বেরোনোর ছাড়পত্র দিন';

  @override
  String get onboardingBody3 =>
      'গেটে নথি ও লোড করা সামগ্রী যাচাই করুন, তারপর বেরোনোর অনুমতি দিন বা কারণ লিখে গাড়ি আটকে রাখুন।';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'ধাপ $current / $total';
  }

  @override
  String get loginTitle => 'সাইন ইন';

  @override
  String get loginSubtitle =>
      'চালিয়ে যেতে আপনার Rainbow ERP অ্যাকাউন্ট ব্যবহার করুন।';

  @override
  String get loginEmailLabel => 'ইমেল ঠিকানা';

  @override
  String get loginEmailHint => 'you@company.com';

  @override
  String get loginPasswordLabel => 'পাসওয়ার্ড';

  @override
  String get loginPasswordHint => 'আপনার পাসওয়ার্ড লিখুন';

  @override
  String get loginShowPassword => 'পাসওয়ার্ড দেখান';

  @override
  String get loginHidePassword => 'পাসওয়ার্ড লুকান';

  @override
  String get loginSubmitting => 'সাইন ইন হচ্ছে…';

  @override
  String get loginFailedTitle => 'সাইন ইন ব্যর্থ';

  @override
  String get loginNoRoleTitle => 'কোনও পরিচালন ভূমিকা নেই';

  @override
  String get loginNoRoleMessage =>
      'এই অ্যাকাউন্টটি গেট বা স্টোর পরিচালনার জন্য নির্ধারিত নয়। প্রশাসকের সঙ্গে যোগাযোগ করুন।';

  @override
  String get validationRequired => 'এই ঘরটি আবশ্যক।';

  @override
  String get validationEmailRequired => 'আপনার ইমেল ঠিকানা লিখুন।';

  @override
  String get validationEmailInvalid => 'একটি সঠিক ইমেল ঠিকানা লিখুন।';

  @override
  String get validationPasswordRequired => 'আপনার পাসওয়ার্ড লিখুন।';

  @override
  String validationMinLength(int min) {
    return 'কমপক্ষে $min অক্ষর হতে হবে।';
  }

  @override
  String validationMaxLength(int max) {
    return '$max অক্ষর বা তার কম হতে হবে।';
  }

  @override
  String get validationVehicleNumberRequired => 'গাড়ির নম্বর লিখুন।';

  @override
  String get validationVehicleNumberInvalid =>
      'সঠিক গাড়ির নম্বর লিখুন, যেমন KA 01 ZZ 7777।';

  @override
  String get validationDriverNameRequired => 'চালকের নাম লিখুন।';

  @override
  String get validationPhoneInvalid => 'সঠিক ফোন নম্বর লিখুন।';

  @override
  String get validationOrderRequired => 'একটি বিক্রয় আদেশ নির্বাচন করুন।';

  @override
  String get validationLocationRequired => 'একটি স্থান নির্বাচন করুন।';

  @override
  String get validationReasonRequired => 'গাড়ি আটকে রাখার কারণ লিখুন।';

  @override
  String get validationNumberInvalid => 'সঠিক সংখ্যা লিখুন।';

  @override
  String get validationQuantityNegative => 'পরিমাণ ঋণাত্মক হতে পারে না।';

  @override
  String validationQuantityExceedsPending(int pending) {
    return 'এই লাইনে মাত্র $pending পিস বকেয়া আছে।';
  }

  @override
  String validationQuantityExceedsStock(int stock) {
    return 'মজুতে মাত্র $stock পিস আছে।';
  }

  @override
  String get validationSelectAtLeastOneItem =>
      'অন্তত একটি সামগ্রীর পরিমাণ লিখুন।';

  @override
  String get greetingMorning => 'সুপ্রভাত';

  @override
  String get greetingAfternoon => 'শুভ অপরাহ্ন';

  @override
  String get greetingEvening => 'শুভ সন্ধ্যা';

  @override
  String get homeTitle => 'হোম';

  @override
  String get homeQuickActions => 'দ্রুত কাজ';

  @override
  String get quickActionGateIn => 'গেট-ইন';

  @override
  String get quickActionReadyOrders => 'প্রস্তুত আদেশ';

  @override
  String get quickActionVehicles => 'গাড়ি';

  @override
  String get quickActionInsideGate => 'গেটের ভিতরে';

  @override
  String get homeTodayAtAGlance => 'আজ এক নজরে';

  @override
  String get homeAssignedLocations => 'নির্ধারিত স্থান';

  @override
  String get homeNoAssignedLocations =>
      'আপনার অ্যাকাউন্টে কোনও স্থান নির্ধারিত নেই।';

  @override
  String get homeRecentVehicles => 'সাম্প্রতিক গাড়ি';

  @override
  String get homeSignOutTitle => 'সাইন আউট করবেন?';

  @override
  String get homeSignOutMessage =>
      'গেটের কাজ চালিয়ে যেতে আপনাকে আবার সাইন ইন করতে হবে।';

  @override
  String get roleGuard => 'নিরাপত্তারক্ষী';

  @override
  String get roleStoreManager => 'স্টোর ম্যানেজার';

  @override
  String get roleAdmin => 'প্রশাসক';

  @override
  String get roleSales => 'বিক্রয়';

  @override
  String get roleMember => 'দলের সদস্য';

  @override
  String get navHome => 'হোম';

  @override
  String get navVehicles => 'গাড়ি';

  @override
  String get navLoading => 'লোডিং';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get guardSectionTitle => 'গেট পরিচালনা';

  @override
  String get guardReadyOrdersTitle => 'ডিসপ্যাচের জন্য প্রস্তুত আদেশ';

  @override
  String get guardReadyOrdersSubtitle =>
      'বকেয়া পরিমাণ থাকা নিশ্চিত বিক্রয় আদেশ।';

  @override
  String get guardGateInTitle => 'গেট-ইন নথিভুক্ত করুন';

  @override
  String get guardGateInSubtitle =>
      'বিক্রয় আদেশের বিপরীতে আসা গাড়ি নথিভুক্ত করুন।';

  @override
  String get guardVehiclesTitle => 'গাড়ি';

  @override
  String get guardVehiclesSubtitle => 'এই গেটে নথিভুক্ত প্রতিটি গাড়ি।';

  @override
  String get guardInspectionTitle => 'বেরোনোর ছাড়পত্র';

  @override
  String get guardInspectionSubtitle =>
      'গাড়ি যাওয়ার আগে লোড ও নথি যাচাই করুন।';

  @override
  String get orderNumberLabel => 'আদেশ নং';

  @override
  String get orderDateLabel => 'আদেশের তারিখ';

  @override
  String get orderExpectedDateLabel => 'প্রত্যাশিত';

  @override
  String get orderCustomerLabel => 'গ্রাহক';

  @override
  String get orderCustomerCodeLabel => 'গ্রাহক কোড';

  @override
  String get orderLocationLabel => 'স্থান';

  @override
  String get orderStatusLabel => 'অবস্থা';

  @override
  String get orderLinesLabel => 'লাইন';

  @override
  String get orderPendingLabel => 'বকেয়া';

  @override
  String get vehicleNumberLabel => 'গাড়ির নম্বর';

  @override
  String get vehicleNumberHint => 'KA 01 ZZ 7777';

  @override
  String get gatePassLabel => 'গেট পাস';

  @override
  String get driverNameLabel => 'চালকের নাম';

  @override
  String get driverNameHint => 'লাইসেন্স অনুযায়ী পুরো নাম';

  @override
  String get driverPhoneLabel => 'চালকের ফোন';

  @override
  String get driverPhoneHint => '+91 91234 56789';

  @override
  String get contactPhoneLabel => 'ফোন';

  @override
  String get transporterLabel => 'পরিবহণকারী';

  @override
  String get transporterHint => 'পরিবহণ সংস্থার নাম';

  @override
  String get remarksLabel => 'মন্তব্য';

  @override
  String get remarksHint => 'পরের জনের যা জানা দরকার';

  @override
  String get locationLabel => 'স্থান';

  @override
  String get locationHint => 'একটি স্থান নির্বাচন করুন';

  @override
  String get salesOrderLabel => 'বিক্রয় আদেশ';

  @override
  String get salesOrderHint => 'একটি বিক্রয় আদেশ নির্বাচন করুন';

  @override
  String get enteredAtLabel => 'গেট-ইন';

  @override
  String get loadedAtLabel => 'লোড হয়েছে';

  @override
  String get clearedAtLabel => 'ছাড়পত্র';

  @override
  String get enteredByLabel => 'নথিভুক্ত করেছেন';

  @override
  String get loadedByLabel => 'লোড করেছেন';

  @override
  String get rejectionReasonLabel => 'আটকানোর কারণ';

  @override
  String get guardGateInSubmit => 'গেট-ইন নথিভুক্ত করুন';

  @override
  String get guardGateInSuccessTitle => 'গেট পাস দেওয়া হয়েছে';

  @override
  String guardGateInSuccessMessage(String gatePassNo, String vehicleNo) {
    return '$vehicleNo-এর জন্য $gatePassNo দেওয়া হয়েছে।';
  }

  @override
  String get guardSelectOrderTitle => 'বিক্রয় আদেশ নির্বাচন করুন';

  @override
  String get guardSelectLocationTitle => 'স্থান নির্বাচন করুন';

  @override
  String get statusEntered => 'প্রবেশ';

  @override
  String get statusLoaded => 'লোড';

  @override
  String get statusCleared => 'ছাড়পত্র';

  @override
  String get statusRejected => 'আটকানো';

  @override
  String get statusOpen => 'খোলা';

  @override
  String get statusPending => 'বকেয়া';

  @override
  String get statusUnknown => 'অজানা';

  @override
  String get markEnteredLabel => 'কমলা চিহ্ন · গেট-ইন';

  @override
  String get markLoadedLabel => 'লাল চিহ্ন · ছাড়পত্রের অপেক্ষায়';

  @override
  String get markClearedLabel => 'সবুজ চিহ্ন · বেরোনোর অনুমতি';

  @override
  String get markRejectedLabel => 'আটকানো · সমস্যা নথিভুক্ত';

  @override
  String get filterAll => 'সব';

  @override
  String get filterLabel => 'ফিল্টার';

  @override
  String get searchVehiclesHint => 'গাড়ি, গেট পাস বা গ্রাহক';

  @override
  String get searchOrdersHint => 'আদেশ নম্বর বা গ্রাহক';

  @override
  String get inspectionDocumentsTitle => 'নথি';

  @override
  String get inspectionItemsTitle => 'যাচাই করার সামগ্রী';

  @override
  String get inspectionNotLoadedTitle => 'এখনও লোড হয়নি';

  @override
  String get inspectionNotLoadedMessage =>
      'স্টোর দল লোডিং নথিভুক্ত করার পরেই এই গাড়িকে ছাড়পত্র দেওয়া যাবে।';

  @override
  String get challanNumberLabel => 'চালান নং';

  @override
  String get challanNumberHint => 'CH-2026-901';

  @override
  String get ewayBillNumberLabel => 'ই-ওয়ে বিল নং';

  @override
  String get ewayBillNumberHint => 'EWB-8877665544';

  @override
  String get invoiceNumberLabel => 'ইনভয়েস নং';

  @override
  String get invoiceNumberHint => 'INV-2026-102';

  @override
  String get loadingRemarksLabel => 'লোডিং মন্তব্য';

  @override
  String get productLabel => 'পণ্য';

  @override
  String get skuLabel => 'SKU';

  @override
  String get rateLabel => 'দর';

  @override
  String get lineTotalLabel => 'লাইন মোট';

  @override
  String get quantityPiecesLabel => 'পিস';

  @override
  String get quantityBoxesLabel => 'বাক্স';

  @override
  String get quantityOrderedLabel => 'আদেশ';

  @override
  String get quantityDispatchedLabel => 'পাঠানো';

  @override
  String get quantityPendingLabel => 'বকেয়া';

  @override
  String get quantityToLoadLabel => 'লোড করতে হবে';

  @override
  String get currentStockLabel => 'মজুত';

  @override
  String get piecesPerBoxLabel => 'পিস / বাক্স';

  @override
  String get totalPiecesLabel => 'মোট পিস';

  @override
  String get totalBoxesLabel => 'মোট বাক্স';

  @override
  String get totalValueLabel => 'মোট মূল্য';

  @override
  String piecesShort(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString পিস';
  }

  @override
  String boxesShort(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString বাক্স';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সামগ্রী',
      one: '১টি সামগ্রী',
      zero: 'কোনও সামগ্রী নেই',
    );
    return '$_temp0';
  }

  @override
  String lineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লাইন',
      one: '১টি লাইন',
      zero: 'কোনও লাইন নেই',
    );
    return '$_temp0';
  }

  @override
  String vehicleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি গাড়ি',
      one: '১টি গাড়ি',
      zero: 'কোনও গাড়ি নেই',
    );
    return '$_temp0';
  }

  @override
  String get guardApproveExit => 'বেরোনোর অনুমতি';

  @override
  String get guardRejectExit => 'গাড়ি আটকান';

  @override
  String get guardApproveTitle => 'বেরোনোর অনুমতি দেবেন?';

  @override
  String guardApproveMessage(String vehicleNo) {
    return '$vehicleNo বেরোনোর ছাড়পত্র পাবে এবং সবুজ চিহ্ন পাবে।';
  }

  @override
  String get guardRejectTitle => 'এই গাড়ি আটকাবেন?';

  @override
  String get guardRejectMessage =>
      'গাড়িটি গেটে আটকে রাখা হবে এবং কারণ নথিভুক্ত হবে।';

  @override
  String guardApproveSuccess(String vehicleNo) {
    return '$vehicleNo-কে বেরোনোর ছাড়পত্র দেওয়া হয়েছে।';
  }

  @override
  String guardRejectSuccess(String vehicleNo) {
    return '$vehicleNo-কে গেটে আটকানো হয়েছে।';
  }

  @override
  String get guardHoldReasonLabel => 'কারণ';

  @override
  String get guardHoldReasonHint => 'গাড়িটি কেন আটকানো হচ্ছে?';

  @override
  String get storeSectionTitle => 'স্টোর পরিচালনা';

  @override
  String get storeEnteredVehiclesTitle => 'গেটের ভিতরে গাড়ি';

  @override
  String get storeEnteredVehiclesSubtitle => 'লোডিংয়ের অপেক্ষায় থাকা গাড়ি।';

  @override
  String get storeLoadingTitle => 'লোডিং নথিভুক্ত করুন';

  @override
  String get storeLoadingSubtitle =>
      'গাড়িতে প্রকৃতপক্ষে লোড করা পরিমাণ লিখুন।';

  @override
  String get storeStartLoading => 'লোডিং শুরু করুন';

  @override
  String get storeSubmitLoading => 'লোডিং জমা দিন';

  @override
  String get storeLoadingSuccessTitle => 'লোডিং নথিভুক্ত হয়েছে';

  @override
  String storeLoadingSuccessMessage(String vehicleNo) {
    return '$vehicleNo এখন নিরাপত্তা ছাড়পত্রের অপেক্ষায়।';
  }

  @override
  String get storePendingLinesLabel => 'বকেয়া লাইন';

  @override
  String get storeLoadFullPending => 'সব বকেয়া লোড করুন';

  @override
  String storeItemsSummary(int loaded, int total) {
    return '$totalটির মধ্যে $loadedটি লাইনে পরিমাণ আছে';
  }

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsAppearance => 'চেহারা';

  @override
  String get settingsTheme => 'থিম';

  @override
  String get settingsThemeSystem => 'সিস্টেম অনুযায়ী';

  @override
  String get settingsThemeLight => 'হালকা';

  @override
  String get settingsThemeDark => 'গাঢ়';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsAccount => 'অ্যাকাউন্ট';

  @override
  String get settingsAbout => 'সম্পর্কে';

  @override
  String get settingsVersion => 'সংস্করণ';

  @override
  String settingsVersionValue(String version, String build) {
    return '$version ($build)';
  }

  @override
  String get settingsServer => 'সার্ভার';

  @override
  String get settingsReplayOnboarding => 'পরিচিতি আবার দেখুন';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageAssamese => 'অসমীয়া';

  @override
  String get a11yBack => 'পিছনে';

  @override
  String get a11yAppLogo => 'Rainbow লোগো';

  @override
  String get a11yLoading => 'লোড হচ্ছে';

  @override
  String a11yStatusMark(String status) {
    return 'অবস্থা: $status';
  }
}
