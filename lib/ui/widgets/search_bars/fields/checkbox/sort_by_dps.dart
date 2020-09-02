///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'checkbox_base.dart';

class SortByDps extends CheckboxBase {
  SortByDps(bool value, callback, [bool textFirst = true])
      : super(
    'Sort by dps',
    value,
    callback,
    textFirst,
  );
}