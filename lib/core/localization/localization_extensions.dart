import 'package:alumni_association_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension LocalizationBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
