///
/// Created by Kanjiu Akuma on 8/31/2020.
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

class ClearsSearchBar extends StatefulWidget implements RequestFactory<Requests.RankingClears> {
  final _SearchBarData data = _SearchBarData();

  ClearsSearchBar(Requests.RankingClears request) {
    // maybe push data
    if (request != null) {
      data.accountClears = request is Requests.RankingClearsAccount;
      data.version = request.boss?.version;
      data.bossId = request.boss?.bossId;
      data.zoneId = request.boss?.zoneId;
      data.server = request.server;
    }
  }

  @override
  Requests.RankingClears createRequest(String region) {
    if (data.version == null) return null;

    if (data.accountClears) {
      return Requests.RankingClearsAccount(
        region,
        data.version,
        data.zoneId,
        data.bossId,
        data.server,
      );
    } else {
      return Requests.RankingClearsCharacters(
        region,
        data.version,
        data.zoneId,
        data.bossId,
        data.server,
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _SearchBarData {
  bool accountClears = true;
  int version;
  String bossId, zoneId, server;
}

class _State extends State<ClearsSearchBar> {
  _SearchBarData get data {
    return widget.data;
  }

  void _maybeSubmit() {
    if (data.version != null) {
      if (data.accountClears) {
        BlocProvider.of<RequestBloc<Requests.RankingClears>>(context)
            .add(RequestEvent<Requests.RankingClears>(Requests.RankingClearsAccount(
          BlocProvider.of<RegionBloc>(context).region,
          data.version,
          data.zoneId,
          data.bossId,
          data.server,
        )));
      } else {
        BlocProvider.of<RequestBloc<Requests.RankingClears>>(context)
            .add(RequestEvent<Requests.RankingClears>(Requests.RankingClearsCharacters(
          BlocProvider.of<RegionBloc>(context).region,
          data.version,
          data.zoneId,
          data.bossId,
          data.server,
        )));
      }
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
            Row(
              // zone, boss
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
              height: 10,
            ),
            Row(
              children: [
                Checkbox(
                  value: !data.accountClears,
                  onChanged: (value) {
                    setState(() {
                      data.accountClears = !value;
                    });
                    _maybeSubmit();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Show clears per character',
                  style: MgTheme.Text.normal,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
