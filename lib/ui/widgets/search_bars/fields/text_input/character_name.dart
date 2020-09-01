///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';

import '../../../../theme.dart' as MgTheme;

class CharacterName extends StatelessWidget {
  final String _value;
  final FocusNode _focusNode;
  final Function(String) _changeListener;
  final Function _submitListener;

  const CharacterName(this._value, this._focusNode, this._changeListener, this._submitListener, {Key key})  : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController(text: _value);
    _controller.addListener(() => _changeListener(_controller.text));

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: MgTheme.Text.title,
      decoration: InputDecoration(
        hintText: 'Character Name',
        hintStyle: MgTheme.Text.normal,
        border: InputBorder.none,
        fillColor: MgTheme.Background.appBar,
        filled: true,
      ),
      onSubmitted: (_) {
        _submitListener();
      },
    );
  }


}