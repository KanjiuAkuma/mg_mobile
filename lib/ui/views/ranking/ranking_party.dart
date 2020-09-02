///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../../base/mg_view_state.dart';
import '../../base/search_bar.dart';

import '../../widgets/cards/log_party_card.dart';
import '../../widgets/search_bars/party_search_bar.dart';

class RankingParty extends StatefulWidget {
  final PartySearchBar _searchBar;

  RankingParty(Requests.RankingParty request) : _searchBar = PartySearchBar(request);

  @override
  State<StatefulWidget> createState() => _State(_searchBar);
}

class _State extends MgViewState<RankingParty, Model.LogParty, Requests.RankingParty> {
  _State(PartySearchBar searchBar) : super(header: SearchBarWrapper(searchBar), requestFactory: searchBar);

  @override
  Widget buildItem(Model.LogParty item, int index) {
    return PartyCard.ranking(item, index + 1);
  }
}
