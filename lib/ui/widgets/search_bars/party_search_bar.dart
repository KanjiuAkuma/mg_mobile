import 'package:flutter/cupertino.dart';

///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../data/data.dart' as Mg;
import '../../../models/models.dart' as Model;
import '../../../mg_api/requests/requests.dart' as Requests;

import '../../theme.dart' as MgTheme;

import 'fields/dropdown/dropdown.dart' as Dropdown;
import 'fields/checkbox/checkbox.dart' as Checkbox;

import '../../views/mg_view_state.dart';

class PartySearchBar extends StatefulWidget implements RequestFactory<Requests.RankingParty> {
  final _SearchBarData data = _SearchBarData();

  PartySearchBar(Requests.RankingParty request) {
    if (request != null) {
      data.server = request.server;
      data.span = request.span;
      data.boss = request.boss;
      data.multiHeal = request.multiHeal;
      data.multiTank = request.multiTank;
    } else {
      // init default values
      data.span = Mg.spans.values.first;
      data.multiHeal = false;
      data.multiTank = false;
    }
  }

  @override
  State<StatefulWidget> createState() => _State();

  @override
  Requests.RankingParty createRequest(String region) {
    if (data.boss == null) return null;

    return Requests.RankingParty.fromBoss(
      region,
      data.boss,
      data.server,
      data.multiHeal,
      data.multiTank,
      data.span,
    );
  }
}

class _SearchBarData {
  String server, span;
  Model.Boss boss;
  bool multiHeal, multiTank;
}

class _State extends State<PartySearchBar> {
  _SearchBarData get data {
    return widget.data;
  }

  void _maybeSubmit() {
    if (data.boss != null) {
      BlocProvider.of<RequestBloc<Requests.RankingParty>>(context)
          .add(RequestEvent<Requests.RankingParty>(Requests.RankingParty.fromBoss(
        BlocProvider.of<RegionBloc>(context).region,
        data.boss,
        data.server,
        data.multiHeal,
        data.multiTank,
        data.span,
      )));
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
            // zone, boss
            Dropdown.Boss(
              data.boss,
              (boss) {
                setState(() {
                  data.boss = boss;
                });
                _maybeSubmit();
              },
              any: false,
            ),
            SizedBox(
              width: 15,
            ),
            // server, span
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Dropdown.Span(
                  data.span,
                        (span) {
                      setState(() {
                        data.span = span;
                      });
                      _maybeSubmit();
                    }
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            // multi heal
            Checkbox.MultiHeal(
              data.multiHeal,
                  (multiHeal) {
                setState(() {
                  data.multiHeal = multiHeal;
                });
                _maybeSubmit();
              },
              false,
            ),
            SizedBox(
              width: 15,
            ),
            // multi tank
            Checkbox.MultiTank(
              data.multiTank,
                  (multiTank) {
                setState(() {
                  data.multiTank = multiTank;
                });
                _maybeSubmit();
              },
              false,
            ),
          ],
        ),
      ),
    );
  }
}
