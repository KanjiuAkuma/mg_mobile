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

class _ExpansionState {
  bool expanded;

  _ExpansionState(this.expanded);
}

class RankingAccountCard extends StatefulWidget {
  final Model.RankingAccount _ranking;
  final _ExpansionState _expansionState = _ExpansionState(false);

  RankingAccountCard(this._ranking, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();

  get expanded {
    return _expansionState.expanded;
  }

  set expanded(bool expanded) {
    _expansionState.expanded = expanded;
  }
}

class _State extends State<RankingAccountCard> {
  Widget _buildNormal(Model.RankingAccount ranking) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // rank number
        Text(
          '#${ranking.rank}',
          style: MgTheme.Text.title.copyWith(fontSize: 25),
        ),
        SizedBox(
          width: 15,
        ),
        // class icon
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ranking.characterRuns.map((r) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        ImageIcon(
                          AssetImage('assets/icons/classes/${r.character.clazz.toLowerCase()}.png'),
                          color: r.character.color ?? MgTheme.Foreground.classIcon,
                          size: 50,
                        ),
                        if (r.character.flair != null)
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Text(r.character.flair),
                          )
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    // char name
                    Column(
                      children: [
                        Text(
                          '${r.character.name}',
                          style: MgTheme.Text.title.copyWith(color: r.character.color),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${r.runs} Clear${r.runs == 1 ? '' : 's'}',
                          style: MgTheme.Text.clears.copyWith(fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          children: [
            Text(
              '${ranking.totalRuns} Clear${ranking.totalRuns == 1 ? '' : 's'}',
              style: MgTheme.Text.clears,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${ranking.characterRuns.length} Char${ranking.characterRuns.length == 1 ? '' : 's'}',
              style: MgTheme.Text.normal,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpanded(Model.RankingAccount ranking) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${ranking.rank}',
              style: MgTheme.Text.title.copyWith(fontSize: 25),
            ),
            Text(
              '${ranking.totalRuns} Clear${ranking.totalRuns == 1 ? '' : 's'}',
              style: MgTheme.Text.clears,
            ),
            Text(
              '${ranking.characterRuns.length} Char${ranking.characterRuns.length == 1 ? '' : 's'}',
              style: MgTheme.Text.normal,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Column(
          children: ranking.characterRuns.map((r) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<RequestBloc<Requests.Search>>(context).add(RequestEvent<Requests.Search>(Requests.Search(
                  BlocProvider.of<RegionBloc>(context).region,
                  r.character.name,
                  server: r.character.server,
                )));
              },
              child: Card(
                color: MgTheme.Background.playerCard,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Stack(
                        overflow: Overflow.visible,
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/classes/${r.character.clazz.toLowerCase()}.png'),
                            color: r.character.color ?? MgTheme.Foreground.classIcon,
                            size: 50,
                          ),
                          if (r.character.flair != null)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Text(r.character.flair),
                            )
                        ],
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      // char name
                      Text(
                        '${r.character.name}',
                        style: MgTheme.Text.title.copyWith(color: r.character.color),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        '${r.runs} Clear${r.runs == 1 ? '' : 's'}',
                        style: MgTheme.Text.clears.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => widget.expanded = !widget.expanded),
      child: Card(
        color: MgTheme.Background.logPartyCard,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.expanded ? _buildExpanded(widget._ranking) : _buildNormal(widget._ranking),
        ),
      ),
    );
  }
}
