///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import '../data/locale.dart';

class RepositoryLocale {

  Locale _locale;

  Future<void> loadData(String localeName) async {
    _locale = await Locale.fromName(localeName);
  }

  Locale get locale {
    return _locale;
  }

}