///
/// Created by Kanjiu Akuma on 8/28/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/region/region_bloc.dart';
import '../../bloc/region/region_state.dart';

import '../../bloc/request/request_bloc.dart';
import '../../bloc/request/request_state.dart';
import '../../bloc/request/request_event.dart';

import '../theme.dart' as MgTheme;

import '../../repositories/repository_locale.dart';
import '../../data/data.dart' as Mg;

import '../../mg_api/requests/requests.dart' as Requests;

class CharacterSearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CharacterSearchBarState();
}

class _CharacterSearchBarState extends State<CharacterSearchBar> {
  bool _searchGuild = false, _sortDps = false;
  int _version;
  String _zoneId, _bossId;
  String _server;

  TextEditingController _characterNameController;
  final FocusNode _usernameNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _characterNameController = TextEditingController();
  }

  void _maybeSubmit() {
    if (_characterNameController.text.isNotEmpty) {
      _usernameNode.unfocus();

      BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(Requests.Search(
        BlocProvider.of<RegionBloc>(context).region,
        _characterNameController.text,
        version: _version,
        zoneId: _zoneId,
        bossId: _bossId,
        server: _server,
        searchForGuild: _searchGuild,
        sortByDps: _sortDps,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;

    return BlocListener<RegionBloc, RegionState>(
      listener: (context, state) {
        // search again
        _maybeSubmit();
      },
      child: BlocListener<RequestBloc<Requests.Search>, RequestState<Requests.Search>>(
        listener: (previous, current) {
          Requests.Search request = current.request;
          if (request != null) {
            if (request.characterName != _characterNameController.text ||
                request.server != _server ||
                request.boss?.version != _version ||
                request.boss?.zoneId != _zoneId ||
                request.boss?.bossId != _bossId ||
                request.searchForGuild != _searchGuild ||
                request.sortByDps != _sortDps) {
              setState(() {
                // update data
                _characterNameController.text = request.characterName;
                _server = request.server;
                _version = request.boss?.version;
                _zoneId = request.boss?.zoneId;
                _bossId = request.boss?.bossId;
                _searchGuild = request.searchForGuild;
                _sortDps = request.sortByDps;
              });
            }
          }
        },
        child: Container(
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
                          _server = server;
                        });
                        _maybeSubmit();
                      },
                      style: MgTheme.Text.normal,
                      dropdownColor: MgTheme.Background.appBar,
                      underline: Container(),
                      value: _server,
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
                          _zoneId = zoneId;
                          _version = zoneId == null ? null : locale.monsters[zoneId]['version'];
                          _bossId = zoneId == null ? null : locale.monsters[zoneId]['monsters'].keys.first;
                        });

                        // maybe submit intelligently
                        _maybeSubmit();
                      },
                      value: _zoneId,
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
                    if (_zoneId == null)
                      Expanded(
                        child: Container(),
                      ),
                    if (_zoneId != null)
                      SizedBox(
                        width: 15,
                      ),
                    if (_zoneId != null && locale.monsters[_zoneId]['monsters'].keys.length != 1)
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _bossId,
                          style: MgTheme.Text.normal,
                          dropdownColor: MgTheme.Background.appBar,
                          onChanged: (bossId) {
                            setState(() {
                              _bossId = bossId;
                            });
                            if (_characterNameController.text.isEmpty) {
                              _usernameNode.requestFocus();
                            } else {
                              _usernameNode.unfocus();
                              _maybeSubmit();
                            }
                          },
                          items: locale.monsters[_zoneId]['monsters'].keys.map<DropdownMenuItem<String>>((id) {
                            return DropdownMenuItem<String>(
                              value: id,
                              child: Text(
                                locale.monsters[_zoneId]['monsters'][id],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (_zoneId != null && locale.monsters[_zoneId]['monsters'].keys.length == 1)
                      Expanded(
                        child: Text(
                          locale.monsters[_zoneId]['monsters'].values.first,
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
                          value: _sortDps,
                          onChanged: (sortDps) {
                            setState(() {
                              _sortDps = sortDps;
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
                          value: _searchGuild,
                          onChanged: (searchGuild) {
                            setState(() {
                              _searchGuild = searchGuild;
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
        ),
      ),
    );
  }
}