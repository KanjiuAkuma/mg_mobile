///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';

import '../../../../theme.dart' as MgTheme;

typedef ValueCallback<T> = void Function(T);

class DropdownItem<V> {
  final V value;
  final String text;

  DropdownItem(this.value, this.text);
}

class DropdownBase<V> extends StatelessWidget {
  final V value;
  final ValueCallback<V> _callback;
  final List<DropdownItem<V>> _items;
  final bool hint;
  final bool expanded;

  DropdownBase(this.value, this._callback, this._items, {DropdownItem<V> defaultItem, this.expanded = false})
      : hint = defaultItem == null {
    if (defaultItem != null) {
      _items.insert(0, defaultItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<V>(
      style: MgTheme.Text.normal,
      dropdownColor: MgTheme.Background.appBar,
      isExpanded: expanded,
      onChanged: _callback,
      value: this.value,
      hint: hint ? Text('Select', style: MgTheme.Text.normal) : null,
      items: _items.map((i) {
        return DropdownMenuItem<V>(
          value: i.value,
          child: Text(
            i.text,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
