///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'character.dart';

class RankingCharacter {
  final int rank, runs;
  final Character character;

  RankingCharacter(this.rank, this.runs, this.character);

  factory RankingCharacter.fromJson(int rank, Map<String, dynamic> json) {
    return RankingCharacter(
      rank,
      json['runs'],
      Character.fromJson(json),
    );
  }
}
