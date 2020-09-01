///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';

import '../../../../theme.dart' as MgTheme;

typedef BoolCallback = void Function(bool);

class CheckboxBase extends StatelessWidget {
  final String _title;
  final BoolCallback _callback;
  final bool _value, _textFirst;

  const CheckboxBase(this._title, this._value, this._callback, this._textFirst, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_textFirst) {
      return Row(
        children: [
          Text(
            _title,
            style: MgTheme.Text.normal,
          ),
          SizedBox(
            width: 10,
          ),
          Checkbox(
            value: _value,
            onChanged: _callback,
          ),
        ],
      );
    }
    else {
      return Row(
        children: [
          Checkbox(
            value: _value,
            onChanged: _callback,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            _title,
            style: MgTheme.Text.normal,
          ),
        ],
      );
    }
  }
}
