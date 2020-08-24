///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'boss.dart';
import 'character.dart';

class RankingCharacter {
  final Boss boss;
  final int runs;
  final Character character;

  RankingCharacter(this.boss, this.runs, this.character);

  factory RankingCharacter.fromJson(Boss boss, Map<String, dynamic> json) {
    return RankingCharacter(
      boss,
      json['runs'],
      Character.fromJson(json),
    );
  }
}
