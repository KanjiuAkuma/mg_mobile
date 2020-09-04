///
/// Created by Kanjiu Akuma on 8/31/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/region/region_state.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../models/models.dart' as Model;
import '../../../mg_api/requests/requests.dart' as Requests;

import '../../theme.dart' as MgTheme;

import 'fields/dropdown/dropdown.dart' as Dropdown;
import 'fields/checkbox/checkbox.dart' as Checkbox;

import '../../base/search_bar.dart';

class ClearsSearchBar extends SearchBar<Requests.RankingClears> {
  final _SearchBarData data = _SearchBarData();

  ClearsSearchBar(Requests.RankingClears request) : super(request?.region) {
    // maybe push data
    if (request != null) {
      data.accountClears = request is Requests.RankingClearsAccount;
      data.boss = request.boss;
      data.server = request.server;
    }
  }

  @override
  Requests.RankingClears createRequest(String region, bool changed) {
    if (data.boss == null) return null;

    if (data.accountClears) {
      return Requests.RankingClearsAccount.fromBoss(
        region,
        data.boss,
        changed ? null : data.server,
      );
    } else {
      return Requests.RankingClearsCharacters.fromBoss(
        region,
        data.boss,
        changed ? null : data.server,
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _State();

  @override
  get height {
    return 136;
  }

  @override
  void onRegionChanged() {
    data.server = null;
  }
}

class _SearchBarData {
  bool accountClears = true;
  Model.Boss boss;
  String server;
}

class _State extends State<ClearsSearchBar> {
  _SearchBarData get data {
    return widget.data;
  }

  void _maybeSubmit() {
    if (data.boss != null) {
      if (data.accountClears) {
        BlocProvider.of<RequestBloc<Requests.RankingClears>>(context)
            .add(RequestEvent<Requests.RankingClears>(Requests.RankingClearsAccount.fromBoss(
          BlocProvider.of<RegionBloc>(context).region,
          data.boss,
          data.server,
        )));
      } else {
        BlocProvider.of<RequestBloc<Requests.RankingClears>>(context)
            .add(RequestEvent<Requests.RankingClears>(Requests.RankingClearsCharacters.fromBoss(
          BlocProvider.of<RegionBloc>(context).region,
          data.boss,
          data.server,
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionBloc, RegionState>(
      builder: (context, state) => Container(
        color: MgTheme.Background.tabBar,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dropdown.Boss(
                data.boss,
                (boss) {
                  setState(() {
                    data.boss = boss;
                  });
                  _maybeSubmit();
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
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
                  Expanded(child: Container()),
                  Checkbox.CharacterClears(
                    !data.accountClears,
                        (accountClears) {
                      setState(() {
                        data.accountClears = !accountClears;
                      });
                      _maybeSubmit();
                    },
                    false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
