///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'boss.dart';
import 'character.dart';

/// MG api party log data wrapper
class LogParty {
  final String logId;
  final Boss boss;
  final DateTime timestamp;
  final int totalDps, fightDuration;
  final List<int> characterDps;
  final List<Character> characters;

  LogParty(this.logId, this.boss, this.timestamp, this.totalDps, this.fightDuration, this.characterDps, this.characters);

  factory LogParty.fromJson(List<Map<String, dynamic>> json) {
    return LogParty.fromJsonAndBoss(Boss.fromJson(json[0]), json);
  }

  factory LogParty.fromJsonAndBoss(Boss boss, List<Map<String, dynamic>> json) {
    assert(0 < json.length, 'No data given for party log!');
    return LogParty(
      json[0]['logId'],
      boss,
      DateTime.fromMillisecondsSinceEpoch(json[0]['timestamp'] * 1000),
      json[0]['partyDps'],
      json[0]['fightDuration'],
      json.map<int>((e) => e['playerDps']).toList(),
      json.map<Character>((e) => Character.fromJson(e)).toList(),
    );
  }
}
