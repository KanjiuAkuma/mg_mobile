///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../../base/mg_view_state.dart';
import '../../widgets/search_bars/clears_search_bar.dart';
import '../../widgets/cards/ranking_account_card.dart';
import '../../widgets/cards/ranking_character_card.dart';

class RankingClears extends StatefulWidget {

  final ClearsSearchBar _searchBar;

  RankingClears(Requests.RankingClears request) : _searchBar = ClearsSearchBar(request);


  @override
  State<StatefulWidget> createState() => _State(_searchBar);

}

class _State extends MgViewState<RankingClears, dynamic, Requests.RankingClears> {

  _State(ClearsSearchBar searchBar): super(header: searchBar, requestFactory: searchBar);

  @override
  Widget buildItem(dynamic item, _) {
    if (item is Model.RankingCharacter) {
      return RankingCharacterCard(item);
    }
    else if (item is Model.RankingAccount) {
      return RankingAccountCard(item);
    }

    assert(false, 'Unknown item type $item');
    return null;
  }

}