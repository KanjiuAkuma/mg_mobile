///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'checkbox_base.dart';

class SearchForGuild extends CheckboxBase {
  SearchForGuild(bool value, callback, [bool textFirst = true])
      : super(
    'Search for guild',
    value,
    callback,
    textFirst,
  );
}