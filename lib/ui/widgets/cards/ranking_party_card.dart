///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme.dart' as MgTheme;

import '../../../repositories/repository_locale.dart';
import '../../../data/data.dart' as Mg;

import '../../../models/models.dart' as Model;

import 'character_card.dart';

class _ExpansionState {
  bool expanded;

  _ExpansionState(this.expanded);
}

class RankingPartyCard extends StatefulWidget {
  final Model.RankingParty _ranking;
  final _ExpansionState _expansionState = _ExpansionState(false);

  RankingPartyCard(this._ranking, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();

  get expanded {
    return _expansionState.expanded;
  }

  set expanded(bool expanded) {
    _expansionState.expanded = expanded;
  }
}

class _State extends State<RankingPartyCard> {

  List<Widget> _buildCharacterCards(Model.RankingParty log, Mg.Locale locale) {
    List<Widget> playerCards = [];
    for (int i = 0; i < log.characters.length; i++) {
      playerCards.add(CharacterCard(log.characters[i], log.characterDps[i]));
    }
    return playerCards;
  }

  Widget _buildExpanded(Model.RankingParty log, Mg.Locale locale) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Fight duration: ${locale.formatFightDuration(log.fightDuration)}',
              style: MgTheme.Text.normal,
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              'Party Dps: ${locale.formatDps(log.totalDps)}',
              style: MgTheme.Text.normal,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: _buildCharacterCards(log, locale),
        )
      ],
    );
  }

  Widget _buildNormal(Model.RankingParty log, Mg.Locale locale) {
    return Row(
      children: [
        // player icons
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: log.characters
                  .map((c) => ImageIcon(
                AssetImage('assets/icons/classes/${c.clazz.toLowerCase()}.png'),
                color: c.color,
                size: 50,
              ))
                  .toList(),
            ),
          ),
        ),
        // log data
        SizedBox(
          width: 15,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Fight duration: ${locale.formatFightDuration(log.fightDuration)}',
              style: MgTheme.Text.normal,
            ),
            Text(
              'Party Dps: ${locale.formatDps(log.totalDps)}',
              style: MgTheme.Text.normal,
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Model.RankingParty ranking = widget._ranking;
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;

    return GestureDetector(
      onTap: () => setState(() => widget.expanded = !widget.expanded),
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
                  Text(
                    // '${locale.formatZoneId(log.boss)}: ${locale.formatBossId(log.boss)}',
                    '#${ranking.rank}',
                    style: MgTheme.Text.title,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    '${locale.formatDateAndTime(ranking.timestamp)}',
                    style: MgTheme.Text.normal,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              widget.expanded ? _buildExpanded(ranking, locale) : _buildNormal(ranking, locale)
            ],
          ),
        ),
      ),
    );
  }

}