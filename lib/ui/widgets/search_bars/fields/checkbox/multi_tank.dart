///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'checkbox_base.dart';

class MultiTank extends CheckboxBase {
  MultiTank(bool value, callback, [bool textFirst = true])
      : super(
    'Allow multiple tanks',
    value,
    callback,
    textFirst,
  );
}