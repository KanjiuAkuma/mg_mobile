///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../mg_view_state.dart';
import '../../widgets/cards/ranking_party_card.dart';
import '../../widgets/search_bars/party_search_bar.dart';

class RankingParty extends StatefulWidget {

  final PartySearchBar _searchBar;

  RankingParty(Requests.RankingParty request) : _searchBar = PartySearchBar(request);

  @override
  State<StatefulWidget> createState() => _State(_searchBar);


}

class _State extends MgViewState<RankingParty, Model.RankingParty, Requests.RankingParty> {

  _State(PartySearchBar searchBar) : super(header: searchBar, requestFactory: searchBar);

  @override
  Widget buildItem(Model.RankingParty item) {
    return RankingPartyCard(item);
  }
}