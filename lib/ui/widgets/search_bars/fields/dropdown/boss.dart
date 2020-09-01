///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/repository_locale.dart';
import '../../../../../data/data.dart' as Mg;
import '../../../../../models/models.dart' as Model;

import '../../../../theme.dart' as MgTheme;

import 'zoneId.dart';
import 'bossId.dart';

typedef BossCallback = void Function(Model.Boss);

class Boss extends StatelessWidget {
  final BossCallback _callback;
  final bool any;
  final Model.Boss _boss;

  const Boss(
    this._boss,
    this._callback, {
    Key key,
    this.any = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;
    int _version = _boss?.version;
    String _zoneId = _boss?.zoneId;
    String _bossId = _boss?.bossId;

    return Row(
      children: [
        // zone Id
        ZoneId(
          _zoneId,
          (v) {
            _callback(_zoneId == null
                ? null
                : Model.Boss(
                    locale.monsters[v]['version'],
                    v,
                    locale.monsters[v]['monsters'].keys.first,
                  ));
          },
          locale.monsters.map<String, String>((k, v) => MapEntry(k, v['name'])),
          any: this.any,
        ),
        if (_version == null)
          Expanded(
            child: Container(),
          ),
        if (_version != null)
          SizedBox(
            width: 15,
          ),
        if (_version != null && locale.monsters[_zoneId]['monsters'].keys.length != 1)
          BossId(
            _bossId,
            (v) {
              _callback(Model.Boss(
                _version,
                _zoneId,
                v,
              ));
            },
            locale.monsters[_zoneId]['monsters'],
          ),
        if (_version != null && locale.monsters[_zoneId]['monsters'].keys.length == 1)
          Expanded(
            child: Text(
              locale.monsters[_zoneId]['monsters'].values.first,
              style: MgTheme.Text.normal,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        // boss Id
      ],
    );
  }
}
