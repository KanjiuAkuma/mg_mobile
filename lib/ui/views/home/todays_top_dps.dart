///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repository_locale.dart';

import '../../../data/data.dart' as Mg;
import '../../../models/models.dart' as Model;
import '../../../mg_api/requests/requests.dart' as Requests;

import '../../widgets/cards/log_character_card.dart';
import '../../base/mg_view_state.dart';

class TodaysTopDps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _RequestFactory extends RequestFactory<Requests.Ranking24Hour> {
  @override
  Requests.Ranking24Hour createRequest(String region) {
    return Requests.Ranking24Hour(region);
  }
}

class _State extends MgViewState<TodaysTopDps, Model.LogCharacter, Requests.Ranking24Hour> {
  _State() : super(requestFactory: _RequestFactory());

  @override
  Widget buildItem(Model.LogCharacter item, int index) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;
    return CharacterCard.log(item, locale.formatBossId(item.boss),);
  }
}
