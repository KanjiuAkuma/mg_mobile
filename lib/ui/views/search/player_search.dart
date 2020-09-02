///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repository_locale.dart';
import '../../../data/data.dart' as Mg;
import '../../../models/models.dart' as Model;

import '../../../mg_api/requests/requests.dart' as Requests;

import '../../base/mg_view_state.dart';
import '../../base/search_bar.dart';

import '../../widgets/search_bars/character_search_bar.dart';
import '../../widgets/cards/log_party_card.dart';

class CharacterSearch extends StatefulWidget {
  final CharacterSearchBar _searchBar;

  CharacterSearch(Requests.Search request) : _searchBar = CharacterSearchBar(request);

  @override
  State<StatefulWidget> createState() => _State(_searchBar);
}

class _State extends MgViewState<CharacterSearch, Model.LogParty, Requests.Search> {
  _State(CharacterSearchBar searchBar) : super(header: SearchBarWrapper(searchBar), requestFactory: searchBar);

  @override
  Widget buildItem(Model.LogParty item, int index) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;
    return PartyCard.log(
      item,
      locale.formatBossId(item.boss),
    );
  }
}
