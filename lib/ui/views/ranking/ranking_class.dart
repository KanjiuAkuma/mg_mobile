///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../mg_view_state.dart';
import '../../widgets/cards/log_character_card.dart';
import '../../widgets/search_bars/class_search_bar.dart';

class RankingClass extends StatefulWidget {

  final ClassSearchBar _searchBar;

  RankingClass(Requests.RankingClass request) : _searchBar = ClassSearchBar(request);

  @override
  State<StatefulWidget> createState() => _State(_searchBar);

}

class _State extends MgViewState<RankingClass, Model.LogCharacter, Requests.RankingClass> {

  _State(ClassSearchBar searchBar): super(header: searchBar, requestFactory: searchBar);

  @override
  Widget buildItem(Model.LogCharacter item) {
    return LogCharacterCard(item);
  }

}

