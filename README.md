# Rainbow

Gate and dispatch operations for **Rainbow ERP**. Security guards register a
vehicle's gate-in against a confirmed sales order, the store team records what
was loaded, and the guard clears the vehicle for exit — or holds it with a
recorded reason.

- **Application ID:** `com.gitcs.rainbow` (Android `applicationId`, iOS `PRODUCT_BUNDLE_IDENTIFIER`)
- **Languages:** English, Hindi, Bengali, Assamese
- **Platforms:** Android (minSdk 24), iOS 13+

---

## Contents

1. [The workflow](#the-workflow)
2. [Requirements](#requirements)
3. [Setup](#setup)
4. [Running](#running)
5. [Environment configuration](#environment-configuration)
6. [Architecture](#architecture)
7. [Folder structure](#folder-structure)
8. [Design system](#design-system)
9. [Responsiveness](#responsiveness)
10. [Localization](#localization)
11. [Assets](#assets)
12. [Testing](#testing)
13. [Building for release](#building-for-release)
14. [How-to guides](#how-to-guides)

---

## The workflow

The whole product is one state machine, driven by a colour mark the ERP
assigns to each gate entry:

```text
                  guard                store                 guard
 sales order  ──▶ gate-in ─────────▶  loading  ─────────▶  exit clearance
                  entered              loaded              cleared
                 (orange)              (red)               (green)
                                                             └──▶ held
                                                              (issue recorded)
```

Transitions are one-way and enforced server-side: a vehicle can only be loaded
while it is `entered`, and can only be cleared once it is `loaded`. The app
mirrors those rules in `GateEntryStatus` so an impossible action is never
offered, and surfaces the server's own explanation when a rule is hit anyway
(for example if two guards act at once).

**Roles.** The API reports `is_guard` and `is_store_manager` on the signed-in
account. `UserRole` derives the operating role from those flags — an account
with both is an administrator and sees both sides. An account with neither is
turned away at sign-in with an explanation rather than dropped on an empty
dashboard, and the router refuses gate or store URLs it has no rights to.

---

## Requirements

| Tool    | Version                        |
| ------- | ------------------------------ |
| Flutter | 3.44.0 or newer (stable)       |
| Dart    | 3.12.2 or newer                |
| Android | SDK 24+, JDK 17                |
| iOS     | Xcode 15+, CocoaPods           |

Check your toolchain with `flutter doctor`.

---

## Setup

```bash
flutter pub get
flutter gen-l10n
```

`flutter gen-l10n` writes `lib/l10n/generated/`, which is not committed as
build output but is required to compile. `flutter run` and `flutter build`
regenerate it automatically; run it by hand after editing an `.arb` file.

---

## Running

```bash
flutter run
```

Against a different server:

```bash
flutter run --dart-define=API_BASE_URL=https://erp.example.com
```

---

## Environment configuration

All build-time configuration goes through `--dart-define` and is read once in
`lib/app/config/app_config.dart`. Nothing else in the codebase reads the
environment.

| Key                      | Default                                             | Purpose                                      |
| ------------------------ | --------------------------------------------------- | -------------------------------------------- |
| `API_BASE_URL`           | `https://indigo-parrot-908857.hostingersite.com`     | Origin of the Rainbow ERP API, no trailing `/` |
| `APP_FLAVOR`             | `development`                                        | `development` \| `staging` \| `production`     |
| `ENABLE_NETWORK_LOGGING` | `true`                                               | Request/response trace lines in the debug log  |

```bash
flutter build apk --release \
  --dart-define=APP_FLAVOR=production \
  --dart-define=API_BASE_URL=https://erp.rainbow.example \
  --dart-define=ENABLE_NETWORK_LOGGING=false
```

The logging interceptor records only method, path, status and duration.
Query strings and bodies are never logged: the sign-in call carries a password
in its query string and gate entries carry driver phone numbers.

---

## Architecture

Feature-first, with a thin shared core. A feature owns its data access, its
models, its providers and its UI; nothing reaches sideways into another
feature's internals.

```text
UI (screens, widgets)
      │  watches
      ▼
Providers (Riverpod)          ── state, no widgets
      │  calls
      ▼
Repository                    ── one per feature, endpoint-shaped methods
      │  calls
      ▼
ApiClient                     ── envelope handling, failure mapping
      │
      ▼
Rainbow ERP
```

**Packages and why each is here**

| Package                 | Purpose                                                        |
| ----------------------- | -------------------------------------------------------------- |
| `flutter_riverpod`      | State management; compile-safe, testable, no `BuildContext`     |
| `go_router`             | Declarative routing with a single redirect for the launch flow  |
| `dio`                   | HTTP with interceptors, cancellation and typed errors           |
| `flutter_svg`           | Renders the bundled SVG icon set and logos                      |
| `flutter_screenutil`    | Supplies the window measurements `AppScale` derives sizing from |
| `shared_preferences`    | Onboarding flag, theme and locale                               |
| `flutter_secure_storage`| API token and cached profile (Keychain / Keystore)              |
| `intl`                  | Date and number formatting                                      |
| `flutter_native_splash` | Native splash generation, plus holding it until the first frame |
| `flutter_launcher_icons`| Launcher icon generation (dev only)                             |

**State management conventions**

- One provider per concern; no global store.
- Reads are `FutureProvider` (`.autoDispose`, `.family` when parameterised).
- Mutations are `AsyncNotifier` controllers that perform the call and then
  invalidate every cache the mutation invalidated. These are deliberately
  **not** auto-disposed: screens `read` them rather than watching them, and an
  auto-disposed provider with no watchers is torn down the moment `read`
  returns, taking the in-flight request with it.
- Repositories are pure: they take an `ApiClient` and return models or throw
  an `ApiFailure`. No widget ever sees a `DioException` or a status code.

**Error handling.** `ApiFailure` is a sealed hierarchy — `NetworkFailure`,
`TimeoutFailure`, `UnauthorizedFailure`, `ForbiddenFailure`, `NotFoundFailure`,
`ValidationFailure`, `ServerFailure`, `BadCertificateFailure`,
`CancelledFailure`, `UnknownFailure`. Each knows how to phrase itself through
`AppLocalizations`. `ValidationFailure` additionally carries the server's
per-field errors, which forms display inline, and distinguishes a field error
from a workflow-rule rejection, where the server's own wording is the most
useful thing to show.

A 401 on any call except sign-in ends the session exactly once, wherever the
user happens to be, and the router returns them to sign-in with an
explanation. This is handled in `ApiClient` rather than in an interceptor,
because the client admits non-2xx responses so it can read their bodies, which
means a 401 never reaches `Interceptor.onError`.

---

## Folder structure

```text
lib/
├── app/                        # Composition root
│   ├── app.dart                # MaterialApp.router, theme + locale wiring
│   ├── bootstrap.dart          # Start-up, native splash handover, DI overrides
│   ├── config/app_config.dart  # --dart-define configuration
│   ├── router/                 # Routes and the launch-flow redirect
│   └── theme/app_theme.dart    # Design tokens assembled into ThemeData
│
├── core/                       # Shared, feature-agnostic
│   ├── constants/              # App, asset, route and storage keys
│   ├── enums/                  # GateEntryStatus, UserRole
│   ├── extensions/             # BuildContext, Iterable, DateTime helpers
│   ├── helpers/                # Validators, formatters
│   ├── network/                # ApiClient, endpoints, failures, interceptors
│   ├── providers/              # Infrastructure providers
│   ├── services/               # Preferences, secure storage
│   ├── theme/                  # Colours, typography, dimensions, durations
│   └── widgets/                # AppButton, AppScaffold, AppCard, …
│
├── features/                   # One folder per feature
│   ├── splash/ onboarding/ auth/ home/ guard/ store/ settings/
│   │   ├── data/               # Repository
│   │   ├── models/             # Wire models with fromJson/toJson
│   │   ├── providers/          # Feature state
│   │   ├── screens/            # Routed pages
│   │   └── widgets/            # Feature-local widgets
│
├── l10n/
│   ├── arb/                    # app_en.arb, app_hi.arb, app_bn.arb, app_as.arb
│   └── generated/              # flutter gen-l10n output
│
└── main.dart
```

A widget goes in `core/widgets/` **only** when two features genuinely use it.
Everything else stays with its feature.

---

## Design system

Every visual value lives in `lib/core/theme/`. There are no magic numbers in
widget code.

| File                  | Holds                                                     |
| --------------------- | --------------------------------------------------------- |
| `app_palette.dart`    | Raw brand colours. Referenced only by the theme layer.     |
| `app_colors.dart`     | Semantic colours as a `ThemeExtension`, light and dark     |
| `app_typography.dart` | Font family, weights, sizes, the full type scale           |
| `app_dimensions.dart` | `AppSpacing`, `AppRadius`, `AppIconSize`, `AppSize`, breakpoints |
| `app_durations.dart`  | Animation timings, debounces, network timeouts             |
| `app_shadows.dart`    | Elevation as explicit shadows, per brightness              |
| `app_scale.dart`      | The single responsive scale factor                         |

Colours beyond Material's `ColorScheme` — `success`, `warning`, the four gate
colour marks, text and border tiers — are a `ThemeExtension`, so light and dark
resolve automatically. Read them with `context.colors`.

```dart
Container(
  padding: AppSpacing.card,
  decoration: BoxDecoration(
    color: context.colors.surfaceRaised,
    borderRadius: AppRadius.cardRadius,
  ),
  child: Text(context.l10n.homeQuickActions, style: AppTextStyles.headingSmall),
)
```

The colour marks are never signalled by colour alone: every badge carries its
translated label and a shape, so the workflow is readable to a colour-blind
guard and to a screen reader.

---

## Responsiveness

Two independent mechanisms, deliberately kept separate.

**1. Scaling — how big things are.** Every token is a design-space value
multiplied by `AppScale.factor`, a single clamped number derived from the
window. It uses the smaller of the width and height scale, so a phone in
landscape does not inflate type, and is clamped to `[0.86, 1.28]` — an
unclamped linear scale makes a tablet look like a zoomed-in phone and squeezes
small phones below legibility.

**2. Layout — what shape things are.** `ResponsiveLayout` picks a different
widget tree per screen class (`compact` / `medium` / `expanded`), and
`ResponsiveGrid` varies its column count. Use these only when the *structure*
changes; a layout should not need them just to look right on a bigger phone.

`ResponsiveGrid` is backed by `UniformGrid`, a small custom layout that gives
every cell the column width **and** the height of the tallest child. A `Wrap`
sizes its children independently, so a card whose label wraps to two lines
leaves its neighbour short; a `GridView` can only equalise them by fixing an
aspect ratio, which breaks as soon as the text scale or the language changes.

Content is also width-capped (`AppSize.maxContentWidth`) and centred, so a form
is never stretched across a 12" tablet.

**Screen margins are defined once.** `AppSpacing.screenH` is the only inset,
applied by `ContentInset` (via `AppScaffold`) or by a list's own
`AppSpacing.listContent` / `listContentUnderHeader` — never both. Rows inside a
padded list use `ContentWidthCap`, which caps width without adding padding.
`content_inset_test.dart` measures the rendered position on every screen, which
is how the double-margin these list screens used to have was found.

**Text scaling** is honoured but bounded by `BoundedTextScale` to
`[0.85, 1.35]`. Beyond that, fixed-height controls clip; below it, plate
numbers read at arm's length stop being legible.

**Overflow is verified, not assumed.** `test/responsive/` renders every screen
across ten device profiles × four languages × light and dark, and fails on any
`RenderFlex`/`RenderBox` overflow. `harness_sanity_test.dart` proves the net
actually catches overflow, `bottom_bar_test.dart` measures that each screen's
primary action really is anchored to the bottom edge, and
`dashboard_layout_test.dart` measures that the dashboard actually splits into
two columns on a tablet instead of merely not clipping.

---

## Localization

**The hard rule: no user-facing string literal may appear in UI code.** Every
visible string comes from `AppLocalizations`.

```dart
Text(context.l10n.actionGetStarted)   // ✅
Text('Get started')                   // ❌ — fails the test suite
```

This is enforced mechanically by `test/l10n/no_hardcoded_strings_test.dart`,
which scans the widget layer for literals in `Text(...)` and in visible named
arguments (`label`, `hint`, `title`, `message`, `tooltip`, …) and fails with the
offending file and line.

`test/l10n/localization_test.dart` additionally checks that every locale
defines every key, keeps every placeholder, has no empty values, and is not
simply a copy of the English source.

**Numbers deliberately do not follow the interface language.** Bengali and
Assamese render digits in their own script (`১০` for ten), and every quantity in
this app is cross-checked at the gate against a printed challan, e-way bill or
invoice — all in Latin digits. `Formatters` therefore uses Latin digits with
Indian grouping (`1,50,000`) in every locale. Dates do follow the locale, with
a fallback for locales `intl` has no CLDR date data for.

> **Translation review.** The Hindi, Bengali and Assamese ARB files were
> produced during implementation and have **not** been reviewed by native
> speakers. Treat them as a complete, structurally-correct starting point and
> have them proofread before release. The English source is authoritative.

---

## Assets

Nothing references a raw asset path. Everything goes through `AppAssets`.

```dart
AppIcon(AppAssets.iconTruck, size: AppIconSize.md)   // ✅
SvgPicture.asset('assets/icons/truck.svg')           // ❌
```

```text
assets/
├── branding/   # Source rasters for the launcher icon and native splash
├── fonts/      # Inter 400/500/600/700 (SIL OFL, see OFL.txt)
├── icons/      # 44 SVG icons on a shared 24pt grid
├── images/
└── logos/      # Mark, dark variant, mono white, mono ink, brand tile
```

`test/core/assets_test.dart` verifies that every declared asset exists, parses
and renders — and that no icon sits in the bundle unreferenced.

**Regenerating the launcher icon and splash** after changing the branding
rasters:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Both are configured in `pubspec.yaml`. The generated platform files are
committed; do not edit them by hand.

**The splash imposes no artificial delay.** `bootstrap()` holds the native
splash only for work that must finish before the first frame — opening
preferences, so theme and language are correct immediately — and removes it in
the first post-frame callback. The Flutter `SplashScreen` is drawn to match the
native one exactly, so the handover is invisible while the session is restored
from the keychain.

---

## Testing

```bash
flutter analyze          # must report no issues
flutter test             # 360+ tests
dart format --set-exit-if-changed lib test
```

| Suite                             | Covers                                                        |
| --------------------------------- | ------------------------------------------------------------- |
| `test/core/validators_test.dart`  | Email, plate, phone, quantity and reason rules                 |
| `test/core/formatters_test.dart`  | Dates, quantities, currency, plate grouping                    |
| `test/core/api_client_test.dart`  | Envelope unwrapping, every failure mapping, auth header rules  |
| `test/core/assets_test.dart`      | Every asset exists, parses and renders                         |
| `test/features/models_test.dart`  | Wire parsing against payloads captured from the live API       |
| `test/features/flow_test.dart`    | Onboarding, sign-in, gate and store screens end to end         |
| `test/features/routing_test.dart` | First-launch decision and the role guards                      |
| `test/l10n/`                      | Locale parity and the no-hardcoded-strings rule                |
| `test/responsive/`                | Overflow across devices, languages and themes; bar anchoring; dashboard column split; uniform grid cells; content margins |

Tests exercise the **real** `ApiClient`, repositories and models; only the
socket is replaced, by `test/support/fake_api.dart`. A failure means the app is
wrong, not that a mock drifted.

---

## Building for release

```bash
flutter build appbundle --release --dart-define=APP_FLAVOR=production
flutter build apk --release --split-per-abi      # ~20 MB per ABI
flutter build ipa --release
```

**Android signing.** `android/app/build.gradle.kts` currently signs release
builds with the debug key so `flutter run --release` works out of the box.
Before publishing, create `android/key.properties` (git-ignored) and point the
release `signingConfig` at your upload key.

Release builds run R8 with `android/app/proguard-rules.pro`, which keeps the
AndroidX Security and Tink classes `flutter_secure_storage` reflects over.

---

## How-to guides

### Read a count for the dashboard

Take it from `dashboardSummaryProvider` (`GET /dashboard/summary`), not from
the length of a list. `guard/orders-ready` returns a capped page — the server
reports 32 ready orders where the list returns 15 — so counting rows
under-reports the queue. A list length is only a fallback for when the summary
call fails.

### Add a new user-facing string

1. Add the key to `lib/l10n/arb/app_en.arb`, with an `@key` entry describing it
   and declaring any placeholders.
2. Add the same key to `app_hi.arb`, `app_bn.arb` and `app_as.arb`.
3. `flutter gen-l10n`
4. Use it: `Text(context.l10n.myNewKey)`

`flutter test test/l10n/` fails if a locale is missing the key, drops a
placeholder, or leaves the English text in place.

### Add a new theme value

Add it to the matching file in `lib/core/theme/` — spacing to `AppSpacing`, a
radius to `AppRadius`, a colour to `AppColors` (both `light` and `dark`, plus
`copyWith` and `lerp`). Express sizes as `AppScale.of(<design value>)` so they
scale with the device. Never introduce a literal at a call site.

### Add a new route

1. Add a name and a path to `AppRoutes` in `lib/core/constants/route_constants.dart`.
2. Register the `GoRoute` in `lib/app/router/app_router.dart`.
3. If it needs a role, add the check to `_redirect` alongside the existing
   `/guard` and `/store` guards.
4. Navigate with `context.pushNamed(AppRoutes.myScreenName)` — never a literal
   path.

### Add a new feature

```text
lib/features/<feature>/
├── data/        <feature>_repository.dart   # takes ApiClient, throws ApiFailure
├── models/      wire models with fromJson
├── providers/   <feature>_providers.dart    # repository + read + mutation providers
├── screens/     routed pages
└── widgets/     feature-local widgets
```

Add its endpoints to `ApiEndpoints`, its strings to the four ARB files, its
routes to `AppRoutes`, and a screen entry to `test/responsive/overflow_test.dart`
so the new UI is held to the same layout guarantees as the rest.

### Point the app at a different ERP instance

Pass `--dart-define=API_BASE_URL=…`. The host in use is shown on the Settings
screen, so field staff can confirm which server a build is talking to.
