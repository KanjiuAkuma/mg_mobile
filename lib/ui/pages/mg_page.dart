///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter/material.dart';

import '../theme.dart' as MgTheme;

import '../widgets/mg_tab.dart';


/// Yes yes, its unnecessary but i hate warnings! >.<
class _Index {
  int value = 0;
}

class MgPage extends StatefulWidget {
  final List<MgTab> tabs;
  final _Index index = _Index();

  MgPage({Key key, this.tabs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MgPageState();
}

class _MgPageState extends State<MgPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.index.value,
    )..addListener(() {
      widget.index.value = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: MgTheme.Background.tabBar,
          child: TabBar(
            labelColor: MgTheme.Foreground.tabBarActive,
            indicatorColor: MgTheme.Foreground.tabBarActive,
            unselectedLabelColor: MgTheme.Foreground.tabBarInactive,
            controller: _tabController,
            tabs: widget.tabs.map((e) => Tab(child: Text(e.name))).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs,
          ),
        ),
      ],
    );
  }
}
