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
import '../../widgets/cards/log_party_card.dart';

class RecentUploads extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _RequestFactory implements RequestFactory<Requests.UploadRecent> {
  @override
  Requests.UploadRecent createRequest(String region, [bool changed = false]) {
    return Requests.UploadRecent(region);
  }
}

class _State extends MgViewState<RecentUploads, Model.LogParty, Requests.UploadRecent> {
  _State() : super(requestFactory: _RequestFactory());

  @override
  Widget buildItem(Model.LogParty item, int index) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;
    return PartyCard.log(item, locale.formatBossId(item.boss),);
  }
}
