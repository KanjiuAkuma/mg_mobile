///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import 'mg_page.dart';
import '../widgets/mg_tab.dart';

import '../views/ranking/ranking.dart' as ViewsRanking;

class Ranking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MgPage(
      tabs: [
        MgTab(
          name: 'Boss',
          // icon: Icon(Icons.list),
          widget: ViewsRanking.RankingBoss(),
        ),
        MgTab(
          name: 'Class',
          // icon: Icon(Icons.format_list_numbered),
          widget: ViewsRanking.RankingClass(),
        ),
        MgTab(
          name: 'Party',
          // icon: Icon(Icons.format_list_numbered),
          widget: ViewsRanking.RankingParty(),
        )
      ],
    );
  }
}