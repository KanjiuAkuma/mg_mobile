///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart' as MgTheme;

import '../../repositories/repository_locale.dart';

import '../../models/models.dart' as Model;
import '../../data/data.dart' as Mg;

class CharacterCard extends StatelessWidget {
  final Model.Character _character;
  final int _characterDps;

  const CharacterCard(this._character, this._characterDps, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Mg.Locale locale = RepositoryProvider.of<RepositoryLocale>(context).locale;
    return Card(
      color: MgTheme.Background.playerCard,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Class icon
            ImageIcon(
              AssetImage('assets/icons/classes/${_character.clazz.toLowerCase()}.png'),
              color: _character.color ?? MgTheme.Foreground.classIcon,
              size: 40,
            ),
            // Character name, server and guild
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${_character.name}',
                  style: MgTheme.Text.normal.copyWith(color: _character.color),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    if (_character.guild != null)
                      Text(
                        '${_character.guild}',
                        style: MgTheme.Text.normal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${_character.server}',
                      style: MgTheme.Text.normal,
                    ),
                  ],
                ),
              ],
            ),
            // Character dps
            Text(
              locale.formatDps(_characterDps),
              style: MgTheme.Text.normal,
            ),
          ],
        ),
      ),
    );
  }
}
