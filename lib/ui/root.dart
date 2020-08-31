///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/request/request_bloc.dart';
import '../bloc/request/request_state.dart';

import '../mg_api/requests/requests.dart' as Requests;

import 'widgets/mg_app_bar.dart';

import 'pages/pages.dart' as Page;
import 'theme.dart' as MgTheme;

class ViewRoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewRootState();
}

class _ViewRootState extends State<ViewRoot> {
  int currentIndex = 0;

  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      Page.Home(),
      Page.Ranking(),
      Page.Search(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mg',
      home: Scaffold(
        appBar: MgAppBar(),
        backgroundColor: MgTheme.Background.global,
        body: BlocListener<RequestBloc<Requests.Search>, RequestState<Requests.Search>>(
          listener: (context, state) {
            _children[2] = Page.Search(state.request);
            setState(() => currentIndex = 2);
          },
          child: _children[currentIndex],
        ),
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
