///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart' as Mg;
import '../../../models/models.dart' as Model;

import '../../../repositories/repository_locale.dart';

import '../../theme.dart' as MgTheme;

import 'character_card.dart';

class _ExpansionState {
  bool expanded;

  _ExpansionState(this.expanded);
}

class PartyCard extends StatefulWidget {
  final Model.LogParty _log;
  final _ExpansionState _expansionState = _ExpansionState(false);
  final Widget _title;

  PartyCard(this._log, this._title, {Key key}) : super(key: key);

  PartyCard.log(this._log, String bossName, {Key key})
      : _title = Text(bossName, style: MgTheme.Text.title, overflow: TextOverflow.ellipsis),
        super(key: key);

  PartyCard.ranking(this._log, int rank, {Key key})
      : _title = Text('#$rank', style: MgTheme.Text.title.copyWith(fontSize: 25), overflow: TextOverflow.ellipsis),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyCardState();

  get expanded {
    return _expansionState.expanded;
  }

  set expanded(bool expanded) {
    _expansionState.expanded = expanded;
  }
}

class _PartyCardState extends State<PartyCard> {
  List<Widget> _buildCharacterCards(Model.LogParty log, Mg.Locale locale) {
    List<Widget> playerCards = [];
    for (int i = 0; i < log.characters.length; i++) {
      playerCards.add(CharacterCard(log.characters[i], log.characterDps[i]));
    }
    return playerCards;
  }

  Widget _buildExpanded(Model.LogParty log, Mg.Locale locale) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Fight duration: ${locale.formatFightDuration(log.fightDuration)}',
              style: MgTheme.Text.fightDuration,
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              'Party Dps: ${locale.formatDps(log.totalDps)}',
              style: MgTheme.Text.dps,
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

  Widget _buildNormal(Model.LogParty log, Mg.Locale locale) {
    return Row(
      children: [
        // player icons
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: log.characters
                  .map((c) {
                    return ImageIcon(
                        AssetImage('assets/icons/classes/${c.clazz.toLowerCase()}.png'),
                        color: c.color,
                        size: 50,
                      );
                  })
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
              style: MgTheme.Text.fightDuration,
            ),
            Text(
              'Party Dps: ${locale.formatDps(log.totalDps)}',
              style: MgTheme.Text.dps,
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Model.LogParty log = widget._log;
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
                  Expanded(
                    child: widget._title,
                  ),
                  Text(
                    '${locale.formatDateAndTime(log.timestamp)}',
                    style: MgTheme.Text.uploadTime,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              widget.expanded ? _buildExpanded(log, locale) : _buildNormal(log, locale)
            ],
          ),
        ),
      ),
    );
  }
}
