///
/// Created by Kanjiu Akuma on 8/28/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/region/region_bloc.dart';

import '../../bloc/request/request_bloc.dart';
import '../../bloc/request/request_event.dart';

import '../../data/data.dart' as Mg;
import '../theme.dart' as MgTheme;
import '../../mg_api/requests/requests.dart' as Requests;

import '../../repositories/repository_locale.dart';

import '../views/mg_view_state.dart';

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
  State<StatefulWidget> createState() => _CharacterSearchBarState();

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

class _CharacterSearchBarState extends State<CharacterSearchBar> {
  TextEditingController _characterNameController;
  final FocusNode _usernameNode = FocusNode();

  String get characterName {
    return widget.data.characterName;
  }
  set characterName(String characterName) {
    widget.data.characterName = characterName;
  }

  bool get searchGuild {
    return widget.data.searchGuild;
  }
  set searchGuild(bool searchGuild) {
    widget.data.searchGuild = searchGuild;
  }

  bool get sortDps {
    return widget.data.sortDps;
  }
  set sortDps(bool sortDps) {
    widget.data.sortDps = sortDps;
  }

  int get version {
    return widget.data.version;
  }
  set version(int version) {
    widget.data.version = version;
  }

  String get bossId {
    return widget.data.bossId;
  }
  set bossId(String bossId) {
    widget.data.bossId = bossId;
  }

  String get zoneId {
    return widget.data.zoneId;
  }
  set zoneId(String zoneId) {
    widget.data.zoneId = zoneId;
  }

  String get server {
    return widget.data.server;
  }
  set server(String server) {
    widget.data.server = server;
  }

  @override
  void initState() {
    super.initState();
    _characterNameController = TextEditingController()
      ..addListener(() {
        characterName = _characterNameController.text;
      });
    _characterNameController.text = characterName;
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
                      server = server;
                    });
                    _maybeSubmit();
                  },
                  style: MgTheme.Text.normal,
                  dropdownColor: MgTheme.Background.appBar,
                  underline: Container(),
                  value: server,
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
                              child: Text('All'),
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
                      this.zoneId = zoneId;
                      version = zoneId == null ? null : locale.monsters[zoneId]['version'];
                      bossId = zoneId == null ? null : locale.monsters[zoneId]['monsters'].keys.first;
                    });

                    // maybe submit intelligently
                    _maybeSubmit();
                  },
                  value: zoneId,
                  style: MgTheme.Text.normal,
                  dropdownColor: MgTheme.Background.appBar,
                  underline: Container(),
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
                          child: Text('All'),
                        )),
                ),
                if (zoneId == null)
                  Expanded(
                    child: Container(),
                  ),
                if (zoneId != null)
                  SizedBox(
                    width: 15,
                  ),
                if (zoneId != null && locale.monsters[zoneId]['monsters'].keys.length != 1)
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: bossId,
                      style: MgTheme.Text.normal,
                      dropdownColor: MgTheme.Background.appBar,
                      onChanged: (bossId) {
                        setState(() {
                          bossId = bossId;
                        });
                        if (_characterNameController.text.isEmpty) {
                          _usernameNode.requestFocus();
                        } else {
                          _usernameNode.unfocus();
                          _maybeSubmit();
                        }
                      },
                      items: locale.monsters[zoneId]['monsters'].keys.map<DropdownMenuItem<String>>((id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(
                            locale.monsters[zoneId]['monsters'][id],
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (zoneId != null && locale.monsters[zoneId]['monsters'].keys.length == 1)
                  Expanded(
                    child: Text(
                      locale.monsters[zoneId]['monsters'].values.first,
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
                      value: sortDps,
                      onChanged: (sortDps) {
                        setState(() {
                          sortDps = sortDps;
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
                      value: searchGuild,
                      onChanged: (searchGuild) {
                        setState(() {
                          searchGuild = searchGuild;
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
