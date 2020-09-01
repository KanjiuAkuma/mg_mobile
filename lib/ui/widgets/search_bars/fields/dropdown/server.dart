///
/// Created by Kanjiu Akuma on 9/1/2020.
///

///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'dropdown_base.dart';

import '../../../../../data/data.dart' as Mg;

class Server extends DropdownBase<String> {
  Server(
    String value,
    callback,
    String region,
  ) : super(
          value,
          callback,
          Mg.regions[region]['servers'].map<DropdownItem<String>>((i) => DropdownItem<String>(i, i)).toList(),
          defaultItem: DropdownItem(null, 'All Servers'),
        );
}
