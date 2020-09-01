///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../mg_api/requests/requests.dart' as Requests;
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../repositories/repository_locale.dart';

import '../../../data/data.dart' as Mg;
import '../../../models/models.dart' as Model;
import '../../theme.dart' as MgTheme;

class CharacterCard extends StatelessWidget {
  final Model.LogCharacter _log;
  final Widget _title;

  CharacterCard(this._log, this._title, {Key key}) : super(key: key);

  CharacterCard.log(this._log, String bossName, {Key key})
      : _title = Text(bossName,
      style: MgTheme.Text.title),
        super(key: key);

  CharacterCard.ranking(this._log, int rank, {Key key})
      : _title = Text('#$rank',
      style: MgTheme.Text.title.copyWith(fontSize: 25)),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;

    return GestureDetector(
      onTap: () {
        // search for tapped character
      if (_log.character.name.replaceAll('*', '').isNotEmpty) {
        BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(Requests.Search(
          BlocProvider
              .of<RegionBloc>(context)
              .region,
          _log.character.name,
          server: _log.character.server,
        )));
      }
      },
      child: Card(
        color: MgTheme.Background.logPartyCard,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _title,
                  Expanded(
                    child: Container(),
                  ),
                  if (_log.timestamp != null)
                    Text(
                      '${locale.formatDateAndTime(_log.timestamp)}',
                      style: MgTheme.Text.normal,
                    ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Class icon
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      ImageIcon(
                        AssetImage('assets/icons/classes/${_log.character.clazz.toLowerCase()}.png'),
                        color: _log.character.color ?? MgTheme.Foreground.classIcon,
                        size: 40,
                      ),
                      if (_log.character.flair != null)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Text(_log.character.flair),
                        )
                    ],
                  ),
                  // Character name, server and guild
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${_log.character.name}',
                        style: MgTheme.Text.title.copyWith(color: _log.character.color),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          if (_log.character.guild != null)
                            Text(
                              '${_log.character.guild}',
                              style: MgTheme.Text.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${_log.character.server}',
                            style: MgTheme.Text.normal,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Character dps
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_log.fightDuration != null)
                        Text(
                          'Fight duration: ${locale.formatFightDuration(_log.fightDuration)}',
                          style: MgTheme.Text.normal,
                        ),
                      Text(
                        'Dps: ${locale.formatDps(_log.dps)}/s',
                        style: MgTheme.Text.normal,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
