import 'package:flutter/material.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';

/// The page shell every screen is built on.
///
/// It fixes three things centrally that are easy to get wrong per screen:
/// the app bar's back affordance uses the app's own icon set, content is
/// inset for the notch and the home indicator, and the body is never allowed
/// to overflow — [scrollable] bodies scroll, and a bottom action bar floats
/// above the keyboard instead of being pushed off-screen.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.subtitle,
    this.actions,
    this.bottomBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.scrollable = false,
    this.padded = true,
    this.showBackButton = true,
    this.onBack,
    this.maxContentWidth,
    this.backgroundColor,
    this.refreshIndicatorKey,
    this.onRefresh,
    super.key,
  });

  final Widget body;

  /// App-bar title. When null, no app bar is shown.
  final String? title;

  /// Optional second line under [title].
  final String? subtitle;

  final List<Widget>? actions;

  /// Pinned to the bottom, above the safe area — used for primary actions.
  final Widget? bottomBar;

  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  /// Wraps [body] in a scroll view. Leave `false` when the body manages its
  /// own scrolling, for example a `ListView`.
  final bool scrollable;

  /// Applies the standard screen padding and the content width cap.
  final bool padded;

  final bool showBackButton;
  final VoidCallback? onBack;
  final double? maxContentWidth;
  final Color? backgroundColor;

  /// Enables pull-to-refresh over the body.
  final Future<void> Function()? onRefresh;
  final Key? refreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();

    // Read the system inset here, above our own `Scaffold`. `Scaffold`
    // strips the bottom padding from the `bottomSheet` slot before the child
    // is built, so a `SafeArea` inside the bar is a no-op and the primary
    // action ends up under Android's gesture bar. Measured by
    // `bottom_bar_test.dart`.
    final double systemBottomInset = MediaQuery.paddingOf(context).bottom;

    Widget content = body;
    if (padded) {
      content = ContentInset(maxWidth: maxContentWidth, child: content);
    }
    if (scrollable) {
      content = SingleChildScrollView(
        physics: onRefresh != null
            ? const AlwaysScrollableScrollPhysics()
            : null,
        padding: EdgeInsets.only(
          top: AppSpacing.screenV,
          bottom: AppSpacing.xxxl,
        ),
        child: content,
      );
    }
    if (onRefresh != null) {
      content = RefreshIndicator.adaptive(
        key: refreshIndicatorKey,
        onRefresh: onRefresh!,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title == null
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              leading: (showBackButton && (canPop || onBack != null))
                  ? _BackButton(onBack: onBack)
                  : null,
              leadingWidth: showBackButton && (canPop || onBack != null)
                  ? AppSize.minTapTarget + AppSpacing.md
                  : null,
              titleSpacing: showBackButton && (canPop || onBack != null)
                  ? 0
                  : AppSpacing.screenH,
              title: _AppBarTitle(title: title!, subtitle: subtitle),
              actions: <Widget>[
                ...?actions,
                SizedBox(width: AppSpacing.sm),
              ],
            ),
      body: SafeArea(top: title == null, child: content),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      // `bottomSheet` sits above the keyboard inset, so the primary action
      // stays reachable while a field is focused.
      bottomSheet: bottomBar == null
          ? null
          : _BottomBar(bottomInset: systemBottomInset, child: bottomBar!),
      resizeToAvoidBottomInset: true,
    );
  }
}

/// Centres content and caps its width, without adding any padding.
///
/// Use this inside a list whose own `padding` already supplies the screen
/// inset. Adding [ContentInset] there as well would double the margin, which
/// is exactly the inconsistency `test/responsive/content_inset_test.dart`
/// guards against.
class ContentWidthCap extends StatelessWidget {
  const ContentWidthCap({required this.child, this.maxWidth, super.key});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? AppSize.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}

/// The standard screen inset: horizontal screen padding, plus the width cap.
///
/// This is what [AppScaffold] applies when `padded` is true, and it is the
/// single definition of "how far content sits from the edge of the screen".
class ContentInset extends StatelessWidget {
  const ContentInset({required this.child, this.maxWidth, super.key});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return ContentWidthCap(
      maxWidth: maxWidth,
      child: Padding(padding: AppSpacing.screenHorizontal, child: child),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    if (subtitle == null) {
      return Text(title, maxLines: 1, overflow: TextOverflow.ellipsis);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.theme.appBarTheme.titleTextStyle,
        ),
        Text(
          subtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      tooltip: context.l10n.a11yBack,
      icon: AppIcon(
        AppAssets.iconChevronLeft,
        size: AppIconSize.md,
        color: context.colors.textPrimary,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.child, required this.bottomInset});

  final Widget child;

  /// System inset at the bottom of the window, captured before `Scaffold`
  /// removed it from the ambient `MediaQuery`.
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colors.border,
            width: AppSize.borderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.md,
          AppSpacing.screenH,
          AppSpacing.md + bottomInset,
        ),
        // `heightFactor: 1` is load-bearing: the bottom-sheet slot passes
        // loose constraints, and a plain `Center` would expand to fill
        // them, floating the action bar into the middle of the screen.
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSize.maxContentWidth,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
