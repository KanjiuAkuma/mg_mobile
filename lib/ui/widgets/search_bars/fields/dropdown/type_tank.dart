///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

import '../../../../../data/data.dart' as Mg;

class TypeTank extends DropdownBase<int> {
  TypeTank(
      int value,
      callback,
      ) : super(
    value,
    callback,
    Mg.tanks.entries.map((e) => DropdownItem(e.value, e.key)).toList(),
    defaultItem: DropdownItem(null, 'Any Tank'),
  );
}