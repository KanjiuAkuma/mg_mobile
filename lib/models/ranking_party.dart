///
/// Created by Kanjiu Akuma on 9/1/2020.
///

import 'character.dart';

class RankingParty {

  final int rank;
  final String logId;
  final DateTime timestamp;
  final int totalDps, fightDuration;
  final List<int> characterDps;
  final List<Character> characters;

  RankingParty(this.logId, this.rank, this.timestamp, this.totalDps, this.fightDuration, this.characterDps, this.characters);

  factory RankingParty.fromJson(int rank, List<Map<String, dynamic>> json) {
    assert(0 < json.length, 'No data given for party log!');
    return RankingParty(
      json[0]['logId'],
      rank,
      DateTime.fromMillisecondsSinceEpoch(json[0]['timestamp'] * 1000),
      json[0]['partyDps'],
      json[0]['fightDuration'],
      json.map<int>((e) => e['playerDps']).toList(),
      json.map<Character>((e) => Character.fromJson(e)).toList(),
    );
  }
}