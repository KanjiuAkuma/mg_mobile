///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../mg_view_state.dart';
import '../../widgets/log_party_card.dart';

class RecentUploads extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _RequestFactory implements RequestFactory<Requests.UploadRecent> {
  @override
  Requests.UploadRecent createRequest(String region) {
    return Requests.UploadRecent(region);
  }
}

class _State extends MgViewState<RecentUploads, Model.LogParty, Requests.UploadRecent> {
  _State() : super(requestFactory: _RequestFactory());

  @override
  Widget buildItem(Model.LogParty item) {
    return LogPartyCard(item);
  }
}
