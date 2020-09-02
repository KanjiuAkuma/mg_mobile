///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

class BossId extends DropdownBase<String> {
  BossId(String value, callback, Map<String, String> items, [expanded = false])
      : super(
          value,
          callback,
          items.entries.map((e) => DropdownItem(e.key, e.value)).toList(),
          expanded: expanded,
        );
}
