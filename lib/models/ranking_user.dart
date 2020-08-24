///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'boss.dart';
import 'character.dart';

class RankingUser {
  final String id;
  final Boss boss;
  final int totalRuns;
  final List<int> characterRuns;
  final List<Character> characters;

  RankingUser(this.id, this.boss, this.totalRuns, this.characterRuns, this.characters);

  factory RankingUser.fromJson(Boss boss, List<Map<String, dynamic>> json) {
    assert(0 < json.length, 'No data given for user ranking!');
    int totalRuns = 0;
    List<int> characterRuns = [];
    List<Character> characters = [];

    for (Map<String, dynamic> e in json) {
      totalRuns += e['runs'];
      characterRuns.add(e['runs']);
      characters.add(Character.fromJson(e));
    }

    return RankingUser(
      json[0]['userId'],
      boss,
      totalRuns,
      characterRuns,
      characters,
    );
  }
}