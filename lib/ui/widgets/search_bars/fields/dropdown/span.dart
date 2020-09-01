///
/// Created by Kanjiu Akuma on 9/1/2020.
///

///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

import '../../../../../data/data.dart' as Mg;

class Span extends DropdownBase<String> {
  Span(
    String value,
    callback,
  ) : super(
          value,
          callback,
          Mg.spans.entries.map((e) => DropdownItem(e.value, e.key)).toList(),
        );
}
