///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

import '../../../../../data/data.dart' as Mg;

class Clazz extends DropdownBase<String> {
  Clazz(
    String value,
    callback, {
    String textAny,
  }) : super(
          value,
          callback,
          Mg.clazzes.map((e) => DropdownItem(e, e)).toList(),
          defaultItem: (textAny != null) ? DropdownItem(null, textAny) : null,
        );
}
