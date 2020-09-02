///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'checkbox_base.dart';

class CharacterClears extends CheckboxBase {
  CharacterClears(bool value, callback, [bool textFirst = true])
      : super(
          'Show clears per character',
          value,
          callback,
          textFirst,
        );
}
