///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter/material.dart';

class MgTab extends StatelessWidget {
  final String name;
  // final Icon icon;
  final Widget widget;

  // MgTab({@required this.name, @required this.icon, @required this.widget,});
  MgTab({@required this.name, @required this.widget,});

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}