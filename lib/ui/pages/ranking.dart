///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'mg_page.dart';
import '../widgets/mg_tab.dart';

import '../views/ranking/ranking.dart' as ViewsRanking;

class Ranking extends MgPage {
  Ranking()
      : super(tabs: [
          MgTab(
            name: 'Boss',
            // icon: Icon(Icons.list),
            widget: ViewsRanking.RankingClears(null),
          ),
          MgTab(
            name: 'Class',
            // icon: Icon(Icons.format_list_numbered),
            widget: ViewsRanking.RankingClass(null),
          ),
          MgTab(
            name: 'Party',
            // icon: Icon(Icons.format_list_numbered),
            widget: ViewsRanking.RankingParty(null),
          )
        ]);
}
