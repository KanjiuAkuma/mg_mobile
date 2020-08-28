///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/region/region_state.dart';

import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_state.dart';
import '../../../bloc/request/request_event.dart';

import '../../theme.dart' as MgTheme;

import '../../../repositories/repository_locale.dart';
import '../../../data/data.dart' as Mg;

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../models/models.dart' as Model;

import '../../widgets/log_party_card.dart';

class PlayerSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerSearchState();
}

class _PlayerSearchState extends State<PlayerSearch> {
  bool disposeLoadingIndicator, isFetchingMore;

  Future<void> shouldDisposeLoadingIndicator() async {
    if (!disposeLoadingIndicator) {
      return Future<void>(() => shouldDisposeLoadingIndicator());
    }
  }

  Widget _buildError(Requests.Search request, String err) {
    return GestureDetector(
      onTap: () => BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(request)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong.',
            style: MgTheme.Text.normal,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            err,
            style: MgTheme.Text.normal.copyWith(color: Colors.red[800]),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Tap to retry',
            style: MgTheme.Text.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildEmpty() {
    return Center();
  }

  Widget _buildLoaded(List<Model.LogParty> logs, Requests.Search request) {
    disposeLoadingIndicator = true;
    return RefreshIndicator(
      color: MgTheme.Foreground.accent,
      backgroundColor: MgTheme.Background.appBar,
      onRefresh: () async {
        disposeLoadingIndicator = false;
        // yield search again
        BlocProvider.of<RequestBloc<Requests.Search>>(context)
            .add(RequestEvent<Requests.Search>(request.copyWith(page: 0)));
        return Future<void>(() => shouldDisposeLoadingIndicator());
      },
      child: ListView.builder(
        itemCount: logs.length + (request.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < logs.length) {
            return LogPartyCard(logs[index]);
          } else {
            if (!isFetchingMore) {
              isFetchingMore = true;
              BlocProvider.of<RequestBloc<Requests.Search>>(context)
                  .add(RequestEvent<Requests.Search>(Requests.Search.fetchMore(request, logs)));
            }
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: MgTheme.Background.appBar,
                    valueColor: AlwaysStoppedAnimation<Color>(MgTheme.Foreground.accent),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isFetchingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search bar
        SearchBar(),
        SizedBox(
          height: 10,
        ),
        // search results
        Expanded(
          child: BlocBuilder<RequestBloc<Requests.Search>, RequestState<Requests.Search>>(
            buildWhen: (previous, current) {
              return !(current is RequestLoadingState<Requests.Search> &&
                  (current.request.page != 0 || current.previousComplete != null));
            },
            builder: (context, state) {
              if (state is RequestNoneState<Requests.Search>) {
                return _buildEmpty();
              } else if (state is RequestLoadingState<Requests.Search>) {
                return _buildLoading();
              } else if (state is RequestLoadedState<Requests.Search>) {
                isFetchingMore = false;
                return _buildLoaded(state.response.data, state.request);
              } else {
                if (state is RequestErrorState<Requests.Search>) {
                  return _buildError(state.request, state.error);
                }
                return _buildError(state.request, 'Unknown error');
              }
            },
          ),
        )
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
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
