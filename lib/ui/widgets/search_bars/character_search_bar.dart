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

import 'fields/dropdown/dropdown.dart' as Dropdown;
import 'fields/checkbox/checkbox.dart' as Checkbox;
import 'fields/text_input/text_input.dart' as TextInput;

import '../../base/search_bar.dart';

class CharacterSearchBar extends SearchBar<Requests.Search> {
  final _SearchBarData data = _SearchBarData();

  CharacterSearchBar(Requests.Search request) {
    if (request != null) {
      data.characterName = request.characterName;
      data.server = request.server;
      data.boss = request.boss;
      data.searchForGuild = request.searchForGuild;
      data.sortByDps = request.sortByDps;
    } else {
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
      searchForGuild: data.searchForGuild,
      sortByDps: data.sortByDps,
    );
  }

  @override
  get height {
    return 242;
  }
}

class _SearchBarData {
  bool searchForGuild = false, sortByDps = false;
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
            // Boss
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
            SizedBox(
              height: 10,
            ),
            // search type and sort
            Checkbox.SearchForGuild(
              data.searchForGuild,
              (searchForGuild) {
                setState(() {
                  data.searchForGuild = searchForGuild;
                });
                _maybeSubmit();
              },
              false,
            ),
            Checkbox.SortByDps(
              data.sortByDps,
              (sortByDps) {
                setState(() {
                  data.sortByDps = sortByDps;
                });
                _maybeSubmit();
              },
              false,
            )
          ],
        ),
      ),
    );
  }
}
