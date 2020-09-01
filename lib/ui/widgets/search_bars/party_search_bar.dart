import 'package:flutter/cupertino.dart';

///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repository_locale.dart';
import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../data/data.dart' as Mg;
import '../../theme.dart' as MgTheme;
import '../../../mg_api/requests/requests.dart' as Requests;

import '../../views/mg_view_state.dart';

class PartySearchBar extends StatefulWidget implements RequestFactory<Requests.RankingParty> {
  final _SearchBarData data = _SearchBarData();

  PartySearchBar(Requests.RankingParty request) {
    if (request != null) {
      data.server = request.server;
      data.span = request.span;
      data.version = request.boss?.version;
      data.zoneId = request.boss?.zoneId;
      data.bossId = request.boss?.bossId;
      data.multiHeal = request.multiHeal;
      data.multiTank = request.multiTank;
    } else {
      // init default values
      data.span = Mg.Span.spans.values.first;
      data.multiHeal = false;
      data.multiTank = false;
    }
  }

  @override
  State<StatefulWidget> createState() => _State();

  @override
  Requests.RankingParty createRequest(String region) {
    if (data.version == null) return null;

    return Requests.RankingParty(
      region,
      data.version,
      data.zoneId,
      data.bossId,
      data.server,
      data.multiHeal,
      data.multiTank,
      data.span,
    );
  }
}

class _SearchBarData {
  String server, span, zoneId, bossId;
  int version;
  bool multiHeal, multiTank;
}

class _State extends State<PartySearchBar> {
  _SearchBarData get data {
    return widget.data;
  }

  void _maybeSubmit() {
    if (data.version != null) {
      BlocProvider.of<RequestBloc<Requests.RankingParty>>(context)
          .add(RequestEvent<Requests.RankingParty>(Requests.RankingParty(
        BlocProvider.of<RegionBloc>(context).region,
        data.version,
        data.zoneId,
        data.bossId,
        data.server,
        data.multiHeal,
        data.multiTank,
        data.span,
      )));
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
            // zone, boss
            Row(
              children: [
                DropdownButton<String>(
                  onChanged: (zoneId) {
                    setState(() {
                      data.zoneId = zoneId;
                      data.version = locale.monsters[zoneId]['version'];
                      data.bossId = locale.monsters[zoneId]['monsters'].keys.first;
                    });

                    // maybe submit intelligently
                    _maybeSubmit();
                  },
                  value: data.zoneId,
                  style: MgTheme.Text.normal,
                  hint: Text(
                    'Select',
                    style: MgTheme.Text.normal,
                  ),
                  dropdownColor: MgTheme.Background.appBar,
                  items: locale.monsters.keys.map((id) {
                    return DropdownMenuItem<String>(
                      value: id,
                      child: Text(
                        locale.monsters[id]['name'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
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
                        _maybeSubmit();
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
              width: 15,
            ),
            // server, span
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                DropdownButton<String>(
                  onChanged: (span) {
                    setState(() {
                      data.span = span;
                    });
                    _maybeSubmit();
                  },
                  style: MgTheme.Text.normal,
                  dropdownColor: MgTheme.Background.appBar,
                  value: data.span,
                  items: Mg.Span.spans.entries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.value,
                      child: Text(
                        e.key,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                  value: data.multiHeal,
                  onChanged: (value) {
                    setState(() {
                      data.multiHeal = value;
                    });
                    _maybeSubmit();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Allow multiple healers',
                  style: MgTheme.Text.normal,
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                  value: data.multiTank,
                  onChanged: (value) {
                    setState(() {
                      data.multiTank = value;
                    });
                    _maybeSubmit();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Allow multiple tanks',
                  style: MgTheme.Text.normal,
                ),
              ],
            )
            // multiHeal/-Tank
          ],
        ),
      ),
    );
  }
}
