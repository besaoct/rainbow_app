import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('as'),
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
  ];

  /// Application name shown in the launcher, app bar and logo lockup.
  ///
  /// In en, this message translates to:
  /// **'Rainbow'**
  String get appName;

  /// Short brand descriptor shown under the logo.
  ///
  /// In en, this message translates to:
  /// **'Gate & Dispatch Operations'**
  String get appTagline;

  /// One paragraph description of the app, used on the about screen.
  ///
  /// In en, this message translates to:
  /// **'Register vehicle gate-in, record loading against sales orders and clear vehicles for exit.'**
  String get appDescription;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get actionSubmit;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get actionGetStarted;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get actionSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get actionViewAll;

  /// No description provided for @actionSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get actionSelect;

  /// No description provided for @actionChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get actionChange;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get labelOptional;

  /// No description provided for @labelRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get labelRequired;

  /// No description provided for @labelLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get labelLoading;

  /// No description provided for @labelNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get labelNotAvailable;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete the request. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find what you were looking for.'**
  String get errorNotFound;

  /// No description provided for @errorRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get errorRequestCancelled;

  /// No description provided for @errorBadCertificate.
  ///
  /// In en, this message translates to:
  /// **'The connection is not secure and was blocked.'**
  String get errorBadCertificate;

  /// No description provided for @errorStorageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Local storage is unavailable. Some preferences will not be saved.'**
  String get errorStorageUnavailable;

  /// No description provided for @errorTitleNoConnection.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get errorTitleNoConnection;

  /// No description provided for @errorTitleSession.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get errorTitleSession;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyReadyOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders ready for dispatch'**
  String get emptyReadyOrdersTitle;

  /// No description provided for @emptyReadyOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'Sales orders appear here once they are confirmed and have pending quantities.'**
  String get emptyReadyOrdersMessage;

  /// No description provided for @emptyVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'No vehicles on record'**
  String get emptyVehiclesTitle;

  /// No description provided for @emptyVehiclesMessage.
  ///
  /// In en, this message translates to:
  /// **'Vehicles appear here after their gate-in is registered.'**
  String get emptyVehiclesMessage;

  /// No description provided for @emptyVehiclesFilteredMessage.
  ///
  /// In en, this message translates to:
  /// **'No vehicles match the current filter.'**
  String get emptyVehiclesFilteredMessage;

  /// No description provided for @emptyEnteredVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'No vehicles waiting'**
  String get emptyEnteredVehiclesTitle;

  /// No description provided for @emptyEnteredVehiclesMessage.
  ///
  /// In en, this message translates to:
  /// **'Vehicles appear here after security registers their gate-in.'**
  String get emptyEnteredVehiclesMessage;

  /// No description provided for @emptyOrderItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending items'**
  String get emptyOrderItemsTitle;

  /// No description provided for @emptyOrderItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'Every line on this order has already been dispatched.'**
  String get emptyOrderItemsMessage;

  /// No description provided for @emptyInspectionItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing loaded yet'**
  String get emptyInspectionItemsTitle;

  /// No description provided for @emptyInspectionItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'The store team has not recorded any loading against this vehicle.'**
  String get emptyInspectionItemsMessage;

  /// No description provided for @emptySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get emptySearchTitle;

  /// No description provided for @emptySearchMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different vehicle number, gate pass or customer name.'**
  String get emptySearchMessage;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Register every vehicle at the gate'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Capture the vehicle, driver and transporter against a confirmed sales order and issue a gate pass in seconds.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track loading as it happens'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'The store team records loaded quantities line by line, with pending quantities and live stock always in view.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Clear the exit with confidence'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Verify documents and loaded items at the gate, then approve the exit or hold the vehicle with a recorded reason.'**
  String get onboardingBody3;

  /// No description provided for @onboardingPageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingPageIndicator(int current, int total);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your Rainbow ERP account to continue.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@company.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @loginSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loginSubmitting;

  /// No description provided for @loginFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get loginFailedTitle;

  /// No description provided for @loginNoRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'No operations role'**
  String get loginNoRoleTitle;

  /// No description provided for @loginNoRoleMessage.
  ///
  /// In en, this message translates to:
  /// **'This account is not set up for gate or store operations. Contact your administrator.'**
  String get loginNoRoleMessage;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validationRequired;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {min} characters.'**
  String validationMinLength(int min);

  /// No description provided for @validationMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Must be {max} characters or fewer.'**
  String validationMaxLength(int max);

  /// No description provided for @validationVehicleNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the vehicle number.'**
  String get validationVehicleNumberRequired;

  /// No description provided for @validationVehicleNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid vehicle number, for example KA 01 ZZ 7777.'**
  String get validationVehicleNumberInvalid;

  /// No description provided for @validationDriverNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the driver’s name.'**
  String get validationDriverNameRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get validationPhoneInvalid;

  /// No description provided for @validationOrderRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a sales order.'**
  String get validationOrderRequired;

  /// No description provided for @validationLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a location.'**
  String get validationLocationRequired;

  /// No description provided for @validationReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for holding this vehicle.'**
  String get validationReasonRequired;

  /// No description provided for @validationNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number.'**
  String get validationNumberInvalid;

  /// No description provided for @validationQuantityNegative.
  ///
  /// In en, this message translates to:
  /// **'Quantity cannot be negative.'**
  String get validationQuantityNegative;

  /// No description provided for @validationQuantityExceedsPending.
  ///
  /// In en, this message translates to:
  /// **'Only {pending} pcs are pending on this line.'**
  String validationQuantityExceedsPending(int pending);

  /// No description provided for @validationQuantityExceedsStock.
  ///
  /// In en, this message translates to:
  /// **'Only {stock} pcs are in stock.'**
  String validationQuantityExceedsStock(int stock);

  /// No description provided for @validationSelectAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity for at least one item.'**
  String get validationSelectAtLeastOneItem;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeQuickActions;

  /// Dashboard tile label. Kept to one short line.
  ///
  /// In en, this message translates to:
  /// **'Gate-in'**
  String get quickActionGateIn;

  /// Dashboard tile label. Kept to one short line.
  ///
  /// In en, this message translates to:
  /// **'Ready orders'**
  String get quickActionReadyOrders;

  /// Dashboard tile label. Kept to one short line.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get quickActionVehicles;

  /// Dashboard tile label. Kept to one short line.
  ///
  /// In en, this message translates to:
  /// **'Inside gate'**
  String get quickActionInsideGate;

  /// No description provided for @homeTodayAtAGlance.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get homeTodayAtAGlance;

  /// No description provided for @homeAssignedLocations.
  ///
  /// In en, this message translates to:
  /// **'Assigned locations'**
  String get homeAssignedLocations;

  /// No description provided for @homeNoAssignedLocations.
  ///
  /// In en, this message translates to:
  /// **'No locations assigned to your account.'**
  String get homeNoAssignedLocations;

  /// No description provided for @homeRecentVehicles.
  ///
  /// In en, this message translates to:
  /// **'Recent vehicles'**
  String get homeRecentVehicles;

  /// No description provided for @homeSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get homeSignOutTitle;

  /// No description provided for @homeSignOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue gate operations.'**
  String get homeSignOutMessage;

  /// No description provided for @roleGuard.
  ///
  /// In en, this message translates to:
  /// **'Security guard'**
  String get roleGuard;

  /// No description provided for @roleStoreManager.
  ///
  /// In en, this message translates to:
  /// **'Store manager'**
  String get roleStoreManager;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @roleSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get roleSales;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Team member'**
  String get roleMember;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get navVehicles;

  /// No description provided for @navLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get navLoading;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @guardSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Gate operations'**
  String get guardSectionTitle;

  /// No description provided for @guardReadyOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders ready for dispatch'**
  String get guardReadyOrdersTitle;

  /// No description provided for @guardReadyOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirmed sales orders with pending quantities.'**
  String get guardReadyOrdersSubtitle;

  /// No description provided for @guardGateInTitle.
  ///
  /// In en, this message translates to:
  /// **'Register gate-in'**
  String get guardGateInTitle;

  /// No description provided for @guardGateInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record the vehicle arriving against a sales order.'**
  String get guardGateInSubtitle;

  /// No description provided for @guardVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get guardVehiclesTitle;

  /// No description provided for @guardVehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every vehicle registered at this gate.'**
  String get guardVehiclesSubtitle;

  /// No description provided for @guardInspectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit clearance'**
  String get guardInspectionTitle;

  /// No description provided for @guardInspectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify the load and documents before the vehicle leaves.'**
  String get guardInspectionSubtitle;

  /// No description provided for @orderNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Order no.'**
  String get orderNumberLabel;

  /// No description provided for @orderDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Order date'**
  String get orderDateLabel;

  /// No description provided for @orderExpectedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get orderExpectedDateLabel;

  /// No description provided for @orderCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get orderCustomerLabel;

  /// No description provided for @orderCustomerCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer code'**
  String get orderCustomerCodeLabel;

  /// No description provided for @orderLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get orderLocationLabel;

  /// No description provided for @orderStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get orderStatusLabel;

  /// No description provided for @orderLinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get orderLinesLabel;

  /// No description provided for @orderPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderPendingLabel;

  /// No description provided for @vehicleNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number'**
  String get vehicleNumberLabel;

  /// No description provided for @vehicleNumberHint.
  ///
  /// In en, this message translates to:
  /// **'KA 01 ZZ 7777'**
  String get vehicleNumberHint;

  /// No description provided for @gatePassLabel.
  ///
  /// In en, this message translates to:
  /// **'Gate pass'**
  String get gatePassLabel;

  /// No description provided for @driverNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver name'**
  String get driverNameLabel;

  /// No description provided for @driverNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name as on the licence'**
  String get driverNameHint;

  /// No description provided for @driverPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver phone'**
  String get driverPhoneLabel;

  /// No description provided for @driverPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+91 91234 56789'**
  String get driverPhoneHint;

  /// The signed-in account’s own phone number, on the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhoneLabel;

  /// No description provided for @transporterLabel.
  ///
  /// In en, this message translates to:
  /// **'Transporter'**
  String get transporterLabel;

  /// No description provided for @transporterHint.
  ///
  /// In en, this message translates to:
  /// **'Transport company name'**
  String get transporterHint;

  /// No description provided for @remarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarksLabel;

  /// No description provided for @remarksHint.
  ///
  /// In en, this message translates to:
  /// **'Anything the next person should know'**
  String get remarksHint;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Select a location'**
  String get locationHint;

  /// No description provided for @salesOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Sales order'**
  String get salesOrderLabel;

  /// No description provided for @salesOrderHint.
  ///
  /// In en, this message translates to:
  /// **'Select a sales order'**
  String get salesOrderHint;

  /// No description provided for @enteredAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Gate-in'**
  String get enteredAtLabel;

  /// No description provided for @loadedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get loadedAtLabel;

  /// No description provided for @clearedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get clearedAtLabel;

  /// No description provided for @enteredByLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered by'**
  String get enteredByLabel;

  /// No description provided for @loadedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Loaded by'**
  String get loadedByLabel;

  /// No description provided for @rejectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Hold reason'**
  String get rejectionReasonLabel;

  /// No description provided for @guardGateInSubmit.
  ///
  /// In en, this message translates to:
  /// **'Register gate-in'**
  String get guardGateInSubmit;

  /// No description provided for @guardGateInSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Gate pass issued'**
  String get guardGateInSuccessTitle;

  /// No description provided for @guardGateInSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'{gatePassNo} issued for {vehicleNo}.'**
  String guardGateInSuccessMessage(String gatePassNo, String vehicleNo);

  /// No description provided for @guardSelectOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a sales order'**
  String get guardSelectOrderTitle;

  /// No description provided for @guardSelectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a location'**
  String get guardSelectLocationTitle;

  /// No description provided for @statusEntered.
  ///
  /// In en, this message translates to:
  /// **'Entered'**
  String get statusEntered;

  /// No description provided for @statusLoaded.
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get statusLoaded;

  /// No description provided for @statusCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get statusCleared;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Held'**
  String get statusRejected;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @markEnteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Orange mark · gate-in'**
  String get markEnteredLabel;

  /// No description provided for @markLoadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Red mark · awaiting clearance'**
  String get markLoadedLabel;

  /// No description provided for @markClearedLabel.
  ///
  /// In en, this message translates to:
  /// **'Green mark · cleared for exit'**
  String get markClearedLabel;

  /// No description provided for @markRejectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Held · issue recorded'**
  String get markRejectedLabel;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterLabel;

  /// No description provided for @searchVehiclesHint.
  ///
  /// In en, this message translates to:
  /// **'Vehicle, gate pass or customer'**
  String get searchVehiclesHint;

  /// Placeholder in the sales-order picker search field.
  ///
  /// In en, this message translates to:
  /// **'Order number or customer'**
  String get searchOrdersHint;

  /// No description provided for @inspectionDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get inspectionDocumentsTitle;

  /// No description provided for @inspectionItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items to verify'**
  String get inspectionItemsTitle;

  /// No description provided for @inspectionNotLoadedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not loaded yet'**
  String get inspectionNotLoadedTitle;

  /// No description provided for @inspectionNotLoadedMessage.
  ///
  /// In en, this message translates to:
  /// **'This vehicle can only be cleared after the store team records the loading.'**
  String get inspectionNotLoadedMessage;

  /// No description provided for @challanNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Challan no.'**
  String get challanNumberLabel;

  /// No description provided for @challanNumberHint.
  ///
  /// In en, this message translates to:
  /// **'CH-2026-901'**
  String get challanNumberHint;

  /// No description provided for @ewayBillNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'E-way bill no.'**
  String get ewayBillNumberLabel;

  /// No description provided for @ewayBillNumberHint.
  ///
  /// In en, this message translates to:
  /// **'EWB-8877665544'**
  String get ewayBillNumberHint;

  /// No description provided for @invoiceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice no.'**
  String get invoiceNumberLabel;

  /// No description provided for @invoiceNumberHint.
  ///
  /// In en, this message translates to:
  /// **'INV-2026-102'**
  String get invoiceNumberHint;

  /// No description provided for @loadingRemarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading remarks'**
  String get loadingRemarksLabel;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @skuLabel.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get skuLabel;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rateLabel;

  /// No description provided for @lineTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Line total'**
  String get lineTotalLabel;

  /// No description provided for @quantityPiecesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get quantityPiecesLabel;

  /// No description provided for @quantityBoxesLabel.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get quantityBoxesLabel;

  /// No description provided for @quantityOrderedLabel.
  ///
  /// In en, this message translates to:
  /// **'Ordered'**
  String get quantityOrderedLabel;

  /// No description provided for @quantityDispatchedLabel.
  ///
  /// In en, this message translates to:
  /// **'Dispatched'**
  String get quantityDispatchedLabel;

  /// No description provided for @quantityPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get quantityPendingLabel;

  /// No description provided for @quantityToLoadLabel.
  ///
  /// In en, this message translates to:
  /// **'To load'**
  String get quantityToLoadLabel;

  /// No description provided for @currentStockLabel.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get currentStockLabel;

  /// No description provided for @piecesPerBoxLabel.
  ///
  /// In en, this message translates to:
  /// **'Pcs / box'**
  String get piecesPerBoxLabel;

  /// No description provided for @totalPiecesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total pieces'**
  String get totalPiecesLabel;

  /// No description provided for @totalBoxesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total boxes'**
  String get totalBoxesLabel;

  /// No description provided for @totalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Total value'**
  String get totalValueLabel;

  /// No description provided for @piecesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} pcs'**
  String piecesShort(num count);

  /// No description provided for @boxesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} box'**
  String boxesShort(num count);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @lineCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No lines} =1{1 line} other{{count} lines}}'**
  String lineCount(int count);

  /// No description provided for @vehicleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No vehicles} =1{1 vehicle} other{{count} vehicles}}'**
  String vehicleCount(int count);

  /// No description provided for @guardApproveExit.
  ///
  /// In en, this message translates to:
  /// **'Approve exit'**
  String get guardApproveExit;

  /// No description provided for @guardRejectExit.
  ///
  /// In en, this message translates to:
  /// **'Hold vehicle'**
  String get guardRejectExit;

  /// No description provided for @guardApproveTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve exit?'**
  String get guardApproveTitle;

  /// No description provided for @guardApproveMessage.
  ///
  /// In en, this message translates to:
  /// **'{vehicleNo} will be cleared to leave and marked green.'**
  String guardApproveMessage(String vehicleNo);

  /// No description provided for @guardRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Hold this vehicle?'**
  String get guardRejectTitle;

  /// No description provided for @guardRejectMessage.
  ///
  /// In en, this message translates to:
  /// **'The vehicle will be held at the gate and the reason recorded.'**
  String get guardRejectMessage;

  /// No description provided for @guardApproveSuccess.
  ///
  /// In en, this message translates to:
  /// **'{vehicleNo} cleared for exit.'**
  String guardApproveSuccess(String vehicleNo);

  /// No description provided for @guardRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'{vehicleNo} held at the gate.'**
  String guardRejectSuccess(String vehicleNo);

  /// No description provided for @guardHoldReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get guardHoldReasonLabel;

  /// No description provided for @guardHoldReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Why is the vehicle being held?'**
  String get guardHoldReasonHint;

  /// No description provided for @storeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Store operations'**
  String get storeSectionTitle;

  /// No description provided for @storeEnteredVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles inside the gate'**
  String get storeEnteredVehiclesTitle;

  /// No description provided for @storeEnteredVehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles waiting to be loaded.'**
  String get storeEnteredVehiclesSubtitle;

  /// No description provided for @storeLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Record loading'**
  String get storeLoadingTitle;

  /// No description provided for @storeLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantities actually loaded onto the vehicle.'**
  String get storeLoadingSubtitle;

  /// No description provided for @storeStartLoading.
  ///
  /// In en, this message translates to:
  /// **'Start loading'**
  String get storeStartLoading;

  /// No description provided for @storeSubmitLoading.
  ///
  /// In en, this message translates to:
  /// **'Submit loading'**
  String get storeSubmitLoading;

  /// No description provided for @storeLoadingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading recorded'**
  String get storeLoadingSuccessTitle;

  /// No description provided for @storeLoadingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'{vehicleNo} is now awaiting security clearance.'**
  String storeLoadingSuccessMessage(String vehicleNo);

  /// No description provided for @storePendingLinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending lines'**
  String get storePendingLinesLabel;

  /// No description provided for @storeLoadFullPending.
  ///
  /// In en, this message translates to:
  /// **'Load all pending'**
  String get storeLoadFullPending;

  /// No description provided for @storeItemsSummary.
  ///
  /// In en, this message translates to:
  /// **'{loaded} of {total} lines have a quantity'**
  String storeItemsSummary(int loaded, int total);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsVersionValue.
  ///
  /// In en, this message translates to:
  /// **'{version} ({build})'**
  String settingsVersionValue(String version, String build);

  /// No description provided for @settingsServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get settingsServer;

  /// No description provided for @settingsReplayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Show the introduction again'**
  String get settingsReplayOnboarding;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageBengali;

  /// No description provided for @languageAssamese.
  ///
  /// In en, this message translates to:
  /// **'অসমীয়া'**
  String get languageAssamese;

  /// No description provided for @a11yBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get a11yBack;

  /// No description provided for @a11yAppLogo.
  ///
  /// In en, this message translates to:
  /// **'Rainbow logo'**
  String get a11yAppLogo;

  /// No description provided for @a11yLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get a11yLoading;

  /// No description provided for @a11yStatusMark.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String a11yStatusMark(String status);
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
      <String>['as', 'bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
