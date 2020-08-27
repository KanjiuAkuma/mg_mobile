///
/// Created by Kanjiu Akuma on 8/27/2020.
///

library mg_theme;

import 'package:flutter/material.dart';

class Background {

  static const Color global = Color.fromARGB(255, 50, 50, 70);
  static const Color logPartyCard = Color.fromARGB(255, 80, 80, 80);
  static const Color playerCard = Color.fromARGB(255, 90, 90, 90);

  static const Color appBar = Color.fromARGB(255, 80, 80, 100);
  static const Color tabBar = Color.fromARGB(255, 50, 50, 50);

}

class Foreground {

  static const Color global = Color.fromARGB(255, 200, 200, 200);
  static const Color accent = Color.fromARGB(255, 68, 138, 255);

  static const Color appBar = Color.fromARGB(255, 230, 230, 230);

  static const Color tabBarActive = Color.fromARGB(255, 68, 138, 255);
  static const Color tabBarInactive = Color.fromARGB(255, 87, 113, 156);

  static const Color accentTitle  = Color.fromARGB(255, 109, 175, 201);

  static const Color classIcon = Colors.black;

}

class Text {
  static const TextStyle title = TextStyle(color: Foreground.accentTitle, fontSize: 20);
  static const TextStyle normal = TextStyle(color: Foreground.global, fontSize: 16);
}