///
/// Created by Kanjiu Akuma on 8/31/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/region/region_bloc.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';

import '../../../models/models.dart' as Model;
import '../../../mg_api/requests/requests.dart' as Requests;
import '../../theme.dart' as MgTheme;

class RankingCharacterCard extends StatelessWidget {
  final Model.RankingCharacter _ranking;

  const RankingCharacterCard(this._ranking, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // search for tapped character
        BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(Requests.Search(
          BlocProvider.of<RegionBloc>(context).region,
          _ranking.character.name,
          server: _ranking.character.server,
        )));
      },
      child: Card(
        color: MgTheme.Background.logPartyCard,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // rank number
              Text(
                '#${_ranking.rank}',
                style: MgTheme.Text.title.copyWith(fontSize: 25),
              ),
              SizedBox(
                width: 15,
              ),
              // class icon
              Stack(
                overflow: Overflow.visible,
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/classes/${_ranking.character.clazz.toLowerCase()}.png'),
                    color: _ranking.character.color ?? MgTheme.Foreground.classIcon,
                    size: 40,
                  ),
                  if (_ranking.character.flair != null)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Text(_ranking.character.flair),
                    )
                ],
              ),
              SizedBox(
                width: 25,
              ),
              // char name
              Text(
                '${_ranking.character.name}',
                style: MgTheme.Text.title.copyWith(color: _ranking.character.color),
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                '${_ranking.runs} Clear${_ranking.runs == 1 ? '' : 's'}',
                style: MgTheme.Text.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
