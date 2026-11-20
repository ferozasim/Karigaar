import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import 'app_localizations_en.dart';

/// Reads the app translation in a configured shell and keeps isolated widgets
/// usable in tests and previews that do not install localization delegates.
AppLocalizations localizedStrings(BuildContext context) =>
    Localizations.of<AppLocalizations>(context, AppLocalizations) ??
    AppLocalizationsEn();
