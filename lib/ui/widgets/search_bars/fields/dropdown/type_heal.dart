///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

import '../../../../../data/data.dart' as Mg;

class TypeHeal extends DropdownBase<int> {
  TypeHeal(
      int value,
      callback,
      ) : super(
    value,
    callback,
    Mg.healers.entries.map((e) => DropdownItem(e.value, e.key)).toList(),
    defaultItem: DropdownItem(null, 'Any Heal'),
  );
}