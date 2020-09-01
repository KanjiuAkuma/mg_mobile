///
/// Created by Kanjiu Akuma on 8/31/2020.
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

class ClassSearchBar extends StatefulWidget implements RequestFactory<Requests.RankingClass> {
  final _SearchBarData data = _SearchBarData();

  ClassSearchBar(Requests.RankingClass request) {
    // maybe push data
    if (request != null) {
      data.clazz = request.clazz;
      data.server = request.server;
      data.span = request.span;
      data.boss = request.boss;
      data.typeTank = request.typeTank;
      data.typeHeal = request.typeHeal;
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
  Requests.RankingClass createRequest(String region) {
    // boss data might be empty
    if (data.boss == null) return null;

    return Requests.RankingClass.fromBoss(
      region,
      data.clazz,
      Mg.roleFromClass(data.clazz),
      data.boss,
      data.server,
      data.multiHeal,
      data.multiTank,
      data.typeTank,
      data.typeHeal,
    );
  }
}

class _SearchBarData {
  String clazz, server, span;
  Model.Boss boss;
  int typeTank, typeHeal;
  bool multiHeal, multiTank;
}

class _State extends State<ClassSearchBar> {
  _SearchBarData get data {
    return widget.data;
  }

  void _maybeSubmit() {
    if (data.boss != null) {
      BlocProvider.of<RequestBloc<Requests.RankingClass>>(context)
          .add(RequestEvent<Requests.RankingClass>(Requests.RankingClass.fromBoss(
        BlocProvider.of<RegionBloc>(context).region,
        data.clazz,
        Mg.roleFromClass(data.clazz),
        data.boss,
        data.server,
        data.multiHeal,
        data.multiTank,
        data.typeTank,
        data.typeHeal,
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
            Row(
              // class, server, span
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Dropdown.Clazz(
                  data.clazz,
                  (clazz) {
                    setState(() {
                      data.clazz = clazz;
                    });
                    _maybeSubmit();
                  },
                  textAny: 'All classes',
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
                Dropdown.Span(
                  data.span,
                  (span) {
                    setState(() {
                      data.span = span;
                    });
                    _maybeSubmit();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
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
              height: 15,
            ),
            // healer type
            Row(
              children: [
                Dropdown.TypeHeal(
                  data.typeHeal,
                  (typeHeal) {
                    setState(() {
                      data.typeHeal = typeHeal;
                    });
                    _maybeSubmit();
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                Checkbox.MultiHeal(
                  data.multiHeal,
                  (multiHeal) {
                    setState(() {
                      data.multiHeal = multiHeal;
                    });
                    _maybeSubmit();
                  },
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            // tank type
            Row(
              children: [
                Dropdown.TypeTank(data.typeTank, (typeTank) {
                  setState(() {
                    data.typeTank = typeTank;
                  });
                  _maybeSubmit();
                }),
                Expanded(
                  child: Container(),
                ),
                Checkbox.MultiTank(data.multiTank, (multiTank) {
                  setState(() {
                    data.multiTank = multiTank;
                  });
                  _maybeSubmit();
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
