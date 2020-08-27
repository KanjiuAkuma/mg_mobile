///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:flutter/material.dart';

import 'widgets/mg_app_bar.dart';
import 'pages/pages.dart' as Page;
import 'theme.dart' as MgTheme;

class ViewRoot extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ViewRootState();

}
class _ViewRootState extends State<ViewRoot> {

  int currentIndex = 0;
  List<Widget> _children = [
    Page.Home(),
    Page.Ranking(),
    Page.Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mg',
      home: Scaffold(
        appBar: MgAppBar(),
        backgroundColor: MgTheme.Background.global,
        body: _children[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: MgTheme.Background.tabBar,
          selectedItemColor: MgTheme.Foreground.tabBarActive,
          unselectedItemColor: MgTheme.Foreground.tabBarInactive,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => this.currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              title: Text('Ranking'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
