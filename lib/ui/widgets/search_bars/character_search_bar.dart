///
/// Created by Kanjiu Akuma on 8/28/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../models/models.dart' as Model;
import '../../../mg_api/requests/requests.dart' as Requests;

import '../../theme.dart' as MgTheme;

import '../../views/mg_view_state.dart';
import 'fields/dropdown/dropdown.dart' as Dropdown;
import 'fields/text_input/text_input.dart' as TextInput;

class CharacterSearchBar extends StatefulWidget implements RequestFactory<Requests.Search> {
  final _SearchBarData data = _SearchBarData();

  CharacterSearchBar(Requests.Search request) {
    if (request != null) {
      data.characterName = request.characterName;
      data.server = request.server;
      data.boss = request.boss;
      data.searchGuild = request.searchForGuild;
      data.sortDps = request.sortByDps;
    }
    else {
      data.characterName = '';
    }
  }

  @override
  State<StatefulWidget> createState() => _State();

  @override
  Requests.Search createRequest(String region) {
    if (data.characterName.isEmpty) return null;

    return Requests.Search.fromBoss(
      region,
      data.characterName,
      data.boss,
      server: data.server,
      searchForGuild: data.searchGuild,
      sortByDps: data.sortDps,
    );
  }
}

class _SearchBarData {
  bool searchGuild = false, sortDps = false;
  Model.Boss boss;
  String server;
  String characterName = '';
}

class _State extends State<CharacterSearchBar> {
  final FocusNode _characterNameNode = FocusNode();

  _SearchBarData get data {
    return widget.data;
  }

  void _maybeSubmit() {
    if (data.characterName.isNotEmpty) {
      _characterNameNode.unfocus();
      BlocProvider.of<RequestBloc<Requests.Search>>(context)
          .add(RequestEvent<Requests.Search>(widget.createRequest(BlocProvider.of<RegionBloc>(context).region)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MgTheme.Background.tabBar,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name input
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextInput.CharacterName(
                    data.characterName,
                    _characterNameNode,
                    (characterName) {
                      data.characterName = characterName;
                    },
                    _maybeSubmit,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Dropdown.Server(
                  data.server,
                  (server) {
                    setState(() {
                      data.server = server;
                    });
                    _maybeSubmit();
                  },
                  BlocProvider.of<RegionBloc>(context).region,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Dropdown.Boss(
              data.boss,
              (boss) {
                setState(() {
                  data.boss = boss;
                });
                _maybeSubmit();
              },
              any: true,
            ),
          ],
        ),
      ),
    );
  }
}
