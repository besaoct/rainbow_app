import 'package:rainbow_app/app/bootstrap.dart';

/// Entry point.
///
/// All start-up work lives in [bootstrap] so that an integration test or an
/// alternate entry point (a flavour, a screenshot harness) can reuse exactly
/// the same initialisation.
void main() => bootstrap();
