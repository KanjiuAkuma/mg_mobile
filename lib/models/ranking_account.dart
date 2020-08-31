///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'ranking_character.dart';

class RankingAccount {
  final String id;
  final int rank, totalRuns;
  List<RankingCharacter> characterRuns;

  RankingAccount(this.id, this.rank, this.totalRuns, this.characterRuns);

  factory RankingAccount.fromJson(int rank, List<Map<String, dynamic>> json) {
    assert(0 < json.length, 'No data given for user ranking!');
    int totalRuns = 0;
    List<RankingCharacter> characterRuns = [];

    for (Map<String, dynamic> e in json) {
      totalRuns += e['runs'];
      characterRuns.add(RankingCharacter.fromJson(rank, e));
    }

    return RankingAccount(
      json[0]['userId'],
      rank,
      totalRuns,
      characterRuns,
    );
  }
}