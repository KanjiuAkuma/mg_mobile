///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import '../base/mg_page.dart';
import '../widgets/mg_tab.dart';

import '../views/home/home.dart' as ViewsHome;

class Home extends MgPage {
  Home()
      : super(tabs: [
          MgTab(
            name: 'Recent uploads',
            // icon: Icon(Icons.list),
            widget: ViewsHome.RecentUploads(),
          ),
          MgTab(
            name: 'Today\'s top dps',
            // icon: Icon(Icons.format_list_numbered),
            widget: ViewsHome.TodaysTopDps(),
          )
        ]);
}
