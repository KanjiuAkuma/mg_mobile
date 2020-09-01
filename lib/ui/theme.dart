///
/// Created by Kanjiu Akuma on 8/27/2020.
///

library mg_theme;

import 'package:flutter/material.dart';

Color _rgb(int r, int g, int b) {
  return Color.fromARGB(255, r, g, b);
}

class Background {
  static final Color global = _rgb(50, 50, 70);
  static final Color logPartyCard = _rgb(80, 80, 80);
  static final Color playerCard = _rgb(90, 90, 90);

  static final Color appBar = _rgb(80, 80, 100);
  static final Color tabBar = _rgb(50, 50, 50);
}

class Foreground {
  static final Color global = _rgb(200, 200, 200);
  static final Color accent = _rgb(68, 138, 255);

  static final Color appBar = _rgb(230, 230, 230);

  static final Color tabBarActive = _rgb(68, 138, 255);
  static final Color tabBarInactive = _rgb(87, 113, 156);

  static final Color accentTitle = _rgb(109, 175, 201);

  static final Color classIcon = Colors.black;
}

class Text {
  static final double _textSizeNormal = 16;
  static final double _textSizeTitle = 20;

  static final TextStyle title = TextStyle(color: Foreground.accentTitle, fontSize: _textSizeTitle);
  static final TextStyle normal = TextStyle(color: Foreground.global, fontSize: _textSizeNormal);

  static final TextStyle dps = TextStyle(color: _rgb(255, 151, 151), fontSize: _textSizeNormal);
  static final TextStyle clears = TextStyle(color: _rgb(255, 151, 151), fontSize: _textSizeNormal);
  static final TextStyle fightDuration = TextStyle(color: _rgb(187, 255, 187), fontSize: _textSizeNormal);
  static final TextStyle uploadTime = TextStyle(color: _rgb(151, 223, 255), fontSize: _textSizeNormal);
}
