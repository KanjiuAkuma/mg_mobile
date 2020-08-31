///
/// Created by Kanjiu Akuma on 8/28/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';

import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../data/data.dart' as Mg;
import '../../theme.dart' as MgTheme;
import '../../../mg_api/requests/requests.dart' as Requests;

import '../../../repositories/repository_locale.dart';

import '../../views/mg_view_state.dart';

class CharacterSearchBar extends StatefulWidget implements RequestFactory<Requests.Search> {
  final _SearchBarData data = _SearchBarData();

  CharacterSearchBar(Requests.Search request) {
    if (request != null) {
      data.characterName = request.characterName;
      data.server = request.server;
      data.version = request.boss?.version;
      data.bossId = request.boss?.bossId;
      data.zoneId = request.boss?.zoneId;
      data.searchGuild = request.searchForGuild;
      data.sortDps = request.sortByDps;
    }
  }

  @override
  State<StatefulWidget> createState() => _State();

  @override
  Requests.Search createRequest(String region) {
    if (data.characterName.isEmpty) return null;

    return Requests.Search(
      region,
      data.characterName,
      version: data.version,
      zoneId: data.zoneId,
      bossId: data.bossId,
      server: data.server,
      searchForGuild: data.searchGuild,
      sortByDps: data.sortDps,
    );
  }
}

class _SearchBarData {
  bool searchGuild = false, sortDps = false;
  int version;
  String zoneId, bossId;
  String server;
  String characterName = '';
}

class _State extends State<CharacterSearchBar> {
  TextEditingController _characterNameController;
  final FocusNode _usernameNode = FocusNode();

  _SearchBarData get data {
    return widget.data;
  }

  @override
  void initState() {
    super.initState();
    _characterNameController = TextEditingController()
      ..addListener(() {
        data.characterName = _characterNameController.text;
      });
    _characterNameController.text = data.characterName;
  }

  void _maybeSubmit() {
    if (_characterNameController.text.isNotEmpty) {
      _usernameNode.unfocus();
      BlocProvider.of<RequestBloc<Requests.Search>>(context)
          .add(RequestEvent<Requests.Search>(widget.createRequest(BlocProvider.of<RegionBloc>(context).region)));
    }
  }

  @override
  Widget build(BuildContext context) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;

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
                  child: TextField(
                    controller: _characterNameController,
                    focusNode: _usernameNode,
                    style: MgTheme.Text.title,
                    decoration: InputDecoration(
                      hintText: 'Character Name',
                      hintStyle: MgTheme.Text.normal,
                      border: InputBorder.none,
                      fillColor: MgTheme.Background.appBar,
                      filled: true,
                    ),
                    onSubmitted: (_) {
                      _maybeSubmit();
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                DropdownButton<String>(
                  onChanged: (server) {
                    setState(() {
                      data.server = server;
                    });
                    _maybeSubmit();
                  },
                  style: MgTheme.Text.normal,
                  dropdownColor: MgTheme.Background.appBar,
                  value: data.server,
                  items: Mg.regions[BlocProvider.of<RegionBloc>(context).region]['servers']
                      .map<DropdownMenuItem<String>>((s) {
                    return DropdownMenuItem<String>(
                      value: s,
                      child: Text(
                        s,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList()
                        ..insert(
                            0,
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('Any Server'),
                            )),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                DropdownButton<String>(
                  onChanged: (zoneId) {
                    setState(() {
                      data.zoneId = zoneId;
                      data.version = zoneId == null ? null : locale.monsters[zoneId]['version'];
                      data.bossId = zoneId == null ? null : locale.monsters[zoneId]['monsters'].keys.first;
                    });

                    // maybe submit intelligently
                    _maybeSubmit();
                  },
                  value: data.zoneId,
                  style: MgTheme.Text.normal,
                  dropdownColor: MgTheme.Background.appBar,
                  items: locale.monsters.keys.map((id) {
                    return DropdownMenuItem<String>(
                      value: id,
                      child: Text(
                        locale.monsters[id]['name'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList()
                    ..insert(
                        0,
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text('Any Boss'),
                        )),
                ),
                if (data.zoneId == null)
                  Expanded(
                    child: Container(),
                  ),
                if (data.zoneId != null)
                  SizedBox(
                    width: 15,
                  ),
                if (data.zoneId != null && locale.monsters[data.zoneId]['monsters'].keys.length != 1)
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: data.bossId,
                      style: MgTheme.Text.normal,
                      dropdownColor: MgTheme.Background.appBar,
                      onChanged: (bossId) {
                        setState(() {
                          data.bossId = bossId;
                        });
                        if (_characterNameController.text.isEmpty) {
                          _usernameNode.requestFocus();
                        } else {
                          _usernameNode.unfocus();
                          _maybeSubmit();
                        }
                      },
                      items: locale.monsters[data.zoneId]['monsters'].keys.map<DropdownMenuItem<String>>((id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(
                            locale.monsters[data.zoneId]['monsters'][id],
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (data.zoneId != null && locale.monsters[data.zoneId]['monsters'].keys.length == 1)
                  Expanded(
                    child: Text(
                      locale.monsters[data.zoneId]['monsters'].values.first,
                      style: MgTheme.Text.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: data.sortDps,
                      onChanged: (sortDps) {
                        setState(() {
                          data.sortDps = sortDps;
                        });
                        _maybeSubmit();
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Sort by Dps',
                      style: MgTheme.Text.normal,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: data.searchGuild,
                      onChanged: (searchGuild) {
                        setState(() {
                          data.searchGuild = searchGuild;
                        });
                        _maybeSubmit();
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Search for guilds',
                      style: MgTheme.Text.normal,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
