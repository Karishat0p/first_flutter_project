import 'package:first_flutter_project/components/locale/l10n/app_locale.dart';
import 'package:flutter/cupertino.dart';

extension LocalContextX on BuildContext {
  AppLocale get locale => AppLocale.of(this)!;
}