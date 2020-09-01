///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'checkbox_base.dart';

class MultiHeal extends CheckboxBase {
  MultiHeal(bool value, callback, [bool textFirst = true])
      : super(
          'Allow multiple healers',
          value,
          callback,
          textFirst,
        );
}
