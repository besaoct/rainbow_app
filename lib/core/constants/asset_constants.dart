/// Every asset path in the application.
///
/// Widgets must reference these constants rather than raw strings so a moved
/// or renamed file is a single-line change and a typo is a compile error.
abstract final class AppAssets {
  static const String _icons = 'assets/icons';
  static const String _logos = 'assets/logos';

  // --- Logos -------------------------------------------------------------
  /// Full-colour mark for light surfaces.
  static const String logoMark = '$_logos/logo_mark.svg';

  /// Brightened mark for dark surfaces.
  static const String logoMarkDark = '$_logos/logo_mark_dark.svg';

  /// Single-colour white mark, for coloured or photographic backgrounds.
  static const String logoMonoWhite = '$_logos/logo_mono_white.svg';

  /// Single-colour ink mark, for light single-colour placements.
  static const String logoMonoInk = '$_logos/logo_mono_ink.svg';

  /// The mark on its brand tile — mirrors the launcher icon.
  static const String logoTile = '$_logos/logo_tile.svg';

  // --- Icons -------------------------------------------------------------
  static const String iconAlertTriangle = '$_icons/alert_triangle.svg';
  static const String iconArrowLeft = '$_icons/arrow_left.svg';
  static const String iconArrowRight = '$_icons/arrow_right.svg';
  static const String iconBox = '$_icons/box.svg';
  static const String iconCalendar = '$_icons/calendar.svg';
  static const String iconCheck = '$_icons/check.svg';
  static const String iconCheckCircle = '$_icons/check_circle.svg';
  static const String iconChevronDown = '$_icons/chevron_down.svg';
  static const String iconChevronLeft = '$_icons/chevron_left.svg';
  static const String iconChevronRight = '$_icons/chevron_right.svg';
  static const String iconClipboardCheck = '$_icons/clipboard_check.svg';
  static const String iconClock = '$_icons/clock.svg';
  static const String iconClose = '$_icons/close.svg';
  static const String iconCloseCircle = '$_icons/close_circle.svg';
  static const String iconDashboard = '$_icons/dashboard.svg';
  static const String iconDocument = '$_icons/document.svg';
  static const String iconEye = '$_icons/eye.svg';
  static const String iconEyeOff = '$_icons/eye_off.svg';
  static const String iconFilter = '$_icons/filter.svg';
  static const String iconGateIn = '$_icons/gate_in.svg';
  static const String iconGateOut = '$_icons/gate_out.svg';
  static const String iconHash = '$_icons/hash.svg';
  static const String iconHistory = '$_icons/history.svg';
  static const String iconHome = '$_icons/home.svg';
  static const String iconInbox = '$_icons/inbox.svg';
  static const String iconInfo = '$_icons/info.svg';
  static const String iconLanguage = '$_icons/language.svg';
  static const String iconLocation = '$_icons/location.svg';
  static const String iconLock = '$_icons/lock.svg';
  static const String iconLogout = '$_icons/logout.svg';
  static const String iconMail = '$_icons/mail.svg';
  static const String iconMoon = '$_icons/moon.svg';
  static const String iconOrders = '$_icons/orders.svg';
  static const String iconPhone = '$_icons/phone.svg';
  static const String iconPlus = '$_icons/plus.svg';
  static const String iconRefresh = '$_icons/refresh.svg';
  static const String iconSearch = '$_icons/search.svg';
  static const String iconSettings = '$_icons/settings.svg';
  static const String iconShieldCheck = '$_icons/shield_check.svg';
  static const String iconSun = '$_icons/sun.svg';
  static const String iconTruck = '$_icons/truck.svg';
  static const String iconUser = '$_icons/user.svg';
  static const String iconWarehouse = '$_icons/warehouse.svg';
  static const String iconWifiOff = '$_icons/wifi_off.svg';

  /// Every icon, used by the asset test to verify each file exists and parses.
  static const List<String> allIcons = <String>[
    iconAlertTriangle,
    iconArrowLeft,
    iconArrowRight,
    iconBox,
    iconCalendar,
    iconCheck,
    iconCheckCircle,
    iconChevronDown,
    iconChevronLeft,
    iconChevronRight,
    iconClipboardCheck,
    iconClock,
    iconClose,
    iconCloseCircle,
    iconDashboard,
    iconDocument,
    iconEye,
    iconEyeOff,
    iconFilter,
    iconGateIn,
    iconGateOut,
    iconHash,
    iconHistory,
    iconHome,
    iconInbox,
    iconInfo,
    iconLanguage,
    iconLocation,
    iconLock,
    iconLogout,
    iconMail,
    iconMoon,
    iconOrders,
    iconPhone,
    iconPlus,
    iconRefresh,
    iconSearch,
    iconSettings,
    iconShieldCheck,
    iconSun,
    iconTruck,
    iconUser,
    iconWarehouse,
    iconWifiOff,
  ];

  /// Every logo variant, used by the asset test.
  static const List<String> allLogos = <String>[
    logoMark,
    logoMarkDark,
    logoMonoWhite,
    logoMonoInk,
    logoTile,
  ];
}
