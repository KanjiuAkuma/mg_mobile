///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'character.dart';
import 'boss.dart';

/// MG api player log data wrapper
class LogCharacter {
  final String logId;
  final Boss boss;
  final DateTime timestamp;
  final int dps, fightDuration;
  final Character character;

  LogCharacter(this.logId, this.boss, this.timestamp, this.dps, this.fightDuration, this.character);

  factory LogCharacter.fromJson(Map<String, dynamic> json) {
    return LogCharacter(
      json['logId'],
      Boss.fromJson(json),
      json.containsKey('timestamp') ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000) : null,
      json['playerDps'],
      json['fightDuration'],
      Character.fromJson(json),
    );
  }
}