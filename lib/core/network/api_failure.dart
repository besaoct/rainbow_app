import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// Every way a Rainbow ERP call can fail, as a closed set.
///
/// The UI switches over this instead of inspecting `DioException`s, and the
/// message shown to the user always comes from the localisation system. The
/// server's own [serverMessage] is kept for logs and for the few cases where
/// it carries workflow detail the app cannot phrase itself — for example
/// "Vehicle must be in 'loaded' status for security exit clearance".
sealed class ApiFailure implements Exception {
  const ApiFailure({this.serverMessage, this.statusCode});

  /// Message returned by the API, in English. Never shown on its own.
  final String? serverMessage;

  /// HTTP status, when the request reached the server.
  final int? statusCode;

  /// The message to show the user, in their language.
  String localizedMessage(AppLocalizations l10n);

  @override
  String toString() =>
      '$runtimeType(status: $statusCode, message: $serverMessage)';
}

/// The device could not reach the server at all.
final class NetworkFailure extends ApiFailure {
  const NetworkFailure({super.serverMessage});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorNoInternet;
}

/// The server accepted the connection but did not answer in time.
final class TimeoutFailure extends ApiFailure {
  const TimeoutFailure({super.serverMessage});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorTimeout;
}

/// The token is missing, expired or rejected. Triggers a sign-out.
final class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure({super.serverMessage, super.statusCode = 401});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorUnauthorized;
}

/// The account is signed in but not permitted to perform the action.
final class ForbiddenFailure extends ApiFailure {
  const ForbiddenFailure({super.serverMessage, super.statusCode = 403});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorForbidden;
}

/// The requested resource does not exist.
final class NotFoundFailure extends ApiFailure {
  const NotFoundFailure({super.serverMessage, super.statusCode = 404});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorNotFound;
}

/// The request was well-formed but rejected: either field validation errors
/// or a workflow rule such as clearing a vehicle that is not yet loaded.
final class ValidationFailure extends ApiFailure {
  const ValidationFailure({
    this.fieldErrors = const <String, List<String>>{},
    super.serverMessage,
    super.statusCode = 422,
  });

  /// Field name to the messages the server returned for it.
  final Map<String, List<String>> fieldErrors;

  /// True when the failure is a workflow rule rather than a form field, in
  /// which case the server's own explanation is the only useful detail.
  bool get isWorkflowRule => fieldErrors.isEmpty;

  /// The first message for [field], if the server reported one.
  String? errorFor(String field) => fieldErrors[field]?.firstOrNull;

  @override
  String localizedMessage(AppLocalizations l10n) {
    // A workflow rule is state-dependent and specific; the server phrases it
    // better than a generic string can, so prefer it when there is one.
    final String? message = serverMessage;
    if (isWorkflowRule && message != null && message.isNotEmpty) {
      return message;
    }
    final String? first = fieldErrors.values.firstOrNull?.firstOrNull;
    return first ?? message ?? l10n.errorGeneric;
  }
}

/// The server failed while handling a valid request (5xx).
final class ServerFailure extends ApiFailure {
  const ServerFailure({super.serverMessage, super.statusCode});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorServer;
}

/// The TLS handshake failed.
final class BadCertificateFailure extends ApiFailure {
  const BadCertificateFailure({super.serverMessage});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorBadCertificate;
}

/// The caller cancelled the request, usually by leaving the screen.
final class CancelledFailure extends ApiFailure {
  const CancelledFailure({super.serverMessage});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorRequestCancelled;
}

/// Anything else, including a response body the app could not parse.
final class UnknownFailure extends ApiFailure {
  const UnknownFailure({super.serverMessage, super.statusCode});

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorGeneric;
}
