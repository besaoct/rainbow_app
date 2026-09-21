// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rainbow';

  @override
  String get appTagline => 'Gate & Dispatch Operations';

  @override
  String get appDescription =>
      'Register vehicle gate-in, record loading against sales orders and clear vehicles for exit.';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionClose => 'Close';

  @override
  String get actionSubmit => 'Submit';

  @override
  String get actionNext => 'Next';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionDone => 'Done';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionGetStarted => 'Get started';

  @override
  String get actionSignIn => 'Sign in';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get actionViewAll => 'View all';

  @override
  String get actionSelect => 'Select';

  @override
  String get actionChange => 'Change';

  @override
  String get labelOptional => 'Optional';

  @override
  String get labelRequired => 'Required';

  @override
  String get labelLoading => 'Loading…';

  @override
  String get labelNotAvailable => '—';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNoInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout =>
      'The server took too long to respond. Please try again.';

  @override
  String get errorServer =>
      'The server could not complete the request. Please try again later.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorForbidden =>
      'You do not have permission to perform this action.';

  @override
  String get errorNotFound => 'We could not find what you were looking for.';

  @override
  String get errorRequestCancelled => 'The request was cancelled.';

  @override
  String get errorBadCertificate =>
      'The connection is not secure and was blocked.';

  @override
  String get errorStorageUnavailable =>
      'Local storage is unavailable. Some preferences will not be saved.';

  @override
  String get errorTitleNoConnection => 'You are offline';

  @override
  String get errorTitleSession => 'Session expired';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyReadyOrdersTitle => 'No orders ready for dispatch';

  @override
  String get emptyReadyOrdersMessage =>
      'Sales orders appear here once they are confirmed and have pending quantities.';

  @override
  String get emptyVehiclesTitle => 'No vehicles on record';

  @override
  String get emptyVehiclesMessage =>
      'Vehicles appear here after their gate-in is registered.';

  @override
  String get emptyVehiclesFilteredMessage =>
      'No vehicles match the current filter.';

  @override
  String get emptyEnteredVehiclesTitle => 'No vehicles waiting';

  @override
  String get emptyEnteredVehiclesMessage =>
      'Vehicles appear here after security registers their gate-in.';

  @override
  String get emptyOrderItemsTitle => 'No pending items';

  @override
  String get emptyOrderItemsMessage =>
      'Every line on this order has already been dispatched.';

  @override
  String get emptyInspectionItemsTitle => 'Nothing loaded yet';

  @override
  String get emptyInspectionItemsMessage =>
      'The store team has not recorded any loading against this vehicle.';

  @override
  String get emptySearchTitle => 'No matches';

  @override
  String get emptySearchMessage =>
      'Try a different vehicle number, gate pass or customer name.';

  @override
  String get onboardingTitle1 => 'Register every vehicle at the gate';

  @override
  String get onboardingBody1 =>
      'Capture the vehicle, driver and transporter against a confirmed sales order and issue a gate pass in seconds.';

  @override
  String get onboardingTitle2 => 'Track loading as it happens';

  @override
  String get onboardingBody2 =>
      'The store team records loaded quantities line by line, with pending quantities and live stock always in view.';

  @override
  String get onboardingTitle3 => 'Clear the exit with confidence';

  @override
  String get onboardingBody3 =>
      'Verify documents and loaded items at the gate, then approve the exit or hold the vehicle with a recorded reason.';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Use your Rainbow ERP account to continue.';

  @override
  String get loginEmailLabel => 'Email address';

  @override
  String get loginEmailHint => 'you@company.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginSubmitting => 'Signing in…';

  @override
  String get loginFailedTitle => 'Sign-in failed';

  @override
  String get loginNoRoleTitle => 'No operations role';

  @override
  String get loginNoRoleMessage =>
      'This account is not set up for gate or store operations. Contact your administrator.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationEmailRequired => 'Enter your email address.';

  @override
  String get validationEmailInvalid => 'Enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Enter your password.';

  @override
  String validationMinLength(int min) {
    return 'Must be at least $min characters.';
  }

  @override
  String validationMaxLength(int max) {
    return 'Must be $max characters or fewer.';
  }

  @override
  String get validationVehicleNumberRequired => 'Enter the vehicle number.';

  @override
  String get validationVehicleNumberInvalid =>
      'Enter a valid vehicle number, for example KA 01 ZZ 7777.';

  @override
  String get validationDriverNameRequired => 'Enter the driver’s name.';

  @override
  String get validationPhoneInvalid => 'Enter a valid phone number.';

  @override
  String get validationOrderRequired => 'Select a sales order.';

  @override
  String get validationLocationRequired => 'Select a location.';

  @override
  String get validationReasonRequired =>
      'Enter the reason for holding this vehicle.';

  @override
  String get validationNumberInvalid => 'Enter a valid number.';

  @override
  String get validationQuantityNegative => 'Quantity cannot be negative.';

  @override
  String validationQuantityExceedsPending(int pending) {
    return 'Only $pending pcs are pending on this line.';
  }

  @override
  String validationQuantityExceedsStock(int stock) {
    return 'Only $stock pcs are in stock.';
  }

  @override
  String get validationSelectAtLeastOneItem =>
      'Enter a quantity for at least one item.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get quickActionGateIn => 'Gate-in';

  @override
  String get quickActionReadyOrders => 'Orders';

  @override
  String get quickActionVehicles => 'Vehicles';

  @override
  String get quickActionInsideGate => 'Loading';

  @override
  String get homeTodayAtAGlance => 'Today at a glance';

  @override
  String get homeAssignedLocations => 'Assigned locations';

  @override
  String get homeNoAssignedLocations =>
      'No locations assigned to your account.';

  @override
  String get homeRecentVehicles => 'Recent vehicles';

  @override
  String get homeSignOutTitle => 'Sign out?';

  @override
  String get homeSignOutMessage =>
      'You will need to sign in again to continue gate operations.';

  @override
  String get roleGuard => 'Security guard';

  @override
  String get roleStoreManager => 'Store manager';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleSales => 'Sales';

  @override
  String get roleMember => 'Team member';

  @override
  String get navHome => 'Home';

  @override
  String get navVehicles => 'Vehicles';

  @override
  String get navLoading => 'Loading';

  @override
  String get navSettings => 'Settings';

  @override
  String get guardSectionTitle => 'Gate operations';

  @override
  String get guardReadyOrdersTitle => 'Orders ready for dispatch';

  @override
  String get guardReadyOrdersSubtitle =>
      'Confirmed sales orders with pending quantities.';

  @override
  String get guardGateInTitle => 'Register gate-in';

  @override
  String get guardGateInSubtitle =>
      'Record the vehicle arriving against a sales order.';

  @override
  String get guardVehiclesTitle => 'Vehicles';

  @override
  String get guardVehiclesSubtitle => 'Every vehicle registered at this gate.';

  @override
  String get guardInspectionTitle => 'Exit clearance';

  @override
  String get guardInspectionSubtitle =>
      'Verify the load and documents before the vehicle leaves.';

  @override
  String get orderNumberLabel => 'Order no.';

  @override
  String get orderDateLabel => 'Order date';

  @override
  String get orderExpectedDateLabel => 'Expected';

  @override
  String get orderCustomerLabel => 'Customer';

  @override
  String get orderCustomerCodeLabel => 'Customer code';

  @override
  String get orderLocationLabel => 'Location';

  @override
  String get orderStatusLabel => 'Status';

  @override
  String get orderLinesLabel => 'Lines';

  @override
  String get orderPendingLabel => 'Pending';

  @override
  String get vehicleNumberLabel => 'Vehicle number';

  @override
  String get vehicleNumberHint => 'KA 01 ZZ 7777';

  @override
  String get gatePassLabel => 'Gate pass';

  @override
  String get driverNameLabel => 'Driver name';

  @override
  String get driverNameHint => 'Full name as on the licence';

  @override
  String get driverPhoneLabel => 'Driver phone';

  @override
  String get driverPhoneHint => '+91 91234 56789';

  @override
  String get contactPhoneLabel => 'Phone';

  @override
  String get transporterLabel => 'Transporter';

  @override
  String get transporterHint => 'Transport company name';

  @override
  String get transporterSuggestionsLabel => 'Or pick one';

  @override
  String get remarksLabel => 'Remarks';

  @override
  String get remarksHint => 'Anything the next person should know';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHint => 'Select a location';

  @override
  String get salesOrderLabel => 'Sales order';

  @override
  String get salesOrderHint => 'Select a sales order';

  @override
  String get enteredAtLabel => 'Gate-in';

  @override
  String get loadedAtLabel => 'Loaded';

  @override
  String get clearedAtLabel => 'Cleared';

  @override
  String get enteredByLabel => 'Registered by';

  @override
  String get loadedByLabel => 'Loaded by';

  @override
  String get rejectionReasonLabel => 'Hold reason';

  @override
  String get guardGateInSubmit => 'Register gate-in';

  @override
  String get guardGateInSuccessTitle => 'Gate pass issued';

  @override
  String guardGateInSuccessMessage(String gatePassNo, String vehicleNo) {
    return '$gatePassNo issued for $vehicleNo.';
  }

  @override
  String get guardSelectOrderTitle => 'Select a sales order';

  @override
  String get guardSelectLocationTitle => 'Select a location';

  @override
  String get statusEntered => 'Entered';

  @override
  String get statusLoaded => 'Loaded';

  @override
  String get statusCleared => 'Cleared';

  @override
  String get statusRejected => 'Held';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get markEnteredLabel => 'Orange mark · gate-in';

  @override
  String get markLoadedLabel => 'Red mark · awaiting clearance';

  @override
  String get markClearedLabel => 'Green mark · cleared for exit';

  @override
  String get markRejectedLabel => 'Held · issue recorded';

  @override
  String get filterAll => 'All';

  @override
  String get filterLabel => 'Filter';

  @override
  String get searchVehiclesHint => 'Vehicle, gate pass or customer';

  @override
  String get searchOrdersHint => 'Order number or customer';

  @override
  String get inspectionDocumentsTitle => 'Documents';

  @override
  String get inspectionItemsTitle => 'Items to verify';

  @override
  String get inspectionNotLoadedTitle => 'Not loaded yet';

  @override
  String get inspectionNotLoadedMessage =>
      'This vehicle can only be cleared after the store team records the loading.';

  @override
  String get challanNumberLabel => 'Challan no.';

  @override
  String get challanNumberHint => 'CH-2026-901';

  @override
  String get ewayBillNumberLabel => 'E-way bill no.';

  @override
  String get ewayBillNumberHint => 'EWB-8877665544';

  @override
  String get invoiceNumberLabel => 'Invoice no.';

  @override
  String get invoiceNumberHint => 'INV-2026-102';

  @override
  String get loadingRemarksLabel => 'Loading remarks';

  @override
  String get productLabel => 'Product';

  @override
  String get skuLabel => 'SKU';

  @override
  String get rateLabel => 'Rate';

  @override
  String get lineTotalLabel => 'Line total';

  @override
  String get quantityPiecesLabel => 'Pieces';

  @override
  String get quantityBoxesLabel => 'Boxes';

  @override
  String get quantityOrderedLabel => 'Ordered';

  @override
  String get quantityDispatchedLabel => 'Dispatched';

  @override
  String get quantityPendingLabel => 'Pending';

  @override
  String get quantityToLoadLabel => 'To load';

  @override
  String get currentStockLabel => 'In stock';

  @override
  String get piecesPerBoxLabel => 'Pcs / box';

  @override
  String get totalPiecesLabel => 'Total pieces';

  @override
  String get totalBoxesLabel => 'Total boxes';

  @override
  String get totalValueLabel => 'Total value';

  @override
  String piecesShort(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString pcs';
  }

  @override
  String boxesShort(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString box';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String lineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines',
      one: '1 line',
      zero: 'No lines',
    );
    return '$_temp0';
  }

  @override
  String vehicleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehicles',
      one: '1 vehicle',
      zero: 'No vehicles',
    );
    return '$_temp0';
  }

  @override
  String get guardApproveExit => 'Approve exit';

  @override
  String get guardRejectExit => 'Hold vehicle';

  @override
  String get guardApproveTitle => 'Approve exit?';

  @override
  String guardApproveMessage(String vehicleNo) {
    return '$vehicleNo will be cleared to leave and marked green.';
  }

  @override
  String get guardRejectTitle => 'Hold this vehicle?';

  @override
  String get guardRejectMessage =>
      'The vehicle will be held at the gate and the reason recorded.';

  @override
  String guardApproveSuccess(String vehicleNo) {
    return '$vehicleNo cleared for exit.';
  }

  @override
  String guardRejectSuccess(String vehicleNo) {
    return '$vehicleNo held at the gate.';
  }

  @override
  String get guardHoldReasonLabel => 'Reason';

  @override
  String get guardHoldReasonHint => 'Why is the vehicle being held?';

  @override
  String get storeSectionTitle => 'Store operations';

  @override
  String get storeEnteredVehiclesTitle => 'Vehicles inside the gate';

  @override
  String get storeEnteredVehiclesSubtitle => 'Vehicles waiting to be loaded.';

  @override
  String get storeLoadingTitle => 'Record loading';

  @override
  String get storeLoadingSubtitle =>
      'Enter the quantities actually loaded onto the vehicle.';

  @override
  String get storeStartLoading => 'Start loading';

  @override
  String get storeSubmitLoading => 'Submit loading';

  @override
  String get storeLoadingSuccessTitle => 'Loading recorded';

  @override
  String storeLoadingSuccessMessage(String vehicleNo) {
    return '$vehicleNo is now awaiting security clearance.';
  }

  @override
  String get storePendingLinesLabel => 'Pending lines';

  @override
  String get storeLoadFullPending => 'Load all';

  @override
  String storeItemsSummary(int loaded, int total) {
    return '$loaded of $total lines have a quantity';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'Match system';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String settingsVersionValue(String version, String build) {
    return '$version ($build)';
  }

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsReplayOnboarding => 'Show the introduction again';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageAssamese => 'অসমীয়া';

  @override
  String get a11yBack => 'Back';

  @override
  String get a11yAppLogo => 'Rainbow logo';

  @override
  String get a11yLoading => 'Loading';

  @override
  String a11yStatusMark(String status) {
    return 'Status: $status';
  }
}
