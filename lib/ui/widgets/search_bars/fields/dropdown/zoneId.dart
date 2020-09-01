///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

class ZoneId extends DropdownBase<String> {
  ZoneId(
    String value,
    callback,
    Map<String, String> items, {
    bool any = false,
  }) : super(
          value,
          callback,
          items.entries.map((e) => DropdownItem(e.key, e.value)).toList(),
          defaultItem: any ? DropdownItem(null, 'All Bosses') : null,
        );
}
